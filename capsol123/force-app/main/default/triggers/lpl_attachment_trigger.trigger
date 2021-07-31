// Trigger to a) send email to compliance if TimeTrade_SF1__Invitation__c has any attachment. b) update a flag on time trade object for reporting 
trigger lpl_attachment_trigger on Attachment (after insert) {
 
//public variable declaration starts
    Set<ID> setOfParentIds = new Set<ID>();
    List<TimeTrade_SF1__Invitation__c> listOfRecordsWithAttmnt = new List<TimeTrade_SF1__Invitation__c>();      
    String htmlBody;

//adding parentIds of new attachments in a set
    for (Attachment att: Trigger.New){
        setOfParentIds.add(att.ParentId);
    }

//Query to fetch details of parent record and attachments tied to that record    
    List<TimeTrade_SF1__Invitation__c> timeTrade = [select id,hasAttachment__c,CreatedBy.Name,Name,CreatedDate, (Select Id,Name,CreatedDate  from attachments)  from TimeTrade_SF1__Invitation__c where id in :setOfParentIds];

// This condition will ensure that the logic runs only for  TimeTrade_SF1__Invitation__c object    
    if(timeTrade.size()>0)     
    { 
        String tempHtmlBody;
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm(); 
        String es = '/'; 
        List<String> listOfUrls = new List<String>(); 
        String[] addr = new String[]{};

//bulkification. If there are multiple timeTrade records as part of mass upload of attachments
            for(TimeTrade_SF1__Invitation__c tD: timeTrade){
                map<String,String> timeTradeDetails = new map<String,String>();
                tD.hasAttachment__c = true;
                listOfRecordsWithAttmnt.add(tD);
                
                String finalRecordUrl = baseUrl+es+tD.Id;           // URL formation
                listOfUrls.add(finalRecordUrl);
                
                               
                timeTradeDetails.put('Invitation Subject',tD.Name);
                timeTradeDetails.put('Created By',tD.CreatedBy.Name);
                timeTradeDetails.put('Invitation Record URL',finalRecordUrl);
                timeTradeDetails.put('Invitation Created Date',String.valueOf(tD.CreatedDate));
                timeTradeDetails.put('Salesforce Record Id',tD.id);
                
                
                for(Attachment attment: tD.attachments){                  
                    timeTradeDetails.put(attment.Id,attment.Name);                   
                }
                
                //finalMap.put(tD.Id,timeTradeDetails);
                tempHtmlBody = LPL_Utility.getTableEmailBody(timeTradeDetails);
                htmlBody =  tempHtmlBody + '<p>';
            }
         // Getting mail Id from custom settings
          MAP<String, TimeTrade_Send_Email__c> TimeTradeEmailCustomsetting= TimeTrade_Send_Email__c.getall();
         List<String>UserEmailList=new List<String>();
            for(TimeTrade_Send_Email__c allUserEmail : TimeTradeEmailCustomsetting.values()) {
                If(allUserEmail.Email_ID__c!=null ){
                    UserEmailList.add(allUserEmail.Email_ID__c);
                   
                }
            }
    
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        //  list of people who should get the email
        List<String> sendTo = new List<String>();
        
        mail.setToAddresses(UserEmailList);
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ajay.koppineedi@lpl.com'];
         System.debug('owea>'+owea);
        if ( owea.size() > 0 ) {
          mail.setOrgWideEmailAddressId(owea.get(0).Id);
            System.debug('owea.get(0).Id>'+owea.get(0).Id);
        }
        // Set email is sent from
       // mail.setReplyTo('amitkumar.verma@lpl.com');
        //mail.setSenderDisplayName('LPL Financial Salesforce');
        
        // Set email contents
        mail.setSubject('The time trade invitation record has attachment/s. ');
        String body = 'Hello Compliance, <p>';
        body += ' The time trade invitation record has attachment/s. Please Review below details. Contact salesforce support for additional details.\n <p>' + htmlBody +  ' <p>Thank you,<br/>Salesforce Support</p>';
        
        mail.setHtmlBody(body);
        
        // Add your email to the master list
        mails.add(mail);
        
        // Finally Send an email for all the records having attachment/s
        Messaging.sendEmail(mails); 
        
        // Update the flag on timeTrade object for reporting
        update listOfRecordsWithAttmnt;
    }                                                                   
    
    
}