@isTest(seeAllData = false)
private class LPL_ABCS_TriggerTest {
    
    @testSetup static void UserData()
    {
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'LPL IAS_LeadPilot'].Id,
            LastName = 'Mackie',
            Email = 'kara.mackie@lpl.com',
            Username = 'kara.mackie@lpl.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'Internal Regional Director',
            Alias = 'kmack',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id
        );
        insert u;
    }
    public static void testData()
    { 
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name='Contact';
        tbp.IsOff__c = False;
        insert tbp;
        
        Contact_Merge_User_Assignment__c mergeCon =new Contact_Merge_User_Assignment__c();
        mergeCon.Name='Kara Mackie';
        mergeCon.User_ID__c='005U0000004h0p7';
        insert mergeCon;
        String userAssign=Contact_Merge_User_Assignment__c.getInstance('Kara Mackie').User_ID__c;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        insert oAcct;
        Contact C1= new Contact(AccountId = oAcct.Id,lastname='ABCStesting',email='ABCStesting@lpltest.com',Internal_Recruiter_IRD__c=userAssign);
        
        insert C1;
        Financials__c f1 = new Financials__c (name= testDataSetUpUtility.getRandomUsername(7) ,Advisor__c=C1.id);
        insert F1;  
    }
    static testMethod void ABCS_Sales_Financials_TestGWP () 
    {
        testData();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s7=  new ABCS_Sales__c(
            Name= 'TestGWP '/*+ testDataSetUpUtility.getRandomUsername(7)*/
            , Advisor_Name__c =c.id ,
            Platform_Product__c='GWP',
            Redemptions_Amount__c=0,
            Sales_Amount__c=0,
            Sales_Date__c=System.today(),
            Sales_Month__c='Oct',
            Sales_Net_Amount__c=0            
        ); 
        
        abcsList.add(s7);     
        insert abcsList;
        ABCS_Sales__c Agwp =[SELECT ID,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where Name='TestGWP' Limit 1];
        Agwp.Sales_Amount__c=200;
        Agwp.Sales_Net_Amount__c=150;  
        Agwp.Redemptions_Amount__c=50;
        update Agwp;
        Test.StartTest();
        //L_AbcsTriggerGateway lplabcs = NEW LPL_AbcsTriggerGateway();
       //plabcs.doInsertOperation();
        Test.StopTest();    
        
    }
    static testMethod void ABCS_Sales_Financials_TestSWM () 
    {
        testData();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s7=  new ABCS_Sales__c(
            Name= 'TestSWM '/*+ testDataSetUpUtility.getRandomUsername(7)*/
            , Advisor_Name__c =c.id ,
            Platform_Product__c='SWM',
            Redemptions_Amount__c=100,
            Sales_Amount__c=200,
            Sales_Date__c=System.today(),
            Sales_Month__c='Oct',
            Sales_Net_Amount__c=200            
        ); 
        
        abcsList.add(s7);     
        insert abcsList;
        Test.StartTest();
       //PL_AbcsTriggerGateway lplabcs = NEW LPL_AbcsTriggerGateway();
     
        Test.StopTest();    
        
    }
    static testMethod void ABCS_Sales_Financials_TestOMP () 
    {
        testData();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s7=  new ABCS_Sales__c(
            Name= 'Test OMP'/*+ testDataSetUpUtility.getRandomUsername(7)*/
            , Advisor_Name__c =c.id ,
            Platform_Product__c='OMP',
            Redemptions_Amount__c=100,
            Sales_Amount__c=200,
            Sales_Date__c=System.today(),
            Sales_Month__c='Oct',
            Sales_Net_Amount__c=200            
        ); 
        
        abcsList.add(s7);     
        insert abcsList;
        Test.StartTest();
       //PL_AbcsTriggerGateway lplabcs = NEW LPL_AbcsTriggerGateway();
       //plabcs.doInsertOperation();
        Test.StopTest();    
        
    }
    
    static testMethod void ABCS_Sales_Financials_TestPWP () 
    {
        testData();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s7=  new ABCS_Sales__c(
            Name= 'TestPWP '/*+ testDataSetUpUtility.getRandomUsername(7)*/
            , Advisor_Name__c =c.id ,
            Platform_Product__c='PWP',
            Redemptions_Amount__c=100,
            Sales_Amount__c=200,
            Sales_Date__c=System.today(),
            Sales_Month__c='Oct',
            Sales_Net_Amount__c=200            
        ); 
        
        abcsList.add(s7);     
        insert abcsList;
        Test.StartTest();
        //L_AbcsTriggerGateway lplabcs = NEW LPL_AbcsTriggerGateway();
       //plabcs.doInsertOperation();
        Test.StopTest();    
        
    }
    static testMethod void ABCS_Sales_Financials_TestMWP () 
    {
        testData();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s7=  new ABCS_Sales__c(
            Name= 'TestMWP '/*+ testDataSetUpUtility.getRandomUsername(7)*/
            , Advisor_Name__c =c.id ,
            Platform_Product__c='MWP',
            Redemptions_Amount__c=100,
            Sales_Amount__c=200,
            Sales_Date__c=System.today(),
            Sales_Month__c='Oct',
            Sales_Net_Amount__c=200            
        ); 
        
        abcsList.add(s7);     
        insert abcsList;
        Test.StartTest();
      //LPL_AbcsTriggerGateway lplabcs = NEW LPL_AbcsTriggerGateway();
       
        Test.StopTest();    
        
    }
    
    static testMethod void ABCS_Sales_Financials_TestSAM () 
    {
        testData();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s7=  new ABCS_Sales__c(
            Name= 'Testsam '/*+ testDataSetUpUtility.getRandomUsername(7)*/
            , Advisor_Name__c =c.id ,
            Platform_Product__c='SAM',
            Redemptions_Amount__c=100,
            Sales_Amount__c=200,
            Sales_Date__c=System.today(),
            Sales_Month__c='Oct',
            Sales_Net_Amount__c=200            
        ); 
        
        abcsList.add(s7);     
        insert abcsList;
        Test.StartTest();
        //L_AbcsTriggerGateway lplabcs = NEW LPL_AbcsTriggerGateway();
       
        Test.StopTest();    
        
    }
    
    static testMethod void ABCS_Sales_Financials_TestMS () 
    {
        testData();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s7=  new ABCS_Sales__c(
            Name= 'TestMS '/*+ testDataSetUpUtility.getRandomUsername(7)*/
            , Advisor_Name__c =c.id ,
            Platform_Product__c='MS',
            Redemptions_Amount__c=100,
            Sales_Amount__c=200,
            Sales_Date__c=System.today(),
            Sales_Month__c='Oct',
            Sales_Net_Amount__c=200            
        ); 
        
        abcsList.add(s7);     
        insert abcsList;
        Test.StartTest();
     
        Test.StopTest();    
        
    }
    
    static testMethod void ABCS_Sales_Financials_TestGWPUpdate () {
        testData();
      
          Test.StartTest();
        Contact c =[select id from contact where email='ABCStesting@lpltest.com'];
        List<ABCS_Sales__c> abcsList1= new List<ABCS_Sales__c>();
        ABCS_Sales__c s7=  new ABCS_Sales__c(Name= 'GWPuPDATE '/*+ testDataSetUpUtility.getRandomUsername(7)*/
                                             , Advisor_Name__c =c.id ,
                                             Platform_Product__c='GWP',
                                             Redemptions_Amount__c=100,
                                             Sales_Amount__c=200,
                                             Sales_Date__c=System.today(),
                                             Sales_Month__c='Oct',
                                             Sales_Net_Amount__c=200  
                                             
                                            ); 
        abcsList1.add(s7);
        
        ABCS_Sales__c s8=  new ABCS_Sales__c(Name= 'MS'/*+ testDataSetUpUtility.getRandomUsername(7)*/
                                             , Advisor_Name__c =c.id ,
                                             Platform_Product__c='MS',
                                             Redemptions_Amount__c=100,
                                             Sales_Amount__c=200,
                                             Sales_Date__c=System.today(),
                                             Sales_Month__c='Oct',
                                             Sales_Net_Amount__c=200  
                                             
                                            ); 
        
          abcsList1.add(s8);
          ABCS_Sales__c s9=  new ABCS_Sales__c(Name= 'SAM'/*+ testDataSetUpUtility.getRandomUsername(7)*/
                                             , Advisor_Name__c =c.id ,
                                             Platform_Product__c='SAM',
                                             Redemptions_Amount__c=100,
                                             Sales_Amount__c=200,
                                             Sales_Date__c=System.today(),
                                             Sales_Month__c='Oct',
                                             Sales_Net_Amount__c=200  
                                             
                                            ); 
        abcsList1.add(s9);     
       
        ABCS_Sales__c s10=  new ABCS_Sales__c(Name= 'PWP'/*+ testDataSetUpUtility.getRandomUsername(7)*/
                                             , Advisor_Name__c =c.id ,
                                             Platform_Product__c='PWP',
                                             Redemptions_Amount__c=100,
                                             Sales_Amount__c=200,
                                             Sales_Date__c=System.today(),
                                             Sales_Month__c='Oct',
                                             Sales_Net_Amount__c=200  
                                             
                                            ); 
        abcsList1.add(s10); 
        
          ABCS_Sales__c s11=  new ABCS_Sales__c(Name= 'SWM'/*+ testDataSetUpUtility.getRandomUsername(7)*/
                                             , Advisor_Name__c =c.id ,
                                             Platform_Product__c='SWM',
                                             Redemptions_Amount__c=100,
                                             Sales_Amount__c=200,
                                             Sales_Date__c=System.today(),
                                             Sales_Month__c='Oct',
                                             Sales_Net_Amount__c=200  
                                             
                                            ); 
        abcsList1.add(s11); 
        
        
         ABCS_Sales__c s12=  new ABCS_Sales__c(Name= 'OMP'/*+ testDataSetUpUtility.getRandomUsername(7)*/
                                             , Advisor_Name__c =c.id ,
                                             Platform_Product__c='OMP',
                                             Redemptions_Amount__c=100,
                                             Sales_Amount__c=200,
                                             Sales_Date__c=System.today(),
                                             Sales_Month__c='Oct',
                                             Sales_Net_Amount__c=200  
                                             
                                            ); 
        abcsList1.add(s12); 
        
          insert abcsList1; 
        
        List<ABCS_Sales__c> updateList=new List<ABCS_Sales__c>();
        ABCS_Sales__c A1 =[SELECT ID,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where Name='GWPuPDATE' Limit 1];
        A1.Sales_Amount__c=300;
        A1.Sales_Net_Amount__c=250;  
        A1.Redemptions_Amount__c=150;
       

 updateList.add(A1);
          
    
        
        ABCS_Sales__c A2 =[SELECT ID,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where Name='MS' Limit 1];
        A2.Sales_Amount__c=300;
        A2.Sales_Net_Amount__c=250;  
        A2.Redemptions_Amount__c=150;
   
         updateList.add(A2);
               
        ABCS_Sales__c A3 =[SELECT ID,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where Name='SAM' Limit 1];
        A3.Sales_Amount__c=300;
        A3.Sales_Net_Amount__c=250;  
        A3.Redemptions_Amount__c=150;
      
        updateList.add(A3);
        
         
        ABCS_Sales__c A4 =[SELECT ID,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where Name='SWM' Limit 1];
        A4.Sales_Amount__c=300;
        A4.Sales_Net_Amount__c=250;  
        A4.Redemptions_Amount__c=150;
      
        updateList.add(A4);
          ABCS_Sales__c A5 =[SELECT ID,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where Name='PWP' Limit 1];
        A5.Sales_Amount__c=300;
        A5.Sales_Net_Amount__c=250;  
        A5.Redemptions_Amount__c=150;
      
        updateList.add(A5);
        
         ABCS_Sales__c A6 =[SELECT ID,Sales_Amount__c,Sales_Net_Amount__c,Redemptions_Amount__c from ABCS_Sales__c where Name='OMP' Limit 1];
        A6.Sales_Amount__c=300;
        A6.Sales_Net_Amount__c=250;  
        A6.Redemptions_Amount__c=150;
      
        updateList.add(A6);
        
         
        
        update updateList;
        
      
       
     
        Test.StopTest();    
        
    }
    
}