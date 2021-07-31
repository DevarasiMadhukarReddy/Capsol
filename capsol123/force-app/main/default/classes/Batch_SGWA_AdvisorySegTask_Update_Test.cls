@isTest 
private class   Batch_SGWA_AdvisorySegTask_Update_Test{

    static testMethod void AdvisorySegTask_Tasks() {
       
       Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
 
       
       Campaign camp = new Campaign();
       camp.name = 'SGWA';
       insert camp ;
        
        
       Account oAcct  = new Account ();
           oAcct.Name ='Account Test Record';
       insert oAcct; 
       
       Contact c = new Contact();
       c.lastname = 'acctest';
       c.master_rep_id__c='LMNO';
       c.AccountId = oAcct.Id;
       c.Lpl_Attachment_Sent_Date__c = system.today();
       insert c;
       
       
        CampaignMemberStatus newStatus = new CampaignMemberStatus(
        CampaignID=camp .id,
        Label='Attended',
        IsDefault=false,
        HasResponded=false,
        SortOrder=3
        );
        insert newStatus;
       
       Campaignmember camem= new Campaignmember ();
       camem.status=newStatus.Label;
       camem.CampaignId=camp.id;
       camem.ContactId=c.Id;       
       camem.SGWA_member__c= false;
       
       insert camem;
        
        Task t = new Task();
        t.whoId= c.id;
        t.subject='Advisory Segmentation';
        t.master_rep_id__c='';        
        t.status='In Progress';
        t.activityDate=system.today()+3;
        
        insert t;
        
        test.startTest();
         
        Schedulable_SGWA_AdvisorySegTask_Update  clsBatchItUpSon = new Schedulable_SGWA_AdvisorySegTask_Update();
        
        
        Batch_SGWA_AdvisorySegTask_Update clsBatchItUpSon1 = new Batch_SGWA_AdvisorySegTask_Update ();
        ID idBatch1 = Database.executeBatch(clsBatchItUpSon1, 200);
        
        String Jobid2=System.schedule('Schedulable_SGWA_AdvisorySegTask_Update:','0 0 1 * * ?', new Schedulable_SGWA_AdvisorySegTask_Update());

       
       test.stopTest();
       }
       
   
   
       }