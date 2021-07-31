/*
##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
Description:  Loading of data of Managed Package Object 'Cl Contract'       Vaibhav Wadhai     31/08/2017
              into custom Object 'Advisor Loan'.here we have mapped 
              some fields from Cl Contract object to Advisor Loan Object.

*/

global class LPL_Batch_CLLoan_TransferObjectdata implements Database.batchable<sobject> {
       

global Database.QueryLocator start(Database.BatchableContext BC){
    
    String Query;
    if(!test.isRunningTest()){                                          
    Query = 'Select Id,Name, Annual_Forgiveness__c, loan__Expected_Disbursal_Date__c, loan__Maturity_Date_Current__c, Loan_Program__c, Interest_Rate__c, loan__Number_of_Installments__c, Loan_Type__c, loan__loan_amount__C, loan__Principal_Remaining__c, Premium_Per_Cycle__c, Prepayments_Received__c, PY_Interest__c, PY_Principal__c, PY_Total_Payments__c, Special_circumstance__c, loan__Loan_Status__c, YTD_Interest__c, YTD_Principal__c, YTD_Total_Payments__c, loan__Contact__r.Master_Rep_ID__c, loan__Contact__r.Name from loan__Loan_Account__c';                                
    }
    else{
    Query = 'Select Id,Name, Annual_Forgiveness__c, loan__Expected_Disbursal_Date__c, loan__Maturity_Date_Current__c, Loan_Program__c, Interest_Rate__c, loan__Number_of_Installments__c, Loan_Type__c, loan__loan_amount__C, loan__Principal_Remaining__c, Premium_Per_Cycle__c, Prepayments_Received__c, PY_Interest__c, PY_Principal__c, PY_Total_Payments__c, Special_circumstance__c, loan__Loan_Status__c, YTD_Interest__c, YTD_Principal__c, YTD_Total_Payments__c, loan__Contact__r.Master_Rep_ID__c, loan__Contact__r.Name from loan__Loan_Account__c LIMIT 190';      
    }           
    return Database.getQueryLocator(Query);        
    
}

global void execute(Database.BatchableContext info, List<loan__Loan_Account__c> scope) {
    
    try {
        
        List<Advisor_Loan__c> advisorList=new List<Advisor_Loan__c>();            
        List<Advisor_Loan__c> AdvisorLoanList=new List<Advisor_Loan__c>();
        Map<String,Advisor_Loan__c> adviosrLoanMap=new Map<String,Advisor_Loan__c>();
        Set<String> ids=new Set<String>();
        
        for(Integer i=0;i<scope.size();i++) {
        
            ids.add(scope[i].Name);
        }
                    
        AdvisorLoanList=[select id,ExternalIdForMap__c from Advisor_Loan__c where ExternalIdForMap__c in : ids];   // Getting advisor loan records
        
        if(AdvisorLoanList.size()>0) {
        
        for(Integer i=0;i<AdvisorLoanList.size();i++) {
        
            if(AdvisorLoanList[i].ExternalIdForMap__c!=null) {
            
                adviosrLoanMap.put(AdvisorLoanList[i].ExternalIdForMap__c,AdvisorLoanList[i]);
                
            }
            
        }
        
        }
        System.debug('adviosrLoanMap'+adviosrLoanMap.size());
        System.debug('AdvisorLoanList'+AdvisorLoanList.size());
        
        if(scope.size()>=1) {
        
            System.debug('scope'+scope.size());
            
            for(loan__Loan_Account__c clContract:scope) {
                                                
                if(AdvisorLoanList.size()==0 ){ //Checking advisor Object having any data or not
                
                        Advisor_Loan__c advisor=new Advisor_Loan__c();                    
                        advisor.Name= clContract.Name;
                        advisor.Amount_Forgiven_Per_Year__c = clContract.Annual_Forgiveness__c;
                        advisor.Creation_Date__c =    clContract.loan__Expected_Disbursal_Date__c;
                        advisor.Loan_Payoff_Date__c =   clContract.loan__Maturity_Date_Current__c;
                        advisor.Loan_Program__c = clContract.Loan_Program__c;
                        advisor.Loan_Rate__c = clContract.Interest_Rate__c;
                        advisor.Loan_Term__c = String.valueOf(clContract.loan__Number_of_Installments__c); //Need to check - Text to decimal?
                        advisor.Loan_Type__c = clContract.Loan_Type__c;
                        advisor.Original_Amount__c = clContract.loan__loan_amount__C;
                        advisor.Outstanding_Loan_Balance__c = clContract.loan__Principal_Remaining__c;
                        advisor.Premium_Per_Period__c = clContract.Premium_Per_Cycle__c;
                        advisor.Prepayments_Received__c = clContract.Prepayments_Received__c;
                        advisor.PY_Interest_Payments__c = clContract.PY_Interest__c;
                        advisor.PY_Principal_Payments__c = clContract.PY_Principal__c;
                        advisor.PY_Total_Payments__c = clContract.PY_Total_Payments__c;
                        advisor.Special_Circumstance__c = clContract.Special_circumstance__c;
                        advisor.Status__c = clContract.loan__Loan_Status__c;
                        advisor.YTD_Interest_Payments__c = clContract.YTD_Interest__c;
                        advisor.YTD_Principal_Payments__c = clContract.YTD_Principal__c;
                        advisor.YTD_Total_Payments__c = clContract.YTD_Total_Payments__c;
                
                        advisor.Master_Rep_ID__c = clContract.loan__Contact__r.Master_Rep_ID__c;
                
                        advisor.Advisor_Name__c = clContract.loan__Contact__r.Id;                
                  
                        advisor.ExternalIdForMap__c=clContract.Name; // for unique data ,using this field(need to ask for field for assigment).
                        //advisor.Id=adviosrLoanMap.get(clContract.Name).Id;                     
                
                        System.debug('In If advisorList'+advisorList.size()+advisorList);
                
                        advisorList.add(advisor);          
                
                }
                
                else {                    
                
                    if(adviosrLoanMap.size()>0) {                                        
                        
                        if(!adviosrLoanMap.containsKey(clContract.Name)) { // If advisorLoanMap does not contain clContract.Name then insert then insert record into Advisor loan object.
                        
                        System.debug('Inside if statement');
                
                        Advisor_Loan__c advisor=new Advisor_Loan__c();                    
                        advisor.Name= clContract.Name;
                        advisor.Amount_Forgiven_Per_Year__c = clContract.Annual_Forgiveness__c;
                        advisor.Creation_Date__c =    clContract.loan__Expected_Disbursal_Date__c;
                        advisor.Loan_Payoff_Date__c =   clContract.loan__Maturity_Date_Current__c;
                        advisor.Loan_Program__c = clContract.Loan_Program__c;
                        advisor.Loan_Rate__c = clContract.Interest_Rate__c;
                        advisor.Loan_Term__c = String.valueOf(clContract.loan__Number_of_Installments__c); //Need to check - Text to decimal?
                        advisor.Loan_Type__c = clContract.Loan_Type__c;
                        advisor.Original_Amount__c = clContract.loan__loan_amount__C;
                        advisor.Outstanding_Loan_Balance__c = clContract.loan__Principal_Remaining__c;
                        advisor.Premium_Per_Period__c = clContract.Premium_Per_Cycle__c;
                        advisor.Prepayments_Received__c = clContract.Prepayments_Received__c;
                        advisor.PY_Interest_Payments__c = clContract.PY_Interest__c;
                        advisor.PY_Principal_Payments__c = clContract.PY_Principal__c;
                        advisor.PY_Total_Payments__c = clContract.PY_Total_Payments__c;
                        advisor.Special_Circumstance__c = clContract.Special_circumstance__c;
                        advisor.Status__c = clContract.loan__Loan_Status__c;
                        advisor.YTD_Interest_Payments__c = clContract.YTD_Interest__c;
                        advisor.YTD_Principal_Payments__c = clContract.YTD_Principal__c;
                        advisor.YTD_Total_Payments__c = clContract.YTD_Total_Payments__c;
                
                        advisor.Master_Rep_ID__c = clContract.loan__Contact__r.Master_Rep_ID__c;
                
                        advisor.Advisor_Name__c = clContract.loan__Contact__r.Id;                                        
                  
                        advisor.ExternalIdForMap__c=clContract.Name; // for unique data ,using this field(need to ask for field for assigment).
                        //advisor.Id=adviosrLoanMap.get(clContract.Name).Id;                     
                
                        System.debug('In If advisorList'+advisorList.size()+advisorList);
                
                        advisorList.add(advisor);          
                
                    }
                    else {
                
                          if(clContract.Name==adviosrLoanMap.get(clContract.Name).ExternalIdForMap__c) { //here we are checking for existing advisor loan records and then updating it.  
                        
                            Advisor_Loan__c advisor=new Advisor_Loan__c();                                        
                            advisor.Name= clContract.Name;                    
                            advisor.Amount_Forgiven_Per_Year__c = clContract.Annual_Forgiveness__c;
                            advisor.Creation_Date__c =    clContract.loan__Expected_Disbursal_Date__c;
                            advisor.Loan_Payoff_Date__c =   clContract.loan__Maturity_Date_Current__c;
                            advisor.Loan_Program__c = clContract.Loan_Program__c;
                            advisor.Loan_Rate__c = clContract.Interest_Rate__c;
                            advisor.Loan_Term__c = String.valueOf(clContract.loan__Number_of_Installments__c); //Need to check - Text to decimal?
                            advisor.Loan_Type__c = clContract.Loan_Type__c;
                            advisor.Original_Amount__c = clContract.loan__loan_amount__C;
                            advisor.Outstanding_Loan_Balance__c = clContract.loan__Principal_Remaining__c;
                            advisor.Premium_Per_Period__c = clContract.Premium_Per_Cycle__c;
                            advisor.Prepayments_Received__c = clContract.Prepayments_Received__c;
                            advisor.PY_Interest_Payments__c = clContract.PY_Interest__c;
                            advisor.PY_Principal_Payments__c = clContract.PY_Principal__c;
                            advisor.PY_Total_Payments__c = clContract.PY_Total_Payments__c;
                            advisor.Special_Circumstance__c = clContract.Special_circumstance__c;
                            advisor.Status__c = clContract.loan__Loan_Status__c;
                            advisor.YTD_Interest_Payments__c = clContract.YTD_Interest__c;
                            advisor.YTD_Principal_Payments__c = clContract.YTD_Principal__c;
                            advisor.YTD_Total_Payments__c = clContract.YTD_Total_Payments__c;
                
                            advisor.Master_Rep_ID__c = clContract.loan__Contact__r.Master_Rep_ID__c;
                
                            advisor.Advisor_Name__c = clContract.loan__Contact__r.Id; //needs to be converted to lookup to contact for requirement.                                            
                  
                            advisor.ExternalIdForMap__c=clContract.Name; // for unique data ,using this field(need to ask for field for assigment).
                                
                            advisor.Id=adviosrLoanMap.get(clContract.Name).Id; //adding salesforce ids of advisory loan records                    
                
                            System.debug('In else advisorList'+advisorList.size()+advisorList);
                
                            advisorList.add(advisor);  
                          }
                      
                }
            }
                }
            }
            
            if(advisorList.size()>0) {
                
                System.debug('advisorListdata'+advisorList);
                
                Database.upsert(advisorList);//modified to upsert to insert or update data.
                
             }
        }     
       
    }
    catch(Exception e) {
        
        //LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_CLLoan_TransferObjectdata','execute',e.getMessage(),''+e.getLineNumber(),e.getTypeName());
         LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_CLLoan_TransferObjectdata','execute',e.getMessage(),e.getLineNumber(),e.getTypeName());//modified by vaibhav
    }
     
}    
global void finish(Database.BatchableContext BC) {
    
    try {
                    
        System.debug('in finsish method');
            AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors,  JobItemsProcessed,
                              TotalJobItems, CreatedBy.Email
                              from AsyncApexJob where Id =:BC.getJobId()];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('LPL_Batch_CLLoan_TransferObjectdata Batch class status ' + a.Status);
            mail.setPlainTextBody('LPL_Batch_CLLoan_TransferObjectdata Batch class records processed ' + a.TotalJobItems +
                                  ' with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
    }
    catch(Exception e) {
        
        //LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_CLLoan_TransferObjectdata','finish',e.getMessage(),''+e.getLineNumber(),e.getTypeName());
        LPL_CreateExceptionLog.createErrorRecordSync('LPL_Batch_CLLoan_TransferObjectdata','finish',e.getMessage(),e.getLineNumber(),e.getTypeName());//modified by vaibhav
    }
}


}