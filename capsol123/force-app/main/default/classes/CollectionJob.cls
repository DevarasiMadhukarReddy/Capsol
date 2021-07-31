global class CollectionJob implements Database.Batchable<sObject>, Schedulable {
    global String query;
    global Date queryDate;
    private Boolean submitNextJob;
    global Database.QueryLocator start(Database.BatchableContext BC) {
       
        query = 'select id,name,collect__External_ID__c,Master_Rep_ID__c from Contact where Master_Rep_ID__c!=null and collect__External_ID__c=null';
        System.debug('<< Initiation Query >>' +query);
        return Database.getQueryLocator(query);
    }
    
    public CollectionJob() {
        
        submitNextJob = true;
    }
    public CollectionJob(Boolean submitNextJob) {
        this.submitNextJob = submitNextJob;
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
         if(scope != null){
             List<Contact> contactList = (List<Contact>) scope;
             List<Contact> con = new List<Contact>();
             for (Contact obj: contactList) {
                if(obj.collect__External_ID__c == null) {
                    obj.collect__External_ID__c = 'COLLECT:'+obj.Master_Rep_ID__c;
                    con.add(obj);
                }
             }
             try {
                if(con.size()>0) {
                    update con;
                }
             } catch(Exception e) {
                System.debug('Exception caught at '+e.getLineNumber()+' with error '+e.getMessage());
             }
         }
    }
    
    global void execute(SchedulableContext ctx) {
        Id batchJobId = Database.executeBatch(new CollectionJob(), 200);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('<< IN FINISH >>');
        submitNextJob();
    }
    global void submitNextJob() {
        if(!submitNextJob) return;
        String table = 'staging__Interface_Contract__c';
        String query = collect.SyncHelper.getBatchQuery(table, true, true);
        System.debug(LoggingLevel.DEBUG, 'Query :' + query);
        collect.SyncJob job = new collect.SyncJob((String) null, query,
                                         table,
                                         true,true,
                                         2000);
        Id jobId = Database.ExecuteBatch(job, 2000);
        
    }
    
}