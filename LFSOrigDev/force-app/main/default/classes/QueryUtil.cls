global class QueryUtil{     
    public static boolean run = true;
    
    public static boolean runOnce(){
      if(run){
        run=false;
        return true;
      }
      else{return run;}
    }

    private static testmethod void testOSRUtil(){
      System.assert(QueryUtil.runOnce(), 'Recursion check failed. Please review OSRUtil recursion logic');
      System.assert(!QueryUtil.runOnce(), 'Recursion check failed. Please review OSRUtil recursion logic');
    }

    public static MAP<Id, User> mapUsers(Event[] events, Task[] tasks, Account[] accounts){
        Map<Id, User> mapUser = new Map<Id, User>();
        
        // Map User Business Units
        if(events != null){
            for(Event e:events){
              mapUser.put(e.OwnerId, null);
            }
        }
        if(tasks != null){
            for(Task t:tasks){
              mapUser.put(t.OwnerId, null);
            }       
        }
        if(accounts != null){
            for(Account a:accounts){
                mapUser.put(a.OwnerId, null);
            }
        }
        // Fill map with User records
        
        for(User[] arrUser : [Select Id, Business_Unit__c, Name, Profile.Name, LocaleSidKey from User Where Id IN :mapUser.keySet()]){
            for(User sUser : arrUser)
            {
                mapUser.put(sUser.Id, sUser);
                System.debug('--Business unit--'+mapUser.get(sUser.id).Business_Unit__c+'---User Id--'+sUser.Id+'--profile-id--'+mapUser.get(sUser.id).profileId);
            }
        }
        
        return mapUser;
        
    }
}