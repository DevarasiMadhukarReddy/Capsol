public class LPL_AbcsTriggerGateway{

    Map<Id,ABCS_Sales__c> MWPabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> OMPabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> PWPabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> SAMabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> SWMabcsSalesData= new Map<Id,ABCS_Sales__c>();
    Map<Id,ABCS_Sales__c> MSabcsSalesData= new Map<Id,ABCS_Sales__c>();
    
    List<Id> abcsSales= new List<Id>();
    List<Financials__c> lstFinancialsRecords= new List<Financials__c>();
    List<Financials__c> lstFinancials= new List<Financials__c>();

    public void collectRecordToProcess(List<ABCS_Sales__c> abcsLst){
        
        for(ABCS_Sales__c ABCSSale: abcsLst){
    
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
        
        abcsSales.add(ABCSSale.Advisor_Name__c);
          
        
                 
        }
        
        lstFinancialsRecords = [SELECT Id,Advisor__c , Manager_Select_Gross__c,Manager_Select_Net__c,Manager_Select_Redemptions__c,MWP_Gross__c, 
        MWP_Net__c, MWP_Redemptions__c, OMP_Gross__c, OMP_Net__c, OMP_Redemptions__c, 
        PWP_Gross__c, PWP_Net__c, PWP_Redemptions__c, SAM_Gross__c,
        SAM_Net__c, SAM_Redemptions__c, SWM_Gross__c, SWM_Net__c,SWM_Redemptions__c,lastmodifieddate
        FROM Financials__c  WHERE Advisor__c = : abcsSales];
    
    }
    
    public List<Financials__c> doInsertOperation(){
    
        for(Financials__c f :lstFinancialsRecords){
            
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
                    f.MWP_Gross__c = 0;
                    f.MWP_Gross__c= f.MWP_Gross__c+ (MWPabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                    
                    if(f.MWP_Net__c== Null)
                    f.MWP_Net__c =0;
                    f.MWP_Net__c= f.MWP_Net__c+ MWPabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                    
                    if(f.MWP_Redemptions__c== Null)
                    f.MWP_Redemptions__c =0;
                    f.MWP_Redemptions__c= f.MWP_Redemptions__c+ MWPabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                
                }
                
                if(MSabcsSalesData.size()>0 && MSabcsSalesData.get(f.Advisor__c) != null){          
                
                    if(f.Manager_Select_Gross__c== Null)
                    f.Manager_Select_Gross__c = 0;
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
                    f.OMP_Gross__c =0;
                    f.OMP_Gross__c= f.OMP_Gross__c + (OMPabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                    
                    if(f.OMP_Net__c== Null)
                    f.OMP_Net__c =0;
                    f.OMP_Net__c= f.OMP_Net__c + OMPabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                    
                    if(f.OMP_Redemptions__c== Null)
                    f.OMP_Redemptions__c =0;
                    f.OMP_Redemptions__c= f.OMP_Redemptions__c + OMPabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                    
                }
                
                if(PWPabcsSalesData.size()>0 && PWPabcsSalesData.get(f.Advisor__c) != null){
                    
                    if(f.PWP_Gross__c == Null)
                    f.PWP_Gross__c = 0;
                    f.PWP_Gross__c= f.PWP_Gross__c + (PWPabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                    
                    if(f.PWP_Net__c== Null)
                    f.PWP_Net__c = 0;
                    f.PWP_Net__c= f.PWP_Net__c + PWPabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                    
                    if(f.PWP_Redemptions__c== Null)
                    f.PWP_Redemptions__c =0;
                    f.PWP_Redemptions__c= f.PWP_Redemptions__c + PWPabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                
                
                }
                
                if(SAMabcsSalesData.size()>0 && SAMabcsSalesData.get(f.Advisor__c) != null){
                
                    if(f.SAM_Gross__c== Null)
                    f.SAM_Gross__c =0;
                    f.SAM_Gross__c= f.SAM_Gross__c + (SAMabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                    
                    if(f.SAM_Net__c== Null)
                    f.SAM_Net__c =0;
                    f.SAM_Net__c= f.SAM_Net__c + SAMabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                    
                    if(f.SAM_Redemptions__c == Null)
                    f.SAM_Redemptions__c = 0;
                    f.SAM_Redemptions__c= f.SAM_Redemptions__c + SAMabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                
                
                }
                
                if(SWMabcsSalesData.size()>0 && SWMabcsSalesData.get(f.Advisor__c) != null){ 
                
                    if(f.SWM_Gross__c== Null)
                    f.SWM_Gross__c = 0;
                    f.SWM_Gross__c= f.SWM_Gross__c + (SWMabcsSalesData.get(f.Advisor__c)).Sales_Amount__c;
                    
                    if(f.SWM_Net__c== Null)
                    f.SWM_Net__c = 0;
                    f.SWM_Net__c= f.SWM_Net__c + SWMabcsSalesData.get(f.Advisor__c).Sales_Net_Amount__c;
                    
                    if(f.SWM_Redemptions__c == Null)
                    f.SWM_Redemptions__c = 0;
                    f.SWM_Redemptions__c= f.SWM_Redemptions__c + SWMabcsSalesData.get(f.Advisor__c).Redemptions_Amount__c;
                
                
                }            
                
                
                
                lstFinancials.add(f);
            
            }
        
        }
        return lstFinancials;
    }
}