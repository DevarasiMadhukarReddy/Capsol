/*
 * This Class is used for Capsol
 * 
 * 
 * CS-42 , CS-2119 - Send email when offer extended and proposal status set to approved from CLO.- Amol - 10/30/2020
 * - Author - Amol Deshpande
 * CS-2769 Add Model Specialist to TA Approved Email -- Madhukar Reddy 1/18/2021
 * * * CH.No       Description                                                           Developer           Date
------------------------------------------------------------------------------------------------------------------------
    *  CH03        CS-3537 - Approval Email Sender Enhancement                            Amol              05/25/2021
*/
public class TriggerEmailwhenOfferExtended {

     public static void sendTemplatedEmail(Loan_Application__c loanApp) {
        String Retention_Monetization_templateApiName = 'Offer_For_Monetization_Retention';
        String TA_WC_templateApiName = 'Offer_Extended_Notification_to_TA';
        list<String> toRecipients = new list<String>();
        list<String> ccRecipients = new list<String>();
        Id RetensionLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Retention_Loan').getRecordTypeId();
        Id ForgivableLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Forgivable_loan').getRecordTypeId();
        Id MonetizationRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Monetization').getRecordTypeId();
        Id WorkingCapitalLoadRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Working_Capital').getRecordTypeId();
        Id TAProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
        Id GeneralProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('General_Proposal').getRecordTypeId();
        Id RepayableProposalRecordTypeId = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Repayable').getRecordTypeId();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        Id templateId;
        
         loanApp=[select RecordTypeId ,Approver_Email__c,Approver_Name__c,Assigned_Recruiter_Email__c,Internal_Recruiter_Email__c,Business_Developer_Email__c,Opportunity__r.Model_Specialist__r.email from Loan_Application__c where id =:loanApp.id]; 
        
        try {
            if(loanApp.RecordTypeId == ForgivableLoadRecordTypeId || loanApp.RecordTypeId == WorkingCapitalLoadRecordTypeId){
                //system.debug('RecordTypeId'+loanApp.RecordTypeId);
                templateId = [select id, name,developername from EmailTemplate where developername = : TA_WC_templateApiName].id;
                if(loanApp.Assigned_Recruiter_Email__c != null){
                    toRecipients.add(loanApp.Assigned_Recruiter_Email__c);
                }
                //CH03 Start
                if(loanApp.Approver_Email__c != null){
                    toRecipients.add(loanApp.Approver_Email__c);
                }
                //CH03 End
                if(loanApp.Internal_Recruiter_Email__c != null) {
                    toRecipients.add(loanApp.Internal_Recruiter_Email__c);
                }
                if(loanApp.Business_Developer_Email__c != null) {
                    toRecipients.add(loanApp.Business_Developer_Email__c);
                }
                //  CS-2769 added by Madhukar Reddy 
                if(loanApp.Opportunity__r.Model_Specialist__r.email != null) {
                    toRecipients.add(loanApp.Opportunity__r.Model_Specialist__r.email);
                }
                ccRecipients.add(system.label.Advisor_Capital_Email);
                ccRecipients.add(system.label.BD_Sales_Support_Email);
                //CH03 Start
                OrgWideEmailAddress owdEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where Address = :system.label.Advisor_Capital_Email];
                email.setOrgWideEmailAddressId(owdEmail.Id);
                //CH03 End
            }else if(loanApp.RecordTypeId == RetensionLoadRecordTypeId || loanApp.RecordTypeId == MonetizationRecordTypeId){
                templateId = [select id, name,developername from EmailTemplate where developername = : Retention_Monetization_templateApiName].id;
                if(loanApp.Business_Consultant_RM_Email__c != null){
                    toRecipients.add(loanApp.Business_Consultant_RM_Email__c);
                }
                ccRecipients.add(system.label.Advisor_Capital_Email);
            }
        }
    catch (Exception e) {
      //throw new UtilException ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName + 
                  //  ' refer to Setup | Communications Templates ' + templateApiName);
    }
    
    
       email.setToAddresses(toRecipients);
       email.setCcAddresses(ccRecipients);
       email.setTreatTargetObjectAsRecipient(false);
       email.setWhatId(loanApp.Id);
       email.setTargetObjectId(UserInfo.getUserId());
       email.setTemplateId(templateId);
        
        System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients  +  ' templateId:' + templateId );
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            return ;
        }
         catch (Exception e) {}
      
    }  
}
//CS-42,CS-2119 chnages Start - by Amol - 10/30/2020