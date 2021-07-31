global class Batcher_Branch_Financial_Yearly implements Database.Batchable<SObject>, Database.AllowsCallouts {

global List<SObject> gllstScopeRecords;

// "Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {

return Database.getQueryLocator([select id,name,Account__c,Current_totalx_of_accounts__c,AUM_Total_Current_Year__c,Fortigent_Growth_Rate_Accts_Current__c,
                                        AUM_Total_Prior_Year__c,Fortigent_Growth_Rate_AUM_YTD__c,Electronic__c,Manual__c,Illiquid__c,Prior_Year_Total_Revenue__c,
                                        BAA__c,Total_Revenue__c,Account_Charge__c,Fixed_Fee__c,UMA__c,AO_I__c,AO_II__c,AUM_Advisory_Other__c,
                                        Prior_Year_Total_of_Accounts__c from Branch_Inst_Financial__c where Recordtype.name =:'Fortigent Financials' ]);
}



   
    public static void BranchFinancial(list<Branch_Inst_Financial__c> Lstsch) {
    
    List<Branch_Inst_Financial__c> Lsbi = new List<Branch_Inst_Financial__c>();
    List<Branch_Inst_Financial_History__c> LsbiH = new List<Branch_Inst_Financial_History__c>();
    
    if(!Lstsch.IsEmpty()){
    set<Id> BIds = new set<Id>();
    for(Branch_Inst_Financial__c b:Lstsch){
    BIds.add(b.Id);
    }
    
    if(!BIds.IsEmpty()){
    
    id a =Schema.SObjectType.Branch_Inst_Financial_History__c.getRecordTypeInfosByName().get('Fortigent AUM and ACC History').getRecordTypeId();
    system.debug('a==='+a);

    List<Branch_Inst_Financial_History__c> lstbh =[select id,name,Total_Revenue__c,Fortigent_Year__c,
                                                            AUM_YTD__c,Total_of_Accounts__c,Growth_rate_Accts_Prior_Yr__c,
                                                            Growth_rate_AUM_Prior_Yr__c,Branch_Inst_Financial__c,
                                                            Account_Charge__c,Fixed_Fee__c,UMA__c,AO_I__c,AO_II__c,AUM_Advisory_Other__c from
                                                            Branch_Inst_Financial_History__c where 
                                                            Branch_Inst_Financial__c In:BIds and RecordtypeId =:a];
        set<Id> ExistingIds = new set<Id>(); 
        set<Id> FinanceExistingIds = new set<Id>();                                                    
        if(!lstbh.IsEmpty()){
        
        for(Branch_Inst_Financial__c b:Lstsch){
        for(Branch_Inst_Financial_History__c bhh :Lstbh){
        
        
        
        if(!FinanceExistingIds.contains(b.Id)){
        Branch_Inst_Financial__c bu = new Branch_Inst_Financial__c();
        bu.Id = b.id;
        bu.AUM_Total_Prior_Year__c = b.AUM_Total_Current_Year__c;
        bu.AUM_Total_Current_Year__c = 0;
        bu.Prior_Year_Total_of_Accounts__c = b.Current_totalx_of_accounts__c;
        bu.Electronic__c =0;
        bu.Manual__c =0;
        bu.Illiquid__c=0;
        bu.Prior_Year_Total_Revenue__c  = b.Total_Revenue__c;
        bu.BAA__c =0;
        bu.Account_Charge__c=0;
        bu.Fixed_Fee__c=0;
        bu.UMA__c =0;
        bu.AO_I__c =0;
        bu.AO_II__c =0;
        bu.AUM_Advisory_Other__c =0; 
        Lsbi.add(bu);
        FinanceExistingIds.add(bu.Id);
        }
    
        if(bhh.Fortigent_Year__c == String.valueof(system.today().year())){
        if(bhh.Branch_Inst_Financial__c == b.Id){
        ExistingIds.add(b.Id);
        Branch_Inst_Financial_History__c bh = new Branch_Inst_Financial_History__c();
        bh.AUM_YTD__c =  b.AUM_Total_Current_Year__c;
        bh.Total_of_Accounts__c = b.Current_totalx_of_accounts__c;
        bh.Fortigent_Year__c = String.valueof(system.today().year()-1);
        bh.Growth_rate_Accts_Prior_Yr__c = b.Fortigent_Growth_Rate_Accts_Current__c;
        bh.Growth_rate_AUM_Prior_Yr__c = b.Fortigent_Growth_Rate_AUM_YTD__c;
        bh.Branch_Inst_Financial__c  = b.Id;
        bh.Account_Charge__c = b.Account_Charge__c;
        bh.Fixed_Fee__c=b.Fixed_Fee__c;
        bh.UMA__c =b.UMA__c;
        bh.Total_Revenue__c =b.Total_Revenue__c;
         bh.AO_I__c = b.AO_I__c;
         bh.AO_II__c = b.AO_II__c;
        bh.AUM_Advisory_Other__c= b.AUM_Advisory_Other__c;
        bh.Id = bhh.Id;
        LsbiH.add(bh);
    
        }
        }
        }
        }
        }
        
        system.debug('ExistingIds=='+ExistingIds);
        system.debug('BIds=='+BIds);
        if(!ExistingIds.IsEmpty()){
        BIds.removeall(ExistingIds);
         system.debug('BIds=='+BIds);
        if(!BIds.IsEmpty()){
        List<Branch_Inst_Financial__c> LstNew = [select id,name,Account__c,Current_totalx_of_accounts__c,AUM_Total_Current_Year__c,Fortigent_Growth_Rate_Accts_Current__c,
                                        AUM_Total_Prior_Year__c,Fortigent_Growth_Rate_AUM_YTD__c,Electronic__c,Manual__c,Illiquid__c,Prior_Year_Total_Revenue__c,
                                        BAA__c,Total_Revenue__c,Account_Charge__c,Fixed_Fee__c,UMA__c,AO_I__c,AO_II__c,AUM_Advisory_Other__c,
                                        Prior_Year_Total_of_Accounts__c from Branch_Inst_Financial__c where Id In:BIds and Recordtype.name =:'Fortigent Financials' ];
            
                    if(!LstNew.IsEmpty()){
                    
                    List<Branch_Inst_Financial_History__c> LsbiHInsert = new List<Branch_Inst_Financial_History__c>();
                    for(Branch_Inst_Financial__c b:LstNew){     
                    Branch_Inst_Financial_History__c bh = new Branch_Inst_Financial_History__c();
                    bh.AUM_YTD__c =  b.AUM_Total_Current_Year__c;
                    bh.Total_of_Accounts__c = b.Current_totalx_of_accounts__c;
                    bh.Fortigent_Year__c = String.valueof(system.today().year()-1);
                    bh.Growth_rate_Accts_Prior_Yr__c = b.Fortigent_Growth_Rate_Accts_Current__c;
                    bh.Growth_rate_AUM_Prior_Yr__c = b.Fortigent_Growth_Rate_AUM_YTD__c;
                    bh.Branch_Inst_Financial__c  = b.Id;
                    bh.Account_Charge__c = b.Account_Charge__c;
                    bh.Fixed_Fee__c=b.Fixed_Fee__c;
                    bh.UMA__c =b.UMA__c;
                    bh.Total_Revenue__c =b.Total_Revenue__c;
                    bh.AO_I__c = b.AO_I__c;
                    bh.AO_II__c = b.AO_II__c;
                    bh.AUM_Advisory_Other__c= b.AUM_Advisory_Other__c;
                    bh.RecordtypeId = a;
                    LsbiHInsert.add(bh);    
                    
                    }
                    
                    if(!LsbiHInsert.IsEmpty()){
                    Insert LsbiHInsert;
                    }
        
                    }
        }
        }else{
        List<Branch_Inst_Financial_History__c> LsbiHInsert = new List<Branch_Inst_Financial_History__c>();
        for(Branch_Inst_Financial__c b:Lstsch){     
        Branch_Inst_Financial_History__c bh = new Branch_Inst_Financial_History__c();
        bh.AUM_YTD__c =  b.AUM_Total_Current_Year__c;
        bh.Total_of_Accounts__c = b.Current_totalx_of_accounts__c;
        bh.Fortigent_Year__c = String.valueof(system.today().year()-1);
        bh.Growth_rate_Accts_Prior_Yr__c = b.Fortigent_Growth_Rate_Accts_Current__c;
        bh.Growth_rate_AUM_Prior_Yr__c = b.Fortigent_Growth_Rate_AUM_YTD__c;
        bh.Branch_Inst_Financial__c  = b.Id;
        bh.Account_Charge__c = b.Account_Charge__c;
        bh.Fixed_Fee__c=b.Fixed_Fee__c;
        bh.UMA__c =b.UMA__c;
        bh.Total_Revenue__c =b.Total_Revenue__c;
        bh.RecordtypeId = a;
         bh.AO_I__c = b.AO_I__c;
         bh.AO_II__c = b.AO_II__c;
         bh.AUM_Advisory_Other__c= b.AUM_Advisory_Other__c;
        LsbiHInsert.add(bh);    
        
        }
        
        if(!LsbiHInsert.IsEmpty()){
        Insert LsbiHInsert;
        }
        
        }
        
        
        
        
    }
    

    
    if(!LsbiH.IsEmpty()){
    update LsbiH;
    }
    
    if(!Lsbi.IsEmpty()){
    update Lsbi;
    }
    
    }
    
    }


       
    
    

     
    
    
global void execute(Database.BatchableContext bcMain, List<SObject> lstBatchRecords) 
{
   BranchFinancial(lstBatchRecords);
}


// Finish the Batch Job
    global void finish(Database.BatchableContext BC) {
    
  
    }
}