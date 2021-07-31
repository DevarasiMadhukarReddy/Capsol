@isTest
public class LPL_Oppty_Aggregate_Data_Schedule_Test {
    public static testMethod void testschedule() {  
        Test.StartTest();
        Lpl_Oppty_Aggregate_Data_Schedulable sh1 = new Lpl_Oppty_Aggregate_Data_Schedulable();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
    }
}