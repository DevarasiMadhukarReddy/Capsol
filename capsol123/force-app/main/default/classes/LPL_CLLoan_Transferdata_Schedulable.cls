global class LPL_CLLoan_Transferdata_Schedulable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
        
        Boolean status;
        
        LPL_Batch_CLLoan_TransferObjectdata transferData=new LPL_Batch_CLLoan_TransferObjectdata();
        
        List<LPL_Batch_CLLoan_TransferObjBatch_Bypass__c> tbp = LPL_Batch_CLLoan_TransferObjBatch_Bypass__c.getAll().values();
        
        status=tbp[0].batch_IsOff__c;
        
        if(status) {
            Database.executeBatch(transferData,2000);
        }
    }
    
}