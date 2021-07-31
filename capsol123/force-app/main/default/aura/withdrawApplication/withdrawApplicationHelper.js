({
    checkApp: function (component, event, helper) {
        var action = component.get('c.checkWithdrawApplication');
        action.setParams({
            "loanAppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            console.log(response.getReturnValue().length);
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                console.log('inside length');
                if (response.getReturnValue() == 'Initiated') {
                    component.set('v.showConfirm1', true);
                } else {
                    component.set('v.showConfirm', true);
                }

                component.set("v.closeLabel", "CLOSE");
            } else {
                alert('Please contact your Administrator');
            }
        });
        $A.enqueueAction(action);
    },
    helperMethod: function (component, event, helper) {
        var action = component.get('c.withdrawApplication');
        action.setParams({
            "loanAppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(state);
            console.log(response.getReturnValue().length);
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                /*console.log('inside length');
                if (response.getReturnValue()) {
                    component.set('v.showConfirm', true);
                } else {
                    component.set('v.showConfirm1', true);
                }*/
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();

                //component.set("v.closeLabel", "CLOSE");
            } else {
                alert('Please contact your Administrator');
            }
        });
        $A.enqueueAction(action);
    },
    closeModal: function (component) {
        // set "isOpen" attribute to false for hide/close model box 
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();

        var dismissActionrefresh = $A.get("e.force:refreshView");
        dismissActionrefresh.fire();
    }
})