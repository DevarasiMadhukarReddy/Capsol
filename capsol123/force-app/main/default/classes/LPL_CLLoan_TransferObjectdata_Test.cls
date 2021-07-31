@isTest(seeAllData=True)
public class LPL_CLLoan_TransferObjectdata_Test {
          
     static testMethod void validateMethod() 
     {  
         Test.startTest();
         
         List<loan__Loan_Account__c> loanAccList= new List<loan__Loan_Account__c>();       
         List<Contact> contactList= new List<Contact>();
         
         for(Integer i=0 ;i <1;i++)
         {
            Contact contactObj = new Contact();
            contactObj.LastName ='Name'+i;
            contactList.add(contactObj);
         }
         insert contactList;
         
         //Custom setting added by vaibhav         
         
         List<LPL_Batch_CLLoan_TransferObjBatch_Bypass__c> tbp = LPL_Batch_CLLoan_TransferObjBatch_Bypass__c.getAll().values();
          
         if(tbp[0].batch_IsOff__c==false) {
             
           tbp[0].batch_IsOff__c=true;
             update tbp;
         }         
                              
    for(Integer j=0; j<1; j++)
        {
            loan__Loan_Account__c loanAcc = new loan__Loan_Account__c();
            //loanAcc.Name='Test';
            loanAcc.loan__ACH_Bank_Name__c='Test Bank';
            loanAcc.loan__Contact__c=contactList[j].id;           
            // loanAcc.loan__Accrual_Start_Date__c=System.Date;
            loanAcc.Loan__Additional_Loan_Amount__c=1000;         
            loanAcc.loan__Branch__c= new loan__Office_Name__c(Name = 'Test Company').ID;                
            loanAcc.loan__Due_Day__c=1231;
            loanAcc.loan__Interest_Rate__c=10;
            loanAcc.loan__Loan_Amount__c=100;
            loanAcc.loan__Loan_Product_Name__c=new loan__Loan_Product__c(Name = 'Test Branch').ID;
            loanAcc.loan__Number_of_Installments__c=1000;            
            loanAccList.add(loanAcc);
        }    
           
           //insert loanAccList;
                                 
            LPL_CLLoan_Transferdata_Schedulable batchObj=new LPL_CLLoan_Transferdata_Schedulable();            
            String sch = '0 0 23 * * ?'; 
            system.schedule('TestCheck',sch,batchObj); 
                       
        Test.stopTest();
    }
  
    
}