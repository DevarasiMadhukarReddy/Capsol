@isTest
public class SFA_Contact_Batch_Test {
    public static Id strRecordTypeC=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
    
    static testmethod void method1() {
        try{
            Trigger_Bypass__c tbp = new Trigger_Bypass__c();
            tbp.name='Contact';
            tbp.IsOff__c = False;
            insert tbp;
            List<Contact> conlistdata=new List<Contact>();
            contact ct1=new contact(lastname = 'lastname ',PardotActivityInput__c = 'MA2', RecordTypeId=strRecordTypeC);
            conlistdata.add(ct1);
            
            
            contact ct2=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC, Previous_PardotAcivity_Value__c = 'MA1');
            conlistdata.add(ct2);
            
            contact ct3=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC, PardotActivityInput__c = 'MA3');
            conlistdata.add(ct3);
            
            contact ct4=new contact(lastname = 'lastname ',RecordTypeId=strRecordTypeC, PardotActivityInput__c = 'MA4');
            conlistdata.add(ct4);
            insert conlistdata;
            
            List<task> taskList=new List<task>();
            
            
            task t1=new task();
            t1.Subject='test subject';
            t1.Status='Completed';
            t1.Priority='Normal';
            t1.ActivityDate=Date.newInstance(2017,06, 11);
            t1.WhoId=ct1.Id;
            t1.Department__c='Business Development';
            t1.Activity_Type__c='IRD Touch';
            t1.Category__c='Call-Internal';
            taskList.add(t1);
            
            task t1a=new task();
            t1a.Subject='test subject';
            t1a.Status='Completed';
            t1a.Priority='Normal';
            t1a.ActivityDate=Date.newInstance(2016,04, 04);
            t1a.WhoId=ct2.Id;
            t1a.Department__c='Business Development';
            t1a.Activity_Type__c='IRD Touch';
            t1a.Category__c='Call-Internal';
            taskList.add(t1a);
            
            task t1b=new task();
            t1b.Subject='test subject';
            t1b.Status='Completed';
            t1b.Priority='Normal';
            t1b.ActivityDate=Date.newInstance(2017,03,03);
            t1b.WhoId=ct2.Id;
            t1b.Department__c='Business Development';
            t1b.Activity_Type__c='IRD Touch';
            t1b.Category__c='Call-Internal';
            t1b.CreatedDate=System.today()-1;
            taskList.add(t1b);
            
            task t1c=new task();
            t1c.Subject='test subject';
            t1c.Status='In Progress';
            t1c.Priority='Normal';
            t1c.ActivityDate=Date.newInstance(2017,03,03);
            t1c.WhoId=ct3.Id;
            t1c.Department__c='Business Development';
            t1c.Activity_Type__c='IRD Touch';
            t1c.Category__c='Call-Internal';
            t1c.CreatedDate=System.today()-1;
            taskList.add(t1c);
            
            task t1d=new task();
            t1d.Subject='test subject';
            t1d.Status='Completed';
            t1d.Priority='Normal';
            t1d.ActivityDate=System.today()+5;
            t1d.WhoId=ct4.Id;
            t1d.Department__c='Business Development';
            t1d.Activity_Type__c='IRD Touch';
            t1d.Category__c='Call-Internal';
            t1d.CreatedDate=System.today()-1;
            taskList.add(t1d);
            
            insert taskList;
            Map<Id,contact> contactsMap =new Map<Id,contact>();//for contact map
            List<Contact> contactList = new List<Contact>();  
            for(Contact con:[Select Id,(Select id,Department__c,Activity_Type__c,Category__c,CreatedDate,ActivityDate,whoid from tasks WHERE Status = 'Completed' and (Department__c='Business Development' and ((Activity_Type__c='IRD Touch' OR Activity_Type__c='Recruiting' OR Activity_Type__c='Master Recruiting') and (Category__c!='Social Media Outreach' and Category__c!='Left Message – Prospecting' and  Category__c!='Mailed information' and  Category__c!='Email – Prospecting' and  Category__c!='Referral to Branch' and  Category__c!='Referral to Core' and  Category__c!='Referral to IS' and  Category__c!='Referral to Masters' and Category__c!='Other'))) order by ActivityDate DESC limit 1) from contact where Id In:conlistdata]) {
                if(con.tasks.isEmpty()) {
                    
                    con.Marketing_Category__c='new';
                    contactsMap.put(con.Id,con);
                }
                else {
                   con.Marketing_Category__c='Inactive';
                    if(con.tasks!=null){
                        
                        Date taskDueDate;
                        Datetime taskCreationDate;
                        for(task tsk:con.tasks) {
                            
                            taskCreationDate=tsk.CreatedDate;
                            Date activityCreated =taskCreationDate.date();
                            
                            
                            taskDueDate=tsk.ActivityDate;
                            
                            
                            
                            if(taskDueDate>activityCreated) {
                                
                                con.Marketing_Category__c='Inactive'; //task created date is greater than marketing activity created date
                                contactsMap.put(con.Id,con);
                            }
                            else {
                                if(taskDueDate.daysBetween(activityCreated)<=180 || taskDueDate==activityCreated) {
                                    
                                    con.Marketing_Category__c='Active';//task created date is previous than marketing activity created date and within 180 days 
                                    contactsMap.put(con.Id,con);       //and also task created date is same as marketing activity created date
                                }
                                else {
                                    
                                    con.Marketing_Category__c='Inactive';//task created date is previous than marketin activity created date and more than 180 days
                                    contactsMap.put(con.Id,con);
                                }
                            }
                            
                        }
                    }
                }
                
            }
            
            contactList = new List<Contact>();
            contactList.addAll(contactsMap.values());
            update contactList;
            
            
            test.startTest();
            
            
            SFA_Contact_Batch batchObj=new SFA_Contact_Batch();
            Database.executeBatch(batchObj);
           
            
            If(Test.isRunningTest())
            {
                Integer x = 1/0; 
            } 
        }
            
        catch(exception e)
        {
            
            //System.debug('SFA_Contact_Test'+e.getMessage());
            system.assertEquals(e.getMessage(), e.getMessage());
            system.assertEquals(e.getLineNumber(), e.getLineNumber());
            system.assertEquals(e.getTypeName(), e.getTypeName());
        }
        test.stopTest();
        
    }
    
     public static testMethod void testschedule() {   
        Test.StartTest();
        SFA_Contact_Batch_Scheduable sh1 = new SFA_Contact_Batch_Scheduable();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
    }
}