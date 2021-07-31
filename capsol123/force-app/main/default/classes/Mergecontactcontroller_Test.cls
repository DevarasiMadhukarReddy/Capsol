/*
Trigger Name            :Mergecontactcontroller_Test
Description             :Test Class for Mergecontactcontroller_Test
Developer Name          : Vaibhav jain
Created Date            : 9/28/2018

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
*/

@isTest(SeeAllData=false)
public class Mergecontactcontroller_Test {
    @testSetup
    public static void testDataSetup(){
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
    }
    
    public static testmethod void getResult(){
        Contact con = new Contact(LastName='Test');
        insert con;
        
        Test.startTest();
        PageReference pageRef = Page.MergeContactPageVF;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(con.Id));
        Mergecontactcontroller mc = new Mergecontactcontroller(sc);
        mc.Navigate();
        delete con;
        system.assertEquals(true, mc.testBoolCheck);
        Test.stopTest();
    }
}