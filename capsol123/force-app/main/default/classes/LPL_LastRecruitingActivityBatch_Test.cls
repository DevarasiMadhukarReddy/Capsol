@isTest(SeeAllData=false)
public class LPL_LastRecruitingActivityBatch_Test {
    @testSetup
    public static void testDataSetup(){        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = true;
        insert tbp;
        
        List<Task> taskList = new List<Task>();
        List<Event> eventList = new List<Event>();
        ID ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        
        Contact con = new Contact(LastName = 'Test',recordtypeid=ConRecordTypeId);
        insert con;
        
        taskList.add(new Task(whoId=con.Id, Subject='apex', Status = 'In Progress',ActivityDate=System.today()-2,Department__c='Adv. Facing Technology',Activity_Type__c='Recruiting'));
        taskList.add(new Task(WhoId=con.Id, Subject='apex', Status = 'Completed',ActivityDate=System.today(),Department__c='Adv. Facing Technology',Activity_Type__c='Master Recruiting'));
        insert taskList;

        eventList.add(new Event(WhoId=con.Id, StartDateTime=System.now()-1,DurationInMinutes = 10,Department__c='Adv. Facing Technology',Activity_Type__c='Recruiting'));
        insert eventList;
    }
    
    public static testmethod void getResults(){
        Test.startTest();
        LPL_LastRecruitingActivityOnContactBatch bc = new LPL_LastRecruitingActivityOnContactBatch();
        Database.executeBatch(bc,200);
        Test.stopTest(); 
        List<Contact> c = [Select id,Last_Recruiting_Activity__c,Lastname from contact where name like '%test%' limit 1];
        List<Task> t = [select ActivityDate from Task where Status='Completed' and whoId=:c[0].id limit 1];
        System.assertEquals(c[0].Last_Recruiting_Activity__c, t[0].ActivityDate);
    }
}