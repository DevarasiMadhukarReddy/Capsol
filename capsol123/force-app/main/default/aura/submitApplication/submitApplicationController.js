({
	doInit: function (component, event, helper) {
		component.set('v.ErrorData', []);
        var action = component.get('c.collectRecordName');
        action.setParams({
            "recId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {               
                
                console.log('Hello'+response.getReturnValue());                
                if (response.getReturnValue() != '' && response.getReturnValue()!= null) {
					component.set("v.hasSubmitted",true);                    
                   // helper.checkApp(component, event, helper); 12/02/2020 commented
                }else{     
                    component.set("v.hasSubmitted",false);
                    component.set('v.showConfirm', true); 
                     
                }
        	}
        });
        $A.enqueueAction(action);
        helper.checkApp(component, event, helper); //added by madhu 12/02/2020

	},
       
    //Started Madhukar Reddy added on 8/14/2020 for Submit confirmation CS-1121
	closepopup: function (component, event, helper) {
		helper.closeModal(component, event, helper);
	},
	submitapplication: function (component, event, helper) {
        component.set("v.showConfirm1",true);
         component.set("v.showSpinner",true);
        
       helper.helperMethod(component, event, helper);
        
	}
    //Ended CS-1121
})