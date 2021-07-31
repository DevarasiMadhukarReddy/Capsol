@isTest(seeAllData = false)
public class New_PracticeAcquisitionChecklist_Test {
    
     @isTest
    public static void createtest() {
        Account a1 = new Account(Name = 'Test Account');
        insert a1;
        
        contact con = new contact(LastName='test');
        insert con;
        
        opportunity op = new opportunity(
                                Name='opptest',
                                AccountId=a1.Id,
                                StageName='completed', 
                                CloseDate=system.today());
        insert op;
        
        Opportunitycontactrole oprole1=new Opportunitycontactrole();
        oprole1.OpportunityId=op.id;
        oprole1.ContactId=con.id;
        oprole1.Role='Seller';
        insert oprole1;
        
        Opportunitycontactrole oprole2=new Opportunitycontactrole();
        oprole2.OpportunityId=op.id;
        oprole2.ContactId=con.id;
        oprole2.Role='Buyer';
        insert oprole2;
        
        
        Practice_Acquisition_Checklist__c pracAcq1=new Practice_Acquisition_Checklist__c();
        pracAcq1.Name='test';
        pracAcq1.Associated_Opportunity__c=op.id;
        insert pracAcq1;
    }
}