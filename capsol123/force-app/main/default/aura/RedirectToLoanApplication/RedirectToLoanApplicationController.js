({
    init : function (component, event, helper){
        var contactId = component.get("v.recordId");
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Loan_Application__c",
            "defaultFieldValues":
            {
                'Advisor__c' : contactId
            }
        });
        createAcountContactEvent.fire();  
    }
})