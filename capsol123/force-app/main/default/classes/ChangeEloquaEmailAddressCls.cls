public class ChangeEloquaEmailAddressCls {

  @future (callout=true)
  public static void ChangeEloquaEmailAddress(map<string,string> emails) {

    //format is a map of emails, the key is the old email, the value is the new email to change it to
    HttpRequest  req = new HttpRequest();   
    HttpResponse response = null;
    Http http = new Http();
    try
    {
      for(string key : emails.keySet() )
      {
        req.setEndpoint('http://now.eloqua.com/e/f2?elqSiteID=640398753&elqFormName=changeEmailAddress&oldEmailAddress='+key+'&newEmailAddress=' + emails.get(key)  );
        req.setMethod('GET') ;
        response = http.send(req);
      }
    } catch(Exception ex){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      String[]  toAddresses = new String[] {'marketinganalytics@lpl.com'};
      mail.setToAddresses( toAddresses );
      mail.setReplyTo('marketinganalytics@lpl.com');
      mail.setSenderDisplayName('Salesforce - ChangeEloquaEmailAddress - EXCEPTION ');
      mail.setSubject('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails - EXCEPTION.'  );
      mail.setBccSender(false);
      mail.setUseSignature(false);
      mail.setPlainTextBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails.' + ex );
      mail.setHtmlBody('ChangeEloquaEmailAddress sent with '+emails.size() + ' emails.' + ex  );
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
  }
}