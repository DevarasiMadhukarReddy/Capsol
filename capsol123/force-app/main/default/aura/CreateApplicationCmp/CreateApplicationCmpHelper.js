({
    helperMethod: function(component, event, helper) {
        var action = component.get("c.getOpportunityForLtng");
       

        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var opp = response.getReturnValue();
                component.set("v.opp",opp);
                component.set("v.showMainModel",true);
                if(opp != null && opp.BAQ__c != null && opp.Application__c == null){
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
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.loadingMsg", '');
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res && res.startsWith('SUCCESS! ')){
                    //this.closeModal(component);
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
        var refresh=$A.get('e.force:refreshView');
                    refresh.fire();
        
    },
    closeModal: function(component) {
        // set "isOpen" attribute to false for hide/close model box 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})