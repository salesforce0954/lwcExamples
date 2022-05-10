({
	getFirstName : function(component, event, helper) {
        
            let firstName = component.find("fname");
            let fname = firstName.get("v.value");
        
            let lastName = component.find("lname");
            let lname = lastName.get("v.value");
        
            let action = component.get("c.createApplicant");
        action.setParams({firstName:fname,
                          lastName:lname            
        });
        action.setCallback(this,function(response){
            const state = response.getState();
            console.log('State '+state);
        })
        $A.enqueueAction(action);
        
        
        
        
	}
})