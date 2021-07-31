/**
* This Class used to Schedule a report when Clo Applicaiton id is null, Clo customer group id is null and status is submitted the generate Dynamic Report
* Created By Madhukar Reddy 1/20/2021 CS-2759 Scheduled report for defect Loan Application
**/

public class LPL_ProposalOfferReport{
    
public void execute(List<Proposal_Offer__c> Listloanapp , boolean jobNotificationDate, Date repDate)
   {
        
        String fromDisplayName = '';
        DateTime reportDateTime;
          fromDisplayName = 'LPL SFDC ADMIN';
        String emailContents = '';
        String emailAttachment = '';        
        emailContents = getEmailContentsForDailyJobReport(Listloanapp,repDate);
        emailAttachment = getEmailAttachmentForDailyJobReport(Listloanapp );       
        
         if(emailAttachment != null && !emailAttachment.equals('')){
           
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHTMLBody(emailContents);
            String Toaddress = Label.Toaddress;
            //from details
            //System.debug('before setting to mail ==> fromDisplayName = ' + fromDisplayName + ', fromEmailId =' + fromEmailId);
            mail.setSenderDisplayName(fromDisplayName );
        
        List<String> l = new List<String>();            
          //  l.add('madhukar.reddy@lpl.com'); 
          //  l.add(Toaddress);
              l.addAll(Toaddress.split(';'));
            mail.setToAddresses(l);
            //subject
            String subject = 'Proposal Offer Failure Report ' +  repDate.day() + '-' + repDate.month() + '-' + repDate.year() ;
           
            mail.setSubject(subject );
        
            if (emailAttachment != null && !emailAttachment.equals('')){
                Messaging.EmailFileAttachment excelAttchment = new Messaging.EmailFileAttachment();
                blob excelBlob = Blob.valueOf(emailAttachment);
                
                String filename = 'Proposal Offer Failure Report ' + repDate.day() + '-' + repDate.month() + '-' + repDate.year() + '.xls' ;
                      
                excelAttchment.setFileName(filename );
                
                excelAttchment.setBody(excelBlob );
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{excelAttchment});
            }
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
         
        }
    }
    
    public String getEmailContentsForDailyJobReport(List<Proposal_Offer__c > Listloanapp, DateTime reportDate ){
        String returnValue = '';
        if (Listloanapp!= null && Listloanapp.size() > 0){
            returnValue  ='Dear All,<br><br> Attached the Proposal Offer Failure Report where Max TA Amount is null from CLO . <br><br>Regards,<br>LPL SFDC Admin<br><br>Note: This is a system generated report. Do not reply to this email. ';
        }
        return returnValue ;
        
    }
      public String getEmailAttachmentForDailyJobReport(List<Proposal_Offer__c> Listloanapp ){
        String contents = '';
        String tabChar = '\t';   

      Listloanapp=[select id,Name,Proposal_Status__c,Max_TA_Amount__c,Verified_AUM__c,TA_of_Verified_AUM_Percent__c,Approved_T12__c,Expiration__c,Date__c,LoanApp_MD__r.id,LoanApp_MD__r.CreatedDate,LoanApp_MD__r.CreatedBy.Name,LoanApp_MD__r.Name,LoanApp_MD__r.status__c,LoanApp_MD__r.CLO_Application_ID__c,LoanApp_MD__r.CLO_Customer_Group_ID__c  from Proposal_Offer__c where (Max_TA_Amount__c=null or Max_TA_Amount__c=0.0) and (LoanApp_MD__r.status__c='Offer Extended' OR LoanApp_MD__r.status__c='Submit for Approval') AND Verified_AUM__c !=0 AND CreatedDate >=TODAY];
          system.debug('Listloanapp***'+Listloanapp);
        if (Listloanapp != null && Listloanapp.size() > 0){
            contents = 'Application Number \tLoanApplicationId \tStatus \tCLOApplicationID  \tCLOCustomerGroupID \tCreatedDate \tCreatedBy \tProposal/Offer Name \tProposal/Offer Id \tProposalStatus \tApprovedLoanAmount \tVerifiedAUM \tTAofVerifiedAUM % \tApprovedT12 \tExpiration \tDate \n';
            //system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~caseList order check '+caseList);
            for(Proposal_Offer__c Loanapps: Listloanapp ){
                contents += Loanapps.LoanApp_MD__r.Name;
                contents += tabChar ;   
                 contents += Loanapps.LoanApp_MD__r.id;
                contents += tabChar ;       
                contents += Loanapps.LoanApp_MD__r.Status__c;
                contents += tabChar ;
                contents += Loanapps.LoanApp_MD__r.CLO_Application_ID__c ;
                contents += tabChar ;
               contents += Loanapps.LoanApp_MD__r.CLO_Customer_Group_ID__c ;
                contents += tabChar ;
                contents += Loanapps.LoanApp_MD__r.CreatedDate;
                contents += tabChar ;
                contents += Loanapps.LoanApp_MD__r.CreatedBy.Name;
                contents += tabChar ;
                contents += Loanapps.Name;
                contents += tabChar ;
                contents += Loanapps.id;
                contents += tabChar ;
                contents += Loanapps.Proposal_Status__c;
                contents += tabChar ;                
                contents += Loanapps.Max_TA_Amount__c;
                contents += tabChar ;
                contents += Loanapps.Verified_AUM__c;
                contents += tabChar ;
                contents += Loanapps.TA_of_Verified_AUM_Percent__c;
                contents += tabChar ;
                contents += Loanapps.Approved_T12__c;
                contents += tabChar ;
                contents += Loanapps.Expiration__c;
                contents += tabChar ;
                contents += Loanapps.Date__c;
                contents += tabChar ;
                   contents += tabChar ;    
               contents += '\n';
            }
         }
         return contents;
    }   


}