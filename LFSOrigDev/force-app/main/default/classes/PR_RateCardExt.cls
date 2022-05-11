public with sharing class PR_RateCardExt {

    public String selectedRateCardName { get; set; }
    
    public Rate_Card__c selectedRateCard {get;set;}

    public PR_RateCardExt (ApexPages.StandardController controller) {
    	rowCounter = null;
        try {
            selectedRateCard = [SELECT id FROM Rate_Card__c WHERE id =: controller.getId()];
        }
        catch(Exception e) {
            Util.addMessage(ApexPages.Severity.ERROR,'Rate Card ID required');
        }
    
    }
      
    public integer rowCounter {
        get {
            if(rowCounter==null) {
                rowCounter = -1;
            }
            return rowCounter;
        }
        set;
    }
    
    public integer getNextRowNum() {
    	System.debug('!!!!! rowCounter' + rowCounter);
        return rowCounter++;
    }
    
    public List<String> creditScores {
        get {
            if(creditScores == null) {
                Schema.DescribeFieldResult fieldResult = Rate__c.Credit_Score__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                creditScores = new List<String>();
                for(Schema.PicklistEntry f : ple)
                {
                    creditScores.add(f.getValue());
                }
             }
             return creditScores;     
        }
        set;
    }

    public List<RateBand> rateCard {
        get {
        	System.debug('$$$$ rateCard ' + rateCard);
            if(rateCard == null) {
            	System.debug('$$$$ selectedRateCard ' + selectedRateCard);
                List<Rate__C> rates = [ SELECT id, name, rate__c, principal_minimum__c, principal_maximum__c, credit_score__c 
                                   FROM     Rate__C 
                                   WHERE    rate_card__c =: selectedRateCard.id
                                   ORDER BY principal_minimum__c ASC, principal_maximum__c ASC, credit_score__c ASC];
           		
	           //RateBand currentRateBand = new RateBand(getNextRowNum());
	           RateBand currentRateBand = new RateBand();
	           //RateBand currentRateBand = new RateBand(1);
	           currentRateBand.pMin = -1;
	           currentRateBand.pMax = -1; 
	           Set<String> processedCreditScore = new Set<String>();
	    		ratecard = new List<RateBand>();
	    		Integer rowIndx = 0;
	           for(Rate__C rate : rates) {
	               if(rate.principal_minimum__c != currentRateBand.pMin && rate.principal_maximum__c != currentRateBand.pMax) {
	                   currentRateBand = new RateBand();
	                   currentRateBand.pMin = rate.principal_minimum__c;
	                   currentRateBand.pMax = rate.principal_maximum__c;
	                   currentRateBand.rateId 	= rate.id;
	                   currentRateBand.rowNum 	= rowIndx ++;
	                   rateCard.add(currentRateBand);
	               }
	               currentRateBand.rateMap.put(rate.credit_score__c, rate);
	           }
	           
	            fillRateCard();
	        }
            return rateCard;
        }
        set;
    }
    
    public PR_RateCardExt () {
    }        
    
    private void fillRateCard() {    
        for(RateBand rb : rateCard) {
            rb.orderedRates.clear();
            for(String creditScore : creditScores) {
                Rate__c rate = rb.rateMap.get(creditScore);
                if(rate==null) {
                    rate = makeBlankRate(rb.pMin, rb.pMax, creditScore);
                }
                rb.orderedRates.add(rate);
            }
        }
    }

    public PageReference saveAllRow(){
        List<Rate__c> ratesToUpsert = new List<Rate__c>();
        for(RateBand rb : rateCard) {
            for(Rate__c rate : rb.orderedRates) {
                rate.principal_minimum__c = rb.pMin;
                rate.principal_maximum__c = rb.pMax;
                //Fahad Akhtar: Commented out the line from here to check the intrest rate before insert. 
                //we need 0% intrest rate for TD risk grade.
                ratesToUpsert.add(rate);
            }
        }

        if(ratesToUpsert.size()>0) {
            //check if user has insert access before performing DML upsert - Marvin @ JAN.18.2016 (Code Scan/Security Issues)
            //if(Rate__c.SObjectType.getDescribe().isCreateable()) {
                upsert ratesToUpsert;
            //} 
        }
        rateCard = null;
        return null;
    }          
    
    public PageReference deleteRow() {        
        String rowNum = ApexPages.currentPage().getParameters().get('rowNum');
        System.debug('####: ' + rowNum);
        List<Rate__c> ratesToDelete= new List<Rate__c>();
        for(RateBand rb : rateCard) {
           if(rowNum == String.valueOf(rb.rowNum)) {
                for(Rate__c rate : rb.orderedRates) {
                   if(rate.id != null) {
                       ratesToDelete.add(rate);
                    }
               }
           }
        }
        rateCard.remove(Integer.valueOf(rowNum));
        System.debug('&&&& ratesToDelete ' + ratesToDelete);
        if(ratesToDelete.size()>0) {
            /*CHECKMARX
            // check if user has delete access before performing DML delete - Russell @ JAN.18.2016 (Code Scan/Security Issues)
            if(Rate__c.sObjectType.getDescribe().isDeletable()){
                delete ratesToDelete;
            }
            */
            delete ratesToDelete;
        }
        rateCard = null;
        return null;
    }
    
    public PageReference addNewRow() {
        rateCard = null;
        RateBand currentRateBand = new RateBand();

        if(rateCard.size()>0) {
            RateBand lastRateBand = rateCard.get(rateCard.size() -1);
            
            currentRateBand.pMin = lastRateBand.pMax + 1;
            currentRateBand.pMax = lastRateBand.pMax + 1;
        } else {
            currentRateBand.pMin = 0;
            currentRateBand.pMax = 0;
        }
        
        rateCard.add(currentRateBand);
        fillRateCard();

        return null;
    }

    
    public Rate__c makeBlankRate(Decimal pMin, Decimal pMax, String creditScore) {
       Rate__c blankRate = new Rate__c();
       blankRate .principal_minimum__c = pMin;
       blankRate .principal_maximum__c = pMax;
       blankRate .rate__c = 0;
       blankRate.rate_Card__c = selectedRateCard.id;
       blankRate.credit_score__c = creditScore;
       return blankRate;
    }
    
    public Class RateBand {
        //public integer rowNum { get; private set;}
        public Decimal pMin {get;set;}
        public Decimal pMax {get;set;}
        public String  rateId {get; set;}
        public Integer rowNum {get; set;}
        public Map<String, Rate__C> rateMap{
            get { 
                if(rateMap==null) {
                    rateMap=new Map<String, Rate__C>();
                }
                return rateMap;
            }
            set;
        }
        
        public List<Rate__c> orderedRates {
            get { 
                if(orderedRates ==null) {
                    orderedRates =new List<Rate__c>();
                }
                return orderedRates ;
            }
            set;
        }
       
        public RateBand(){

        }
    }   

}