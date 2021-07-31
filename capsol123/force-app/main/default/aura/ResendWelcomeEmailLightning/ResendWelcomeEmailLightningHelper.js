({
    helperMethod: function(component, event, helper) {
        var action = component.get("c.resendWelcomeEmail");
       

        action.setParams({
            "taskId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var task1 = response.getReturnValue();
                component.set("v.task1",task1);
                component.set("v.showMainModel",true);
                console.log(task1);
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
            $A.get('e.force:refreshView').fire();
        });
         
        $A.enqueueAction(action);
    },
    closeModal: function(component) {
        // set "isOpen" attribute to false for hide/close model box 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})