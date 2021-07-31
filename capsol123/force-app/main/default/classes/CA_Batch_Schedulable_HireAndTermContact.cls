global class CA_Batch_Schedulable_HireAndTermContact implements Schedulable {
      global void execute(SchedulableContext sc) {
                        
        CA_BatchHireAndTermDateUpdateFromContact con=new CA_BatchHireAndTermDateUpdateFromContact();
        
        Database.executeBatch(con,200); 
        
    }

}