trigger ABCS_Sales_Financials_Update on ABCS_Sales__c (before insert,before update,after insert,after update,after delete) {
    
    Map<Id,ABCS_Sales__c> MWPabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> OMPabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> PWPabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> SAMabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> SWMabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> MSabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> GWPabcsSalesData= new Map<Id,ABCS_Sales__c>();
    List<Id> abcsSales= new List<Id>();
    List<ABCS_Sales__c> Records = new  List<ABCS_Sales__c>(); 
    List<Financials__c> lstFinancials= new List<Financials__c>();
    List<Financials__c> lstFinancials1= new List<Financials__c>();
    List<Financials__c> lstFinancialsrecords= new List<Financials__c>();
    List<ABCS_Sales__c> currentrecords= new  List<ABCS_Sales__c>(); 
    /******Added the year label for data fix*********/
    string Years = system.label.Year_for_ABCS_Sales;
    Integer yr = integer.ValueOf(Years);
    
    if(trigger.IsAfter && (!trigger.IsDelete)){
        Records = trigger.new;  
        for(ABCS_Sales__c ABCSSale: Records){
            if(ABCSSale.Platform_Product__c=='MWP'&& ( ABCSSale.Sales_Date__c.year()==System.Today().year()|| (ABCSSale.Sales_Date__c.year()==System.Today().year()-1 && ABCSSale.Sales_Month__c=='Dec')))
                MWPabcsSalesData.put(ABCSSale.Advisor_Name__c,ABCSSale);
            if(ABCSSale.Platform_Product__c=='OMP'&& (ABCSSale.Sales_Date__c.year()==System.Today().year() || (ABCSSale.Sales_Date__c.year()==System.Today().year()-1 && ABCSSale.Sales_Month__c=='Dec')))
                OMPabcsSalesData.put(ABCSSale.Advisor_Name__c,ABCSSale);
            if(ABCSSale.Platform_Product__c=='PWP' && (ABCSSale.Sales_Date__c.year()==System.Today().year()|| (ABCSSale.Sales_Date__c.year()==System.Today().year()-1 && ABCSSale.Sales_Month__c=='Dec')))
                PWPabcsSalesData.put(ABCSSale.Advisor_Name__c,ABCSSale);
            if(ABCSSale.Platform_Product__c=='SAM' && (ABCSSale.Sales_Date__c.year()==System.Today().year()|| (ABCSSale.Sales_Date__c.year()==System.Today().year()-1 && ABCSSale.Sales_Month__c=='Dec')))
                SAMabcsSalesData.put(ABCSSale.Advisor_Name__c,ABCSSale);
            if(ABCSSale.Platform_Product__c=='SWM' && (ABCSSale.Sales_Date__c.year()==System.Today().year()|| (ABCSSale.Sales_Date__c.year()==System.Today().year()-1 && ABCSSale.Sales_Month__c=='Dec')))
                SWMabcsSalesData.put(ABCSSale.Advisor_Name__c,ABCSSale);
            if(ABCSSale.Platform_Product__c=='MS' && (ABCSSale.Sales_Date__c.year()==System.Today().year()|| (ABCSSale.Sales_Date__c.year()==System.Today().year()-1 && ABCSSale.Sales_Month__c=='Dec')))
                MSabcsSalesData.put(ABCSSale.Advisor_Name__c,ABCSSale); 
            if(ABCSSale.Platform_Product__c=='GWP' && (ABCSSale.Sales_Date__c.year()==System.Today().year() || (ABCSSale.Sales_Date__c.year()==System.Today().year()-1 && ABCSSale.Sales_Month__c=='Dec')))
                GWPabcsSalesData.put(ABCSSale.Advisor_Name__c,ABCSSale);
            abcsSales.add(ABCSSale.Advisor_Name__c);
        }
        lstFinancialsrecords =[SELECT Id,Advisor__c , Manager_Select_Gross__c,Manager_Select_Net__c,Manager_Select_Redemptions__c,MWP_Gross__c, 
                               MWP_Net__c, MWP_Redemptions__c, OMP_Gross__c, OMP_Net__c, OMP_Redemptions__c, 
                               PWP_Gross__c, PWP_Net__c, PWP_Redemptions__c, SAM_Gross__c,YTD_GWP_Gross__c,YTD_GWP_Net__c,YTD_GWP_Redemptions__c,
                               SAM_Net__c, SAM_Redemptions__c, SWM_Gross__c, SWM_Net__c,SWM_Redemptions__c,lastmodifieddate
                               FROM Financials__c  WHERE Advisor__c IN : abcsSales]; 
    }
    else if(trigger.IsAfter && trigger.isDelete){  
        Records = trigger.old;
        for(ABCS_Sales__c ABCSSale:Records){
            abcsSales.add(ABCSSale.Advisor_Name__c);
        }
        lstFinancialsrecords =[SELECT Id,Advisor__c , Manager_Select_Gross__c,Manager_Select_Net__c,Manager_Select_Redemptions__c,MWP_Gross__c, 
                               MWP_Net__c, MWP_Redemptions__c, OMP_Gross__c, OMP_Net__c, OMP_Redemptions__c, 
                               PWP_Gross__c, PWP_Net__c, PWP_Redemptions__c, SAM_Gross__c,YTD_GWP_Gross__c,YTD_GWP_Net__c,YTD_GWP_Redemptions__c,
                               SAM_Net__c, SAM_Redemptions__c, SWM_Gross__c, SWM_Net__c,SWM_Redemptions__c,lastmodifieddate
                               FROM Financials__c  WHERE Advisor__c IN : abcsSales]; 
        
        
    }
    if(trigger.IsAfter && (trigger.IsInsert)){
        If(abcsSales.size()>0) { 
            for(Financials__c f : [SELECT Id,Advisor__c , Manager_Select_Gross__c,Manager_Select_Net__c,Manager_Select_Redemptions__c,MWP_Gross__c, 
                                   MWP_Net__c, MWP_Redemptions__c, OMP_Gross__c, OMP_Net__c, OMP_Redemptions__c, 
                                   PWP_Gross__c, PWP_Net__c, PWP_Redemptions__c, SAM_Gross__c,YTD_GWP_Gross__c,YTD_GWP_Net__c,YTD_GWP_Redemptions__c,
                                   SAM_Net__c, SAM_Redemptions__c, SWM_Gross__c, SWM_Net__c,SWM_Redemptions__c,lastmodifieddate
                                   FROM Financials__c  WHERE Advisor__c = : abcsSales]){ 
             If(f.Advisor__c != null) {           
                 if(System.Today().month()==2 && f.lastmodifieddate < System.Today()){
                     
                     f.MWP_Gross__c= 0;
                     f.MWP_Net__c= 0;
                     f.MWP_Redemptions__c= 0;
                     
                     f.Manager_Select_Gross__c= 0;
                     f.Manager_Select_Net__c= 0;
                     f.Manager_Select_Redemptions__c= 0;
                     
                     f.OMP_Gross__c= 0;
                     f.OMP_Net__c= 0;
                     f.OMP_Redemptions__c= 0;
                     
                     f.PWP_Gross__c= 0;
                     f.PWP_Net__c= 0;
                     f.PWP_Redemptions__c= 0;
                     
                     f.SAM_Gross__c= 0;
                     f.SAM_Net__c= 0;
                     f.SAM_Redemptions__c= 0;
                     
                     f.SWM_Gross__c= 0;
                     f.SWM_Net__c=0;
                     f.SWM_Redemptions__c= 0;         
                 }  
                 
                 if(MWPabcsSalesData.size()>0 && MWPabcsSalesData.get(f.Advisor__c) != null ){    
                     if(f.MWP_Gross__c== Null)
                         f.MWP_Gross__c=0;
                     f.MWP_Gross__c= f.MWP_Gross__c+ (MWPabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                     
                     if(f.MWP_Net__c== Null)
                         f.MWP_Net__c=0;
                     f.MWP_Net__c= f.MWP_Net__c+ MWPabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                     
                     if(f.MWP_Redemptions__c== Null)
                         f.MWP_Redemptions__c=0;
                     f.MWP_Redemptions__c= f.MWP_Redemptions__c+ MWPabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                 }
                 
                 if(MSabcsSalesData.size()>0 && MSabcsSalesData.get(f.Advisor__c) != null){          
                     if(f.Manager_Select_Gross__c== Null)
                         f.Manager_Select_Gross__c=0;
                     f.Manager_Select_Gross__c= f.Manager_Select_Gross__c + (MSabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                     
                     if(f.Manager_Select_Net__c== Null)
                         f.Manager_Select_Net__c=0;
                     f.Manager_Select_Net__c= f.Manager_Select_Net__c + MSabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                     
                     if(f.Manager_Select_Redemptions__c== Null)
                         f.Manager_Select_Redemptions__c=0;
                     f.Manager_Select_Redemptions__c= f.Manager_Select_Redemptions__c + MSabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                 }
                 
                 if(OMPabcsSalesData.size()>0 && OMPabcsSalesData.get(f.Advisor__c) != null){
                     if(f.OMP_Gross__c== Null)
                         f.OMP_Gross__c=0;
                     f.OMP_Gross__c= f.OMP_Gross__c + (OMPabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                     
                     if(f.OMP_Net__c== Null)
                         f.OMP_Net__c=0;
                     f.OMP_Net__c= f.OMP_Net__c + OMPabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                     
                     if(f.OMP_Redemptions__c== Null)
                         f.OMP_Redemptions__c=0;
                     f.OMP_Redemptions__c= f.OMP_Redemptions__c + OMPabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                 }
                 
                 if(PWPabcsSalesData.size()>0 && PWPabcsSalesData.get(f.Advisor__c) != null){
                     if(f.PWP_Gross__c== Null)
                         f.PWP_Gross__c=0;
                     f.PWP_Gross__c= f.PWP_Gross__c + (PWPabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                     
                     if(f.PWP_Net__c== Null)
                         f.PWP_Net__c=0;
                     f.PWP_Net__c= f.PWP_Net__c + PWPabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                     
                     if(f.PWP_Redemptions__c== Null)
                         f.PWP_Redemptions__c=0;
                     f.PWP_Redemptions__c= f.PWP_Redemptions__c + PWPabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                 }
                 
                 if(SAMabcsSalesData.size()>0 && SAMabcsSalesData.get(f.Advisor__c) != null){
                     if(f.SAM_Gross__c== Null)
                         f.SAM_Gross__c=0;
                     f.SAM_Gross__c= f.SAM_Gross__c + (SAMabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                     
                     if(f.SAM_Net__c== Null)
                         f.SAM_Net__c=0;
                     f.SAM_Net__c= f.SAM_Net__c + SAMabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                     
                     if(f.SAM_Redemptions__c== Null)
                         f.SAM_Redemptions__c=0;
                     f.SAM_Redemptions__c= f.SAM_Redemptions__c + SAMabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                 }
                 
                 if(SWMabcsSalesData.size()>0 && SWMabcsSalesData.get(f.Advisor__c) != null){ 
                     if(f.SWM_Gross__c== Null)
                         f.SWM_Gross__c=0;
                     f.SWM_Gross__c= f.SWM_Gross__c + (SWMabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                     
                     if(f.SWM_Net__c== Null)
                         f.SWM_Net__c=0;
                     f.SWM_Net__c= f.SWM_Net__c + SWMabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                     
                     if(f.SWM_Redemptions__c== Null)
                         f.SWM_Redemptions__c=0;
                     f.SWM_Redemptions__c= f.SWM_Redemptions__c + SWMabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                 }
                 
                 if(GWPabcsSalesData.size()>0 && GWPabcsSalesData.get(f.Advisor__c) !=null ){
                     if(f.YTD_GWP_Gross__c ==null)
                         f.YTD_GWP_Gross__c =0;
                     f.YTD_GWP_Gross__c= f.YTD_GWP_Gross__c +(GWPabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                     
                     if(f.YTD_GWP_Net__c == null)
                         f.YTD_GWP_Net__c=0;
                     f.YTD_GWP_Net__c=f.YTD_GWP_Net__c+ (GWPabcsSalesData.get(f.Advisor__c)).Sales_Net_Amount__c;
                     
                     if(f.YTD_GWP_Redemptions__c == null)
                         f.YTD_GWP_Redemptions__c=0;
                     f.YTD_GWP_Redemptions__c =f.YTD_GWP_Redemptions__c + (GWPabcsSalesData.get(f.Advisor__c)).Redemptions_Amount__c;
                 }            
                 
                 if(!lstFinancials.contains(f))
                     lstFinancials.add(f);
             }
            }          
        } 
        
        If(lstFinancials.size() > 0 ){
            update lstFinancials;
        }   
    } 
    
    if(trigger.IsAfter && ((trigger.IsUpdate) || (trigger.isdelete))){ 
        for(Financials__c f2 : lstFinancialsrecords){
            If(f2.Advisor__c != null){ 
                if(f2.YTD_GWP_Gross__c !=null && f2.YTD_GWP_Net__c !=null &&  f2.YTD_GWP_Redemptions__c!=null){
                    f2.YTD_GWP_Gross__c=0;
                    f2.YTD_GWP_Net__c=0;
                    f2.YTD_GWP_Redemptions__c=0;
                    for(ABCS_Sales__c a : [Select id,Platform_Product__c,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where CALENDAR_YEAR(Sales_Date__c)=: yr AND Advisor_Name__c=: f2.Advisor__c]){
                        if(a.Platform_Product__c=='GWP') {
                            f2.YTD_GWP_Gross__c = f2.YTD_GWP_Gross__c + a.Sales_Amount__c;
                            f2.YTD_GWP_Net__c=f2.YTD_GWP_Net__c+ a.Sales_Net_Amount__c;
                            f2.YTD_GWP_Redemptions__c = f2.YTD_GWP_Redemptions__c + a.Redemptions_Amount__c;
                        }
                    }
                }
                //Sam
                if(f2.SAM_Gross__c !=null && f2.SAM_Net__c !=null &&  f2.SAM_Redemptions__c!=null){
                    f2.SAM_Gross__c=0;
                    f2.SAM_Net__c=0;
                    f2.SAM_Redemptions__c=0;
                    for(ABCS_Sales__c a : [Select id,Platform_Product__c,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where CALENDAR_YEAR(Sales_Date__c)=: yr AND Advisor_Name__c=: f2.Advisor__c]){
                        if(a.Platform_Product__c=='SAM') {
                            f2.SAM_Gross__c = f2.SAM_Gross__c + a.Sales_Amount__c;
                            f2.SAM_Net__c=f2.SAM_Net__c+ a.Sales_Net_Amount__c;
                            f2.SAM_Redemptions__c = f2.SAM_Redemptions__c + a.Redemptions_Amount__c;
                        }
                    }
                }
                
                //SWM
                if(f2.SWM_Gross__c !=null && f2.SWM_Net__c !=null &&  f2.SWM_Redemptions__c!=null){
                    f2.SWM_Gross__c=0;
                    f2.SWM_Net__c=0;
                    f2.SWM_Redemptions__c=0;
                    for(ABCS_Sales__c a : [Select id,Platform_Product__c,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where CALENDAR_YEAR(Sales_Date__c)=: yr AND Advisor_Name__c=: f2.Advisor__c]){
                        if(a.Platform_Product__c=='SWM') {
                            f2.SWM_Gross__c = f2.SWM_Gross__c + a.Sales_Amount__c;
                            f2.SWM_Net__c=f2.SWM_Net__c+ a.Sales_Net_Amount__c;
                            f2.SWM_Redemptions__c = f2.SWM_Redemptions__c + a.Redemptions_Amount__c;
                        }
                    }
                }
                
                //PWD
                if(f2.PWP_Gross__c !=null && f2.PWP_Net__c !=null &&  f2.PWP_Redemptions__c!=null){
                    f2.PWP_Gross__c=0;
                    f2.PWP_Net__c=0;
                    f2.PWP_Redemptions__c=0;
                    for(ABCS_Sales__c a : [Select id,Platform_Product__c,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where CALENDAR_YEAR(Sales_Date__c)=: yr AND Advisor_Name__c=: f2.Advisor__c]){
                        if(a.Platform_Product__c=='PWP') {
                            f2.PWP_Gross__c = f2.PWP_Gross__c + a.Sales_Amount__c;
                            f2.PWP_Net__c=f2.PWP_Net__c+ a.Sales_Net_Amount__c;
                            f2.PWP_Redemptions__c = f2.PWP_Redemptions__c + a.Redemptions_Amount__c;
                        }
                    }
                }
                
                //OMP
                if(f2.OMP_Gross__c !=null && f2.OMP_Net__c !=null &&  f2.OMP_Redemptions__c!=null){
                    f2.OMP_Gross__c=0;
                    f2.OMP_Net__c=0;
                    f2.OMP_Redemptions__c=0;
                    for(ABCS_Sales__c a : [Select id,Platform_Product__c,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where CALENDAR_YEAR(Sales_Date__c)=: yr AND Advisor_Name__c=: f2.Advisor__c]){
                        if(a.Platform_Product__c=='OMP') {
                            f2.OMP_Gross__c = f2.OMP_Gross__c + a.Sales_Amount__c;
                            f2.OMP_Net__c=f2.OMP_Net__c+ a.Sales_Net_Amount__c;
                            f2.OMP_Redemptions__c = f2.OMP_Redemptions__c + a.Redemptions_Amount__c;
                        }
                    }
                }
                
                //MS
                
                if(f2.Manager_Select_Gross__c !=null && f2.Manager_Select_Net__c !=null &&  f2.Manager_Select_Redemptions__c!=null){
                    f2.Manager_Select_Gross__c=0;
                    f2.Manager_Select_Net__c=0;
                    f2.Manager_Select_Redemptions__c=0;
                    for(ABCS_Sales__c a : [Select id,Platform_Product__c,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where CALENDAR_YEAR(Sales_Date__c)=: yr AND Advisor_Name__c=: f2.Advisor__c]){
                        if(a.Platform_Product__c=='MS') {
                            f2.Manager_Select_Gross__c = f2.Manager_Select_Gross__c + a.Sales_Amount__c;
                            f2.Manager_Select_Net__c=f2.Manager_Select_Net__c+ a.Sales_Net_Amount__c;
                            f2.Manager_Select_Redemptions__c = f2.Manager_Select_Redemptions__c + a.Redemptions_Amount__c;
                        }
                    }
                }
                // MWP
                
                if(f2.MWP_Gross__c !=null && f2.MWP_Net__c !=null &&  f2.MWP_Redemptions__c!=null) {
                    f2.MWP_Gross__c=0;
                    f2.MWP_Net__c=0;
                    f2.MWP_Redemptions__c=0;
                    for(ABCS_Sales__c a : [Select id,Platform_Product__c,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where CALENDAR_YEAR(Sales_Date__c)=: yr AND Advisor_Name__c=: f2.Advisor__c]){
                        if(a.Platform_Product__c=='MWP') {
                            f2.MWP_Gross__c = f2.MWP_Gross__c + a.Sales_Amount__c;
                            f2.MWP_Net__c=f2.MWP_Net__c+ a.Sales_Net_Amount__c;
                            f2.MWP_Redemptions__c = f2.MWP_Redemptions__c + a.Redemptions_Amount__c;
                        }
                    }
                }                              
            }
            if(!lstFinancials1.contains(f2))
                lstFinancials1.add(f2);
        }
        If(lstFinancials1.size() > 0 ){
            update lstFinancials1;
        }   
    }
}