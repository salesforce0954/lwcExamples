trigger conInsert on Account (after insert) {
    
     if(Trigger.isAfter && Trigger.isInsert){
       insertcontact.insertcon(Trigger.New);
     }
 }