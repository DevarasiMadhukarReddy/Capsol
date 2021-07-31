@isTest(seeAllData=false)
public class Test_Relate_AccountContactRelations{
    
    
    private static Account a1;
    private static User u;
    private static Contact ct1;
    private static AccountContactRelation rt1;
    
    static {  
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        u = [SELECT Country FROM User WHERE (Id = :UserInfo.getUserId()) LIMIT 1];
        
        a1 = new Account(Name = 'Test Account');
        insert a1;
               
        ct1= new Contact(AccountId = a1.id, firstname = 'Fisrname', lastname = 'lastname ' ,Insurance_Territory__c = 'Test Territory');
        insert ct1;
        
    }
    
    static testMethod void testTrigger(){
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Account a2 = new Account(Name = 'Test AccountContact Relations');
        insert a2;
        
        rt1 = new AccountContactRelation(AccountID = a2.Id, ContactID = ct1.ID);
        insert rt1;
        
        Contact con = [Select Id, Institutional_Group__c, Is_Institutional_Group_Updated__c from Contact where Id =: ct1.Id];
        
        system.assertEquals(con.Is_Institutional_Group_Updated__c , true);
        system.assertEquals(con.Institutional_Group__c, 'Test AccountContact Relations');
    }
    
    static testMethod void testBulkTrigger(){
        
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        /*
        
        
        List<Account> a2 = new List<Account>();
        for(Integer i=0 ; i<10 ; i++){
            a2.add(new Account(Name = 'Test AccountContact Relations'+ i));
        }
        
        insert a2;
        
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        
        Set<ID> accID = new Set<ID>(); 
        accID.add(a1.Id); 
        
        List<Account> acclist1 = [select id from Account where ID not in :accId  ];
         
        for(Account acc : acclist1 ){
            acrList.add(new AccountContactRelation(AccountID = acc.Id, ContactID = ct1.ID));    
        }
        
        insert acrList;
        
        Contact con = [Select Id, Institutional_Group__c, Is_Institutional_Group_Updated__c from Contact where Id =: ct1.Id];
        
        system.assertEquals(con.Is_Institutional_Group_Updated__c , true);
        system.assertEquals(con.Institutional_Group__c, 'Test AccountContact Relations9');*/
    } 

}