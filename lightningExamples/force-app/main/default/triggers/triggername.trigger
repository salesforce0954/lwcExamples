Trigger triggername on Account(after insert){
List<contact> cclist = new List<contact>();
for(Account acc:trigger.new){
Contact c = new Contact();
c.lastname = 'recursivetest';
c.accountid = acc.id;
cclist.add(c);
}
system.debug('Account Triggered');
insert cclist;
}