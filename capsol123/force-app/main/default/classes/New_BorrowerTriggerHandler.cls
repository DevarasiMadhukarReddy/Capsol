public class New_BorrowerTriggerHandler implements BaseTriggerHandler{
    /*
##############Change History#############
CH.No       Description                                                          Developer           Date
-----------------------------------------------------------------------------------------------------------------
CH-01      Added method UpdatePrimaryContactCheck and ValidateBorrower          Ishan Nigam     10/22/2020
           to set primary contact flag and validate borrower.    
    * * CH.No       Description                                                           Developer           Date
------------------------------------------------------------------------------------------------------------------------
    *   CH02       CS-2756 Sprint 21- Remove hardcoded values                              Bhanu              02/01/2021
    *   CH-03      CS-2610 Sprint 22- Multiple Acquisition Application for Borrower        Saritha            02/17/2021
    *   CH-04      CS - 2953 Enhancement - Update Forgivable Application and related 
                   record as read - only when offer accepted                               Amol               03/26/2021 
                                                                                         
*/
    //Global Variables
        ID aquisitionLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Acquisition Loan').getRecordTypeId();
        ID growthLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Growth Loan').getRecordTypeId();
        ID locRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Line of Credit').getRecordTypeId();
        ID refinanceLoanRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Refinance Loan').getRecordTypeId();
        ID backendTaRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Backend TA').getRecordTypeId();
        ID retentionRecTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByName().get('Retention Loan').getRecordTypeId();// CH-04
    
    public Boolean IsDisabled()
    { 
        return false;
    }
    
    public void AfterInsert(Map<Id, SObject> newItems){
        UpdatePrimaryContactCheck(trigger.new,trigger.old,(Map<Id,Borrowers__c>)trigger.oldMap);
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
       UpdatePrimaryContactCheck(trigger.new,trigger.old,(Map<Id,Borrowers__c>)trigger.oldMap);
    }
    public void BeforeInsert(List<SObject> newItems) {
        ValidateBorrower(trigger.new,trigger.old,(Map<Id,Borrowers__c>)trigger.oldMap);
    }
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
       ValidateBorrower(trigger.new,trigger.old,(Map<Id,Borrowers__c>)trigger.oldMap);
    }
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
    
    public void UpdatePrimaryContactCheck(list<Borrowers__c> borrList,List<Borrowers__c> oldborrList,Map<Id,Borrowers__c> oldborrMap){
         
        List<Borrowers__c> bList = new List<Borrowers__c>();  //borrowers list
        ID pConId;
        ID pConNullId = null;
        Boolean pConCheck;
        Set<Id> appIds = new Set<Id>();        //set to store application ids for primary contact checked
        Set<Id> borrowerIds = new Set<Id>();   //set to store borrower ids
        Set<Id> pAppIds = new Set<Id>();         //set to store application ids
        for(Borrowers__c b : borrList)
        {
            pConId = b.Contact__c;
            pConCheck = b.Primary_Contact__c;
            pAppIds.add(b.Loan_Application__c);
            if(pConCheck == true)
            {
              appIds.add(b.Loan_Application__c);
              borrowerIds.add(b.Id);   
            }
                         
        }
        List<Borrowers__c> lstToUpdate = new List<Borrowers__c>();
        bList = [select id,Primary_Contact__c from Borrowers__c
                 where Loan_Application__c IN :appIds
                 and Id NOT IN :borrowerIds
                 and (Loan_Application__r.RecordTypeId = :aquisitionLoanRecTypeId
                      or Loan_Application__r.RecordTypeId = :growthLoanRecTypeId
                      or Loan_Application__r.RecordTypeId = :locRecTypeId
                      or Loan_Application__r.RecordTypeId = :refinanceLoanRecTypeId
                      or Loan_Application__r.RecordTypeId = :backendTaRecTypeId)];
        for(Borrowers__c bor : bList)
        {
            if(bor.Primary_Contact__c == true)
            {
               bor.Primary_Contact__c = false;   //set Primary Contact checkbox for existing primary records to false
               lstToUpdate.add(bor);
            }
        }
        //Code for updating primary contact of application with primary borrowers contact
        List<Loan_Application__c> appUpdate = new List<Loan_Application__c>();
        for(Loan_Application__c app : [select id,Primary_Contact_name__c,RecordTypeId from Loan_Application__c where id in :pAppIds])
        {
           if(app.RecordTypeId == aquisitionLoanRecTypeId || app.RecordTypeId == growthLoanRecTypeId || app.RecordTypeId == locRecTypeId || app.RecordTypeId == refinanceLoanRecTypeId || app.RecordTypeId == backendTaRecTypeId)
           {
            if(pConCheck == true && pConId != null)
            {
                app.Primary_Contact_Name__c = pConId;
                appUpdate.add(app);
            }
            else if(pConCheck == false && app.Primary_Contact_Name__c != null && Trigger.isUpdate)
            {
               // System.Debug('Primary Check'+ pConCheck);
                app.Primary_Contact_Name__c = pConNullId;
                appUpdate.add(app);
            }
           }
        }
        
        if(lstToUpdate.size() > 0)
        {
           update lstToUpdate; 
        }
        if(appUpdate.size() > 0)
        {
            update appUpdate;
        }
        
    }
    
    public void ValidateBorrower(list<Borrowers__c> borrList,List<Borrowers__c> oldborrList,Map<Id,Borrowers__c> oldborrMap){
        //Method to validate borrower for terminated contact or if primary contact already exist for non funded and non declined loan application
        Set<Id> appIds = new Set<Id>();
        Set<Id> borrowerIds = new Set<Id>();
        Set<Id> conIds = new Set<Id>();
        Map<string,Borrowers__c> newBorr = new Map<string,Borrowers__c>();
        Map<string,Contact> newCon = new Map<string,Contact>();
        Map<ID,Loan_Application__c> newApp = new Map<ID,Loan_Application__c>();
        
        List<LPL_Applications_status__mdt> lplStatusLst = [select Id,Action__c, Status__c ,Object_Name__c from LPL_Applications_status__mdt];
        String   loanStatusDocumentation=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_13');
        String   loanStatusBoardingFunding=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_14');
        String   loanStatusNigo=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_15');
        String   loanStatuInformationRequested=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_16');
        String   loanStatusInformationSubmitted=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_17');
        String   loanStatusFunded=LPL_LoanApplicationHandler.getApplicationStatus(lplStatusLst,'Loan_Application__c','Status_7');
        //Map<ID,Borrowers__c> matchedBorr = new Map<ID,Borrowers__c>();
        
            //start CH02 
        String conStatus= LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_8');
        String LoanDeclined= LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_2');
        String loanFunded= LoanSubmitApplication.getApplicationStatus('Loan_Application__c','Status_7');
        //End
        for(Borrowers__c bor : borrlist)
        {
           conIds.add(bor.Contact__c);
           appIds.add(bor.Loan_Application__c); 
            
        }
        
        for(Contact con : [select id,Rep_Status__c from contact where id in :conIds])
        {
            newCon.put(con.Rep_Status__c,con);
                      
         
        }
        for(Loan_Application__c app : [select id,recordtypeid from Loan_Application__c where id IN :appIds])
        {
            newApp.put(app.recordtypeid,app);
            
        }
         List<Borrowers__c> vBorr = new List<Borrowers__c>();
         List<Borrowers__c> matchBorr = new List<Borrowers__c>();
            //start CH02 
        vBorr = [select id,primary_contact__c,Loan_Application__r.recordtypeid from Borrowers__c
                 where Loan_Application__c NOT IN :appIds
                 and Contact__c IN :conIds
                 and primary_Contact__c = true
                 and Loan_Application__r.RecordTypeId = :newApp.keyset()
                 and Loan_Application__r.status__c NOT IN (:LoanDeclined,:loanFunded)];//End
        for(Borrowers__c b : vBorr)
        {
            matchBorr.add(b);
            
        }
       //CH-03 START 
        /*for(Borrowers__c bor : borrlist)
        {
            if((newCon.containskey(conStatus) || (matchBorr.size() > 0) && bor.primary_contact__c == true) && (newApp.containsKey(growthLoanRecTypeId) || newApp.containsKey(locRecTypeId) || newApp.containsKey(refinanceLoanRecTypeId) || newApp.containsKey(backendTaRecTypeId) || newApp.containsKey(aquisitionLoanRecTypeId)))
            {
                bor.addError('This Customer already has an opened Loan Application or this Contact is Terminated.');
            }
        } */
       for(Borrowers__c bor : borrlist)
        {
            //CH-04 Start
            if((bor.Loan_Application__r.Status__c != loanStatusDocumentation && bor.Loan_Application__r.Status__c != loanStatusBoardingFunding &&
            bor.Loan_Application__r.Status__c != loanStatusNigo && bor.Loan_Application__r.Status__c != loanStatuInformationRequested &&
            bor.Loan_Application__r.Status__c != loanStatusInformationSubmitted && bor.Loan_Application__r.Status__c != loanStatusFunded) 
            && bor.Loan_Application__r.RecordTypeId != retentionRecTypeId ){
                    if((newCon.containskey(conStatus) || (matchBorr.size() > 0) && bor.primary_contact__c == true) && (newApp.containsKey(growthLoanRecTypeId) || newApp.containsKey(locRecTypeId) || newApp.containsKey(refinanceLoanRecTypeId) || newApp.containsKey(backendTaRecTypeId)))
                    {
                        bor.addError('This Customer already has an opened Loan Application or this Contact is Terminated.');
                    }
                }
                //CH-04 End
        }
        //CH-03 END
    }
    
}