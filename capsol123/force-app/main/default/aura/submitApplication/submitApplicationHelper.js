({
    checkApp: function (component, event, helper) {
        var action = component.get('c.checkLoanApplication');
        action.setParams({
            "loanAppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                if (response.getReturnValue().length != 0) {
                    console.log('inside length');
                    component.set('v.showMainModel', true);

                    component.set('v.ErrorData', response.getReturnValue());
                    component.set('v.showConfirm', false); // aded by Madhukar reddy
                    // component.set('v.showConfirm1', false);
                    component.set("v.closeLabel", "CLOSE"); // aded by Madhukar reddy 8/24/2020

                } else {
                    console.log('outside length');
                    //helper.helperMethod(component, event, helper); //commented by madhukar Reddy
                    //alert('Please review following fields \n ' + response.getReturnValue().join('\n'));

                    component.set('v.showConfirm', true);
                    //   component.set('v.showConfirm1', true);
                }
            } else {
                alert('Please contact your Administrator');
            }
        });
        $A.enqueueAction(action);
    },
    helperMethod: function (component, event, helper) {
        var action = component.get("c.createRepayableProposalOfferAura");
        action.setParams({
            "loanAppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('SUCCESS');
                var loanApp = response.getReturnValue();
                //added by Amol for Error Handling
                console.log('loanApp' + loanApp);
                window.setTimeout(
                    $A.getCallback(function () {
                        helper.pollExceptionLog(component, helper);
                    }), 8000
                );

                /*component.set("v.loanApp", loanApp);
                component.set("v.showMainModel", true);
                component.set('v.showConfirm', false); //Added by Madhukar Reddy
                component.set("v.closeLabel", "CLOSE"); //Added by Madhukar Reddy
                console.log(loanApp);
                component.set("v.showSpinner",false);*/
                //Amol Chnages end 
                //$A.get("e.force:closeQuickAction").fire();
                // $A.get('e.force:refreshView').fire();
            } else if (state == "INCOMPLETE") {
                console.log('INCOMPLETE');
                component.set("v.showMainModel", true); //Added by Madhukar Reddy
                component.set("v.showError", true);
                component.set("v.loanApp", "No Internet Connection"); // Ended
                /* var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Oops!",
                     "message": "No Internet Connection"
                 });
                 toastEvent.fire();*/ //commented by Madhukar Reddy
                component.set("v.showSpinner", false);
            } else if (state == "ERROR") {
                console.log('error');
                component.set("v.showMainModel", true);
                component.set("v.showError", true);
                component.set("v.loanApp", "Please contact your administrator");
                component.set("v.showSpinner", false);
                /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
            $A.get('e.force:refreshView').fire();
        });
         
        $A.enqueueAction(action);  */ // commented by Madhukar Reddy
            }
        });

        $A.enqueueAction(action);


    },
    //added by Amol for Error Handling

    pollExceptionLog: function (component, event, helper) {
        var action = component.get("c.checkExceptionLog");
        action.setParams({
            "loanAppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //console.log('SUCCESS');
                var loanApp = response.getReturnValue();
                component.set("v.loanApp", loanApp);
                component.set("v.showMainModel", true);
                component.set('v.showConfirm', false); //Added by Madhukar Reddy
                component.set("v.closeLabel", "CLOSE"); //Added by Madhukar Reddy
                console.log('poll' + loanApp);
                component.set("v.showSpinner", false);
                //$A.get("e.force:closeQuickAction").fire();
                // $A.get('e.force:refreshView').fire();
            } else if (state == "INCOMPLETE") {
                console.log('INCOMPLETE');
                component.set("v.showMainModel", true); //Added by Madhukar Reddy
                component.set("v.showError", true);
                component.set("v.loanApp", "No Internet Connection"); // Ended
                /* var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Oops!",
                     "message": "No Internet Connection"
                 });
                 toastEvent.fire();*/ //commented by Madhukar Reddy
                component.set("v.showSpinner", false);
            } else if (state == "ERROR") {
                console.log('error');
                component.set("v.showMainModel", true);
                component.set("v.showError", true);
                component.set("v.loanApp", "Please contact your administrator");
                component.set("v.showSpinner", false);
                /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();
            }
            $A.get('e.force:refreshView').fire();
        });
         
        $A.enqueueAction(action);  */ // commented by Madhukar Reddy
            }
        });

        $A.enqueueAction(action);


    },
    // Amol chnages End
    closeModal: function (component) {
        // set "isOpen" attribute to false for hide/close model box 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();

        var dismissActionrefresh = $A.get("e.force:refreshView");
        dismissActionrefresh.fire();
    }   
      
})