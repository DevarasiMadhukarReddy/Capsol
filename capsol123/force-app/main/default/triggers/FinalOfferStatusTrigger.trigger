trigger FinalOfferStatusTrigger on Opportunity (after update) {
    
    if (!loan.CustomSettingsUtil.getOrgParameters().loan__Disable_Triggers__c){
     
        Set<Id> appsIds = new Set<Id>();
        for(Id key : trigger.newMap.keySet()) {
            
            /*
            if((String.valueOf(trigger.newMap.get(key).Final_Offer_Status__c)) != null) {
                if(trigger.oldMap.get(key).Final_Offer_Status__c == null && String.valueOf(trigger.newMap.get(key).Final_Offer_Status__c).equals(ConstantsCl.OPPORTUNITY_STATUS_FINAL_OFFER_SUBMITTED)) {
                    appsIds.add(trigger.newMap.get(key).Application__c);
                }
            } */
            
            /* Changing logic with checkbox data type */
            System.debug('## Opp : ' + trigger.newMap.get(key).Name + ' ## OldMapFlag ' + trigger.oldMap.get(key).Final_Offer_Submitted__c + ' & NewMapFlag ' + trigger.newMap.get(key).Final_Offer_Submitted__c);
            if(trigger.oldMap.get(key).Final_Offer_Submitted__c == false && trigger.newMap.get(key).Final_Offer_Submitted__c == true) {
                /* Defensive check against recursive call */
                System.debug('## Opp : ' + trigger.newMap.get(key).Name + ' ## OldMapStatus ' + trigger.oldMap.get(key).Final_Offer_Status__c + ' & NewMapStatus ' + trigger.newMap.get(key).Final_Offer_Status__c);
                if(trigger.oldMap.get(key).Final_Offer_Status__c == trigger.newMap.get(key).Final_Offer_Status__c) {
                    appsIds.add(trigger.newMap.get(key).Application__c);
                }
            }
        }
        
        if(appsIds.size() > 0) {
            List<genesis__Applications__c> apps = [SELECT Id, Name, genesis__Status__c
                                                    FROM genesis__Applications__c
                                                    WHERE isParentApplication__c = true AND Id IN :appsIds ];
            
            if(apps != null && apps.size() > 0) {
                List<genesis__Applications__c> appsToUpdate = new List<genesis__Applications__c>();
                //List<Id> appIdsForFinalOffers = new List<Id>();
                for(genesis__Applications__c app : apps) {
                    app.genesis__Status__c = ConstantsCl.APPLICATION_STATUS_FINAL_OFFER_INITIATED;
                    appsToUpdate.add(app);
                    //appIdsForFinalOffers.add(app.Id);
                }
                
                if(appsToUpdate.size() > 0) {
                    UPDATE appsToUpdate;
                }
                
                /* Removed this for accomodating change request on business flow. 09/14
                Savepoint sp = Database.setSavepoint();
                
                try{
                    if(appsToUpdate.size() > 0) {
                        UPDATE appsToUpdate;
                    }
                    Cls_FinalOfferCreation.finalOfferCreation(appIdsForFinalOffers);
                } catch(Exception e) {
                    Database.rollback(sp);
                    Trigger.new[0].addError(e);
                } */
                
            }
        } 
     
    }
    
}