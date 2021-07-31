/* ******** Lead Onboarding Changes Task Trigger handler class  ********** 

To get the Task status Picklist Value Entry and Exit Dates. */

public without sharing class Triggerhandler {
    
    public List<Task> handleTaskStatusDays(List<Task> tskList, List<Task> oldTkList){
        
        
        /*Set<ID> taskID = new Set<ID>();
        for(Task tk : tskList){
           
           taskID.add(tk.ID);
            
        }
        
        List<Task> tskNewList = [select id, Status, Status_Not_Started_Entry__c, Status_Completed_Entry__c, Status_In_Progress_Entry__c,Status_Deferred_Entry__c, 
                                     Status_Not_Started_Exit__c, Status_In_Progress_Exit__c, Status_Deferred_Exit__c from Task where Id in: taskID];
        */
        for(Task tk : tskList){
            Task oldtk = oldTkList[0];
            if(oldTk.Status == 'Not Started'){
                tk.Status_Not_Started_Exit__c = system.today();
            }
            if(oldTk.Status == 'In Progress'){
                tk.Status_In_Progress_Exit__c = system.today();
            }
            if(oldTk.Status == 'Deferred'){
                tk.Status_Deferred_Exit__c = system.today();
            }
            if(tk.Status == 'Completed'){
                tk.Status_Completed_Entry__c = system.today();
            }
            if(tk.Status == 'In Progress'){
                tk.Status_In_Progress_Entry__c = system.today();
            }
            if(tk.Status == 'Deferred'){
                tk.Status_Deferred_Entry__c = system.today();
            }
        }
        
        //if(tskList.size() != 0) {
            return tskList;
        //}
    }

}