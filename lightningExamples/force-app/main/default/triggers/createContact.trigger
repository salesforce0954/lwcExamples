trigger createContact on Account (after insert) {

 List<contact> conList = new List<Contact>();
 if(Trigger.isInsert && Trigger.isAfter){
 for(Account acc: Trigger.New){
   contact con = new contact();
   con.lastName = 'Suneel';
   con.accountId = acc.id;
   conList.add(con);
 }
  insert conList;
  }
 
}