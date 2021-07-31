@isTest 
private class BatcherHistory_Test{
    static testMethod void BatchHistory() {
       
       
       test.startTest();
       
       Account a = new Account();
       a.name = 'acctest';
       insert a;
       
        id aa =Schema.SObjectType.Branch_Inst_Financial__c.getRecordTypeInfosByName().get('Fortigent Financials').getRecordTypeId();
        
       Branch_Inst_Financial__c b = new Branch_Inst_Financial__c();
       b.name = 'test';
       b.RecordtypeId = aa;
       b.Account__c = a.id;
       insert b;
       
       Branch_Inst_Financial__c bb = new Branch_Inst_Financial__c();
       bb.name = 'test';
       bb.RecordtypeId = aa;
       bb.Account__c = a.id;
       insert bb;
       
        Branch_Inst_Financial__c bbnew = new Branch_Inst_Financial__c();
       bbnew.name = 'test';
       bbnew.RecordtypeId = aa;
       bbnew.Account__c = a.id;
       insert bbnew;
       
        id brec =Schema.SObjectType.Branch_Inst_Financial_History__c.getRecordTypeInfosByName().get('Fortigent AUM and ACC History').getRecordTypeId();
        
       Branch_Inst_Financial_History__c bi = new Branch_Inst_Financial_History__c();
       bi.Branch_Inst_Financial__c = b.id;
       bi.Fortigent_Year__c ='2015';
        bi.recordtypeId = brec;
       insert bi;
       
        Branch_Inst_Financial_History__c bii = new Branch_Inst_Financial_History__c();
       bii.Branch_Inst_Financial__c = b.id;
       bii.recordtypeId = brec;
       insert bii;
       
       Branch_Inst_Financial_History__c boi = new Branch_Inst_Financial_History__c();
       boi.Branch_Inst_Financial__c = bb.id;
       boi.Fortigent_Year__c ='2015';
       boi.recordtypeId = brec;
       insert boi;
       
        Branch_Inst_Financial_History__c bioi = new Branch_Inst_Financial_History__c();
       bioi.Branch_Inst_Financial__c = bb.id;
       bioi.recordtypeId = brec;
       insert bioi;
       
        Batcher_Branch_Financial clsBatchItUpSon = new Batcher_Branch_Financial ();
     ID idBatch = Database.executeBatch(clsBatchItUpSon, 200);
     
      Batcher_Branch_Financial_Yearly clsBatchItUpSon1 = new Batcher_Branch_Financial_Yearly();
     ID idBatch1 = Database.executeBatch(clsBatchItUpSon1, 200);
     
     String Jobid1=System.schedule('Schedulable_Branch_Financial','0 0 1 * * ?',new Schedulable_Branch_Financial());


String Jobid=System.schedule('Schedulable_Branch_Financial_Yearly','0 0 1 * * ?',new Schedulable_Branch_Financial_Yearly());

       
       test.stopTest();
       }
       
   
    static testMethod void BatchHistoryyearly() {
       
       
       test.startTest();
       
       Account a = new Account();
       a.name = 'acctest';
       insert a;
       
        id aa =Schema.SObjectType.Branch_Inst_Financial__c.getRecordTypeInfosByName().get('Fortigent Financials').getRecordTypeId();
        
       Branch_Inst_Financial__c b = new Branch_Inst_Financial__c();
       b.name = 'test';
       b.RecordtypeId = aa;
       b.Account__c = a.id;
       insert b;
       
       Branch_Inst_Financial__c bb = new Branch_Inst_Financial__c();
       bb.name = 'test';
       bb.RecordtypeId = aa;
       bb.Account__c = a.id;
       insert bb;
       
        Branch_Inst_Financial__c bbnew = new Branch_Inst_Financial__c();
       bbnew.name = 'test';
       bbnew.RecordtypeId = aa;
       bbnew.Account__c = a.id;
       insert bbnew;
       
        id brec =Schema.SObjectType.Branch_Inst_Financial_History__c.getRecordTypeInfosByName().get('Fortigent AUM and ACC History').getRecordTypeId();
        
       Branch_Inst_Financial_History__c bi = new Branch_Inst_Financial_History__c();
       bi.Branch_Inst_Financial__c = b.id;
       bi.Fortigent_Year__c ='2015';
        bi.recordtypeId = brec;
       insert bi;
       
        Branch_Inst_Financial_History__c bii = new Branch_Inst_Financial_History__c();
       bii.Branch_Inst_Financial__c = b.id;
       bii.recordtypeId = brec;
       insert bii;
       
       Branch_Inst_Financial_History__c boi = new Branch_Inst_Financial_History__c();
       boi.Branch_Inst_Financial__c = bb.id;
       boi.Fortigent_Year__c ='2015';
       boi.recordtypeId = brec;
       insert boi;
       
        Branch_Inst_Financial_History__c bioi = new Branch_Inst_Financial_History__c();
       bioi.Branch_Inst_Financial__c = bb.id;
       bioi.recordtypeId = brec;
       insert bioi;
       
     
      Batcher_Branch_Financial_Yearly clsBatchItUpSon1 = new Batcher_Branch_Financial_Yearly();
     ID idBatch1 = Database.executeBatch(clsBatchItUpSon1, 200);
     
     

String Jobid=System.schedule('Schedulable_Branch_Financial_Yearly','0 0 1 * * ?',new Schedulable_Branch_Financial_Yearly());

       
       test.stopTest();
       }
       
   
       
    static testMethod void BatchHistoryno() {
       
       
       test.startTest();
       
       Account a = new Account();
       a.name = 'acctest';
       insert a;
       
        id aa =Schema.SObjectType.Branch_Inst_Financial__c.getRecordTypeInfosByName().get('Fortigent Financials').getRecordTypeId();
        
       Branch_Inst_Financial__c b = new Branch_Inst_Financial__c();
       b.name = 'test';
       b.RecordtypeId = aa;
       b.Account__c = a.id;
       insert b;
       
       
        Batcher_Branch_Financial clsBatchItUpSon22 = new Batcher_Branch_Financial ();
     ID idBatch22 = Database.executeBatch(clsBatchItUpSon22, 200);
     
      Batcher_Branch_Financial_Yearly clsBatchItUpSon12 = new Batcher_Branch_Financial_Yearly ();
     ID idBatch12 = Database.executeBatch(clsBatchItUpSon12, 200);
     
     String Jobid21=System.schedule('Schedulable_Branch_Financial1','0 0 1 * * ?',new Schedulable_Branch_Financial());


String Jobid2=System.schedule('Schedulable_Branch_Financial_Yearly1','0 0 1 * * ?',new Schedulable_Branch_Financial_Yearly());

       
       test.stopTest();
       }
       }