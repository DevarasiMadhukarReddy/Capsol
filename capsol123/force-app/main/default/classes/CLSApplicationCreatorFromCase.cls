global class CLSApplicationCreatorFromCase {
    String caseId;
    Case cases;
    List<Contact> caseContact = new List<Contact>();
    //List<Contact> riaContact = new List<Contact>();
    Contact riaContact ;
    public CLSApplicationCreatorFromCase (String caseId) {
        this.caseId= caseId;
    }
    
    private void getCaseRecord() {
        /* Query the case fields */
        cases= [SELECT Id,Interest_Rate__c,Loan_Amount__c,ContactId,OwnerId,
                       Term__c,Status,Case_Reason_Detail__c,Application_Number__c,application__c
                FROM Case WHERE Id = :caseId];
        
        
    }
    
    private String createApplictionFromCase() {
        Savepoint sp = Database.setSavepoint();
        try {
            
            clcommon__cl_product__C clProduct= [select id,name
                                                      from clcommon__CL_Product__c
                                                      where clcommon__Product_Name__c=: cases.Case_Reason_Detail__c];
            /*
            if (cases.ContactId!=null)                                       
                caseContact = [select id,name,RIA_Firm_ID__c,RIA_Type__c from Contact where id=:cases.ContactId and RIA_Type__c='Hybrid']; 
            
            if(caseContact !=null && caseContact.size()>0)                  
                riaContact = [select id,name from Contact where master_rep_id__c=:caseContact[0].RIA_Firm_ID__c ];
            */
            List<RecordType> rtypes = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'genesis__Applications__c' AND Name='Loan' AND isActive=true];
            genesis__Applications__c app = new genesis__Applications__c();
            app.RecordTypeId = rtypes.get(0).Id;
            app.advisor_type__c = 'Existing';
            app.genesis__Contact__c = cases.contactId;
            app.genesis__product_type__c='LOAN';
            app.genesis__loan_amount__c = cases.loan_amount__c;
            app.genesis__interest_rate__c = cases.interest_rate__c;
            app.genesis__term__c = cases.term__c;
            app.application_type__c = cases.Case_Reason_Detail__c;
            app.amount_in_words__c  = (cases.loan_amount__c!=null?CLS_NumberToWord.amountWords(cases.loan_amount__c):null);
            //app.RIA_Type__c = (caseContact !=null && caseContact.size()>0?caseContact[0].RIA_Type__c:'');
            app.isParentApplication__c = true;
            app.Case__c = cases.Id;
            //app.osj_rep__c = (riaContact!=null?riaContact.id:null);
            app.genesis__status__c = cases.status;
            app.genesis__cl_product__c = (clProduct!=null?clProduct.id:null);
            
            INSERT app;
            
            List<genesis__Applications__c> appList = [SELECT Id, Name FROM genesis__Applications__c WHERE Id = :app.Id];
            cases.application__c  = app.id;
            cases.Application_Number__c = appList.get(0).Name;
            update cases;
            return 'SUCCESS! Application has been created.';
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug('##### Error in creating application ##### ' + e.getStackTraceString());
            if(e.getLineNumber()==31)
                return 'Error in creating an application. No RIA Firm ID matches with Master Rep Id in Contact' ;
            else 
                return 'Error in creating an application.'+ e.getMessage();
        }     
    }
    
    
    
    webService static String createApplication(String caseId) {
        if(String.isNotBlank(String.valueOf(caseId))) {
            
            CLSApplicationCreatorFromCase  ac = new CLSApplicationCreatorFromCase (caseId);
            ac.getCaseRecord();
            return ac.createApplictionFromCase();
            
        } else {
            return 'Unable to create an application! Case details are missing';
        }
        
    }
}