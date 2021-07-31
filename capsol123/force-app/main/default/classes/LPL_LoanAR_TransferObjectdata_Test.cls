@isTest(seeAllData=False)
public class LPL_LoanAR_TransferObjectdata_Test {
    
    
    
    static testMethod void test1(){  
        Test.startTest();
        
        List<collect__Loan_Account__c> loanAccList= new List<collect__Loan_Account__c>();       
        List<Contact> contactList= new List<Contact>();
        List<Account_Receivable__c> arList= new List<Account_Receivable__c>();
        List<Account_Receivable__c> checkARList = new List<Account_Receivable__c>();
        Set<String> ids=new Set<String>();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        
        
        for(Integer i=0 ;i <2;i++)
        {
            Contact contactObj = new Contact();
            contactObj.LastName ='Name'+i;
            contactList.add(contactObj);
        }
        insert contactList;
        
        
        
        for(Integer j=0; j<2; j++)
        {
            collect__Loan_Account__c loanAcc = new collect__Loan_Account__c();
            loanAcc.Name='Test';
            loanAcc.Less_Than_120_Days__c=50;
            loanAcc.collect__Contact__c=contactList[j].id;           
            loanAcc.Greater_Than_120_Days__c =1000;         
            loanAcc.Total_AR_Balance__c= 50;
            loanAcc.Forgivable_Loan__c = 1231;
            loanAcc.Repayable_Loan__c = 10;
            loanAcc.Non_Loan__c = 100;
            loanAcc.collect__External_ID__c = '081efd1'+ j;
            loanAcc.Master_Rep_Id__c='master';
            loanAccList.add(loanAcc);
        }    
        
        insert loanAccList;
        
        //Id batchJobId = Database.executeBatch(new LPL_Batch_LoanAR_TransferObjectdata(), 200);
        
        LPL_LoanAR_Transferdata_Schedulable batchObj = new LPL_LoanAR_Transferdata_Schedulable();            
        
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('TestCheck',sch,batchObj); 
        
        for(Integer i=0;i< loanAccList.size();i++) {
            
            ids.add(loanAccList[i].Master_Rep_Id__c);
        }
        
        
        
        for(Integer k=0; k<2; k++){
            
            Account_Receivable__c ar = new Account_Receivable__c();
            
            ar.Name= 'Test';
            ar.Balances_Less_than_120_Days__c = 50;
            ar.Balances_Greater_than_120_days__c = 1000;
            ar.Total_Account_Receivables__c = 50;
            ar.Advisor__c = contactList[k].id;
            ar.Forgivable_Loan__c = 1231;
            ar.Repayable_Loan__c = 10;
            ar.Non_Loan__c = 100;
            ar.Master_Rep_ID__c = '081efd1'+ k;
            ar.Original_Rep_ID_c__c='master';
            arList.add(ar);
            
        }         
        insert arList;
        
        
        
        checkARList = [select id, Master_Rep_ID__c,Original_Rep_ID_c__c from Account_Receivable__c where Original_Rep_ID_c__c in : ids];  
        
        If(checkARList.size()==0){
            for(Integer k=0; k<2; k++){
                
                Account_Receivable__c ar = new Account_Receivable__c();
                
                ar.Name= 'Test';
                ar.Balances_Less_than_120_Days__c = 50;
                ar.Balances_Greater_than_120_days__c = 1000;
                ar.Total_Account_Receivables__c = 50;
                ar.Advisor__c = contactList[k].id;
                ar.Forgivable_Loan__c = 1231;
                ar.Repayable_Loan__c = 10;
                ar.Non_Loan__c = 100;
                ar.Master_Rep_ID__c =checkARList[k].Master_Rep_ID__c;
                ar.Original_Rep_ID_c__c=checkARList[k].Original_Rep_ID_c__c;
                arList.add(ar);
                
            }    
            
            upsert arList; 
        }           
        Test.stopTest();
    }
    
    //*****************************************************************************************
    
    static testMethod void test2(){  
        Test.startTest();
        
        List<collect__Loan_Account__c> loanAccList= new List<collect__Loan_Account__c>();       
        List<Contact> contactList= new List<Contact>();
        List<Account_Receivable__c> arList= new List<Account_Receivable__c>();
        List<Account_Receivable__c> checkARList = new List<Account_Receivable__c>();
        Set<String> ids=new Set<String>();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        
        for(Integer i=0 ;i <2;i++)
        {
            Contact contactObj = new Contact();
            contactObj.LastName ='Name'+i;
            contactList.add(contactObj);
        }
        insert contactList;
        
        
        
        for(Integer j=0; j<2; j++)
        {
            collect__Loan_Account__c loanAcc = new collect__Loan_Account__c();
            loanAcc.Name='Test';
            loanAcc.Less_Than_120_Days__c=50;
            loanAcc.collect__Contact__c=contactList[j].id;           
            loanAcc.Greater_Than_120_Days__c =1000;         
            loanAcc.Total_AR_Balance__c= 50;
            loanAcc.Forgivable_Loan__c = 1231;
            loanAcc.Repayable_Loan__c = 10;
            loanAcc.Non_Loan__c = 100;
            loanAcc.collect__External_ID__c = '081efd1'+ j;
            loanAccList.add(loanAcc);
        }    
        
        insert loanAccList;
        
        //Id batchJobId = Database.executeBatch(new LPL_Batch_LoanAR_TransferObjectdata(), 200);
        
        LPL_LoanAR_Transferdata_Schedulable batchObj = new LPL_LoanAR_Transferdata_Schedulable();            
        
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('TestCheck',sch,batchObj); 
        
        
        for(Integer i=0;i< loanAccList.size();i++) {
            
            ids.add(loanAccList[i].collect__External_ID__c);
        }
        
        checkARList = [select id, Master_Rep_ID__c from Account_Receivable__c where Master_Rep_ID__c in : ids];   
        
        If(checkARList.size()> 0 && checkARList.size()!= loanAccList.size()){
            for(Integer k=0; k<2; k++){
                
                Account_Receivable__c ar = new Account_Receivable__c();
                
                ar.Name= 'Test';
                ar.Balances_Less_than_120_Days__c = 50;
                ar.Balances_Greater_than_120_days__c = 1000;
                ar.Total_Account_Receivables__c = 50;
                ar.Advisor__c = contactList[k].id;
                ar.Forgivable_Loan__c = 1231;
                ar.Repayable_Loan__c = 10;
                ar.Non_Loan__c = 100;
                ar.Master_Rep_ID__c = '081efd1'+ k;
                arList.add(ar);
                
            }           
            update arList; 
        } 
        
        Test.stopTest();
    }
    
    //3*****************************************************************************************
    
    static testMethod void test3(){  
        Test.startTest();
        
        
        List<collect__Loan_Account__c> loanAccList= new List<collect__Loan_Account__c>();       
        List<Contact> contactList= new List<Contact>();
        List<Account_Receivable__c> arList= new List<Account_Receivable__c>();
        List<Account_Receivable__c> checkARList = new List<Account_Receivable__c>();
        Set<String> ids=new Set<String>();
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        
      
        
        for(Integer i=0 ;i <2;i++)
        {
            Contact contactObj = new Contact();
            contactObj.LastName ='Name'+i;
            contactList.add(contactObj);
        }
        insert contactList;
        
        
        
        for(Integer j=0; j<2; j++)
        {
            collect__Loan_Account__c loanAcc = new collect__Loan_Account__c();
            loanAcc.Name='Test';
            loanAcc.Less_Than_120_Days__c=50;
            loanAcc.collect__Contact__c=contactList[j].id;           
            loanAcc.Greater_Than_120_Days__c =1000;         
            loanAcc.Total_AR_Balance__c= 50;
            loanAcc.Forgivable_Loan__c = 1231;
            loanAcc.Repayable_Loan__c = 10;
            loanAcc.Non_Loan__c = 100;
            loanAcc.collect__External_ID__c = '081efddsds1'+ j;
            loanAcc.Master_Rep_Id__c='master1';
            loanAccList.add(loanAcc);
        }    
        
        insert loanAccList;
        
        
        for(Integer k=0; k<2; k++){
            
            Account_Receivable__c ar = new Account_Receivable__c();
            
            ar.Name= 'Test';
            ar.Balances_Less_than_120_Days__c = 50;
            ar.Balances_Greater_than_120_days__c = 1000;
            ar.Total_Account_Receivables__c = 50;
            ar.Advisor__c = contactList[k].id;
            ar.Forgivable_Loan__c = 1231;
            ar.Repayable_Loan__c = 10;
            ar.Non_Loan__c = 100;
            ar.Master_Rep_ID__c = '081efd1'+ k;
            ar.Original_Rep_ID_c__c='master'+k;
            arList.add(ar);
            
        }         
        upsert arList;
        
        checkARList = [select id, Master_Rep_ID__c,Original_Rep_ID_c__c from Account_Receivable__c where Original_Rep_ID_c__c in : ids];  
        
        
        for(Integer k=0; k<2; k++){
            
            Account_Receivable__c ar = new Account_Receivable__c();
            
            ar.Name= 'Test';
            ar.Balances_Less_than_120_Days__c = 50;
            ar.Balances_Greater_than_120_days__c = 1000;
            ar.Total_Account_Receivables__c = 50;
            ar.Advisor__c = contactList[k].id;
            ar.Forgivable_Loan__c = 1231;
            ar.Repayable_Loan__c = 10;
            ar.Non_Loan__c = 100;
            ar.Master_Rep_ID__c =loanAccList[k].collect__External_ID__c;
            ar.Original_Rep_ID_c__c='dssdsd';
            arList.add(ar);
            
        }    
        
        upsert arList; 
        
        
        
        //Id batchJobId = Database.executeBatch(new LPL_Batch_LoanAR_TransferObjectdata(), 200);
        /*  
LPL_LoanAR_Transferdata_Schedulable batchObj = new LPL_LoanAR_Transferdata_Schedulable();            


String sch = '0 0 23 * * ?'; 
system.schedule('TestCheck',sch,batchObj); 

for(Integer i=0;i< loanAccList.size();i++) {

ids.add(loanAccList[i].Master_Rep_Id__c);
}







}  */         
        Test.stopTest();
    }
}