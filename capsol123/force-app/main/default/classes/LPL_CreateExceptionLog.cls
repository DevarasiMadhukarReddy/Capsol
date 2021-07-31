/**********************************************************************
Name:  LPL_CreateExceptionLog 
======================================================
======================================================
Purpose: An apex class for storing the exceptions                                                          
- -- -- -                                                             
======================================================
======================================================
History                                                            
-- -- -- -                                                            
VERSION      AUTHOR                     DATE              DETAIL                              FEATUR

ES/CSR/TTP

1.0 -       Amit                     08/06/2017      INITIAL DEVELOPMENT                       CSR: 
2.0         Amol                     06/19/2020      Error Handling  for 
                                                     Capsol(SF->DP->Mule Integration)
************************************************************************/



global class LPL_CreateExceptionLog {

     @future

     public static void createErrorRecordAsync(string className, string methodName, string expMessage, Integer expLineNum, string expType){

         Exception_Log__c newExceptionRecord = new Exception_Log__c();

         newExceptionRecord.Details__c = expMessage;
         newExceptionRecord.className__c = className;
         newExceptionRecord.methodName__c = methodName;
         newExceptionRecord.lineNumber__c = String.valueOf(expLineNum);
         newExceptionRecord.expType__c = expType;
         
         Database.insert(newExceptionRecord,false);

     }
     
     
     

     public static void createErrorRecordSync(string className, string methodName, string expMessage, Integer expLineNum, string expType){

         Exception_Log__c newExceptionRecord = new Exception_Log__c();

         newExceptionRecord.Details__c = expMessage;
         newExceptionRecord.className__c = className;
         newExceptionRecord.methodName__c = methodName;
         newExceptionRecord.lineNumber__c = String.valueOf(expLineNum);
         newExceptionRecord.expType__c = expType;
         

         Database.insert(newExceptionRecord,false);

     }

     //Start 2.0
     public static string createErrorRecordForSFMuleAPIFailure(string className, string methodName, Integer expLineNum,string apiScope, 
                                                            string errorDescription,string errorSource, string errorStatus, Integer errorCode,
                                                            Id loanId,Id conId){

         Exception_Log__c newExceptionRecord = new Exception_Log__c();

         //newExceptionRecord.Details__c = expMessage;
         newExceptionRecord.className__c = className;
         newExceptionRecord.methodName__c = methodName;
         newExceptionRecord.lineNumber__c = String.valueOf(expLineNum);
         newExceptionRecord.API_Scope__c = apiScope;
         newExceptionRecord.Error_Description__c = errorDescription;
         newExceptionRecord.Error_Source__c = errorSource;
         newExceptionRecord.Error_Status__c = errorStatus;
         newExceptionRecord.Error_Code__c = errorCode;
         if(loanId != null){
            newExceptionRecord.Loan_Application_Number__c = loanId;
         }
         if(conId !=null){
            newExceptionRecord.Contact__c = conId;
         }
        
            if(loanId != null){
                 cls_lpl_CreateSNOWTicket_CAPSOL.makeSNOWCallout(loanId,null);
            }
            if(conId != null){
                 cls_lpl_CreateSNOWTicket_CAPSOL.makeSNOWCallout(null,conId);
            }
        
            
             Database.SaveResult sr = Database.insert(newExceptionRecord,false);
            system.debug('@@@@@@'+sr);

            Exception_Log__c updateExceptionRecord = new Exception_Log__c();
            if(sr.isSuccess() ==true){
                updateExceptionRecord = [select id,name,CreatedDate,Exception_Log_ID_Loan_App_ID__c,Loan_Application_Number__c from Exception_Log__c where id=:sr.getId()];
                updateExceptionRecord.Exception_Log_ID_Loan_App_ID__c = String.valueof(updateExceptionRecord.CreatedDate)+updateExceptionRecord.Loan_Application_Number__c;
                update updateExceptionRecord;
            }

            return LoanSubmitApplication.snowError;

     }
     //End 2.0
     
}