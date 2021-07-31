public class New_PracticeAcquisitionChecklistHandler {
    public void populatecontactrole(list<Practice_Acquisition_Checklist__c> praclist){
        
        set<ID> oppIds = new set<id>();
        Practice_Acquisition_Checklist__c pracAcqCont;
        Map<ID,Practice_Acquisition_Checklist__c> opppractiveAcqMap = new Map<ID,Practice_Acquisition_Checklist__c>();
        
        for(Practice_Acquisition_Checklist__c prac : praclist){
            opppractiveAcqMap.put(prac.Associated_Opportunity__c, prac);
        }
        
        List<Opportunitycontactrole>  oppconlist = [Select id,Role,OpportunityID,ContactId from Opportunitycontactrole where OpportunityID in :opppractiveAcqMap.keySet() and role in('Seller','Buyer')];     
        
        for(Opportunitycontactrole ocr : oppconlist){
            pracAcqCont = opppractiveAcqMap.get(ocr.OpportunityId);
            if(ocr.Role == 'Seller') {
                pracAcqCont.seller__c = ocr.ContactId;
            }
            else if(ocr.Role == 'Buyer'){
                pracAcqCont.Primary_Buyer__c = ocr.ContactId;
            }
        }                
    }
}