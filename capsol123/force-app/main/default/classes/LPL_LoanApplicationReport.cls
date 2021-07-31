/**
* This Class used to Schedule a report when Clo Applicaiton id is null, Clo customer group id is null and status is submitted the generate Dynamic Report
* Created By Madhukar Reddy 1/20/2021 CS-2759 Scheduled report for defect Loan Application
**/

public class LPL_LoanApplicationReport{
public void execute(List<Loan_Application__c > Listloanapp , boolean jobNotificationDate, Date repDate)
   {
        system.debug('repDate' +repDate);
        String fromDisplayName = '';
        //DateTime reportDateTime;
          fromDisplayName = 'LPL SFDC ADMIN';
        String emailContents = '';
        String emailAttachment = '';        
        emailContents = getEmailContentsForDailyJobReport(Listloanapp,repDate);
        emailAttachment = getEmailAttachmentForDailyJobReport(Listloanapp );       
        
         if(emailAttachment != null && !emailAttachment.equals('')){
           //AKG 
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
           // system.debug('repDatedate'+repDate.day());
            String subject = 'Loan Application Submission Failure Report '  +  repDate.day() + '-' + repDate.month() + '-' + repDate.year();
                        
            mail.setSubject(subject );
        
            if (emailAttachment != null && !emailAttachment.equals('')){
                Messaging.EmailFileAttachment excelAttchment = new Messaging.EmailFileAttachment();
                blob excelBlob = Blob.valueOf(emailAttachment);
                
                String filename = 'Loan Application Submission Failure Report ' +  repDate.day() + '-' + repDate.month() + '-' + repDate.year() + '.xls' ;
                excelAttchment.setFileName(filename );
                excelAttchment.setBody(excelBlob );
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{excelAttchment});
            }
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           
        }
    }
    
    public String getEmailContentsForDailyJobReport(List<Loan_Application__c > Listloanapp, DateTime reportDate ){
        String returnValue = '';
        if (Listloanapp!= null && Listloanapp.size() > 0){
            returnValue  ='Dear All,<br><br> Attached the Loan Application submission Failure Report where CLO Application Id and CLO Group Id is null executed today. <br><br>Regards,<br>LPL SFDC Admin<br><br>Note: This is a system generated report. Do not reply to this email. ';
        }
        return returnValue ;
        
    }
      public String getEmailAttachmentForDailyJobReport(List<Loan_Application__c > Listloanapp ){
        String contents = '';
        String tabChar = '\t';
        if (Listloanapp != null && Listloanapp.size() > 0){
            contents = 'Application Number \t LoanApplicationId \tStatus\tCLOApplicationID  \tCLOCustomerGroupID \tCreated Date \tCreatedBy \tRecordType\n';
            //system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~caseList order check '+caseList);
            for(Loan_Application__c  Loanapps: Listloanapp ){
                contents += Loanapps.Name;
                contents += tabChar ;  
                contents += Loanapps.id;
                contents += tabChar ;        
                contents += Loanapps.Status__c;
                contents += tabChar ;
                contents += Loanapps.CLO_Application_ID__c ;
                contents += tabChar ;
                contents += Loanapps.CLO_Customer_Group_ID__c ;
                contents += tabChar ;
                contents += Loanapps.CreatedDate;
                contents += tabChar ;
                contents += Loanapps.CreatedBy.Name;
                contents += tabChar ;
                contents += Loanapps.RecordType.Name;
                contents += tabChar ;
                   contents += tabChar ;    
               contents += '\n';
            }
         }
         return contents;
    }   


}