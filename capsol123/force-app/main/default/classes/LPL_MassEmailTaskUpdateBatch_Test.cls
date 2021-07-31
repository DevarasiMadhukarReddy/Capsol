/*Test class Name               : LPL_MassEmailTaskUpdateBatch_Test
Description                      : Test class for LPL_MassEmailTaskUpdateBatch.
Created By                       : Rinku Yadav
Created Date                     : 3-August-2020
*/
@isTest(SeeAllData=False)
public class LPL_MassEmailTaskUpdateBatch_Test {
    static testMethod void checkPermissionSet(){
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS User'].Id,
            FirstName='ashish',
            LastName = 'gupta',
            Email = 'ashish.gupta@lpl.com',
            Username = 'ashish.gupta@lpl.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'Internal Regional Director',
            Alias = 'agupt',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
          	 insert u1;
        PermissionSet ps = new PermissionSet(Label = 'mockPs', Name = 'mockPs');
        insert ps;
        insert new PermissionSetAssignment(AssigneeId = u1.id, PermissionSetId = ps.Id);
     }
   
  static testmethod void setupTestData(){
    test.startTest();
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS User'].Id,
            FirstName='ashish',
            LastName = 'gupta',
            Email = 'ashish.gupta@lpl.com',
            Username = 'ashish.gupta@lpl.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'Internal Regional Director',
            Alias = 'agupt',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            );
          	 insert u1;
     
          Contact con = new Contact();
          con.lastname = 'Test 1234';
          insert con;
          Task task_Obj = new Task(WhoId = con.id,
                                   Type = 'Email',
                                   Subject = 'Mass Email:',
                                   department__c = '',
                                   Activity_Type__c = '',
                                   ownerid = u1.id);
          insert task_Obj;
         
          LPL_MassEmailTaskUpdateBatch obj01 = new LPL_MassEmailTaskUpdateBatch();
          Database.executeBatch(obj01, 200);
      test.stopTest();
  }
    
  public static testmethod void testsch(){
       test.startTest();
        	LPL_MassEmailTaskUpdateBatch_Scheduler batchObj = new LPL_MassEmailTaskUpdateBatch_Scheduler();            
            String sch = '0 0 23 * * ?'; 
            String JobID = system.schedule('Test',sch,batchObj);
        test.stopTest();
    }
}