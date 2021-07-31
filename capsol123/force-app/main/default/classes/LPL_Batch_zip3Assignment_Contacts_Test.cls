@isTest(seeAllData = false)

public class LPL_Batch_zip3Assignment_Contacts_Test{
    
    
    public static Id conRecordTypeId;
    
    static testmethod void method1() {
        try{
            
            Trigger_Bypass__c tbp = new Trigger_Bypass__c();
            tbp.name='Contact';
            tbp.IsOff__c = False;
            insert tbp;
            
            /*
            Zip3_Assignment_Batch_Date__c zipAssign = new Zip3_Assignment_Batch_Date__c();
            zipAssign.Name ='Zip3 Assign Batch';
            zipAssign.Last_Run__c = System.now() - 2;
            
            insert zipAssign;
            
            
            Datetime zipAssignDate = Zip3_Assignment_Batch_Date__c.getInstance('Zip3 Assign Batch').Last_Run__c;
            
            */

            conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
            ID lplAdvisorRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
            
            List<Account> accList = new List<Account>();
            
            Account a1 = new Account(Name = 'Test Account', Type = 'IAS');
            accList.add(a1);
            
            Account a2 = new Account(Name = 'Test Account', Type = 'IS');
            accList.add(a2);
            
            insert accList;
            
            Zip3_Assignment__c zip = new Zip3_Assignment__c(Name = '010'
                                                            , X3_digit_Zip__c = '010'
                                                            , Advisory_Recruiting_Territory__c = 'New England'
                                                           // , Internal_Advisory_Consultant__c = UserInfo.getUserID()
                                                            , Internal_AI_Consultant__c = UserInfo.getUserID()
                                                            , Internal_Annuity_Consultant__c = UserInfo.getUserID()
                                                            , IS_Regional_Advisory_Consultant__c = UserInfo.getUserID()
                                                            , State__c = 'MA'
                                                            , Territory__c = 'Northeast'
                                                            , IS_Advisory_Territory__c = 'Northeast'
                                                            , Institutional_Recruiting_Territory__c = 'Northeast');
            
            insert zip;
            
            List<Contact> conlistdata=new List<Contact>();
            contact ct1=new contact(AccountId = a1.Id, lastname = 'lastname ', MailingPostalCode = '01012',  RecordTypeId=conRecordTypeId );
            conlistdata.add(ct1);
            
            
            contact ct2=new contact(AccountId = a1.Id, lastname = 'lastname ', MailingPostalCode = '01012', RecordTypeId=lplAdvisorRecTypeId);
            conlistdata.add(ct2);
            
            contact ct3=new contact(AccountId = a1.Id, lastname = 'lastname ', MailingPostalCode = '01012', RecordTypeId=lplAdvisorRecTypeId);
            conlistdata.add(ct3);
            
            contact ct4=new contact(AccountId = a2.Id, lastname = 'lastname ', MailingPostalCode = '01012', RecordTypeId=lplAdvisorRecTypeId);
            conlistdata.add(ct4);
            insert conlistdata;
            
            
            test.startTest();
           
            LPL_Batch_zip3Assignment_Contacts con=new LPL_Batch_zip3Assignment_Contacts();
            Database.executeBatch(con,200); 
            
            System.abortJob('01p3D0000011Quw');
                
            test.stopTest();  
            
        }
        
        catch(exception e)
        {
            
            //System.debug('SFA_Contact_Test'+e.getMessage());
            system.assertEquals(e.getMessage(), e.getMessage());
            system.assertEquals(e.getLineNumber(), e.getLineNumber());
            system.assertEquals(e.getTypeName(), e.getTypeName());
        }
        
        
    }
    
    
    
    public static testMethod void testschedule() {   
        Test.StartTest();
        /*
        Zip3_Assignment_Batch_Date__c zipAssign = new Zip3_Assignment_Batch_Date__c();
            zipAssign.Name ='Zip3 Assign Batch';
            zipAssign.Last_Run__c = System.now() - 2;
            
            insert zipAssign;
            
            
            Datetime zipAssignDate = Zip3_Assignment_Batch_Date__c.getInstance('Zip3 Assign Batch').Last_Run__c;
        */
        
        LPL_Batch_zip3Assignment_Contacts_Sche sh1 = new LPL_Batch_zip3Assignment_Contacts_Sche();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        
        //System.abortJob('01p3D0000011aqT');
        
        Test.stopTest();
    }        
    
    
      static testmethod void method2() {
        try{
   test.startTest();            
            Trigger_Bypass__c tbp = new Trigger_Bypass__c();
            tbp.name='Contact';
            tbp.IsOff__c = False;
            insert tbp;
           
            conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
            ID lplAdvisorRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
            
            List<Account> accList = new List<Account>();
            
            Account a1 = new Account(Name = 'Test Account', Type = 'IAS');
            accList.add(a1);
            
            Account a2 = new Account(Name = 'Test Account', Type = 'IS');
            accList.add(a2);
            
            insert accList;
            
            Zip3_Assignment__c   zip3Assign  = new Zip3_Assignment__c(Name = '967'
                                                            , X3_digit_Zip__c = '967'
                                                            , Advisory_Recruiting_Territory__c = 'New England'
                                                           // , Internal_Advisory_Consultant__c = UserInfo.getUserID()
                                                            , Internal_AI_Consultant__c = UserInfo.getUserID()
                                                            , Internal_Annuity_Consultant__c = UserInfo.getUserID()
                                                            , IS_Regional_Advisory_Consultant__c = UserInfo.getUserID()
                                                            , State__c = 'MA'
                                                            , Territory__c = 'Northeast'
                                                            , IS_Advisory_Territory__c = 'Northeast'
                                                            , Institutional_Recruiting_Territory__c = 'Northeast');
            
            insert zip3Assign;
            
         
            contact ct1=new contact(AccountId = a1.Id, lastname = 'lastname ', MailingPostalCode = '967',  RecordTypeId=lplAdvisorRecTypeId );
   
            
             insert ct1;
            Contact updatedCon =[Select Id, MailingPostalCode, Branch_Channel__c, Regional_Advisory_Consultant__c,  Hybrid_Advisory_Consultant__c , Internal_Annuity_Consultant__c, Internal_AI_Consultant__c, Advisor_Recuiting_Territory__c, Institutional_Recruiting_Territory__c , IS_Advisory_Territory__c , Advisory_Territory__c, RecordTypeId, CreatedDate from Contact where RecordTypeId =: lplAdvisorRecTypeId And ID=:ct1.ID];  
        
                                                     updatedCon.Institutional_Recruiting_Territory__c = zip3Assign.Institutional_Recruiting_Territory__c;
                                         updatedCon.Regional_Advisory_Consultant__c = NULL;
                                     
                                        updatedCon.Hybrid_Advisory_Consultant__c = zip3Assign.IS_Regional_Advisory_Consultant__c;
                                        updatedCon.Internal_Annuity_Consultant__c = zip3Assign.Internal_Annuity_Consultant__c;
                                        updatedCon.Internal_AI_Consultant__c = zip3Assign.Internal_AI_Consultant__c;
                                      
                                        updatedCon.Advisor_Recuiting_Territory__c= zip3Assign.Advisory_Recruiting_Territory__c;
                                        
                                        updatedCon.IS_Advisory_Territory__c = zip3Assign.IS_Advisory_Territory__c;
                                        
                                        updatedCon.Advisory_Territory__c = zip3Assign.Territory__c;
            
            
            update updatedCon;
         
           LPL_Batch_zip3Assignment_Contacts con=new LPL_Batch_zip3Assignment_Contacts();
           Database.executeBatch(con,200); 
            
         
            test.stopTest();  
            
        }
        
        catch(exception e)
        {
            
            //System.debug('SFA_Contact_Test'+e.getMessage());
            system.assertEquals(e.getMessage(), e.getMessage());
            system.assertEquals(e.getLineNumber(), e.getLineNumber());
            system.assertEquals(e.getTypeName(), e.getTypeName());
        }
        
        
    }
    
    
    
    
   
}