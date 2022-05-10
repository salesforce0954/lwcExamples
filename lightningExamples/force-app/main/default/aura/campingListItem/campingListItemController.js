({
	packItem:function(component, event, helper) {
		var a = component.get(v.item);
        a.Packed__c = true;
        component.set("v.item",a);
        var btn1 = event.getsource();
        document.getElementById(btn1.id).disabled=true;
	}
})