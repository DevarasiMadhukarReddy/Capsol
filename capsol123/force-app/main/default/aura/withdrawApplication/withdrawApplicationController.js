({
    doInit: function (component, event, helper) {
        component.set('v.ErrorData', []);
        helper.checkApp(component, event, helper);

    },
    
    closepopup: function (component, event, helper) {
        helper.closeModal(component, event, helper);
    },
    submitapplication: function (component, event, helper) {
        
        helper.helperMethod(component, event, helper);

    }
    
})