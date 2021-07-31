/*
    @Author         : Rinku Yadav
    @Date           : 5th May, 2021
    @Project        : Data Load - Lightning
    @Description    : This batch class helps in managing the actual data load in salesforce.
    @TestClass      : LPL_UpdateAllianceNameAndAdvisor_BatchT
*/
global class LPL_UpdateAllianceNameAndAdvisor_Batch implements Database.Batchable<SObject>, Database.Stateful {
    /*
        @Author         : Rinku Yadav
        @Date           : 5th May, 2021
        @Description    : Start method of the batch class returns the Contact List
        @Params         : Database.BatchableContext bc
        @Return         : Querylocator
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> OSJID = system.Label.New_OSJ_Id.split(',');
        String query = 'SELECT Id,Updated_Large_Small_Enterprise_Advisor__c,New_Large_Small_Enterprise_Name__c,OSJ_ID__c,Branch_ID__c FROM Contact WHERE OSJ_ID__c IN: OSJID OR Branch_ID__c IN: OSJID';
        system.debug('$$$$$$'+query);
        return Database.getQueryLocator(query);
    }
    /*
        @Author         : Rinku Yadav
        @Date           : 5th May, 2021
        @Description    : Execute method of the batch class to do the dml required
        @Params         : Database.BatchableContext bc , List<contact> con
        @Return         : None
    */
    global void execute(Database.BatchableContext BC, List<contact> con){
        
        List<Contact> conList = new List<Contact>();
        Set<String> OsjIdSet = new Set<String>();
        Map<String,OSJ_ID__mdt> osjMap = new Map<String,OSJ_ID__mdt>();
        Map<String,OSJ_ID__mdt> brnchMap = new Map<String,OSJ_ID__mdt>();
        for( Contact cont : con ) {
            osjIdSet.add(cont.OSJ_ID__c);
            osjIdSet.add(cont.Branch_ID__c);
        }
        for( OSJ_ID__mdt osjmdt : [Select MasterLabel,QualifiedApiName,OSJ_Name__c, Type__c,IAS_Advisor__c FROM OSJ_ID__mdt
                                  WHERE Active__c = true
                                  and MasterLabel in : osjIdSet] ) {
                                      if( osjmdt.Type__c == 'Branch' ) {
                                          brnchMap.put(osjmdt.MasterLabel, osjmdt);
                                        }
                                      else if( osjmdt.Type__c == 'OSJ' ) {
                                          osjMap.put(osjmdt.MasterLabel, osjmdt);
                                        }
                                    }
        for( Contact cont : con ){
            if(cont.OSJ_ID__c != null && cont.OSJ_ID__c != '' && osjMap.containsKey(cont.OSJ_ID__c)){
                cont.New_Large_Small_Enterprise_Name__c = osjMap.get(cont.OSJ_ID__c).OSJ_Name__c;
                cont.Updated_Large_Small_Enterprise_Advisor__c = osjMap.get(cont.OSJ_ID__c).IAS_Advisor__c;
            }
            else if(cont.Branch_ID__c != null && cont.Branch_ID__c != '' && brnchMap.containsKey(cont.Branch_ID__c)){
                cont.New_Large_Small_Enterprise_Name__c = brnchMap.get(cont.Branch_ID__c).OSJ_Name__c;
                cont.Updated_Large_Small_Enterprise_Advisor__c = brnchMap.get(cont.Branch_ID__c).IAS_Advisor__c;
            }
            else{
                cont.New_Large_Small_Enterprise_Name__c = '';
                cont.Updated_Large_Small_Enterprise_Advisor__c = '';
            }
            conList.add(cont);
        }
        if( conList != null ) {
            Database.update(conList,false);
        }
    }
    /*
        @Author         : Rinku Yadav
        @Date           : 5th May, 2021
        @Description    : Finish method will send a email with error and total record count
        @Params         : Database.BatchableContext bc
        @Return         : None
    */
	global void finish(Database.BatchableContext BC) {
    
        AsyncApexJob a = [SELECT Id, Status,ExtendedStatus,NumberOfErrors,JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =:BC.getJobId()];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'lplsfdc.admin@lplfinancial.com','rinku.yadav@lplfinancial.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Enterprise Alliance Update' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}