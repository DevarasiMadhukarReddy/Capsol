/***
 * Created By Madhukar Reddy 10/12/2020 CS-42- Sprint 17 Email Notification Enhancement - Retention & Monetization Application
 * 
 */
public  class LPLMontizationandRetention{
public Id Loanid {get;set;}
  id strRecordDevName12 = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
   public List<Proposal_Offer__c> getMonetization(){
     Proposal_Offer__c[] proposaloffer = [SELECT Max_TA_Amount__c,Loan_Term__c,Interest_Rate__c,LoanApp_MD__r.Primary_Contact_Name__r.name,Id,Date__c,Expiration__c,LoanApp_MD__r.Requested_Loan_Amount__c,LoanApp_MD__r.Requested_Loan_Term__c,LoanApp_MD__r.name,LoanApp_MD__r.Interest_Rate__c,LoanApp_MD__r.RecordType.Name,LoanApp_MD__r.Case_Number__r.CaseNumber,LoanApp_MD__r.Contact_Master_Rep_Id__c,LoanApp_MD__r.Advisor__r.name FROM Proposal_Offer__c WHERE LoanApp_MD__c =: Loanid order by createdDate limit 1 ];
     if((!proposaloffer .isempty()) && (proposaloffer[0].LoanApp_MD__r.Recordtype.name=='Monetization' || proposaloffer[0].LoanApp_MD__r.Recordtype.name=='Retention Loan' )){
       system.debug('proposaloffer ***'+proposaloffer[0].LoanApp_MD__r.RecordType.Name =='Monetization');
       system.debug('proposaloffer ***'+proposaloffer[0].LoanApp_MD__r.RecordType.Name =='Retention Loan');
      }
   return proposaloffer ;
   
   }
 
}