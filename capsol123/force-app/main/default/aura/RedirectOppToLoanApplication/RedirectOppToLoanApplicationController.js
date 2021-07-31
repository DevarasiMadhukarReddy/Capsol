({
    init : function (component, event, helper){
        var oppId = component.get("v.recordId");
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "Loan_Application__c",
            "defaultFieldValues":
            {
                'Opportunity__c' : oppId
            }
        });
        createAcountContactEvent.fire();  
    }
})