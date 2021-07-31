global class LPL_OpportunityContactRole_batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'select id,contact__c from Opportunity';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Opportunity> oppList){
        Map<Id,Id> oppConMap = new Map<Id,Id>();
        List<opportunityContactRole> oppConToDelete = new List<opportunityContactRole>();
        Set<Id> oppId = new Set<Id>();
        for(Opportunity o : oppList){
            oppId.add(o.Id);
            oppConMap.put(o.Id,o.Contact__c);
        }
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>([Select id,OpportunityId,ContactId from OpportunityContactRole where OpportunityId in:oppId]);
        for(OpportunityContactRole ocr:ocrList){
            if(oppConMap.containsKey(ocr.OpportunityId)){
                String conId = oppConMap.get(ocr.OpportunityId);
                if(ocr.ContactId!=conId)
                    oppConToDelete.add(ocr);
            }
        }
        delete oppConToDelete;
    }
    global void finish(Database.BatchableContext bc){}
}