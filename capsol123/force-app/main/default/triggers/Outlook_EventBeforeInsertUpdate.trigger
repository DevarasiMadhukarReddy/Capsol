trigger Outlook_EventBeforeInsertUpdate on Event (before insert, before update) {

     
   Set<id> ContactWhoIds = new Set<id>();    
   
   for(Event e : trigger.new) 
    {
        if(e.whoId!= null)
        {       
            if(String.valueOf(e.whoId).StartsWith('003')) ContactWhoIds.add(e.whoId);            
        }
    }    
    
    
  if(ContactWhoIds.size() != 0){
    
        Map<id, Contact> conMap = new Map<id, Contact>([Select Full_Name__c, phone,Advisory_Segment__c,Advisor_Channel__c,Direct_Mutual_Fund_AUM__c,MailingStreet,YTD_NNA__c, MailingCity,MailingPostalCode,MailingState,MF_and_ETF_AUM__c ,Current_Year_GDC__c From Contact Where (id in :ContactWhoIds )]);           
        
        for(Event e : trigger.new)
        {        
              
                Contact fin = conMap.get(e.WhoId);
                
                if(fin != null) 
                {       
                    e.Outlook_Subject__c = e.subject + ': '+  fin.Full_Name__c +':' + fin.phone;
                    
                    //Address addr = fin.MailingAddress;

                    e.Outlook_Location__c= e.Location + ','+ fin.MailingStreet + ',' + fin.MailingCity + ',' + fin.MailingState + ',' + fin.MailingPostalCode ;
                    
                    e.Out_Look_Body__c = '. Advisory Segment :'+ fin.Advisory_Segment__c +',' + fin.Advisor_Channel__c+ '. YTD GDC :'+ fin.Current_Year_GDC__c + '. YTD NNA:' + fin.YTD_NNA__c +'. Direct Mutual Fund AUM :'+ fin.Direct_Mutual_Fund_AUM__c + '. MF and ETF AUM :'+ fin.MF_and_ETF_AUM__c + '.';
                      
                }
            
        }    
    
    }
  

}