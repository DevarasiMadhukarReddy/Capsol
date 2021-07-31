trigger BankAccountCustomTrigger on loan__Bank_Account__c (after insert, before update) {
    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            if (!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c){
                BankAccountCustomTriggerHandlerCL handler = new BankAccountCustomTriggerHandlerCL(trigger.oldMap, trigger.newMap);
                handler.afterInsertHandler();   
            }
        }
    }
    
    else if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            if (!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c){
                for (loan__Bank_Account__c bankObj: trigger.new){
                    /*if( !(trigger.oldMap.get(bankObj.Id).Approved__c == false && bankObj.Approved__c == true)) {
                        bankObj.Approved__c = false;
                    }*/
                    if(trigger.oldMap.get(bankObj.Id).Approved__c == true) {
                        Trigger.newMap.get(bankObj.Id).addError('Can not modify approved bank account records!');
                    }
                }
            }
        }
    }


    
}