/*
Batch class Name              :LPL_UpdateCaseResult_Batch
Developer Name                :Vaibhav Wadhai
Created Date                  :28 june 2017
Versio No                     :1.0 

*/
@isTest(seeAllData=False)
public class LPL_UpdateCaseResult_Batch_Test {

    public static Id caseRecordTypeIBDid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();//Ishan Nigam:Modified the name from Project J to Business Development as part of Project Wreath changes
    
    Static testMethod void method1() {
        
        List<Case> caseList=new List<Case>();
        List<case> updateCaseList=new List<Case>();
        Set<Id> caseids=new Set<Id>();
        
        for(Integer i=0;i<10;i++) {
            
            Case c=new Case();
            c.Status='Not Started';
            c.Region__c='East';
            c.Subject='caseSub+i';
            c.Description='Desc+i';
            c.Case_Origin_Detail__c='Email';
            c.Priority__c='Low';
            c.RecordTypeId=caseRecordTypeIBDid;
            c.First_Email_Sent_Date__c=System.Today();
            c.Result__c='Verbal Yes';
            caseList.add(c);
        }
       
        insert caseList;
        
         for(Case caseRec:caseList) {
            
            caseids.add(caseRec.id);
        }
        updateCaseList=[Select id from Case where id in: caseids ];
        
        update updateCaseList;
        
        test.startTest();
        
        LPL_UpdateCaseResult_Batch_Schedulable batchjob=new LPL_UpdateCaseResult_Batch_Schedulable();
        
        //Database.executeBatch(batchjob);
         String sch = '0 0 23 * * ?'; 
         system.schedule('TestCheck',sch,batchjob); 
        test.stopTest();
    }
}