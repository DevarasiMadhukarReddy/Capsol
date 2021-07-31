({
	//Bhanu CS-2072 Start  
    checkUserPermission: function (component, event, helper) {
         var action = component.get('c.checkLoggedInUserAccess1');
          action.setParams({
            "source": "Contact"
        });
         action.setCallback(this, function (response) {
            if (response.getReturnValue()==false){
                 alert('You do not have the level of access necessary to perform the operation you requested.');
           	     $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    //Bhanu CS-2072 ends
    helperMethod : function() {
		
	}
})