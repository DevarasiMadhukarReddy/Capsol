/*
Trigger Name            :LPL_CaseCommentGateway 
Description             :This class contains logic realted to Custom object Case Comment.

Developer Name          :Pravin Kale
Created Date            :7/25/2017 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01      Project J Enhancement:To send emails to userids    Vaibhav Wadhai      14 Augast 2017

           present in 'SME CC' field of custom setting 
           'SME Details' 

Ch-02       send auto mail to IRD and Assignment Recuiter if CATs  Ashish Gupta     3-oct-2017
            value is '1:1 in Marketing Meeting' in case comment gateway 

*/
public class LPL_CaseCommentGateway {
   
    
      
    Map<ID, Case_Comments_J__c> csjMap = new Map<Id, Case_Comments_J__c >();
    
    Map<String, SME_Details__c> smeDetailsMap = SME_Details__c.getAll();
    
    List<String> emailSendList = new List<String>();
    List<String> emailSendListForSNDE = new List<String>(); // Added by Utkarsh Topre
    List<String> emailSendListForCTAs = new List<String>(); // Added by Utkarsh Topre
    
    List<String> emailsendlistforIRDandAssignRecuiter = new List<String>(); 
    
    EmailTemplate et = new EmailTemplate();
    set<Id> caseId = new set<Id>();
    Map<ID, Case> caseMap = new Map<ID, Case>();
     Map<ID, Case_Comments_J__c> getCaseIdOnCaseCommentMap = new Map<ID, Case_Comments_J__c>(); //By Ashish
    
    public void collectRecordToProcess(List<Case_Comments_J__c> caseList){
        
        system.debug('********Inside Collect Record Process');
        for(Case_Comments_J__c  csj : caseList){
            caseId.add(csj.Case__c);
            csjMap.put(csj.ID, csj);
            getCaseIdOnCaseCommentMap.put(csj.Case__c,csj);
        }
        
        for(Case cas : [Select id, Status, Contact.FirstName, Contact.LastName, Project_Manager__r.Email, Assigned_Recruiter__r.Email, 
                        IRD__r.Email, Executive_Recruiter__r.Email,(select id, Max_TA_Dollars_Allowed__c from Cases)
                        from Case where id in: caseId]){
                            caseMap.put(cas.Id, cas);
                        }
        
    }
    
    
    
    
    
    List<String> smeName = new List<String>();
    public void processEmailAlertComments(Case_Comments_J__c newCSJ, Case_Comments_J__c oldCSJ){
        system.debug('********Inside Record Process');
        
        
        
        boolean checkOldValueSME = false;
        boolean checkOldValueCTA = false;
        boolean checkOldValueSNDE = false; // Added by Utkarsh Topre
        
        if(Trigger.isInsert){
            checkOldValueSME = true;
            checkOldValueCTA = true;
            checkOldValueSNDE = true; // Added by Utkarsh Topre
        }
        
        if(Trigger.isUpdate){
            if(newCSJ.SMEs_Needed_for_Follow_up__c != oldCSJ.SMEs_Needed_for_Follow_up__c){
                checkOldValueSME = true;
            }
            if(oldCSJ.CTAs__c != 'Escalate'){
                checkOldValueCTA = true;
            }
            
            // Added by Utkarsh Topre
            
            if(oldCSJ.Send_Email__c != TRUE){
                checkOldValueSNDE = true;
            }
        }
        
        Map<String, String> smeMap = new Map<String, String>();
        List<String> smeList = new List<String>();
        
        if(newCSJ.Case__c != null && caseMap.size() != 0){
            system.debug('********Inside Record Case');
            if(caseMap.get(newCSJ.Case__c).Project_Manager__r != null){
                //emailSendList.add(caseMap.get(newCSJ.Case__c).Project_Manager__r.Email);
                emailSendListForSNDE.add(caseMap.get(newCSJ.Case__c).Project_Manager__r.Email); // Added by Utkarsh Topre
                emailSendListForCTAs.add(caseMap.get(newCSJ.Case__c).Project_Manager__r.Email); // Added by Utkarsh Topre
            }
            if(caseMap.get(newCSJ.Case__c).Assigned_Recruiter__r != null){
                emailSendList.add(caseMap.get(newCSJ.Case__c).Assigned_Recruiter__r.Email);
                emailSendListForSNDE.add(caseMap.get(newCSJ.Case__c).Assigned_Recruiter__r.Email); // Added by Utkarsh Topre
                
                
            }
            if(caseMap.get(newCSJ.Case__c).IRD__r != null){
                //emailSendList.add(caseMap.get(newCSJ.Case__c).IRD__r.Email);
                emailSendListForSNDE.add(caseMap.get(newCSJ.Case__c).IRD__r.Email); // Added by Utkarsh Topre
            }
            if(caseMap.get(newCSJ.Case__c).Executive_Recruiter__r != null){
                //emailSendList.add(caseMap.get(newCSJ.Case__c).Executive_Recruiter__r.Email);
                emailSendListForSNDE.add(caseMap.get(newCSJ.Case__c).Executive_Recruiter__r.Email); // Added by Utkarsh Topre
            }
            
        }
        
        
        system.debug('******'+newCSJ.Case__c);
        
        
        if(newCSJ.SMEs_Needed_for_Follow_up__c != null && Trigger.isInsert){
            //smeList.add(newCSJ.SMEs_Needed_for_Follow_up__c);
            
            for(String str : newCSJ.SMEs_Needed_for_Follow_up__c.split(';')){
                
                System.debug('data 1  smeDetailsMap.get(str).SME_Email__c >>'+str+' '+smeDetailsMap.get(str).SME_Email__c);
                //System.debug('smeDetailsMap 1'+smeDetailsMap);
                emailSendList.add(smeDetailsMap.get(str).SME_Email__c);
                
                //Ch-01 Start
                //added by vaibhav:to send emails to CC field in custom settting 'SME Details'
                if(smeDetailsMap.get(str).SME_CC__c!=null) {
                
                    emailSendList.add(smeDetailsMap.get(str).SME_CC__c);
                }
                //Ch-01 End
                
                smeName.add(str); 
                System.debug('smeName insert '+smeName);
                System.debug('list 1'+emailSendList);
                
            }
        }
        
        List<String> oldEmailList=new List<String>();
        //  List<String> newEmailList=new List<String>();
        system.debug('###oldCSJ1'+oldCSJ);
        system.debug('###newCSJ1'+newCSJ);
        
        if(oldCSJ != null && oldCSJ.SMEs_Needed_for_Follow_up__c != null && Trigger.isUpdate && newCSJ.SMEs_Needed_for_Follow_up__c != null){
            
            Set<String> setOfOldValues = new Set<String>();
            setOfOldValues = new Set<String>();
            List<String> listOfNewValues;
            listOfNewValues = new List<String>();
            String smeTempName;
            
            for(String str1 : oldCSJ.SMEs_Needed_for_Follow_up__c.split(';')){
                system.debug('#@#@'+str1);
                setOfOldValues.add(str1);                                               
            }
            
            for(String str2 : newCSJ.SMEs_Needed_for_Follow_up__c.split(';')){
                listOfNewValues.add(str2);                                               
            }                   
            
            
            for(integer index=0; index<listOfNewValues.size(); index++){
                if(!(setOfOldValues.contains(listOfNewValues.get(index)))){
                    smeTempName = listOfNewValues.get(index);
                    smeName.add(smeTempName);
                    emailSendList.add(smeDetailsMap.get(smeTempName).SME_Email__c);
                    
                    //CH-01 Start
                    //added by vaibhav:to send emails to CC field in custom settting 'SME Details'
                    if(smeDetailsMap.get(smeTempName).SME_CC__c!=null) {
                
                        emailSendList.add(smeDetailsMap.get(smeTempName).SME_CC__c);
                    }
                    //
                    //CH-01 End
                }
            }
        }
        
        else if(oldCSJ != null && oldCSJ.SMEs_Needed_for_Follow_up__c == null && Trigger.isUpdate && newCSJ.SMEs_Needed_for_Follow_up__c != null){
            
            smeName.clear();
            emailSendList.clear();
            for(String str : newCSJ.SMEs_Needed_for_Follow_up__c.split(';')){
                emailSendList.add(smeDetailsMap.get(str).SME_Email__c);
                
                //CH-01 Start
                //added by vaibhav:to send emails to CC field in custom settting 'SME Details'
                if(smeDetailsMap.get(str).SME_CC__c!=null) {
                
                        emailSendList.add(smeDetailsMap.get(str).SME_CC__c);
                 }
                 //CH-01 End
                    
                smeName.add(str);                    
            }
            
        }
        // Ch -02 Start Created By Ashish 
       
         System.debug('newCSJ.CTAs__c>>'+newCSJ.CTAs__c);
         if(newCSJ.CTAs__c != null && ((newCSJ.CTAs__c=='1:1 Meeting with Recruiter') || newCSJ.CTAs__c.containsIgnoreCase('1:1 Meeting with Recruiter')))
        {
            System.debug('inside CTAs value found');
            if(caseMap.get(newCSJ.Case__c).Assigned_Recruiter__r != null){
                  emailsendlistforIRDandAssignRecuiter.add(caseMap.get(newCSJ.Case__c).Assigned_Recruiter__r.Email);
                 System.debug('Assignment recuiter'+caseMap.get(newCSJ.Case__c).Assigned_Recruiter__r.Email);
                
            }
        if(caseMap.get(newCSJ.Case__c).IRD__r != null){
                emailsendlistforIRDandAssignRecuiter.add(caseMap.get(newCSJ.Case__c).IRD__r.Email);
                 System.debug('IRD recuiter:'+caseMap.get(newCSJ.Case__c).IRD__r.Email);
                
            }
             
              
        if(emailsendlistforIRDandAssignRecuiter.size() != 0 && emailsendlistforIRDandAssignRecuiter != null)
        {
            system.debug('******'+emailsendlistforIRDandAssignRecuiter);
            sendEmailToIRDandAssignRecruiters(emailsendlistforIRDandAssignRecuiter, newCSJ);    
        }
        }
           // Ch -02 End
        if(emailSendList.size() != 0 && emailSendList != null && newCSJ.SMEs_Needed_for_Follow_up__c != null && checkOldValueSME){
            system.debug('******'+newCSJ.Case__r);
            sendEmailToSMEandRecruiters(emailSendList, newCSJ);    
        }
    System.debug('emailSendListForCTAs.size() '+emailSendListForCTAs.size() +'emailSendListForCTAs!= null'+emailSendListForCTAs+'newCSJ.CTAs__c>'+newCSJ.CTAs__c+'checkOldValueCTA'+checkOldValueCTA);
        if(emailSendListForCTAs.size() != 0 && emailSendListForCTAs!= null && /**Added by Utkarsh Topre**/ newCSJ.CTAs__c != null && newCSJ.CTAs__c == 'Escalate' && checkOldValueCTA) {
            system.debug('********Inside Record Escalate11');
            sendEmailToCTAsandRecruiters(emailSendListForCTAs/**Added by Utkarsh Topre**/, newCSJ);        
        }
        //Ch -02 End
        
        /************* Added by Utkarsh Topre for Send Email field ********************/
        
        /* if(emailSendListForSNDE.size() != 0 && emailSendListForSNDE != null && newCSJ.Send_Email__c == TRUE && checkOldValueSNDE) {
            system.debug('********Send Email');
            sendEmailToRecruitersForSendEmail(emailSendListForSNDE, newCSJ);        
            }    
        */
        
        //
       
         
        
        
        
        
    }
    
    public void sendEmailToSMEandRecruiters(List<String> userEmailList, Case_Comments_J__c newCSJ){
        
        system.debug('******'+newCSJ.Case__r);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = userEmailList;
        message.optOutPolicy = 'FILTER';
        message.subject = caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' '+caseMap.get(newCSJ.Case__c).Contact.LastName + ' : SME Call Requested';
        
        
        
        
        String plainTextBody = '<html><body>This is to notify you that ' + caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' ' + caseMap.get(newCSJ.Case__c).Contact.LastName +
            ' has requested to speak with the ' + /*newCSJ.SMEs_Needed_for_Follow_up__c*/ smeName + ' team. <br>' + 
            'Please  review all details in the '+
            'Case : ' +newCSJ.Case_URL__c +
            ' and log all comments and activity there. </body></html>';
        message.setHtmlbody(plainTextBody);
        
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
    }
    
    public void sendEmailToCTAsandRecruiters(List<String> userEmailList, Case_Comments_J__c newCSJ){
        
        
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = userEmailList;
        message.optOutPolicy = 'FILTER';
        message.subject = caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' '+caseMap.get(newCSJ.Case__c).Contact.LastName + ' :  Escalation Requested ';
        
        
        
        String plainTextBody = '<html><body>This is to notify you that ' + caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' ' + caseMap.get(newCSJ.Case__c).Contact.LastName +
            ' has a matter that needs escalation.  Please review all details in the' +
            ' Case (Link Below) <br>'+ 
            'Case : ' +newCSJ.Case_URL__c + '</body></html>';
        
        message.setHtmlbody(plainTextBody);
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
    }
    
    /******* Added by Utkarsh Topre for Send Email field ********************/
    /*
public void sendEmailToRecruitersForSendEmail(List<String> userEmailList, Case_Comments_J__c newCSJ){

Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
message.toAddresses = userEmailList;
message.optOutPolicy = 'FILTER';
message.subject = caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' '+caseMap.get(newCSJ.Case__c).Contact.LastName + ' has received a new comment on his/her Case ';
String plainTextBody = '<html><body>This is to notify you that ' + caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' ' + caseMap.get(newCSJ.Case__c).Contact.LastName +
' has received a new comment. <br><br>  Please review the details here : ' +newCSJ.Case_URL__c + '</body></html>';

message.setHtmlbody(plainTextBody);

Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

if (results[0].success) {
System.debug('The email was sent successfully.');
} else {
System.debug('The email failed to send: ' + results[0].errors[0].message);
}

} */
  
      public void sendEmailToIRDandAssignRecruiters(List<String> userEmailList, Case_Comments_J__c newCSJ){
        
        System.debug('Assign recuiter and IRD emails.'+userEmailList);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = userEmailList;
        message.optOutPolicy = 'FILTER';
        message.subject = caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' '+caseMap.get(newCSJ.Case__c).Contact.LastName + ' : 1:1 Meeting with Recruiter Requested ';
        
         
        
        String plainTextBody = '<html><body>This is to notify you that ' + caseMap.get(newCSJ.Case__c).Contact.FirstName+ ' ' + caseMap.get(newCSJ.Case__c).Contact.LastName +
            ' has requested a 1:1 Meeting with the Recruiter.  Please review all details in the' +
            ' Case (Link Below) <br>'+ 
            'Case : ' +newCSJ.Case_URL__c + '</body></html>';
        
        message.setHtmlbody(plainTextBody);
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        
    }
    
    
}