@isTest(SeeAllData = True)
public class LPL_Batch_Delete_Pardot_Contacts_Test {
    public static Id strRecordTypeC=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Pardot Prospect').getRecordTypeId();
    
    
    
    
    static testmethod void method1() {
        try{
        
         test.startTest();
            /*Trigger_Bypass__c tbp = new Trigger_Bypass__c();
            tbp.name='Contact';
            tbp.IsOff__c = False;
            insert tbp;
           */
            
            
            
            List<Contact> conlistdata=new List<Contact>();
            contact ct1=new contact(lastname = 'lastname ',PardotActivityInput__c = 'MA2', Pardot_Status__c = 'Yes', RecordTypeId=strRecordTypeC);
            conlistdata.add(ct1);
            
           
            contact ct2=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC, Previous_PardotAcivity_Value__c = 'MA1', Pardot_Status__c = 'Yes');
            conlistdata.add(ct2);
            
            contact ct3=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC, PardotActivityInput__c = 'MA3', Pardot_Status__c = 'Yes');
            conlistdata.add(ct3);
            
            contact ct4=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC, PardotActivityInput__c = 'MA4', Pardot_Status__c = 'Yes');
            conlistdata.add(ct4);
            insert conlistdata;
            
            //delete conlistdata;
            /*           
            Delete_Contacts__c delCon = new Delete_Contacts__c();
            delCon.Name = 'Add Days';
            delCon.No_of_Days__c = 5;
            insert delCon;
            
            Decimal Days = delCon.No_of_Days__c;
            
            Date d = (System.Today() - Integer.ValueOf(Days));
            */
            //system.assertEquals(d = Date.newInstance(2017, 12, 22), Date.newInstance(2017, 12, 22));
           /*             
            List<Contact> conList = [Select Id, Pardot_Status__c from Contact where RecordTypeId =:strRecordTypeC AND Pardot_Status__c = 'Yes' AND Pardot_Status__c!=null AND CreatedDate >=: d ];
            if(conList.size()>0){
            Database.delete(conList); 
            System.assertequals(conList.size(), 0);
            }
            */
            
            /*
            Database.delete(conlistdata);
            
            system.assertEquals(conlistdata.size(), 0);
           */
            
            /*
            List<Contact> deleteCon=new List<Contact>();
            
            List<Contact> conList = [Select Id, Pardot_Status__c from Contact where RecordTypeId =:strRecordTypeC AND Pardot_Status__c = 'Yes' AND Pardot_Status__c!=null /*AND CreatedDate >=: d ];*/
            /*
            If(conList.size()>0){
            for(Contact con: conList){
                if(con.Pardot_Status__c == 'Yes' && con.RecordTypeId ==strRecordTypeC){
                  deleteCon.add(con);
                } 
            }
            
            delete deleteCon;
            }
            */
            LPL_Batch_Delete_Pardot_Contacts batchObj=new LPL_Batch_Delete_Pardot_Contacts();
            Database.executeBatch(batchObj);
            /*
            If(Test.isRunningTest())
            {
                Integer x = 1/0; 
            } */
        }
            
        catch(exception e)
        {
             If(Test.isRunningTest())
            {
                Integer x = 1/0; 
            } 
            //e.getMessage() = 'Error';
            
            //LPL_CreateExceptionLog.createErrorRecordSync('LPL_Delete_Pardot_Contacts ','execute','Test',11,'test');
            Exception_Log__c exLog = new Exception_Log__c(className__c= 'LPL_Delete_Pardot_Contacts ',Details__c='execute',expType__c='Test',lineNumber__c='11',methodName__c='test');
            insert exLog;
            //System.debug('SFA_Contact_Test'+e.getMessage());
            //system.assertEquals(e.getMessage(), 'Test Error');
            //system.assertEquals(e.getMessage(), e.getMessage());
            //system.assertEquals(e.getLineNumber(), e.getLineNumber());
            //system.assertEquals(e.getTypeName(), e.getTypeName());
        }
        test.stopTest();
        
    }
    
     public static testMethod void testschedule() {   
        Test.StartTest();
        LPL_Batch_Delete_Pardot_Contacts_Sche sh1 = new LPL_Batch_Delete_Pardot_Contacts_Sche();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
    }
}