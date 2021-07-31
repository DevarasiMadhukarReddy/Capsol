/*#############################Change History####################
CH#              Description                                                      Developer Name             Date
----------------------------------------------------------------------------------------------------------------------
Ch-1        Trigger by pass logic added for successfull completion batch          Manila Agnihotri           17th May 2018
*/    

trigger LPL_TaskTrigger on Task (after delete, after insert, after update, before delete, before insert, before update) {
    //Ch-1 - start
    Boolean isOff  = False;
    Map<String, Trigger_Support__c> supportMap = Trigger_Support__c.getAll();
    Trigger_Bypass__c tbp =  Trigger_Bypass__c.getInstance('Contact');
    List<Task> tsk = Trigger.New;
    List<Task> tskOld = Trigger.Old;
    
    if(!Trigger.isDelete)
    {
        
    if(supportMap.keyset().Contains(tsk[0].Logged_In_User_Profile__c))
    {
            isOff = supportMap.get(tsk[0].Logged_In_User_Profile__c).Off_Trigger__c;
        }
       if(tsk[0].Logged_In_User_Profile__c!='System Administrator' && tsk[0].Logged_In_User_Profile__c!='API only' && tsk[0].Logged_In_User_Profile__c!='AEM API User')
        {
        if(!LPL_OpportunityTriggerGateway.notrigger)
        {
            isOff =false;
        }
        else
        {
         isOff =true;
        }
       } 
    }
    else {
     
        if(supportMap.keyset().Contains(tskOld[0].Logged_In_User_Profile__c)){
            isOff = supportMap.get(tskOld[0].Logged_In_User_Profile__c).Off_Trigger__c;
            
        }
         if(tskOld[0].Logged_In_User_Profile__c!='System Administrator' && tskOld[0].Logged_In_User_Profile__c!='API only' && tskOld[0].Logged_In_User_Profile__c!='AEM API User')
        {
        if(!LPL_OpportunityTriggerGateway.notrigger)
        {
            isOff =False;
        } 
         else
        {
         isOff =true;
        }
        }
    }
    
    if(tbp.isOff__c == False){
    
      if(!isOff){
             TriggerFactory.createHandler(Task.sObjectType);
        }
    }
      //Ch-1 - end
}