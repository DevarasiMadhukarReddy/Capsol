public class TestHelperCL {

    public static Account createAccount(){
        Account a;
        try {
            a = [SELECT Id, Name FROM Account WHERE Name = 'LPL Enterprise'];
        } catch(Exception ex) {
            a = new Account(name = 'LPL Enterprise');
            INSERT a;
        }
        return a;
    }
    
    public static Contact createContact() {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name = 'Contact';
        tbp.IsOff__c = False;
        insert tbp;
        Contact c;
        
        try {
            c = [SELECT Id, name, FirstName, LastName, ints__Social_Security_Number__c,
                 MailingStreet, MailingCity, MailingState, MailingPostalCode, BirthDate, Master_Rep_ID__c
                    FROM Contact
                    WHERE FirstName = 'KANEKAL' AND LastName ='TESTCASE' limit 1];
        } catch(Exception ex){
            
            c = new Contact();
            c.FirstName = 'KANEKAL';
            c.LastName ='TESTCASE' ;     
            c.ints__Social_Security_Number__c='000-00-0006';
            c.MailingStreet='19 FOREST DR';
            c.MailingCity='ANTHILL';
            c.MailingState='MO';
            c.MailingPostalCode='65488';
            c.BirthDate=Date.today().addYears(-30);
            c.Master_Rep_ID__c = '005H';
            
            INSERT c;
        }
        return c;
    }
    
    public static Opportunity createOpportunity() {
        List<RecordType> rType = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = 'IAS Business Development' AND isActive=true];
        Opportunity opp = new Opportunity();
        
        if(rtype != null) {
            opp.RecordTypeId = rType.get(0).Id;
        }
        
        opp.AccountId = createAccount().Id;
        opp.Name = 'Test Opportunity';
        opp.StageName = '1 - Engaged';
        opp.Probability = 90;
        opp.CloseDate = Date.today();
        opp.Contact__c = createContact().Id;
        
        INSERT opp;
        return opp;
    }
    
    public static BAQ__c createBAQ(Contact c, Opportunity opp) {
        BAQ__c baq = new BAQ__c();
        baq.Name = 'Test BAQ';
        baq.Contact__c = c.Id;
        baq.Opportunity__c = opp.Id;
        baq.Current_Custodian__c = 'Test Custodian';
        baq.Joining_RIA_or_Corporate__c = 'Corporate';
        baq.Number_of_Advisors__c = 5;
        baq.AUM_SAM_SWM__c = 1000;
        baq.AUM_Mutual_Funds__c = 1000;
        baq.GDC_Mutual_Funds__c = 1000;
        
        baq.Affiliation_1__c = 'Corp';
        baq.Branch_1__c = 'HOS';
        baq.OSJ_LE_1__c = 'Test OSJ1';
        
        baq.Affiliation_2__c = 'Hybrid';
        baq.Branch_2__c = 'In Branch';
        baq.OSJ_LE_2__c = 'Test OSJ2';
        
        baq.Affiliation_3__c = 'Corp';
        baq.Branch_3__c = 'HOS';
        baq.OSJ_LE_3__c = 'Test OSJ1';
        
        baq.Affiliation_3__c = 'Corp';
        baq.Branch_3__c = 'HOS';
        baq.OSJ_LE_3__c = 'Test OSJ1';
        
        baq.Affiliation_4__c = 'Corp';
        baq.Branch_4__c = 'HOS';
        baq.OSJ_LE_4__c = 'Test OSJ1';
        
        baq.Affiliation_5__c = 'Corp';
        baq.Branch_5__c = 'HOS';
        baq.OSJ_LE_5__c = 'Test OSJ1';
        
        baq.Affiliation_6__c = 'Corp';
        baq.Branch_6__c = 'HOS';
        baq.OSJ_LE_6__c = 'Test OSJ1';
        baq.Status__c = 'In Progress';
        
        INSERT baq;
        return baq;
    }
    
    public static cls_gl_string__c createGLcustomSetting() {
        cls_gl_string__c gl = new cls_gl_string__c();
        gl.Forgivable__c = '1000';
        gl.Repayable__c = '2000';
        gl.Acquisition_Loan__c = '3000';
        gl.Growth_Loan__c = '4000';
        gl.Retention_Loan__c = '5000';
        gl.Other_Loans__c = '6000';
        INSERT gl;
        
        return gl;
    }
}