/**

* Description  : This is Test class of LPL_attachment_trigger and LPL_Utility. 
* 
* @Author      : Ashish Gupta(Cognizant)
* @version     : 1.0
* @CreatedDate : August 16,2018
*/
@isTest
public class LPL_Attachment_Test {
    
    static testMethod void createInvitation(){
        test.startTest();
        TimeTrade_Send_Email__c customSettingObj1=new TimeTrade_Send_Email__c();
        customSettingObj1.Name='Ashish Gupta';
        customSettingObj1.Email_ID__c='Ashish.Gupta2@lpl.com';
        
        insert customSettingObj1;
        
        TimeTrade_SF1__Invitation__c invitation1 =new TimeTrade_SF1__Invitation__c();
        invitation1.hasAttachment__c=false;
        invitation1.Name='Test Invitation';
        invitation1.TimeTrade_SF1__Duration__c='30 Minutes';
        Insert invitation1;
        
        Attachment attachmentObj=new Attachment();  
        attachmentObj.Name='Test attachment';
        attachmentObj.ParentId =invitation1.ID;
        
        String myString = 'body data';
        Blob myBlob = Blob.valueof(myString);
        
        attachmentObj.Body=myBlob;
        insert attachmentObj;
        test.stopTest(); 
        
        
    }
    
    
}