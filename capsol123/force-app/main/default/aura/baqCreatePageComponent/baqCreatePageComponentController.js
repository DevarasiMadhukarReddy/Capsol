({
    doInit : function(component, event, helper){
        /*var recordId = component.get("v.recordId");
        console.log("-recordId-"+recordId);
    	component.find("opp_field").set("v.value", recordId);*/
	},
    cancelBaqNew  : function(component, event, helper) {
        window.history.go(-1);
    },
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        //eventFields["Opportunity__c"] = "Test Value";
        component.find('edit').submit(eventFields);
    },
    onSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(payload.id);
        var navEvt = $A.get("e.force:navigateToSObject");
        console.log(navEvt);
        navEvt.setParams({
            "recordId": payload.id,
            "slideDevName": "detail"
        });
        navEvt.fire();
        console.log('fired',navEvt);        
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
})