trigger discountOnPrice on Book__c (before insert,before update) {

    List<Book__c> blist = Trigger.New;
    bookHandler.discountPrice(blist);
}