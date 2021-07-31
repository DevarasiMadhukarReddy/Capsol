public class Opportunity_EmailHandler{
public static boolean Recursive = true;

public static void EmailsHandler(List<opportunity> Lstopp,Map<Id,opportunity> Oldmap,Boolean Isupdatevalue, Map<Id, User> MapUser){

    List < Messaging.SingleEmailMessage > emails = new List < Messaging.SingleEmailMessage > ();
    
    /*if(Lstopp.size()>0){
    
    Set<Id> UserId = new set<Id>();
    
    for(opportunity o:Lstopp){
    
    if(o.Internal_Recruiter_IRD__c != Null){
    UserId.add(o.Internal_Recruiter_IRD__c);
    }
    if( o.Assigned_Recruiter__c != Null){
    UserId.add(o.Assigned_Recruiter__c);
    }
    if( o.Integration_Manager__c != Null){
    UserId.add(o.Integration_Manager__c);
    }
    }
    
    if(UserId.size()>0){
    
    Map<Id,User> MapUser = new Map<Id,User>([select id,email from user where Id In:Userid]); */
    
    if(MapUser.size()>0){
    
    for(opportunity o:Lstopp){
    
    if(!IsupdateValue){
    if(o.StageName != Null && (o.StageName =='5 - HOV' || o.StageName == '6 - e-kit Submitted/Final Negotiation' || o.StageName =='7 - Committed to Join'
         || o.StageName=='8 - Joined')){
         
         
         if(o.Assigned_Recruiter__c  != null){
         Messaging.SingleEmailMessage singleMail =FrameEmail(MapUser.get(o.Assigned_Recruiter__c).Email,o.Id);
         emails.add(singleMail);
         }
         if(o.Internal_Recruiter_IRD__c != null){
         Messaging.SingleEmailMessage singleMail =FrameEmail(MapUser.get(o.Internal_Recruiter_IRD__c).Email,o.Id);
         emails.add(singleMail);
         }
         if(o.Integration_Manager__c != null){
         Messaging.SingleEmailMessage singleMail =FrameEmail(MapUser.get(o.Integration_Manager__c).Email,o.Id);
         emails.add(singleMail);
         }
        
    }
    }else{
    
    if(o.StageName != Null && ((o.StageName =='5 - HOV' && oldmap.get(o.Id).StageName != o.StageName )|| 
                                (o.StageName == '6 - e-kit Submitted/Final Negotiation' && oldmap.get(o.Id).StageName != o.StageName ) ||
                                (o.StageName =='7 - Committed to Join'&& oldmap.get(o.Id).StageName != o.StageName ) ||
                                (o.StageName=='8 - Joined' && oldmap.get(o.Id).StageName != o.StageName ))){
         
         
         if(o.Assigned_Recruiter__c  != null){
         Messaging.SingleEmailMessage singleMail =FrameEmail(MapUser.get(o.Assigned_Recruiter__c).Email,o.Id);
         emails.add(singleMail);
         }
         if(o.Internal_Recruiter_IRD__c != null){
         Messaging.SingleEmailMessage singleMail =FrameEmail(MapUser.get(o.Internal_Recruiter_IRD__c).Email,o.Id);
         emails.add(singleMail);
         }
         if(o.Integration_Manager__c != null){
         Messaging.SingleEmailMessage singleMail =FrameEmail(MapUser.get(o.Integration_Manager__c).Email,o.Id);
         emails.add(singleMail);
         }
        
    }
    
    }
    }
    
    //system.debug('emails.size()==='+emails.size());
     if(emails.size()>0){
        sendmail(emails);
        Recursive = false;
        }
    }
   // }
}
//}

public static Messaging.SingleEmailMessage FrameEmail(string AssgEmail,ID Cid){
    
    EmailTemplate_for_Opp__c TBE= EmailTemplate_for_Opp__c.getInstance();
    
                    //New instance of a single email message
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 
                // Who you are sending the email to
                   mail.setToAddresses(new String[] {AssgEmail});
                
                   // The email template ID used for the email
                   mail.setTemplateId(TBE.Template_Id__c);
                   mail.setTargetObjectId(userinfo.getuserid());      
                   mail.setWhatId(Cid);    
                   mail.setUseSignature(false);
                  // mail.setReplyTo(Email);
                   //mail.setSenderDisplayName('');
                   mail.setSaveAsActivity(false);  
                   return mail;
    }
    
    

public static void sendmail(List <Messaging.SingleEmailMessage> emails){
    
     // Send the emails in a transaction, then roll it back
                Savepoint sp = Database.setSavepoint(); 
                if(!test.Isrunningtest()){                           
                        Messaging.sendEmail(emails);
                        }
                Database.rollback(sp);

                // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
                // contents to a new SingleEmailMessage. Then send those new messages.
                List < Messaging.SingleEmailMessage > lstMsgsToSend = new List < Messaging.SingleEmailMessage > ();
                for (Messaging.SingleEmailMessage email: emails) {
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(email.getToAddresses());
                    emailToSend.setccAddresses(email.getccAddresses());
                    emailToSend.setBccAddresses(email.getBccAddresses());
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    lstMsgsToSend.add(emailToSend);
                }
                if(!test.Isrunningtest()){   
                Messaging.sendEmail(lstMsgsToSend);
                }
    
    }
}