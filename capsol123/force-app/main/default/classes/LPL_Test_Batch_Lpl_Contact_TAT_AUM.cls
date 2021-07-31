@isTest(seeAllData=false)

public class LPL_Test_Batch_Lpl_Contact_TAT_AUM {
    
    static testMethod void validateMethod(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        List<Account> accountList= new List<Account>();
        List<Opportunity> opportunityList= new List<Opportunity>();
        for(Integer i=0 ;i <11;i++){
            Account acc = new Account();
            acc.Name ='Name'+i;
            
            accountList.add(acc);
        }
        
        insert accountList;
        
        List<Contact> contactList= new List<Contact>();
        for(Integer i=0 ;i <11;i++){
            Contact contactObj = new Contact(LastName ='Name'+i,Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions');
            contactList.add(contactObj);
        }
        insert contactList;
        
        Decimal sumGDC=0.0;
        Decimal unverifiedAUM=0.0;
        for(Integer i=0 ;i <11;i++){
            Opportunity opp = new Opportunity();
            opp.AccountId=accountList[i].Id;
            opp.Contact__c=contactList[i].Id;
            opp.Name='test'+i;
            opp.Expected_AUM__c=10;
            opp.TAT_GDC__c=20;
            opp.Request_Type__c='Direct';
            opp.CloseDate=Date.today();
            opp.StageName='Completed';
            opp.Probability=50;
            unverifiedAUM=opp.Expected_AUM__c+100;
            opp.Expected_AUM__c=unverifiedAUM;
            sumGDC=opp.TAT_GDC__c+10;
            opp.TAT_GDC__c=sumGDC;
            opportunityList.add(opp);
        }
        insert opportunityList;
        
        List<Account>accountNewList=new List<Account>();
        for(Integer i=0 ;i <11;i++){
            Account acc = accountList[i];
            acc.TAT_GDC__c=opportunityList[i].TAT_GDC__c;
            acc.AUM_flat_load__c=opportunityList[i].Expected_AUM__c;
            accountNewList.add(acc);
        }
        update accountNewList;
        
        Test.startTest();
        Lpl_Contact_TAT_AUM_Batch obj = new Lpl_Contact_TAT_AUM_Batch();
        ID batchID = DataBase.executeBatch(obj, 50);
        Test.stopTest();
    }
}