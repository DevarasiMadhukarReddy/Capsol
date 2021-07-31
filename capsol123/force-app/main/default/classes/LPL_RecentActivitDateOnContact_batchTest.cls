@isTest(SeeAllData=false)
public class LPL_RecentActivitDateOnContact_batchTest {
    
    public static void testDataSetup(Integer x){        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = false;
        insert tbp;
        
        List<Contact> conList = new List<Contact>();
        List<Task> taskList = new List<Task>();
        List<Event> eventList = new List<Event>();
        ID ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId(); 
        for(Integer i=1;i<=5;i++){
            conList.add(new Contact(LastName = 'Jain '+i,recordtypeid=ConRecordTypeId));
        }
        insert conList;
        Id recordTypeIdTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Apex Call').getRecordTypeId();
        Id recordTypeIdEvent = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Master Profile').getRecordTypeId();
        for(Contact c:conList){
            if(x!=2){//Contact with no task
                for(Integer j=1;j<=3;j++){
                    taskList.add(new Task(WhoId = c.Id,
                                          Subject = 'New Task '+j,
                                          Priority= 'Normal',
                                          Status = 'Not Started',
                                          Department__c = 'Other',
                                          ActivityDate = System.today(),
                                          RecordTypeId = recordTypeIdTask
                                         )
                                );
                }
            }
            if(x!=1){//Contact with no event
                for(Integer k=1;k<=3;k++){
                    eventList.add(new Event(WhoId = c.Id,
                                            Subject = 'New Event '+k,
                                            StartDateTime = System.now(),
                                            EndDateTime = System.now()+2,
                                            Event_Type__c = 'Event',
                                            Department__c = 'Other',
                                            RecordTypeId = recordTypeIdEvent
                                           )
                                 );
                }
            }
            x++;
        }
        insert taskList;
        insert eventList;
    }
    
    public static testmethod void getResultsForTasks(){
        testDataSetup(1);
        Test.startTest();
        LPL_RecentActivitDateOnContact_batch bc = new LPL_RecentActivitDateOnContact_batch();
        Database.executeBatch(bc,200);
        Test.stopTest();
    }
    
    public static testmethod void getResultsForEvents(){
        testDataSetup(0);
        Test.startTest();
        LPL_RecentActivitDateOnContact_batch bc = new LPL_RecentActivitDateOnContact_batch();
        Database.executeBatch(bc,200);
        Test.stopTest();
    }
}