global class CLSresendWelcomeEmail{
    String taskId;
    
    
    public CLSresendWelcomeEmail(String taskId) {
        this.taskId= taskId;
    }
    
   
    @AuraEnabled
    public static String resendWelcomeEmail(String taskId) {
    Task tasks;
        if(String.isNotBlank(String.valueOf(taskId))) {
             tasks = [SELECT Id, Status,OpportunityEmail__c,Activity_Type__c,Fire_Email__c FROM Task WHERE Id = :taskId  limit 1];
             if(tasks.Activity_Type__c =='Initial Call Out' && tasks.Status =='Completed' && tasks.OpportunityEmail__c != null && tasks.OpportunityEmail__c != '') {
                    tasks.Fire_Email__c = true;
                    update tasks;
                    return 'Email sent successfully';
              }
              else {
            return 'This advisor is not eligible for access to the Advisor Transition Portal. If you want to resend the Welcome Email, please ensure the access rules are set appropriately.';
        }
        
    }
    
    return 'This advisor is not eligible for access to the Advisor Transition Portal. If you want to resend the Welcome Email, please ensure the access rules are set appropriately.';
}
}