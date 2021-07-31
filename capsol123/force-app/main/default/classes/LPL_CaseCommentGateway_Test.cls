/*
Trigger Name            :LPL_CaseCommentGateway_Test
Description             :Test Class for LPL_CaseCommentGateway

Developer Name          : 
Created Date            : 

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------


*/

@isTest(seeAllData = false)
public class LPL_CaseCommentGateway_Test{
    
    //vaibhav-commented to change field data type
    
    public static Id strRecordTypeC=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    
    static testMethod void method1() {
       Test.startTest();
        
        Boolean checkOldValueCTA;
        Boolean checkOldValueSME;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Utkarsh Topre',
            Email = 'pravin.kale@cognizant.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            // UserRoleId = r.Id
        );
        insert u;
        
        Trigger_Bypass__c tbp =  new Trigger_Bypass__c();
        tbp.IsOff__c=false;
        tbp.Name='Contact';
        insert tbp;
        
        SME_Details__c sme = new SME_Details__c();
        
        sme.Name = 'Utkarsh Topre';
        sme.SME_Email__c = 'pravin.kale@cognizant.com';
        sme.SME_User_ID__c = u.ID;
        sme.SME_Name__c = 'Utkarsh Topre';
        checkOldValueSME=true;
        insert sme;
        
        Contact con = new Contact(LastName = 'Contact 1' , RecordTypeId = strRecordTypeC );
        insert con;
        
        Case c = new Case(Subject = 'Test 1', Description = 'Test 1 Description', Status= 'Not Started', Priority = 'Medium',Region__c='East', 
                          ContactId = con.Id, Assigned_Recruiter__c = u.Id, IRD__c = u.Id, Project_Manager__c = u.Id, Executive_Recruiter__c = u.Id);
        
        insert c;
        
        List<Case_Comments_J__c> ccList= new List<Case_Comments_J__c>();
        Set<id> ids=new Set<id>();
         Case_Comments_J__c cc3 = new Case_Comments_J__c();
       
        cc3.Case__c = c.Id;
        cc3.SMEs_Needed_for_Follow_up__c = 'Utkarsh Topre';
        cc3.CTAs__c= 'Escalate';
        cc3.Send_Email__c= True;
       
        ccList.add(cc3);
        
        
        Case_Comments_J__c cc1 = new Case_Comments_J__c();
        cc1.Case__c = c.Id;
        cc1.SMEs_Needed_for_Follow_up__c = 'Utkarsh Topre';
        cc1.CTAs__c= '1:1 Meeting with Recruiter';
        
        cc1.Send_Email__c= True;
        ccList.add(cc1);
        
        Case_Comments_J__c cc2 = new Case_Comments_J__c();
        cc2.Case__c = c.Id;
        cc2.SMEs_Needed_for_Follow_up__c = 'Utkarsh Topre';
        cc2.CTAs__c= 'Escalate';
        cc2.Send_Email__c= True;
        ccList.add(cc2);
        checkOldValueCTA=true;
        checkOldValueSME=true;
        
        insert ccList;
        
        for(Case_Comments_J__c cv:ccList) {
            
            ids.add(cv.id);
            
        }
        
        List<Case_Comments_J__c> updateccList= new List<Case_Comments_J__c>();
          List<Case_Comments_J__c> updateccList1= new List<Case_Comments_J__c>();
        updateccList=[select id,CTAs__c from Case_Comments_J__c where id in:ids ];
        
        for(Case_Comments_J__c cc:updateccList){
            
           cc.CTAs__c ='Escalate';
             updateccList1.add(cc);
        }
        
        update updateccList1;
       
          Test.stopTest();
    }

    
    
}