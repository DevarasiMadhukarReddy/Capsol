/*
Trigger Name            : MergecontactpageController_Test
Description             :Test Class for MergecontactpageController_Test
Developer Name          : Vaibhav jain
Created Date            : 9/28/2018

##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
*/
@isTest(SeeAllData=false)
public class MergecontactpageController_Test {
    @testSetup
    public static void testDataSetup(){
        Trigger_Bypass__c tbp = LPL_testDataSetUpUtility.createTriggerByPass('Contact',False);
        insert tbp;
    }
    
    public static testmethod void unitTest1(){
        Id contactProspectRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
        List<Contact> conList1 = new List<Contact>();
        // Create 2 contacts with matching UniqueKey
        for(integer i=1;i<=2;i++){
            conList1.add(new Contact(Prospect_Status__c='A',Recruiter_Probability__c=1,
                                     Highest_Stage_Reached__c='A',Had_Tech_Demo__c=false,Had_RD_Conversation__c=false,
                                     Had_HOV__c=false,Dually_Registered__c=false,Non_Producer__c=false,Sell_Against_Details__c='Test',
                                     Smart_List_Segment__c='A',
                                     DoNotCall=false,Do_Not_Mail__c=false,Discovery_Contact_Address_1__c='Addr1'+i,
                                     Discovery_Contact_Address_2__c='Addr2'+i,Discovery_Home_Address_1__c='Addr1'+i,
                                     Discovery_Home_Address_2__c='Addr2'+i,CFP__c=true,ChFC__c=true,
                                     Pref_Name__c='Test Pref'+i,Email_Unknown__c=false,
                                     Comments__c='Test Comment'+i,Form_Phone__c='10000'+i,
                                     LPL_Magazine__c=true,Email='test@lpl.com',
                                     Title='Developer',Status_notes__c ='Notes',phone='21285',
                                     mobilePhone='456',fax='789',crd_number__c='12345',FirstName='Test',LastName='Contact',
                                     Data_Link2__DDL_RepID__c='100'+i,recordTypeId = contactProspectRecordType,
                                     Discovery_Email_Personal_Type__c='test@test.com',Lead_Source__c='Banner',
                                     GDC_from_Discovery_database__c='Test',GDC_from_other_source__c='Test',pi__campaign__c='Text',
                                     Discovery_Email_Business_Type__c='test@test.com'));
        }
        insert conList1;
        Contact c = conList1[0];
        //System.assertEquals('Contact21285', c.UniqueKey__c);
        Test.setCurrentPage(Page.MergeContactControllerVF);
        ApexPages.currentPage().getParameters().put('recordID', String.valueOf(c.Id));
        System.currentPagereference().getParameters().put('conid',String.valueOf(c.Id));
        System.currentPagereference().getParameters().put('Had Tech Demo', String.valueOf(c.Had_Tech_Demo__c));
        System.currentPagereference().getParameters().put('Highest Stage Reached', String.valueOf(c.Highest_Stage_Reached__c));
        System.currentPagereference().getParameters().put('Recruiter Probability', String.valueOf(c.Recruiter_Probability__c));
        System.currentPagereference().getParameters().put('duallyRegistered', String.valueOf(c.Dually_Registered__c));
        System.currentPagereference().getParameters().put('Had HOV', String.valueOf(c.Had_HOV__c));
        System.currentPagereference().getParameters().put('Had RD Conversation', String.valueOf(c.Had_RD_Conversation__c));
        //System.currentPagereference().getParameters().put('twitterAccount', String.valueOf(c.Twitter_Account__c));
        System.currentPagereference().getParameters().put('Non-Producer', String.valueOf(c.Non_Producer__c));
        System.currentPagereference().getParameters().put('sellAgainstDetails', String.valueOf(c.Sell_Against_Details__c));
        System.currentPagereference().getParameters().put('leadScore', String.valueOf(c.Smart_List_Segment__c));
        //System.currentPagereference().getParameters().put('referringAdvisorRepID', String.valueOf(c.Referring_Advisor_Rep_ID__c));
        System.currentPagereference().getParameters().put('doNotCall', String.valueOf(c.DoNotCall));
        System.currentPagereference().getParameters().put('doNotMail', String.valueOf(c.Do_Not_Mail__c));
        System.currentPagereference().getParameters().put('prefName', String.valueOf(c.Pref_Name__c));
        //System.currentPagereference().getParameters().put('pronunciation', String.valueOf(c.Pronunciation__c));
        System.currentPagereference().getParameters().put('emailUnknown', String.valueOf(c.Email_Unknown__c));
        System.currentPagereference().getParameters().put('formComments', String.valueOf(c.Comments__c));
        System.currentPagereference().getParameters().put('formPhone', String.valueOf(c.Form_Phone__c));
        //System.currentPagereference().getParameters().put('referralOverride', String.valueOf(c.Referral_Override__c));
        System.currentPagereference().getParameters().put('CFP', String.valueOf(c.CFP__c));
        System.currentPagereference().getParameters().put('ChFC', String.valueOf(c.ChFC__c));
        //System.currentPagereference().getParameters().put('assistantName', String.valueOf(c.AssistantName));
        //System.currentPagereference().getParameters().put('asstPhone', String.valueOf(c.AssistantPhone));
        System.currentPagereference().getParameters().put('email', String.valueOf(c.Email));
        System.currentPagereference().getParameters().put('Contact Record Type', String.valueOf(c.RecordTypeId));
        System.currentPagereference().getParameters().put('phone', String.valueOf(c.phone));
        System.currentPagereference().getParameters().put('LastName', String.valueOf(c.LastName));
        System.currentPagereference().getParameters().put('title', String.valueOf(c.title));
        System.currentPagereference().getParameters().put('status', String.valueOf(c.Status_Notes__c));
        //System.currentPagereference().getParameters().put('gender', String.valueOf(c.Gender__c));
        System.currentPagereference().getParameters().put('account', String.valueOf(c.AccountId));
        System.currentPagereference().getParameters().put('mobilePhone', String.valueOf(c.MobilePhone));
        //System.currentPagereference().getParameters().put('otherPhone', String.valueOf(c.otherPhone));
        System.currentPagereference().getParameters().put('fax', String.valueOf(c.fax));
        //System.currentPagereference().getParameters().put('dbaName', String.valueOf(c.DBA_Name__c));
        System.currentPagereference().getParameters().put('LPL Magazine', String.valueOf(c.LPL_Magazine__c));
        System.currentPagereference().getParameters().put('prospectStatus', String.valueOf(c.Prospect_Status__c));
        System.currentPagereference().getParameters().put('discoveryEmailPersonalType', String.valueOf(c.Discovery_Email_Personal_Type__c));
        System.currentPagereference().getParameters().put('Leadsource', String.valueOf(c.Lead_Source__c));
        System.currentPagereference().getParameters().put('CRD', String.valueOf(c.CRD_Number__c));
        System.currentPagereference().getParameters().put('gdcFromDiscoveryDatabase', String.valueOf(c.GDC_from_Discovery_database__c));
        System.currentPagereference().getParameters().put('gdcFromOtherSource', String.valueOf(c.GDC_from_other_source__c));
        System.currentPagereference().getParameters().put('discoveryEmailBusinessType', String.valueOf(c.Discovery_Email_Business_Type__c));
        MergecontactpageController mcc1 = new MergecontactpageController();
        String s = mcc1.getFields();
        mcc1.getContacts();
        mcc1.getSelected();
        mcc1.GetSelectedContacts();
        mcc1.selectcon();
        mcc1.Selectemail();
        mcc1.save();
        mcc1.Previous();
        mcc1.cancel();
        MergecontactpageController.Contactwrapper1 cw1 = new MergecontactpageController.Contactwrapper1(c);
    }
}