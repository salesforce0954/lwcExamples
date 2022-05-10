trigger checkLeadEmail on Lead(before insert,before update){

  set<string> searchEmail = new set<String>();
  
  for(Lead l:Trigger.New){
     searchEmail.add(l.Email);
  }
  
  List<Lead> lst = [select email from Lead where email in : searchEmail];
  
  for(Lead ld:Trigger.new){
    if(lst.size() > 0){
       ld.addError('Email alread exists in another lead record');
    }
  }

}