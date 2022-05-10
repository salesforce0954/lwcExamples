trigger addDrbeforeName on Lead (before insert) {
   for(Lead ld : Trigger.New){
      ld.FirstName = 'Dr '+ld.FirstName;
   }
   
}