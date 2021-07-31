/*
#############################Change History####################
CH#              Description                                                        Developer Name                       Date
------------------------------------------------------------------------------------------------------------------------------------
ch-01           Test class for Batch - LPL_Update_BSStatus_Batch                  Saritha Siddamshetty                  18-SEP-2020
 */

//CH-01 STARTS
@isTest(seeAllData=false)
public class LPL_Update_BSStatus_BatchTest
{
    Public static ID LPLAdvisorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
    static testMethod void validateContactStatus()
    {
        List<Contact> contactlist = new List<Contact>();
        Date dt = Date.Today();
        // Record Insert with Active date today
        for(Integer i=0;i<50;i++)
        {
            contact con = new contact();
            con.RecordTypeId = LPLAdvisorRecordTypeId;
            con.LastName = 'Name'+ i;
            con.Admin_Solutions_Active_Date__c = dt;
            con.Marketing_Solutions_Active_Date__c = dt;
            con.CFO_Solutions_Active_Date__c   = dt; 
            con.Admin_Solutions_Termination_Date__c = null; 
            con.Marketing_Solutions_Termination_Date__c = dt.addDays(20);
            con.CFO_Solutions_Termination_Date__c = dt.addDays(30);
            contactlist.add(con);
        }
        insert contactlist; 
        
        test.startTest();
        LPL_Update_BSStatus_Batch_Sche LPLubss1 = new LPL_Update_BSStatus_Batch_Sche();
        String sch = '0 0 23 * * ?';
        System.schedule('lpltest1',sch,LPLubss1);
        
        LPL_Update_BSStatus_Batch LPLubsas = new LPL_Update_BSStatus_Batch();
        Database.executeBatch(LPLubsas);
        test.stopTest();
        
        System.assertEquals(50, [SELECT count() from Contact WHERE (IAO_Advisor_Interest__c = 'Active' OR Experiment_s__c = 'Active' OR CFO_Solutions_Status__c = 'Active')]);
    }
    
    static testMethod void validateContactStatus1()
    {
        List<Contact> contactlist = new List<Contact>();
        Date  dt = Date.Today();
        // Record insert with termination date today 
        for(Integer i=0;i<50;i++)
        {
            contact con = new contact();
            con.RecordTypeId = LPLAdvisorRecordTypeId;
            con.LastName = 'Test'+ i;
            con.Admin_Solutions_Active_Date__c = dt.addDays(-10);
            con.Marketing_Solutions_Active_Date__c = dt.addDays(-20);
            con.CFO_Solutions_Active_Date__c   = dt.addDays(-30);
            con.Admin_Solutions_Termination_Date__c = dt; 
            con.Marketing_Solutions_Termination_Date__c = dt; 
            con.CFO_Solutions_Termination_Date__c = dt; 
            contactlist.add(con);
        }
        insert contactlist; 
        
        test.startTest();   
        LPL_Update_BSStatus_Batch LPLubsts = new LPL_Update_BSStatus_Batch();
        Database.executeBatch(LPLubsts);
        test.stopTest();
        
        System.assertEquals(50, [SELECT count() from Contact WHERE (IAO_Advisor_Interest__c = 'Terminated' OR Experiment_s__c = 'Terminated' OR CFO_Solutions_Status__c = 'Terminated')]);
    } 
}//CH-0 ENDS