public Class caseTrigger{



public void caseTriggerone(){

list<case> caselst = [select id, ownerid from case];

for(case c:caselst){
if(c.Status=='Escalated')  
     c.OwnerId='00G7F000000ifV4';  
}

}

}