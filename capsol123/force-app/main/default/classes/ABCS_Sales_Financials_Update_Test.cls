@isTest(seeAllData = false)
private class ABCS_Sales_Financials_Update_Test {
    
    // added my madhukar 
    public static ABCS_Sales__c createABCSales(String name,Integer amount,String month, Id conId) {
        ABCS_Sales__c abcs = new ABCS_Sales__c(Name= name+ testDataSetUpUtility.getRandomUsername(7),
            Advisor_Name__c =conId ,Redemptions_Amount__c=amount,
            External_Id__c=testDataSetUpUtility.getRandomUsername(4),
            Sales_Amount__c=amount,Sales_Date__c=System.today(),
            Sales_Month__c=month,Sales_Net_Amount__c=amount);
        return abcs;
    }
    
    static testMethod void ABCS_Sales_Financials_Test () {
        Trigger_Bypass__c tbp = new Trigger_Bypass__c();
        tbp.name = 'Contact';
        tbp.IsOff__c = false;
        insert tbp;
        
        Account oAcct  = new Account ();
        oAcct.Name ='Account Test Record';
        insert oAcct;
        
        Contact C1= new Contact(AccountId = oAcct.Id,lastname=testDataSetUpUtility.getRandomUsername(7),email=testDataSetUpUtility.getRandomUsername(7)+'@lpltest.com');
        insert C1;
        
        Financials__c f1 = new Financials__c (name= testDataSetUpUtility.getRandomUsername(7) ,Advisor__c=C1.id);
        insert F1;  
        
        List<ABCS_Sales__c> abcsList = new List<ABCS_Sales__c>();
        
        ABCS_Sales__c s1=  createABCSales('Test',100,'Oct',C1.id);
        s1.Platform_Product__c='MWP';
        abcsList.add(s1);    
        
        ABCS_Sales__c s2=  createABCSales('Test',100,'Oct',C1.id);
        s2.Platform_Product__c='MS';
        abcsList.add(s2);        
        
        ABCS_Sales__c s3=  createABCSales('Test',100,'Oct',C1.id);
        s3.Platform_Product__c='OMP';
        abcsList.add(s3);        
        
        ABCS_Sales__c s4=  createABCSales('Test',100,'Oct',C1.id);
        s4.Platform_Product__c='PWP';
        abcsList.add(s4);         
        
        ABCS_Sales__c s5=  createABCSales('Test',100,'Oct',C1.id);
        s5.Platform_Product__c='SAM';
        abcsList.add(s5);          
        
        ABCS_Sales__c s6=  createABCSales('Test',100,'Oct',C1.id);
        s6.Platform_Product__c='SWM';
        abcsList.add(s6);

        ABCS_Sales__c s7=  createABCSales('Test',100,'Oct',C1.id);
        s7.Platform_Product__c='GWP';
        abcsList.add(s7);       
        
        Test.StartTest();
        insert abcsList;
        update abcsList;
        delete abcsList;
        Test.StopTest();    
    } 
}