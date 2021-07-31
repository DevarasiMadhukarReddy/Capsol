//trigger for the marketing / IRD (business development) 9 templated emails (see related SF workorder) to create a follow up activity due in 3 business days


trigger CT_TaskAfterInsertMarketingEmail on Task (after insert) {

    Set<id> WhatIds = new Set<id>();
    
    List<task> tskList= new List<task>();
    
    for(Task t : trigger.new) 
    {
      //  if(t.Subject== 'Email: Can Your Firm Support Your Advisory Transition?' || t.Subject== 'Email: Stop Waiting for Stability in Your Business'||t.Subject== 'Email: Regulatory Changes Interrupting Your Business? They Don’t Have To'||t.Subject== 'Email: You’re Focused on the Future. Is Your Firm?'||t.Subject== 'Email: When It Comes to Your Success, Don’t Play the Waiting Game'||t.Subject== 'Email: Is Your Firm Making Change Work in Your Favor?'||t.Subject== 'Email: You Know What You’re Worth. Why Aren’t You Getting It?'||t.Subject== 'Email: Take Control of Your Future—No Strings Attached'||t.Subject== 'Email: Don’t Let Your Firm Diminish Your Value' )
        
       if(t.Subject==Label.Disruption_LPL_Scale_Advisor_Value  || t.Subject== Label.Disruption_LPL_Scale_Change_Environment ||t.Subject== Label.Disruption_LPL_Scale_Current_Firm_Limitations ||t.Subject== Label.Disruption_LPL_Stability_Change_Environment||t.Subject== Label.Disruption_LPL_Stability_Compensation ||t.Subject== Label.Disruption_LPL_Stability_Current_Firm_Instability||t.Subject== Label.Disruption_LPL_Value_Advisor_Value||t.Subject== label.Disruption_LPL_Value_Control ||t.Subject== Label.Disruption_LPL_Value_Current_Firm_Limitations ) 
        {  
           Task tsk=new task();
           
           tsk.subject='Agile Email Follow Up';
           tsk.Department__c = 'Business Development';
           tsk.Activity_Type__c ='IRD Touch';
           
           tsk.recordtypeId='012U0000000aiCI';
           
           if(t.whoId!=null)
           tsk.whoId=t.whoid; 
           
           if(t.whatId!=null)
           tsk.whatId=t.whatid;
           
           Datetime dt = DateTime.newInstance(Date.today(),Time.newInstance(0, 0, 0, 0));
           String dayOfWeek=dt.format('EEEE');
           if(dayOfWeek=='Wednesday' || dayOfWeek=='Thursday'|| dayOfWeek=='Friday' ){
           
           tsk.ActivityDate = system.today()+5;}
           else If(dayOfWeek=='Saturday'){
           
           tsk.ActivityDate = system.today()+4;}
           else {   
                         
           tsk.ActivityDate = system.today()+3;}
           
                   
           tsk.OwnerId=t.OwnerId; 
           
           tskList.add(tsk);
        }    
    }           
    
    
    if(tskList.size()>0)
    {
       insert tskList;
    }
    
}