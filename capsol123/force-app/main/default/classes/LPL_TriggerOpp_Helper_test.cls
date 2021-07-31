/*
##############Change History#############
CH.No       Description                                              Developer         Date
------------------------------------------------------------------------------------------------
CH-01    User Story LBSFNS-226 Promo Codes on Opportunity           Anil Mannuru      06/23/2021
CH-02    User Story ---------  Opportunity Field updates            Anil Mannuru      06/24/2021        
*/


@isTest
public class LPL_TriggerOpp_Helper_test {
     /*******************CH-01 Start******************************/  
    public static testMethod void addPromoCodeTest(){
        Test.startTest();
        Id rt_MapCon = Schema.SObjectType.contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        //contact 
        Contact cons = new contact();
        cons.lastname ='promotest';
        cons.RecordTypeId = rt_MapCon;
        cons.Admin_Solutions_Active_Date__c = system.today();
        cons.CFO_Solutions_Active_Date__c = system.today();
        cons.Experiment_s_Other_Reason__c = 'Terminated';
        cons.Technology_Solutions_Termination_Date__c = system.today();
        cons.Technology_Solutions_Active_Date__c = system.today();
        cons.Technology_Consultant_Assigned__c='test';
        cons.CFO_Consultant_Assigned__c='test';
        cons.Marketing_Solutions_Active_Date__c=system.today();
        cons.Marketing_Consultant_Assigned__c='test';
        cons.VA_Assigned__c='test';
        cons.Experiment_s__c='Interested lead';
        insert cons; 
        
        Product2 prod = new Product2(Name = 'Promo Code',ProductCode = 'PMCODE', IsActive = true);
        insert prod;
        
        Product2 adminProd = new Product2(Name = 'Admin Solutions',IsActive = true,Product_Type__c = 'Standalone');
        insert adminProd;
        
        Product2 admPrd = [Select Id from Product2 Where Product_Type__c = 'Standalone' limit 1];
        ID standardPBID = Test.getStandardPricebookId();
        PricebookEntry pbook = new PricebookEntry (Product2ID=admPrd.id,Pricebook2ID=standardPBID,UnitPrice=0, isActive=true);
        insert pbook;
        
        Promo_Code__c pc = new Promo_Code__c();
        pc.name ='Promo Code';
        pc.Active__c = true;
        pc.Discount__c = 10;
        pc.Expiration_date__c = system.today()+60;
        insert pc;
        Promo_Code__c pcode = [Select Id from Promo_Code__c limit 1];
        
        String clabel = System.Label.LBS_PROMOCODE_PRODUCT;
        Contact adContact = [Select Id from Contact limit 1];
        
        //Opportunity
        Opportunity  opp = new Opportunity ();
        opp.name='Promo Code test';
        opp.StageName='Engaged Opportunity';
        opp.Type='Finance Solution';
        opp.CloseDate =  system.today()+30;
        opp.RecordTypeId= OppRecordTypeId;
        opp.contact__c=adContact.id;
        opp.ContactId=adContact.id;
        opp.Pricebook2Id = Test.getStandardPricebookId();
        opp.LBS_Promo_Code__c = null;
        insert opp;
        
                
        Opportunity op = [Select Id,LBS_Promo_Code__c,IsClosed from Opportunity limit 1];
        
        System.debug('opportunity***'+op);
        //Opportunity Product
        OpportunityLineItem opProduct = new OpportunityLineItem();
        opProduct.OpportunityId = op.Id; 
        opProduct.Product2Id = admPrd.Id;
        opProduct.Quantity = 1;
        opProduct.UnitPrice = 500;
        insert opProduct;
        
        op.LBS_Promo_Code__c = pcode.id;
        update op;
        
        op.LBS_Promo_Code__c = null;
        update op;
 
        List<OpportunityLineItem> oproduct = [Select Id,Product2.Name from OpportunityLineItem Where OpportunityId = :op.Id];
        System.assert(oproduct != null);
        Test.stopTest();
    }
   
    
    public static testMethod void addPromoCodeExistingTest(){
        Test.startTest();
        Id rt_MapCon = Schema.SObjectType.contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        //contact 
        Contact cons = new contact();
        cons.lastname ='promotest';
        cons.RecordTypeId = rt_MapCon;
        cons.Admin_Solutions_Active_Date__c = system.today();
        cons.CFO_Solutions_Active_Date__c = system.today();
        cons.Experiment_s_Other_Reason__c = 'Terminated';
        cons.Technology_Solutions_Termination_Date__c = system.today();
        cons.Technology_Solutions_Active_Date__c = system.today();
        cons.Technology_Consultant_Assigned__c='test';
        cons.CFO_Consultant_Assigned__c='test';
        cons.Marketing_Solutions_Active_Date__c=system.today();
        cons.Marketing_Consultant_Assigned__c='test';
        cons.VA_Assigned__c='test';
        cons.Experiment_s__c='Interested lead';
        insert cons; 
        
        Product2 prod = new Product2(Name = 'Promo Code',ProductCode = 'PMCODE', IsActive = true);
        insert prod;
        
        Product2 adminProd = new Product2(Name = 'Admin Solutions',IsActive = true,Product_Type__c = 'Standalone');
        insert adminProd;
        
        Product2 admPrd = [Select Id from Product2 Where Product_Type__c = 'Standalone' limit 1];
        ID standardPBID = Test.getStandardPricebookId();
        PricebookEntry pbook = new PricebookEntry (Product2ID=prod.id,Pricebook2ID=standardPBID,UnitPrice=0, isActive=true);
        insert pbook;
        
        
        //Promo Code
        Promo_Code__c pc = new Promo_Code__c();
        pc.name ='Promo Code';
        pc.Active__c = true;
        pc.Discount__c = 10;
        pc.Expiration_date__c = system.today()+60;
        insert pc;
        Promo_Code__c pcode = [Select Id from Promo_Code__c limit 1];
        Contact adContact = [Select Id from Contact limit 1];
        
        //Opportunity
        Opportunity  oppty = new Opportunity ();
        oppty.name='Promo Code test';
        oppty.StageName='Engaged Opportunity';
        oppty.Type='Finance Solution';
        oppty.CloseDate =  system.today()+30;
        oppty.RecordTypeId= OppRecordTypeId;
        oppty.contact__c=adContact.id;
        oppty.ContactId=adContact.id;
        oppty.Pricebook2Id = Test.getStandardPricebookId();
        oppty.LBS_Promo_Code__c = null;
        insert oppty;
        
        Opportunity op = [Select Id,LBS_Promo_Code__c,IsClosed from Opportunity limit 1];
        
        System.debug('opportunity***'+op);
        //Opportunity Product
        OpportunityLineItem opProduct = new OpportunityLineItem();
        opProduct.OpportunityId = op.Id; 
        opProduct.Product2Id = prod.Id;
        opProduct.Quantity = 1;
        opProduct.UnitPrice = 500;
        insert opProduct;
        
        op.LBS_Promo_Code__c = pcode.id;
        update op;
        List<OpportunityLineItem> oproduct = [Select Id,Product2.Name from OpportunityLineItem Where OpportunityId = :op.Id];
        System.assert(oproduct != null);
        Test.stopTest();
    }
    /*******************CH-01 Ends******************************/ 
    
    /*******************CH-02 Start******************************/  
    public static testMethod void createUpdateReverseTest(){
        Test.startTest();
        Id rt_MapCon = Schema.SObjectType.contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        //contact 
        List<Contact> cons = new List<Contact>();
        
        Contact cons1 = new contact();
        cons1.lastname ='test Contact';
        cons1.RecordTypeId = rt_MapCon;
        cons1.Admin_Solutions_Active_Date__c = system.today();
        cons1.CFO_Solutions_Active_Date__c = system.today();
        cons1.Experiment_s_Other_Reason__c = 'Terminated';
        cons1.Technology_Solutions_Termination_Date__c = system.today();
        cons1.Technology_Solutions_Active_Date__c = system.today();
        cons1.Technology_Consultant_Assigned__c='test';
        cons1.CFO_Consultant_Assigned__c='test';
        cons1.Marketing_Solutions_Active_Date__c=system.today();
        cons1.Marketing_Consultant_Assigned__c='test';
        cons1.VA_Assigned__c='test';
        cons1.Experiment_s__c='Interested lead';
        cons.add(cons1);
        
        Contact cons2 = new contact();
        cons2.lastname ='test Contact';
        cons2.RecordTypeId = rt_MapCon;
        cons2.Admin_Solutions_Active_Date__c = system.today();
        cons2.CFO_Solutions_Active_Date__c = system.today();
        cons2.Experiment_s_Other_Reason__c = 'Terminated';
        cons2.Technology_Solutions_Termination_Date__c = system.today();
        cons2.Technology_Solutions_Active_Date__c = system.today();
        cons2.Technology_Consultant_Assigned__c='test';
        cons2.CFO_Consultant_Assigned__c='test';
        cons2.Marketing_Solutions_Active_Date__c=system.today();
        cons2.Marketing_Consultant_Assigned__c='test';
        cons2.VA_Assigned__c='test';
        cons2.Experiment_s__c='Interested lead';
        cons.add(cons2);
        
        Contact cons3 = new contact();
        cons3.lastname ='test Contact';
        cons3.RecordTypeId = rt_MapCon;
        cons3.Admin_Solutions_Active_Date__c = system.today();
        cons3.CFO_Solutions_Active_Date__c = system.today();
        cons3.Experiment_s_Other_Reason__c = 'Terminated';
        cons3.Technology_Solutions_Termination_Date__c = system.today();
        cons3.Technology_Solutions_Active_Date__c = system.today();
        cons3.Technology_Consultant_Assigned__c='test';
        cons3.CFO_Consultant_Assigned__c='test';
        cons3.Marketing_Solutions_Active_Date__c=system.today();
        cons3.Marketing_Consultant_Assigned__c='test';
        cons3.VA_Assigned__c='test';
        cons3.Experiment_s__c='Interested lead';
        cons.add(cons3);
        
        Contact cons4 = new contact();
        cons4.lastname ='test Contact';
        cons4.RecordTypeId = rt_MapCon;
        cons4.Admin_Solutions_Active_Date__c = system.today();
        cons4.CFO_Solutions_Active_Date__c = system.today();
        cons4.Experiment_s_Other_Reason__c = 'Terminated';
        cons4.Technology_Solutions_Termination_Date__c = system.today();
        cons4.Technology_Solutions_Active_Date__c = system.today();
        cons4.Technology_Consultant_Assigned__c='test';
        cons4.CFO_Consultant_Assigned__c='test';
        cons4.Marketing_Solutions_Active_Date__c=system.today();
        cons4.Marketing_Consultant_Assigned__c='test';
        cons4.VA_Assigned__c='test';
        cons4.Experiment_s__c='Interested lead';
        cons.add(cons4);
        
        Contact cons5 = new contact();
        cons5.lastname ='test Contact';
        cons5.RecordTypeId = rt_MapCon;
        cons5.Admin_Solutions_Active_Date__c = system.today();
        cons5.CFO_Solutions_Active_Date__c = system.today();
        cons5.Experiment_s_Other_Reason__c = 'Terminated';
        cons5.Technology_Solutions_Termination_Date__c = system.today();
        cons5.Technology_Solutions_Active_Date__c = system.today();
        cons5.Technology_Consultant_Assigned__c='test';
        cons5.CFO_Consultant_Assigned__c='test';
        cons5.Marketing_Solutions_Active_Date__c=system.today();
        cons5.Marketing_Consultant_Assigned__c='test';
        cons5.VA_Assigned__c='test';
        cons5.Experiment_s__c='Interested lead';
        cons.add(cons5);
        
        Contact cons6 = new contact();
        cons6.lastname ='test Contact';
        cons6.RecordTypeId = rt_MapCon;
        cons6.Admin_Solutions_Active_Date__c = system.today();
        cons6.CFO_Solutions_Active_Date__c = system.today();
        cons6.Experiment_s_Other_Reason__c = 'Terminated';
        cons6.Technology_Solutions_Termination_Date__c = system.today();
        cons6.Technology_Solutions_Active_Date__c = system.today();
        cons6.Technology_Consultant_Assigned__c='test';
        cons6.CFO_Consultant_Assigned__c='test';
        cons6.Marketing_Solutions_Active_Date__c=system.today();
        cons6.Marketing_Consultant_Assigned__c='test';
        cons6.VA_Assigned__c='test';
        cons6.Experiment_s__c='Interested lead';
        cons.add(cons6);
        
        Contact cons7 = new contact();
        cons7.lastname ='test Contact';
        cons7.RecordTypeId = rt_MapCon;
        cons7.Admin_Solutions_Active_Date__c = system.today();
        cons7.CFO_Solutions_Active_Date__c = system.today();
        cons7.Experiment_s_Other_Reason__c = 'Terminated';
        cons7.Technology_Solutions_Termination_Date__c = system.today();
        cons7.Technology_Solutions_Active_Date__c = system.today();
        cons7.Technology_Consultant_Assigned__c='test';
        cons7.CFO_Consultant_Assigned__c='test';
        cons7.Marketing_Solutions_Active_Date__c=system.today();
        cons7.Marketing_Consultant_Assigned__c='test';
        cons7.VA_Assigned__c='test';
        cons7.Experiment_s__c='Interested lead';
        cons.add(cons7);
        
        Contact cons8 = new contact();
        cons8.lastname ='test lastname';
        cons8.RecordTypeId = rt_MapCon;
        cons8.Admin_Solutions_Active_Date__c = system.today();
        cons8.CFO_Solutions_Active_Date__c = system.today();
        cons8.Experiment_s_Other_Reason__c = 'Terminated';
        cons8.Technology_Solutions_Termination_Date__c = system.today();
        cons8.Technology_Solutions_Active_Date__c = system.today();
        cons8.Technology_Consultant_Assigned__c='test';
        cons8.CFO_Consultant_Assigned__c='test';
        cons8.Marketing_Solutions_Active_Date__c=system.today();
        cons8.Marketing_Consultant_Assigned__c='test';
        cons8.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons8.VA_Assigned__c='test';
        cons8.Experiment_s__c='Interested lead';
        cons8.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons8);
        
        Contact cons9 = new contact();
        cons9.lastname ='test lastname';
        cons9.RecordTypeId = rt_MapCon;
        cons9.Admin_Solutions_Active_Date__c = system.today();
        cons9.CFO_Solutions_Active_Date__c = system.today();
        cons9.Experiment_s_Other_Reason__c = 'Terminated';
        cons9.Technology_Solutions_Termination_Date__c = system.today();
        cons9.Technology_Solutions_Active_Date__c = system.today();
        cons9.Technology_Consultant_Assigned__c='test';
        cons9.CFO_Consultant_Assigned__c='test';
        cons9.Marketing_Solutions_Active_Date__c=system.today();
        cons9.Marketing_Consultant_Assigned__c='test';
        cons9.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons9.VA_Assigned__c='test';
        cons9.Experiment_s__c='Interested lead';
        cons9.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons9);
        
        Contact cons10 = new contact();
        cons10.lastname ='test lastname';
        cons10.RecordTypeId = rt_MapCon;
        cons10.Admin_Solutions_Active_Date__c = system.today();
        cons10.CFO_Solutions_Active_Date__c = system.today();
        cons10.Experiment_s_Other_Reason__c = 'Terminated';
        cons10.Technology_Solutions_Termination_Date__c = system.today();
        cons10.Technology_Solutions_Active_Date__c = system.today();
        cons10.Technology_Consultant_Assigned__c='test';
        cons10.CFO_Consultant_Assigned__c='test';
        cons10.Marketing_Solutions_Active_Date__c=system.today();
        cons10.Marketing_Consultant_Assigned__c='test';
        cons10.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons10.VA_Assigned__c='test';
        cons10.Experiment_s__c='Interested lead';
        cons10.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons10);
        
        Contact cons11 = new contact();
        cons11.lastname ='test lastname';
        cons11.RecordTypeId = rt_MapCon;
        cons11.Admin_Solutions_Active_Date__c = system.today();
        cons11.CFO_Solutions_Active_Date__c = system.today();
        cons11.Experiment_s_Other_Reason__c = 'Terminated';
        cons11.Technology_Solutions_Termination_Date__c = system.today();
        cons11.Technology_Solutions_Active_Date__c = system.today();
        cons11.Technology_Consultant_Assigned__c='test';
        cons11.CFO_Consultant_Assigned__c='test';
        cons11.Marketing_Solutions_Active_Date__c=system.today();
        cons11.Marketing_Consultant_Assigned__c='test';
        cons11.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons11.VA_Assigned__c='test';
        cons11.Experiment_s__c='Interested lead';
        cons11.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons11);
        
        Contact cons12 = new contact();
        cons12.lastname ='test lastname';
        cons12.RecordTypeId = rt_MapCon;
        cons12.Admin_Solutions_Active_Date__c = system.today();
        cons12.CFO_Solutions_Active_Date__c = system.today();
        cons12.Experiment_s_Other_Reason__c = 'Terminated';
        cons12.Technology_Solutions_Termination_Date__c = system.today();
        cons12.Technology_Solutions_Active_Date__c = system.today();
        cons12.Technology_Consultant_Assigned__c='test';
        cons12.CFO_Consultant_Assigned__c='test';
        cons12.Marketing_Solutions_Active_Date__c=system.today();
        cons12.Marketing_Consultant_Assigned__c='test';
        cons12.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons12.VA_Assigned__c='test';
        cons12.Experiment_s__c='Interested lead';
        cons12.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons12);
        
        Contact cons13 = new contact();
        cons13.lastname ='test lastname';
        cons13.RecordTypeId = rt_MapCon;
        cons13.Admin_Solutions_Active_Date__c = system.today();
        cons13.CFO_Solutions_Active_Date__c = system.today();
        cons13.Experiment_s_Other_Reason__c = 'Terminated';
        cons13.Technology_Solutions_Termination_Date__c = system.today();
        cons13.Technology_Solutions_Active_Date__c = system.today();
        cons13.Technology_Consultant_Assigned__c='test';
        cons13.CFO_Consultant_Assigned__c='test';
        cons13.Marketing_Solutions_Active_Date__c=system.today();
        cons13.Marketing_Consultant_Assigned__c='test';
        cons13.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons13.VA_Assigned__c='test';
        cons13.Experiment_s__c='Interested lead';
        cons13.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons13);
        
        Contact cons14 = new contact();
        cons14.lastname ='test lastname';
        cons14.RecordTypeId = rt_MapCon;
        cons14.Admin_Solutions_Active_Date__c = system.today();
        cons14.CFO_Solutions_Active_Date__c = system.today();
        cons14.Experiment_s_Other_Reason__c = 'Terminated';
        cons14.Technology_Solutions_Termination_Date__c = system.today();
        cons14.Technology_Solutions_Active_Date__c = system.today();
        cons14.Technology_Consultant_Assigned__c='test';
        cons14.CFO_Consultant_Assigned__c='test';
        cons14.Marketing_Solutions_Active_Date__c=system.today();
        cons14.Marketing_Consultant_Assigned__c='test';
        cons14.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons14.VA_Assigned__c='test';
        cons14.Experiment_s__c='Interested lead';
        cons14.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons14);
        
        insert cons; 
        
        //Promo Code
        Promo_Code__c pc = new Promo_Code__c();
        pc.name ='Promo Code';
        pc.Active__c = true;
        pc.Discount__c = 10;
        pc.Expiration_date__c = system.today()+60;
        insert pc;
        
        Product2 prod = new Product2(Name = 'Promo Code',ProductCode = 'PMCODE',IsActive = true);
        insert prod;
        
        //Opportunity
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity  opp = new Opportunity ();
        opp.name='test Opportunity';
        opp.StageName='Closed-Won';
        opp.Type='Finance Solution';
        opp.CloseDate =  system.today()+30;
        opp.RecordTypeId= OppRecordTypeId;
        opp.contact__c=cons[0].id;
        opp.ContactId=cons[0].id;
        opp.Pricebook2Id = Test.getStandardPricebookId();
        opp.LBS_Promo_Code__c = null;
        opp.Close_Won_Reason__c = 'Acquisition strategy';
        oppList.add(opp);
        
        Opportunity  opp1 = new Opportunity ();
        opp1.name='test Opportunity';
        opp1.StageName='Engaged opportunity';
        opp1.Type='Marketing Solution';
        opp1.CloseDate =  system.today()+30;
        opp1.RecordTypeId= OppRecordTypeId;
        opp1.contact__c=cons[1].id;
        opp1.ContactId=cons[1].id;
        opp1.Pricebook2Id = Test.getStandardPricebookId();
        opp1.LBS_Promo_Code__c = null;
        oppList.add(opp1);
        
        Opportunity  opp2 = new Opportunity ();
        opp2.name='test Opportunity';
        opp2.StageName='Engaged opportunity';
        opp2.Type='Technology Solution';
        opp2.CloseDate =  system.today()+30;
        opp2.RecordTypeId= OppRecordTypeId;
        opp2.contact__c=cons[2].id;
        opp2.ContactId=cons[2].id;
        opp2.Pricebook2Id = Test.getStandardPricebookId();
        opp2.LBS_Promo_Code__c = null;
        oppList.add(opp2);
        
        Opportunity  opp3 = new Opportunity ();
        opp3.name='test opp';
        opp3.StageName='Qualification';
        opp3.Type='Marketing Solution';
        opp3.CloseDate =  system.today()+30;
        opp3.RecordTypeId= OppRecordTypeId;
        opp3.contact__c=cons[3].id;
        opp3.ContactId=cons[3].id;
        opp3.Pricebook2Id = Test.getStandardPricebookId();
        opp3.LBS_Promo_Code__c = null;
        oppList.add(opp3);
        
        Opportunity  opp4 = new Opportunity ();
        opp4.name='test opp';
        opp4.StageName='Qualification';
        opp4.Type='Technology Solution';
        opp4.CloseDate =  system.today()+30;
        opp4.RecordTypeId= OppRecordTypeId;
        opp4.contact__c=cons[4].id;
        opp4.ContactId=cons[4].id;
        opp4.Pricebook2Id = Test.getStandardPricebookId();
        opp4.LBS_Promo_Code__c = null;
        oppList.add(opp4);
        
        Opportunity  opp5 = new Opportunity ();
        opp5.name='test opp';
        opp5.StageName='Qualification';
        opp5.Type='Admin Solution';
        opp5.CloseDate =  system.today()+30;
        opp5.RecordTypeId= OppRecordTypeId;
        opp5.contact__c=cons[5].id;
        opp5.ContactId=cons[5].id;
        opp5.Pricebook2Id = Test.getStandardPricebookId();
        opp5.LBS_Promo_Code__c = null;
        oppList.add(opp5);
        
        Opportunity  opp6 = new Opportunity ();
        opp6.name='test opp';
        opp6.StageName='Qualification';
        opp6.Type='Finance Solution';
        opp6.CloseDate =  system.today()+30;
        opp6.RecordTypeId= OppRecordTypeId;
        opp6.contact__c=cons[6].id;
        opp6.ContactId=cons[6].id;
        opp6.Pricebook2Id = Test.getStandardPricebookId();
        opp6.LBS_Promo_Code__c = null;
        oppList.add(opp6);
        
        Opportunity  opp7 = new Opportunity ();
        opp7.name='test opp';
        opp7.StageName='Closed-Won';
        opp7.Type='Finance Solution';
        opp7.CloseDate =  system.today()+30;
        opp7.RecordTypeId= OppRecordTypeId;
        opp7.contact__c=cons[7].id;
        opp7.ContactId=cons[7].id;
        opp7.Pricebook2Id = Test.getStandardPricebookId();
        opp7.LBS_Promo_Code__c = null;
        opp7.Close_Won_Reason__c = 'Acquisition strategy';
        oppList.add(opp7);
        
        Opportunity  opp8 = new Opportunity ();
        opp8.name='test opp';
        opp8.StageName='Closed-Won';
        opp8.Type='Marketing Solution';
        opp8.CloseDate =  system.today()+30;
        opp8.RecordTypeId= OppRecordTypeId;
        opp8.contact__c=cons[8].id;
        opp8.ContactId=cons[8].id;
        opp8.Pricebook2Id = Test.getStandardPricebookId();
        opp8.LBS_Promo_Code__c = null;
        opp8.Close_Won_Reason__c = 'Website management';
        oppList.add(opp8);  
        
        Opportunity  opp9 = new Opportunity ();
        opp9.name='test opp';
        opp9.StageName='Closed-Won';
        opp9.Type='Technology Solution';
        opp9.CloseDate =  system.today()+30;
        opp9.RecordTypeId= OppRecordTypeId;
        opp9.contact__c=cons[9].id;
        opp9.ContactId=cons[9].id;
        opp9.Pricebook2Id = Test.getStandardPricebookId();
        opp9.LBS_Promo_Code__c = null;
        opp9.Close_Won_Reason__c = 'Cloud storage';
        oppList.add(opp9);
        
        Opportunity  opp10 = new Opportunity ();
        opp10.name='test opp';
        opp10.StageName='Closed-Won';
        opp10.Type='Admin Solution';
        opp10.CloseDate =  system.today()+30;
        opp10.RecordTypeId= OppRecordTypeId;
        opp10.contact__c=cons[10].id;
        opp10.ContactId=cons[10].id;
        opp10.Pricebook2Id = Test.getStandardPricebookId();
        opp10.LBS_Promo_Code__c = null;
        opp10.Close_Won_Reason__c = 'Short-term solution';
        oppList.add(opp10);
        
        Opportunity  opp11 = new Opportunity ();
        opp11.name='test opp';
        opp11.StageName='Closed-Won';
        opp11.Type='LPL Assurance';
        opp11.CloseDate =  system.today()+30;
        opp11.RecordTypeId= OppRecordTypeId;
        opp11.contact__c=cons[11].id;
        opp11.ContactId=cons[11].id;
        opp11.Pricebook2Id = Test.getStandardPricebookId();
        opp11.LBS_Promo_Code__c = null;
        opp11.Close_Won_Reason__c = 'Annual valuation';
        oppList.add(opp11);
        
        Opportunity  opp12 = new Opportunity ();
        opp12.name='test opp';
        opp12.StageName='Closed-Won';
        opp12.Type='M&A Solution-Premium Buyer Program';
        opp12.CloseDate =  system.today()+30;
        opp12.RecordTypeId= OppRecordTypeId;
        opp12.contact__c=cons[12].id;
        opp12.ContactId=cons[12].id;
        opp12.Pricebook2Id = Test.getStandardPricebookId();
        opp12.LBS_Promo_Code__c = null;
        opp12.Close_Won_Reason__c = 'Acquisition financing';
        oppList.add(opp12);
        
        Opportunity  opp13 = new Opportunity ();
        opp13.name='test opp';
        opp13.StageName='Closed-Won';
        opp13.Type='Resilience Plan';
        opp13.CloseDate =  system.today()+30;
        opp13.RecordTypeId= OppRecordTypeId;
        opp13.contact__c=cons[13].id;
        opp13.ContactId=cons[13].id;
        opp13.Pricebook2Id = Test.getStandardPricebookId();
        opp13.LBS_Promo_Code__c = null;
        opp13.Close_Won_Reason__c = 'FMLA';
        oppList.add(opp13);
        
        insert oppList;
        
    
        oppList[0].StageName='Engaged opportunity';
        oppList[0].Type='Admin Solution';
        oppList[7].StageName='Closed-Won';
        oppList[8].StageName='Closed-Won';
        oppList[9].StageName='Closed-Won';
        oppList[10].StageName='Closed-Won';
        oppList[11].StageName='Closed-Won';
        oppList[12].StageName='Closed-Won';
        oppList[13].StageName='Closed-Won';
        update oppList;
        
        oppList[7].StageName='Engaged opportunity';
        oppList[8].StageName='Engaged opportunity';
        oppList[9].StageName='Engaged opportunity';
        oppList[10].StageName='Engaged opportunity';
        oppList[11].StageName='Engaged opportunity';
        oppList[12].StageName='Engaged opportunity';
        oppList[13].StageName='Engaged opportunity';
        update oppList;
        
        Test.stopTest();
    }
    public static testMethod void createUpdateTest(){
        Test.startTest();
        Id rt_MapCon = Schema.SObjectType.contact.getRecordTypeInfosByName().get('LPL Advisor').getRecordTypeId();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Solutions').getRecordTypeId();
        List<Contact> cons = new List<Contact>();
        //contact 
        Contact cons1 = new contact();
        cons1.lastname ='test lastname';
        cons1.RecordTypeId = rt_MapCon;
        cons1.Admin_Solutions_Active_Date__c = system.today();
        cons1.CFO_Solutions_Active_Date__c = system.today();
        cons1.Experiment_s_Other_Reason__c = 'Terminated';
        cons1.Technology_Solutions_Termination_Date__c = system.today();
        cons1.Technology_Solutions_Active_Date__c = system.today();
        cons1.Technology_Consultant_Assigned__c='test';
        cons1.CFO_Consultant_Assigned__c='test';
        cons1.Marketing_Solutions_Active_Date__c=system.today();
        cons1.Marketing_Consultant_Assigned__c='test';
        cons1.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons1.VA_Assigned__c='test';
        cons1.Experiment_s__c='Interested lead';
        cons1.CFO_Solutions_Status__c ='Sales Qualified lead';
        cons.add(cons1);
        
        Contact cons2 = new contact();
        cons2.lastname ='test lastname';
        cons2.RecordTypeId = rt_MapCon;
        cons2.Admin_Solutions_Active_Date__c = system.today();
        cons2.CFO_Solutions_Active_Date__c = system.today();
        cons2.Experiment_s_Other_Reason__c = 'Terminated';
        cons2.Technology_Solutions_Termination_Date__c = system.today();
        cons2.Technology_Solutions_Active_Date__c = system.today();
        cons2.Technology_Consultant_Assigned__c='test';
        cons2.CFO_Consultant_Assigned__c='test';
        cons2.Marketing_Solutions_Active_Date__c=system.today();
        cons2.Marketing_Consultant_Assigned__c='test';
        cons2.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons2.VA_Assigned__c='test';
        cons2.Experiment_s__c='Interested lead';
        cons.add(cons2);
        
        Contact cons3 = new contact();
        cons3.lastname ='test lastname';
        cons3.RecordTypeId = rt_MapCon;
        cons3.Admin_Solutions_Active_Date__c = system.today();
        cons3.CFO_Solutions_Active_Date__c = system.today();
        cons3.Experiment_s_Other_Reason__c = 'Terminated';
        cons3.Technology_Solutions_Termination_Date__c = system.today();
        cons3.Technology_Solutions_Active_Date__c = system.today();
        cons3.Technology_Consultant_Assigned__c='test';
        cons3.CFO_Consultant_Assigned__c='test';
        cons3.Marketing_Solutions_Active_Date__c=system.today();
        cons3.Marketing_Consultant_Assigned__c='test';
        cons3.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons3.VA_Assigned__c='test';
        cons3.Experiment_s__c='Interested lead';
        cons.add(cons3);
        
        Contact cons4 = new contact();
        cons4.lastname ='test lastname';
        cons4.RecordTypeId = rt_MapCon;
        cons4.Admin_Solutions_Active_Date__c = system.today();
        cons4.CFO_Solutions_Active_Date__c = system.today();
        cons4.Experiment_s_Other_Reason__c = 'Terminated';
        cons4.Technology_Solutions_Termination_Date__c = system.today();
        cons4.Technology_Solutions_Active_Date__c = system.today();
        cons4.Technology_Consultant_Assigned__c='test';
        cons4.CFO_Consultant_Assigned__c='test';
        cons4.Marketing_Solutions_Active_Date__c=system.today();
        cons4.Marketing_Consultant_Assigned__c='test';
        cons4.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons4.VA_Assigned__c='test';
        cons4.Experiment_s__c='Interested lead';
        cons.add(cons4);
        
        Contact cons5 = new contact();
        cons5.lastname ='test lastname';
        cons5.RecordTypeId = rt_MapCon;
        cons5.Admin_Solutions_Active_Date__c = system.today();
        cons5.CFO_Solutions_Active_Date__c = system.today();
        cons5.Experiment_s_Other_Reason__c = 'Terminated';
        cons5.Technology_Solutions_Termination_Date__c = system.today();
        cons5.Technology_Solutions_Active_Date__c = system.today();
        cons5.Technology_Consultant_Assigned__c='test';
        cons5.CFO_Consultant_Assigned__c='test';
        cons5.Marketing_Solutions_Active_Date__c=system.today();
        cons5.Marketing_Consultant_Assigned__c='test';
        cons5.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons5.VA_Assigned__c='test';
        cons5.Experiment_s__c='Interested lead';
        cons.add(cons5);
        
        Contact cons6 = new contact();
        cons6.lastname ='test lastname';
        cons6.RecordTypeId = rt_MapCon;
        cons6.Admin_Solutions_Active_Date__c = system.today();
        cons6.CFO_Solutions_Active_Date__c = system.today();
        cons6.Experiment_s_Other_Reason__c = 'Terminated';
        cons6.Technology_Solutions_Termination_Date__c = system.today();
        cons6.Technology_Solutions_Active_Date__c = system.today();
        cons6.Technology_Consultant_Assigned__c='test';
        cons6.CFO_Consultant_Assigned__c='test';
        cons6.Marketing_Solutions_Active_Date__c=system.today();
        cons6.Marketing_Consultant_Assigned__c='test';
        cons6.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons6.VA_Assigned__c='test';
        cons6.Experiment_s__c='Interested lead';
        cons.add(cons6);
        
        Contact cons7 = new contact();
        cons7.lastname ='test lastname';
        cons7.RecordTypeId = rt_MapCon;
        cons7.Admin_Solutions_Active_Date__c = system.today();
        cons7.CFO_Solutions_Active_Date__c = system.today();
        cons7.Experiment_s_Other_Reason__c = 'Terminated';
        cons7.Technology_Solutions_Termination_Date__c = system.today();
        cons7.Technology_Solutions_Active_Date__c = system.today();
        cons7.Technology_Consultant_Assigned__c='test';
        cons7.CFO_Consultant_Assigned__c='test';
        cons7.Marketing_Solutions_Active_Date__c=system.today();
        cons7.Marketing_Consultant_Assigned__c='test';
        cons7.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons7.VA_Assigned__c='test';
        cons7.Experiment_s__c='Interested lead';
        cons.add(cons7);
        
        Contact cons8 = new contact();
        cons8.lastname ='test lastname';
        cons8.RecordTypeId = rt_MapCon;
        cons8.Admin_Solutions_Active_Date__c = system.today();
        cons8.CFO_Solutions_Active_Date__c = system.today();
        cons8.Experiment_s_Other_Reason__c = 'Terminated';
        cons8.Technology_Solutions_Termination_Date__c = system.today();
        cons8.Technology_Solutions_Active_Date__c = system.today();
        cons8.Technology_Consultant_Assigned__c='test';
        cons8.CFO_Consultant_Assigned__c='test';
        cons8.Marketing_Solutions_Active_Date__c=system.today();
        cons8.Marketing_Consultant_Assigned__c='test';
        cons8.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons8.VA_Assigned__c='test';
        cons8.Experiment_s__c='Interested lead';
        cons.add(cons8);
        
        Contact cons9 = new contact();
        cons9.lastname ='test lastname';
        cons9.RecordTypeId = rt_MapCon;
        cons9.Admin_Solutions_Active_Date__c = system.today();
        cons9.CFO_Solutions_Active_Date__c = system.today();
        cons9.Experiment_s_Other_Reason__c = 'Terminated';
        cons9.Technology_Solutions_Termination_Date__c = system.today();
        cons9.Technology_Solutions_Active_Date__c = system.today();
        cons9.Technology_Consultant_Assigned__c='test';
        cons9.CFO_Consultant_Assigned__c='test';
        cons9.Marketing_Solutions_Active_Date__c=system.today();
        cons9.Marketing_Consultant_Assigned__c='test';
        cons9.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons9.VA_Assigned__c='test';
        cons9.Experiment_s__c='Interested lead';
        cons.add(cons9);
        
        Contact cons10= new contact();
        cons10.lastname ='test lastname';
        cons10.RecordTypeId = rt_MapCon;
        cons10.Admin_Solutions_Active_Date__c = system.today();
        cons10.CFO_Solutions_Active_Date__c = system.today();
        cons10.Experiment_s_Other_Reason__c = 'Terminated';
        cons10.Technology_Solutions_Termination_Date__c = system.today();
        cons10.Technology_Solutions_Active_Date__c = system.today();
        cons10.Technology_Consultant_Assigned__c='test';
        cons10.CFO_Consultant_Assigned__c='test';
        cons10.Marketing_Solutions_Active_Date__c=system.today();
        cons10.Marketing_Consultant_Assigned__c='test';
        cons10.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons10.VA_Assigned__c='test';
        cons10.Experiment_s__c='Interested lead';
        cons.add(cons10);
        
        Contact cons11= new contact();
        cons11.lastname ='test lastname';
        cons11.RecordTypeId = rt_MapCon;
        cons11.Admin_Solutions_Active_Date__c = system.today();
        cons11.CFO_Solutions_Active_Date__c = system.today();
        cons11.Experiment_s_Other_Reason__c = 'Terminated';
        cons11.Technology_Solutions_Termination_Date__c = system.today();
        cons11.Technology_Solutions_Active_Date__c = system.today();
        cons11.Technology_Consultant_Assigned__c='test';
        cons11.CFO_Consultant_Assigned__c='test';
        cons11.Marketing_Solutions_Active_Date__c=system.today();
        cons11.Marketing_Consultant_Assigned__c='test';
        cons11.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons11.VA_Assigned__c='test';
        cons11.Experiment_s__c='Interested lead';
        cons.add(cons11);
        
        Contact cons12= new contact();
        cons12.lastname ='test lastname';
        cons12.RecordTypeId = rt_MapCon;
        cons12.Admin_Solutions_Active_Date__c = system.today();
        cons12.CFO_Solutions_Active_Date__c = system.today();
        cons12.Experiment_s_Other_Reason__c = 'Terminated';
        cons12.Technology_Solutions_Termination_Date__c = system.today();
        cons12.Technology_Solutions_Active_Date__c = system.today();
        cons12.Technology_Consultant_Assigned__c='test';
        cons12.CFO_Consultant_Assigned__c='test';
        cons12.Marketing_Solutions_Active_Date__c=system.today();
        cons12.Marketing_Consultant_Assigned__c='test';
        cons12.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons12.VA_Assigned__c='test';
        cons12.Experiment_s__c='Interested lead';
        cons.add(cons12);
        
        Contact cons13= new contact();
        cons13.lastname ='test lastname';
        cons13.RecordTypeId = rt_MapCon;
        cons13.Admin_Solutions_Active_Date__c = system.today();
        cons13.CFO_Solutions_Active_Date__c = system.today();
        cons13.Experiment_s_Other_Reason__c = 'Terminated';
        cons13.Technology_Solutions_Termination_Date__c = system.today();
        cons13.Technology_Solutions_Active_Date__c = system.today();
        cons13.Technology_Consultant_Assigned__c='test';
        cons13.CFO_Consultant_Assigned__c='test';
        cons13.Marketing_Solutions_Active_Date__c=system.today();
        cons13.Marketing_Consultant_Assigned__c='test';
        cons13.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons13.VA_Assigned__c='test';
        cons13.Experiment_s__c='Interested lead';
        cons.add(cons13);
        
        Contact cons14= new contact();
        cons14.lastname ='test lastname';
        cons14.RecordTypeId = rt_MapCon;
        cons14.Admin_Solutions_Active_Date__c = system.today();
        cons14.CFO_Solutions_Active_Date__c = system.today();
        cons14.Experiment_s_Other_Reason__c = 'Terminated';
        cons14.Technology_Solutions_Termination_Date__c = system.today();
        cons14.Technology_Solutions_Active_Date__c = system.today();
        cons14.Technology_Consultant_Assigned__c='test';
        cons14.CFO_Consultant_Assigned__c='test';
        cons14.Marketing_Solutions_Active_Date__c=system.today();
        cons14.Marketing_Consultant_Assigned__c='test';
        cons14.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons14.VA_Assigned__c='test';
        cons14.Experiment_s__c='Interested lead';
        cons.add(cons14);
        
        Contact cons15= new contact();
        cons15.lastname ='test lastname';
        cons15.RecordTypeId = rt_MapCon;
        cons15.Admin_Solutions_Active_Date__c = system.today();
        cons15.CFO_Solutions_Active_Date__c = system.today();
        cons15.Experiment_s_Other_Reason__c = 'Terminated';
        cons15.Technology_Solutions_Termination_Date__c = system.today();
        cons15.Technology_Solutions_Active_Date__c = system.today();
        cons15.Technology_Consultant_Assigned__c='test';
        cons15.CFO_Consultant_Assigned__c='test';
        cons15.Marketing_Solutions_Active_Date__c=system.today();
        cons15.Marketing_Consultant_Assigned__c='test';
        cons15.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons15.VA_Assigned__c='test';
        cons15.Experiment_s__c='Interested lead';
        cons.add(cons15);
        
        Contact cons16= new contact();
        cons16.lastname ='test lastname';
        cons16.RecordTypeId = rt_MapCon;
        cons16.Admin_Solutions_Active_Date__c = system.today();
        cons16.CFO_Solutions_Active_Date__c = system.today();
        cons16.Experiment_s_Other_Reason__c = 'Terminated';
        cons16.Technology_Solutions_Termination_Date__c = system.today();
        cons16.Technology_Solutions_Active_Date__c = system.today();
        cons16.Technology_Consultant_Assigned__c='test';
        cons16.CFO_Consultant_Assigned__c='test';
        cons16.Marketing_Solutions_Active_Date__c=system.today();
        cons16.Marketing_Consultant_Assigned__c='test';
        cons16.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons16.VA_Assigned__c='test';
        cons16.Experiment_s__c='Interested lead';
        cons.add(cons16);
        
        Contact cons17= new contact();
        cons17.lastname ='test lastname';
        cons17.RecordTypeId = rt_MapCon;
        cons17.Admin_Solutions_Active_Date__c = system.today();
        cons17.CFO_Solutions_Active_Date__c = system.today();
        cons17.Experiment_s_Other_Reason__c = 'Terminated';
        cons17.Technology_Solutions_Termination_Date__c = system.today();
        cons17.Technology_Solutions_Active_Date__c = system.today();
        cons17.Technology_Consultant_Assigned__c='test';
        cons17.CFO_Consultant_Assigned__c='test';
        cons17.Marketing_Solutions_Active_Date__c=system.today();
        cons17.Marketing_Consultant_Assigned__c='test';
        cons17.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons17.VA_Assigned__c='test';
        cons17.Experiment_s__c='Interested lead';
        cons.add(cons17);
        
        Contact cons18= new contact();
        cons18.lastname ='test lastname';
        cons18.RecordTypeId = rt_MapCon;
        cons18.Admin_Solutions_Active_Date__c = system.today();
        cons18.CFO_Solutions_Active_Date__c = system.today();
        cons18.Experiment_s_Other_Reason__c = 'Terminated';
        cons18.Technology_Solutions_Termination_Date__c = system.today();
        cons18.Technology_Solutions_Active_Date__c = system.today();
        cons18.Technology_Consultant_Assigned__c='test';
        cons18.CFO_Consultant_Assigned__c='test';
        cons18.Marketing_Solutions_Active_Date__c=system.today();
        cons18.Marketing_Consultant_Assigned__c='test';
        cons18.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons18.VA_Assigned__c='test';
        cons18.Experiment_s__c='Interested lead';
        cons.add(cons18);
        
        Contact cons19= new contact();
        cons19.lastname ='test lastname';
        cons19.RecordTypeId = rt_MapCon;
        cons19.Admin_Solutions_Active_Date__c = system.today();
        cons19.CFO_Solutions_Active_Date__c = system.today();
        cons19.Experiment_s_Other_Reason__c = 'Terminated';
        cons19.Technology_Solutions_Termination_Date__c = system.today();
        cons19.Technology_Solutions_Active_Date__c = system.today();
        cons19.Technology_Consultant_Assigned__c='test';
        cons19.CFO_Consultant_Assigned__c='test';
        cons19.Marketing_Solutions_Active_Date__c=system.today();
        cons19.Marketing_Consultant_Assigned__c='test';
        cons19.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons19.VA_Assigned__c='test';
        cons19.Experiment_s__c='Interested lead';
        cons.add(cons19);
        
        Contact cons20= new contact();
        cons20.lastname ='test lastname';
        cons20.RecordTypeId = rt_MapCon;
        cons20.Admin_Solutions_Active_Date__c = system.today();
        cons20.CFO_Solutions_Active_Date__c = system.today();
        cons20.Experiment_s_Other_Reason__c = 'Terminated';
        cons20.Technology_Solutions_Termination_Date__c = system.today();
        cons20.Technology_Solutions_Active_Date__c = system.today();
        cons20.Technology_Consultant_Assigned__c='test';
        cons20.CFO_Consultant_Assigned__c='test';
        cons20.Marketing_Solutions_Active_Date__c=system.today();
        cons20.Marketing_Consultant_Assigned__c='test';
        cons20.Technology_Solutions_Subscription_Type__c = 'Pre-Qualified lead';
        cons20.VA_Assigned__c='test';
        cons20.Experiment_s__c='Interested lead';
        cons.add(cons20);
        
        insert cons;
            
        //Promo code
        Promo_Code__c pc = new Promo_Code__c();
        pc.name ='Promo Code';
        pc.Active__c = true;
        pc.Discount__c = 10;
        pc.Expiration_date__c = system.today()+60;
        insert pc;
        
        Product2 prod = new Product2(Name = 'Promo Code',ProductCode = 'PMCODE',IsActive = true);
        insert prod;
        List<Opportunity> oppList = new List<Opportunity>();
        
        //Opportunity
        Opportunity  opp1 = new Opportunity ();
        opp1.name='test opp';
        opp1.StageName='Closed-Won';
        opp1.Type='Finance Solution';
        opp1.CloseDate =  system.today()+30;
        opp1.RecordTypeId= OppRecordTypeId;
        opp1.contact__c=cons[0].id;
        opp1.ContactId=cons[0].id;
        opp1.Pricebook2Id = Test.getStandardPricebookId();
        opp1.LBS_Promo_Code__c = null;
        opp1.Close_Won_Reason__c = 'Acquisition strategy';
        oppList.add(opp1);
        
        Opportunity  opp2 = new Opportunity ();
        opp2.name='test opp';
        opp2.StageName='Closed-Won';
        opp2.Type='M&A Solution-Premium Buyer Program';
        opp2.CloseDate =  system.today()+30;
        opp2.RecordTypeId= OppRecordTypeId;
        opp2.contact__c=cons[1].id;
        opp2.ContactId=cons[1].id;
        opp2.Pricebook2Id = Test.getStandardPricebookId();
        opp2.LBS_Promo_Code__c = null;
        opp2.Close_Won_Reason__c = 'Acquisition financing';
        oppList.add(opp2);
        
        Opportunity  opp3 = new Opportunity ();
        opp3.name='test opp';
        opp3.StageName='Closed-Won';
        opp3.Type='Resilience Plan';
        opp3.CloseDate =  system.today()+30;
        opp3.RecordTypeId= OppRecordTypeId;
        opp3.contact__c=cons[2].id;
        opp3.ContactId=cons[2].id;
        opp3.Pricebook2Id = Test.getStandardPricebookId();
        opp3.LBS_Promo_Code__c = null;
        opp3.Close_Won_Reason__c = 'FMLA';
        oppList.add(opp3);
        
        Opportunity  opp4 = new Opportunity ();
        opp4.name='test opp';
        opp4.StageName='Qualification';
        opp4.Type='LPL Assurance';
        opp4.CloseDate =  system.today()+30;
        opp4.RecordTypeId= OppRecordTypeId;
        opp4.contact__c=cons[3].id;
        opp4.ContactId=cons[3].id;
        opp4.Pricebook2Id = Test.getStandardPricebookId();
        opp4.LBS_Promo_Code__c = null;
        oppList.add(opp4);
        
        Opportunity  opp5 = new Opportunity ();
        opp5.name='test opp';
        opp5.StageName='Qualification';
        opp5.Type='M&A Solution-Premium Buyer Program';
        opp5.CloseDate =  system.today()+30;
        opp5.RecordTypeId= OppRecordTypeId;
        opp5.contact__c=cons[4].id;
        opp5.ContactId=cons[4].id;
        opp5.Pricebook2Id = Test.getStandardPricebookId();
        opp5.LBS_Promo_Code__c = null;
        oppList.add(opp5);
        
        Opportunity  opp6 = new Opportunity ();
        opp6.name='qualification test';
        opp6.StageName='Qualification';
        opp6.Type='Resilience Plan';
        opp6.CloseDate =  system.today()+30;
        opp6.RecordTypeId= OppRecordTypeId;
        opp6.contact__c=cons[5].id;
        opp6.ContactId=cons[5].id;
        opp6.Pricebook2Id = Test.getStandardPricebookId();
        opp6.LBS_Promo_Code__c = null;
        oppList.add(opp6);
        
        Opportunity  opp7 = new Opportunity ();
        opp7.name='qualification test';
        opp7.StageName='Closed-Won';
        opp7.Type='Marketing Solution';
        opp7.CloseDate =  system.today()+30;
        opp7.RecordTypeId= OppRecordTypeId;
        opp7.contact__c=cons[6].id;
        opp7.ContactId=cons[6].id;
        opp7.Pricebook2Id = Test.getStandardPricebookId();
        opp7.LBS_Promo_Code__c = null;
        opp7.Close_Won_Reason__c = 'Website management';
        oppList.add(opp7);
        
        Opportunity  opp8 = new Opportunity ();
        opp8.name='qualification test';
        opp8.StageName='Closed-Won';
        opp8.Type='Technology Solution';
        opp8.CloseDate =  system.today()+30;
        opp8.RecordTypeId= OppRecordTypeId;
        opp8.contact__c=cons[7].id;
        opp8.ContactId=cons[7].id;
        opp8.Pricebook2Id = Test.getStandardPricebookId();
        opp8.LBS_Promo_Code__c = null;
        opp8.Close_Won_Reason__c = 'Cloud storage';
        oppList.add(opp8);
        
        Opportunity  opp9 = new Opportunity ();
        opp9.name='qualification test';
        opp9.StageName='Closed-Won';
        opp9.Type='Admin Solution';
        opp9.CloseDate =  system.today()+30;
        opp9.RecordTypeId= OppRecordTypeId;
        opp9.contact__c=cons[8].id;
        opp9.ContactId=cons[8].id;
        opp9.Pricebook2Id = Test.getStandardPricebookId();
        opp9.LBS_Promo_Code__c = null;
        opp9.Close_Won_Reason__c = 'Short-term solution';
        oppList.add(opp9);
        
        Opportunity  opp10 = new Opportunity ();
        opp10.name='qualification test';
        opp10.StageName='Closed-Won';
        opp10.Type='LPL Assurance';
        opp10.CloseDate =  system.today()+30;
        opp10.RecordTypeId= OppRecordTypeId;
        opp10.contact__c=cons[9].id;
        opp10.ContactId=cons[9].id;
        opp10.Pricebook2Id = Test.getStandardPricebookId();
        opp10.LBS_Promo_Code__c = null;
        opp10.Close_Won_Reason__c = 'Annual valuation';
        oppList.add(opp10);
        
        Opportunity  opp11 = new Opportunity ();
        opp11.name='qualification test';
        opp11.StageName='Closed-Won';
        opp11.Type='M&A Solution-Premium Buyer Program';
        opp11.CloseDate =  system.today()+30;
        opp11.RecordTypeId= OppRecordTypeId;
        opp11.contact__c=cons[10].id;
        opp11.ContactId=cons[10].id;
        opp11.Pricebook2Id = Test.getStandardPricebookId();
        opp11.LBS_Promo_Code__c = null;
        opp11.Close_Won_Reason__c = 'Valuation service';
        oppList.add(opp11);
        
        Opportunity  opp12 = new Opportunity ();
        opp12.name='qualification test';
        opp12.StageName='Closed-Won';
        opp12.Type='Resilience Plan';
        opp12.CloseDate =  system.today()+30;
        opp12.RecordTypeId= OppRecordTypeId;
        opp12.contact__c=cons[11].id;
        opp12.ContactId=cons[11].id;
        opp12.Pricebook2Id = Test.getStandardPricebookId();
        opp12.LBS_Promo_Code__c = null;
        opp12.Close_Won_Reason__c = 'FMLA';
        oppList.add(opp12);
        
        Opportunity  opp13 = new Opportunity ();
        opp13.name='qualification test';
        opp13.StageName='Closed-Lost';
        opp13.Type='Marketing Solution';
        opp13.CloseDate =  system.today()+30;
        opp13.RecordTypeId= OppRecordTypeId;
        opp13.contact__c=cons[12].id;
        opp13.ContactId=cons[12].id;
        opp13.Pricebook2Id = Test.getStandardPricebookId();
        opp13.LBS_Promo_Code__c = null;
        opp13.Lost_Outcome__c = 'Other';
        oppList.add(opp13);
        
        Opportunity  opp14 = new Opportunity ();
        opp14.name='qualification test';
        opp14.StageName='Closed-Lost';
        opp14.Type='Technology Solution';
        opp14.CloseDate =  system.today()+30;
        opp14.RecordTypeId= OppRecordTypeId;
        opp14.contact__c=cons[13].id;
        opp14.ContactId=cons[13].id;
        opp14.Pricebook2Id = Test.getStandardPricebookId();
        opp14.LBS_Promo_Code__c = null;
        opp14.Lost_Outcome__c = 'Other';
        oppList.add(opp14);
        
        Opportunity  opp15 = new Opportunity ();
        opp15.name='qualification test';
        opp15.StageName='Closed-Lost';
        opp15.Type='Admin Solution';  
        opp15.CloseDate =  system.today()+30;
        opp15.RecordTypeId= OppRecordTypeId;
        opp15.contact__c=cons[14].id;
        opp15.ContactId=cons[14].id;
        opp15.Pricebook2Id = Test.getStandardPricebookId();
        opp15.LBS_Promo_Code__c = null;
        opp15.Lost_Outcome__c = 'Other';
        oppList.add(opp15);
        
        Opportunity  opp16 = new Opportunity ();
        opp16.name='qualification test';
        opp16.StageName='Closed-Lost';
        opp16.Type='Finance Solution';
        opp16.CloseDate =  system.today()+30;
        opp16.RecordTypeId= OppRecordTypeId;
        opp16.contact__c=cons[15].id;
        opp16.ContactId=cons[15].id;
        opp16.Pricebook2Id = Test.getStandardPricebookId();
        opp16.LBS_Promo_Code__c = null;
        opp16.Lost_Outcome__c = 'Other';
        oppList.add(opp16);
        
        Opportunity  opp17 = new Opportunity ();
        opp17.name='qualification test';
        opp17.StageName='Closed-Lost';
        opp17.Type='LPL Assurance';
        opp17.CloseDate =  system.today()+30;
        opp17.RecordTypeId= OppRecordTypeId;
        opp17.contact__c=cons[16].id;
        opp17.ContactId=cons[16].id;
        opp17.Pricebook2Id = Test.getStandardPricebookId();
        opp17.LBS_Promo_Code__c = null;
        opp17.Lost_Outcome__c = 'Other';
        oppList.add(opp17);
        
        
        Opportunity  opp18 = new Opportunity ();
        opp18.name='qualification test';
        opp18.StageName='Closed-Lost';
        opp18.Type='M&A Solution-Premium Buyer Program';
        opp18.CloseDate =  system.today()+30;
        opp18.RecordTypeId= OppRecordTypeId;
        opp18.contact__c=cons[17].id;
        opp18.ContactId=cons[17].id;
        opp18.Pricebook2Id = Test.getStandardPricebookId();
        opp18.LBS_Promo_Code__c = null;
        opp18.Lost_Outcome__c = 'Other';
        oppList.add(opp18);

        Opportunity  opp19 = new Opportunity ();
        opp19.name='qualification test';
        opp19.StageName='Closed-Lost';
        opp19.Type='Resilience Plan';
        opp19.CloseDate =  system.today()+30;
        opp19.RecordTypeId= OppRecordTypeId;
        opp19.contact__c=cons[18].id;
        opp19.ContactId=cons[18].id; 
        opp19.Pricebook2Id = Test.getStandardPricebookId();
        opp19.LBS_Promo_Code__c = null;
        opp19.Lost_Outcome__c = 'Other';
        oppList.add(opp19);
        
                      
        INSERT oppList;
        
        oppList[0].StageName='Engaged opportunity';
        oppList[1].StageName='Engaged opportunity';
        oppList[2].StageName='Engaged opportunity';
        UPDATE oppList;
        
        Test.stopTest();
    }         
}

 /*******************CH-02 End******************************/