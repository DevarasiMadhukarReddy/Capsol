trigger Outlook_TaskBeforeInsertUpdate on Task(before insert, before update) {

     
   Set<id> ContactWhoIds = new Set<id>();    
   
   for(Task t : trigger.new) 
    {
        if(t.whoId!= null)
        {       
            if(String.valueOf(t.whoId).StartsWith('003')) ContactWhoIds.add(t.whoId);            
        }
    }    
    
    
  if(ContactWhoIds.size() != 0){
    
        Map<id, Contact> conMap = new Map<id, Contact>([Select Full_Name__c, phone,Advisory_Segment__c,YTD_NNA__c,Advisor_Channel__c,Direct_Mutual_Fund_AUM__c,MF_and_ETF_AUM__c ,Current_Year_GDC__c From Contact Where (id in :ContactWhoIds )]);           
        
        for(Task  t : trigger.new)
        {        
              
                Contact fin = conMap.get(t.WhoId);
                
                if(fin != null) 
                {       
                    t.Outlook_Subject__c =t.subject + ':'+  fin.Full_Name__c +':' + fin.phone;
                    
                    t.Out_Look_Body__c = '. Advisory Segment :'+ fin.Advisory_Segment__c +',' + fin.Advisor_Channel__c+ '. YTD GDC :'+ fin.Current_Year_GDC__c + '. YTD NNA:' + fin.YTD_NNA__c +'. Direct Mutual Fund AUM :'+ fin.Direct_Mutual_Fund_AUM__c + '. MF and ETF AUM :'+ fin.MF_and_ETF_AUM__c + '.';
                     
                }
            
        }    
    
    }
  

}