({
    
    getDetails : function(component, event, helper) {
        var action = component.get("c.getDetails");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });    
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data = response.getReturnValue();
            if(state === "SUCCESS") {
                component.set("v.baqRecord", data);
                console.log('>?>./'+JSON.stringify(data));
                
            }  
        });
        $A.enqueueAction(action);
    },
    
    deleteBaqHelper : function(component, event, helper) {
        if(confirm('Are you sure, you want to delete the selected records?')){
            var recID = component.get("v.recordId");
            console.log('***',recID);
            var action = component.get("c.deleteBaq");
            action.setParams({
                "recordId" : component.get("v.recordId"),
            });    
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var homeEvent = $A.get("e.force:navigateToObjectHome");
                    console.log('evt',homeEvent);
                    homeEvent.setParams({
                        "scope": "BAQ__c"
                    });
                    homeEvent.fire();
                    console.log('evtfired');
                }  
            });
            $A.enqueueAction(action);
        }else{
            console.log('do not delete');
        }
    },
    
    /*saveBaq : function(component, event, helper) {
        var action = component.get("c.deleteBaq");
        action.setParams({
            "record" : component.get("v.baqRecord"),
            "isUpdate"	: true
        });    
        action.setCallback(this, function(response) {
            var state = response.getState();
            var data = response.getReturnValue();
            if(state === "SUCCESS") {
             // component.set("v.baqRecord", data);
                console.log('update.../');
                this.getDetails(component, event, helper);
            }  
        });
        $A.enqueueAction(action);
    },*/
})