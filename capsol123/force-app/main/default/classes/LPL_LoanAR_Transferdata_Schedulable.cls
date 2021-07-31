global class LPL_LoanAR_Transferdata_Schedulable implements Schedulable {
    
    
    global void execute(SchedulableContext sc) {
        
        
        
        LPL_Batch_LoanAR_TransferObjectdata transferData = new LPL_Batch_LoanAR_TransferObjectdata();
        
        
            Database.executeBatch(transferData,2000);
        
    }
    
}