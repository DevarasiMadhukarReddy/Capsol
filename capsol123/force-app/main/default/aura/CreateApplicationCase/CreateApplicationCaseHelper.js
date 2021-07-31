({
    helperMethod: function(component, event, helper) {

      
        var action = component.get("c.getCaseForLtng");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var case1 = response.getReturnValue();
                component.set("v.case1",case1);
                component.set("v.showMainModel",true);
                console.log(case1);
                if(case1 != null && case1.Application__c == null){
                    this.createApplication(component);
                }
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
    createApplication: function(component) {
        var toggleText = component.find("Hidemsg");
        $A.util.toggleClass(toggleText, "createApplication");
        component.set("v.errorMsg", '');
        component.set("v.loadingMsg", 'SUCCESS! Application has been created.');
        let createBtn = component.find("createBtn");
        if(createBtn){
            createBtn.set("v.disabled", true);
        }
        var action = component.get("c.createApplicationLtng");
        
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.loadingMsg", '');
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res && res.startsWith('SUCCESS! ')){
                    
                    var sObectEvent = $A.get("e.force:navigateToSObject");
                    sObectEvent .setParams({
                        "recordId": component.get("v.recordId")
                    });
                    sObectEvent.fire();
                }else{
                    if(createBtn){
                        createBtn.set("v.disabled", false);
                    }
                    component.set("v.errorMsg", res);
                }
            } else if (state == "INCOMPLETE") {
                if(createBtn){
                    createBtn.set("v.disabled", false);
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {
                if(createBtn){
                    createBtn.set("v.disabled", false);
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },
    closeModal: function(component) {
        // set "isOpen" attribute to false for hide/close model box 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})