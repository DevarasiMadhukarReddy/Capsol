@isTest(seeAllData = false)
public class LPL_Test_Batch_Opportunity_TAT_GDC_AUM {
    
    static testMethod void validateMethod() 
    {Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        List<Account> accountList= new List<Account>();
        
        List<Opportunity> opportunityList= new List<Opportunity>();
        for(Integer i=0 ;i <11;i++)
        {
            Account acc = new Account();
            acc.Name ='Name'+i;
            
            accountList.add(acc);
        }
        
        insert accountList;
        
        
        
        
               
         List<Contact> contactList= new List<Contact>();
        for(Integer i=0 ;i <11;i++)
        {
            Contact contactObj = new Contact();
            contactObj.LastName ='Name'+i;
            contactObj.Approved_Expected_AUM__c=10;
            contactObj.Approved_TAT_Revenue__c=20;
            if(accountList.size()>0 && accountList!=null ){  
            contactObj.Account=accountList[i];
            }
            contactList.add(contactObj);
        }
        
        insert contactList;
        
     
        
       
        List<Account>accountNewList=new List<Account>();
        for(Integer i=0 ;i <11;i++)
        {
            Account acc = accountList[i];
            acc.TAT_GDC__c=contactList[i].Approved_TAT_Revenue__c;
            acc.AUM_flat_load__c=contactList[i].Approved_Expected_AUM__c;
            accountNewList.add(acc);
        }
        update accountNewList;
        Test.startTest();

            LPL_Opportunity_TAT_GDC_AUM_Batch obj = new LPL_Opportunity_TAT_GDC_AUM_Batch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }

}