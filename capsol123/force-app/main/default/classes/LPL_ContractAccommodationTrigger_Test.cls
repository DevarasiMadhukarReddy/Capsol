@isTest(seeAllData = false)
public class LPL_ContractAccommodationTrigger_Test {
    
    
    static testMethod void validate() {
        
        Test.startTest();
        List<Contract_Accommodation__c> accommodationList=new List<Contract_Accommodation__c>();
        List<Contract_Accommodation__c> accommodationUpdateList=new List<Contract_Accommodation__c>();
        list<Contract_Accommodations__c> customSettingList =new List <Contract_Accommodations__c>();
        list<Contract_Accommodations__c> customSettingGetList =new List <Contract_Accommodations__c>();
        
        
        User u = new User(
                         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                         LastName = 'last',
                         Email = 'puser000@amamama.com',
                         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                         CompanyName = 'TEST',
                         Title = 'title',
                         Alias = 'alias',
                         TimeZoneSidKey = 'America/Los_Angeles',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         LocaleSidKey = 'en_US',
                         CA_Created_By_Manager__c=true
                         //UserRoleId = r.Id
                    );
        insert u;
        
        
        
        Contract_Accommodations__c customSettingObj1=new Contract_Accommodations__c();
        customSettingObj1.Name='Branchnet (Core)';
        customSettingObj1.Gross_Profit__c=900;
        customSettingList.add(customSettingObj1); 
        insert customSettingObj1;
        Contract_Accommodations__c customSettingObj2=new Contract_Accommodations__c();
        customSettingObj2.Name='Albridge';
        customSettingObj2.Gross_Profit__c=2820;
        customSettingList.add(customSettingObj2); 
        insert customSettingObj2;
        
        Contract_Accommodations__c customSettingObj3=new Contract_Accommodations__c();
        customSettingObj3.Name='Wealthvision';
        customSettingObj3.Gross_Profit__c=3600;
        customSettingList.add(customSettingObj3); 
        insert customSettingObj3;
         Contract_Accommodations__c customSettingObj333=new Contract_Accommodations__c();
            customSettingObj333.Name='Salesforce';
            customSettingObj333.Gross_Profit__c=3800;
            customSettingList.add(customSettingObj333); 
            insert customSettingObj333;
        Contract_Accommodations__c customSettingObj4=new Contract_Accommodations__c();
        customSettingObj4.Name='Enhanced Trading - Reballancer Add-on';
        customSettingObj4.Gross_Profit__c=1800;
        customSettingList.add(customSettingObj4); 
        insert customSettingObj4;
        
        Contract_Accommodations__c customSettingObj5=new Contract_Accommodations__c();
        customSettingObj5.Name='Portfolio Manager';
        customSettingObj5.Gross_Profit__c=1150;
        customSettingList.add(customSettingObj5);
        
        insert customSettingObj5;
        
        Contract_Accommodations__c customSettingObj11=new Contract_Accommodations__c();
        customSettingObj11.Name='Orion';
        customSettingObj11.Gross_Profit__c=900;
        customSettingList.add(customSettingObj11);
        
        insert customSettingObj11;
        
        Contract_Accommodations__c customSettingObj8=new Contract_Accommodations__c();
        customSettingObj8.Name='Orion';
        customSettingObj8.Gross_Profit__c=900;
        customSettingList.add(customSettingObj8);
        
        insert customSettingObj8;
        
        Contract_Accommodations__c customSettingObj9=new Contract_Accommodations__c();
        customSettingObj9.Name='Retirement Partners Tool';
        customSettingObj9.Gross_Profit__c=4800;
        customSettingList.add(customSettingObj9);
        
        insert customSettingObj9;
        
        Contract_Accommodations__c customSettingObj21=new Contract_Accommodations__c();
        customSettingObj21.Name='HOS';
        customSettingObj21.Gross_Profit__c=4800;
        customSettingList.add(customSettingObj21);
        insert customSettingObj21;
        
        Contract_Accommodations__c customSettingObj22=new Contract_Accommodations__c();
        customSettingObj22.Name='E&O';
        customSettingObj22.Gross_Profit__c=3650;
        customSettingList.add(customSettingObj22);
        
        insert customSettingObj22;
        
        Contract_Accommodations__c customSettingObj30=new Contract_Accommodations__c();
        customSettingObj30.Name='Resource';
        customSettingObj30.Gross_Profit__c=2100;
        customSettingList.add(customSettingObj30);
        
        insert customSettingObj30;
        
        Contract_Accommodations__c customSettingObj23=new Contract_Accommodations__c();
        customSettingObj23.Name='Split Rep-ID';
        customSettingObj23.Gross_Profit__c=100;
        customSettingList.add(customSettingObj23);
        insert customSettingObj23;
        // extra components
        // 
        Contract_Accommodations__c customSettingObj24=new Contract_Accommodations__c();
        customSettingObj24.Name='HOS (through 2018)';
        customSettingObj24.Gross_Profit__c=4800;
        customSettingList.add(customSettingObj24);
        insert customSettingObj24;
        
        Contract_Accommodations__c customSettingObj25=new Contract_Accommodations__c();
        customSettingObj25.Name='Tech, Resource, HOS (3 years from hire)';
        customSettingObj25.Gross_Profit__c=7800;
        customSettingList.add(customSettingObj25);
      
        
        Contract_Accommodations__c customSettingObj26=new Contract_Accommodations__c();
        customSettingObj26.Name='Tech, Resource, HOS, E&O (3 years from hire)';
        customSettingObj26.Gross_Profit__c=7800;
        customSettingList.add(customSettingObj26);
     
        
        Contract_Accommodations__c customSettingObj27=new Contract_Accommodations__c();
        customSettingObj27.Name='Portfolio Review Tool';
        customSettingObj27.Gross_Profit__c=1150;
        customSettingList.add(customSettingObj27);
        insert customSettingObj27;
        
        Contract_Accommodations__c customSettingObj28=new Contract_Accommodations__c();
        customSettingObj28.Name='Reuters';
        customSettingObj28.Gross_Profit__c=2244;
        customSettingList.add(customSettingObj28);
        
         insert customSettingObj28;
        Contract_Accommodations__c customSettingObj29=new Contract_Accommodations__c();
        customSettingObj29.Name='Morningstar';
        customSettingObj29.Gross_Profit__c=2100;
        customSettingList.add(customSettingObj29);
        insert customSettingObj29;
        
        Contract_Accommodations__c customSettingObj31=new Contract_Accommodations__c();
        customSettingObj31.Name='S&P Package';
        customSettingObj31.Gross_Profit__c=660;
        customSettingList.add(customSettingObj31);
        
        /*Contract_Accommodations__c customSettingObj32=new Contract_Accommodations__c();
customSettingObj32.Name='CRM';
customSettingObj32.Gross_Profit__c=780;
customSettingList.add(customSettingObj32);*/
        
        //Test data for this custom setting GL_Account_and_GL_Department_Debited__c
        List<GL_Account_and_GL_Department_Debited__c> GLCustomList=new List<GL_Account_and_GL_Department_Debited__c>();
        
        GL_Account_and_GL_Department_Debited__c GlCustomObj1=new GL_Account_and_GL_Department_Debited__c();
        GlCustomObj1.Name='Core Business Development';
        GlCustomObj1.GL_Account__c='812150';
        GlCustomObj1.GL_Department__c='4141';
        GLCustomList.add(GlCustomObj1);
        
        GL_Account_and_GL_Department_Debited__c GlCustomObj2=new GL_Account_and_GL_Department_Debited__c();
        GlCustomObj2.Name='IAS Business Consulting';
        GlCustomObj2.GL_Account__c='812152';
        GlCustomObj2.GL_Department__c='4131';
        GLCustomList.add(GlCustomObj2);
        
        GL_Account_and_GL_Department_Debited__c GlCustomObj3=new GL_Account_and_GL_Department_Debited__c();
        GlCustomObj3.Name='Inst. Business Development';
        GlCustomObj3.GL_Account__c='812150';
        GlCustomObj3.GL_Department__c='4224';
        GLCustomList.add(GlCustomObj3);
        
        GL_Account_and_GL_Department_Debited__c GlCustomObj4=new GL_Account_and_GL_Department_Debited__c();
        GlCustomObj4.Name='IS Business Consulting';
        GlCustomObj4.GL_Account__c='812110';
        GlCustomObj4.GL_Department__c='4231';
        GLCustomList.add(GlCustomObj4);
        
        insert GLCustomList;
        
        List<Contact> contactList= new List<Contact>();
        for(Integer i=0; i<customSettingList.size(); i++)
        {
            Contact contactObj = new Contact();
            contactObj.LastName ='Name'+i;
            
            contactList.add(contactObj);
        }
        
        for(Integer i=0; i<customSettingList.size(); i++)
        {
            Contract_Accommodation__c Obj=new Contract_Accommodation__c();
            
            
            Obj.Accommodation_Requested__c='Yes';
             obj.Created_By_Manager__c = u.id;
            //** Start --Getting value from custom setting and update in GL Account  and GL Department on insert Operation
            if(i<4){
                Obj.Requesting_Dept__c= GLCustomList[i].Name;
                
                if(Obj.Requesting_Dept__c.equalsIgnoreCase('Core Business Development')){
                    
                    Obj.GL_Account__c=String.Valueof(GLCustomList[i].GL_Account__c);
                    Obj.GL_Department__c=String.Valueof(GLCustomList[i].GL_Department__c);
                }   
                
            }
            //** End --Getting value from custom setting and update in GL Account  and GL Department on insert Operation
            
            Obj.Accommodation_Detail__c=customSettingList[i].Name;                
            if(Obj.Accommodation_Detail__c.equalsIgnoreCase('HOS')|| Obj.Accommodation_Detail__c.equalsIgnoreCase('E&O')||Obj.Accommodation_Detail__c.equalsIgnoreCase('Resource')||Obj.Accommodation_Detail__c.equalsIgnoreCase('Split Rep-ID'))
            {
                
                Obj.Accommodation_Type_Term__c='Fee Waivers';               
                
            }
            else if(Obj.Accommodation_Detail__c.equalsIgnoreCase('Tech, Resource, HOS (3 years from hire)')|| Obj.Accommodation_Detail__c.equalsIgnoreCase('Tech, Resource, HOS, E&O (3 years from hire)')||Obj.Accommodation_Detail__c.equalsIgnoreCase('HOS (through 2018)')) {
                Obj.Accommodation_Type_Term__c='Recruiting Initiatives';
            }
            else{
                
                Obj.Accommodation_Type_Term__c='Technology';
                
            }
             Obj.Requesting_Dept__c='Core Business Development';
            Obj.Start_Date__c=System.today();
            Obj.End_Date__c=System.today();
            // Obj.Approver_Title__c='VP';
            Obj.Accommodation_Status__c='Approved';
            Obj.Payment_method__c='Check';
            Obj.Accommodation_Frequency__c='Monthly';
            Obj.Does_credit_stay_with_individual_or_flow__c='Individual';  
            Obj.Business_Consultant_RM__c=contactList[i].Business_Consultant_RM__c;
            obj.Annual_GDP_Impact__c=customSettingList[i].Gross_Profit__c;
            Obj.Accommodation_Type_status__c='New';
                        
            accommodationList.add(Obj);       
        }
        insert accommodationList;
        
        accommodationUpdateList=[Select GL_Department__c,GL_Account__c,Requesting_Dept__c,Business_Consultant_RM__c,Accommodation_Detail__c from Contract_Accommodation__c where Id In:accommodationList];
        customSettingGetList=[Select Name, Gross_Profit__c from Contract_Accommodations__c where Id In:customSettingList];
        
        for(Integer i=0; i<customSettingGetList.size(); i++){
            accommodationUpdateList[i].Business_Consultant_RM__c=contactList[i].Business_Consultant_RM__c;
            if(customSettingGetList[i].Name==accommodationUpdateList[i].Accommodation_Detail__c){
                
                accommodationUpdateList[i].Annual_GDP_Impact__c =customSettingGetList[i].Gross_Profit__c;  
                
            }
        }
        
        
        for(Integer i=0; i<accommodationUpdateList.size(); i++) {
            
            
            //** Start --Getting value from custom setting and update in GL Account  and GL Department on update Operation
            if(i<4){
                accommodationUpdateList[i].Requesting_Dept__c= GLCustomList[i].Name;
                
                if(accommodationUpdateList[i].Requesting_Dept__c.equalsIgnoreCase('Core Business Development')){
                    
                    accommodationUpdateList[i].GL_Account__c=String.Valueof(GLCustomList[i].GL_Account__c);
                    accommodationUpdateList[i].GL_Department__c=String.Valueof(GLCustomList[i].GL_Department__c);
                }   
                
            }
            //** End --Getting value from custom setting and update in GL Account  and GL Department on update Operation
            
            
            
        }
        
        /*******************************************************/
        ID nonCARecordTypeId = Schema.SObjectType.Contract_Accommodation__c.getRecordTypeInfosByName().get('Non-CA One-Time Credit').getRecordTypeId();
        List<Contract_Accommodation__c> newAccommodationList=new List<Contract_Accommodation__c>();
        List<Contract_Accommodation__c> newUpdateAccommodationList=new List<Contract_Accommodation__c>();
        
            Contract_Accommodation__c ac1 =new Contract_Accommodation__c();
            ac1.RecordTypeID = nonCARecordTypeId;
            ac1.Requesting_Dept__c = 'Core Business Development';
            ac1.GL_Account__c = '812150';
            ac1.GL_Department__c = '4141';
            ac1.Region__c='Core';
            ac1.Created_By_Manager__c = u.id;
            ac1.Credit_Category__c = 'Processing';
            ac1.Credit_Amount_Requested__c = 500;
            ac1.Does_credit_stay_with_individual_or_flow__c = 'Individual';
            ac1.Advisor_Statement_Description__c = 'Test';
            ac1.Additional_Details__c = 'Test Details';
            ac1.Approver_Title__c = '';
            ac1.Credit_Status__c='Mgr Approved';
            //ac1.Region__c='East';
            newAccommodationList.add(ac1);
        
            Contract_Accommodation__c ac2 =new Contract_Accommodation__c();
            ac2.RecordTypeID = nonCARecordTypeId;
            ac2.Requesting_Dept__c = 'Inst. Business Development';
            ac2.GL_Account__c = '812150';
            ac2.GL_Department__c = '4224';
            ac2.Region__c='Core';
            ac2.Created_By_Manager__c = u.id;
            ac2.Credit_Category__c = 'Processing';
            ac2.Credit_Amount_Requested__c = 500;
            ac2.Does_credit_stay_with_individual_or_flow__c = 'Individual';
            ac2.Advisor_Statement_Description__c = 'Test';
            ac2.Additional_Details__c = 'Test Details';
            //ac2.Region__c='East';
            newAccommodationList.add(ac2);
        
            Contract_Accommodation__c ac3 =new Contract_Accommodation__c();
            ac3.RecordTypeID = nonCARecordTypeId;
            ac3.Requesting_Dept__c = 'IAS Business Consulting';
            ac3.GL_Account__c = '812152';
            ac3.GL_Department__c = '4131';
            ac3.Region__c='Core';
            ac3.Created_By_Manager__c = u.id;
            ac3.Credit_Category__c = 'Processing';
            ac3.Credit_Amount_Requested__c = 500;
            ac3.Does_credit_stay_with_individual_or_flow__c = 'Individual';
            ac3.Advisor_Statement_Description__c = 'Test';
            ac3.Additional_Details__c = 'Test Details';
            ac3.Region__c='East';
            newAccommodationList.add(ac3);
        
            Contract_Accommodation__c ac4 =new Contract_Accommodation__c();
            ac4.RecordTypeID = nonCARecordTypeId;
            ac4.Requesting_Dept__c = 'IS Business Consulting';
            ac4.GL_Account__c = '812110';
            ac4.GL_Department__c = '4231';
            ac4.Region__c='Core';
            ac4.Created_By_Manager__c = u.id;
            ac4.Credit_Category__c = 'Processing';
            ac4.Credit_Amount_Requested__c = 500;
            ac4.Does_credit_stay_with_individual_or_flow__c = 'Individual';
            ac4.Advisor_Statement_Description__c = 'Test';
            ac4.Additional_Details__c = 'Test Details';
            //ac4.Region__c='East';
            newAccommodationList.add(ac4);
           
            insert newAccommodationList;
        
        newUpdateAccommodationList = [Select Id, RecordTypeID, Requesting_Dept__c, GL_Department__c, GL_Account__c, Credit_Status__c, Approved_Declined_By__c, Approver_Title__c from Contract_Accommodation__c where RecordTypeID =: nonCARecordTypeId ];
        
        for(Contract_Accommodation__c ca : newUpdateAccommodationList){
            
            if( ca.Credit_Status__c=='Mgr Approved' && (ca.Approved_Declined_By__c==NULL || ca.Approver_Title__c==NULL)){
                
                ca.addError('Please add Approver Title AND Approved/Declined By before approve. Please Click Here to retun in the detail page of the CA record');
            }
        }
        
         Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Prospect').getRecordTypeId();
Id BackendTAProposalRecordTypeId = Schema.SObjectType.Loan_Application__c.getRecordTypeInfosByDeveloperName().get('Backend_TA').getRecordTypeId();
         Id BackendTAProposalRecordTypeId1 = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('Backend_Proposal').getRecordTypeId();
         Account a1 = new Account(Name = 'Test Account');
        insert a1;        
        Contact ct1= new Contact(AccountId = a1.id, firstname = '', lastname = 'lastname ' ,
                                 Insurance_Territory__c = 'Test Territory', RecordTypeId = conRecordTypeId , 
                                 HasOptedOutOfEmail = false, ELQ_Marketing_Email_Opt_Out__c = false,Rep_Status__c ='Active',
                                 ownerId=Userinfo.getUserId(),Channel_owner__c = 'IS BD', Discover_Zip_Code__c = '84081',
                                 Inactive_Reason__c='Inactive - Compliance', PardotActivityInput__c ='MA1', 
                                 Internal_Recruiter_IRD__c = UserInfo.getUserID(), Previous_PardotAcivity_Value__c = 'MA1',
                                 Source_Type_Prospect__c ='Transitions',Lead_Source__c='Transitions',CLO_Customer_ID__c=null);
        insert ct1;
        
        
           Loan_Application__c loanApp3 = new Loan_Application__c();        
            loanApp3.Primary_Contact_Name__c = ct1.id;
            loanApp3.Status__c = 'Initiated';
            loanApp3.SUM_NNA__c=456;
            loanApp3.Backend_Hurdle__c=234;
            loanApp3.Backend_Bps__c=2;
            loanApp3.Requested_Loan_Amount__c=444;
            loanApp3.RecordTypeId=BackendTAProposalRecordTypeId;
            insert loanApp3;
            
            Proposal_Offer__c prolist = new Proposal_Offer__c();
            prolist.LoanApp_MD__c = loanApp3.Id;
            prolist.RecordTypeId =  BackendTAProposalRecordTypeId1;
            prolist.TA_Amount__c = loanApp3.Requested_Loan_Amount__c;
            prolist.Max_TA_Amount__c = loanApp3.Requested_Loan_Amount__c;
            prolist.SUM_NNA__c = loanApp3.SUM_NNA__c;
            prolist.Backend_Hurdle__c = loanApp3.Backend_Hurdle__c;
            prolist.Backend_Bps__c = loanApp3.Backend_Bps__c;
            prolist.Proposal_Status__c = 'Accepted';
            prolist.Offer_Name__c = 'Backend TA Offer';
            prolist.Proposal_Name__c='Backend TA Offer';
            prolist.DBA_Business_Name__c ='TESTDBA';
            prolist.Loan_Type__c = 'TEST';
            prolist.Status__c=true;
           
            insert prolist;
            
        
           Id TA_OSJ_RecordTypeId =  Schema.getGlobalDescribe().get('Contract_Accommodation__c').getDescribe().getRecordTypeInfosByName().get('TA OSJ Credit').getRecordTypeId();
         Contract_Accommodation__c ac41 =new Contract_Accommodation__c();
            ac41.RecordTypeID = TA_OSJ_RecordTypeId ;
            ac41.Requesting_Dept__c = 'IS Business Consulting';
            ac41.GL_Account__c = '812110';
            ac41.GL_Department__c = '4231';
            ac41.Region__c='Core';
            ac41.Created_By_Manager__c = u.id;
            ac41.Credit_Category__c = 'Processing';
            ac41.Credit_Amount_Requested__c = 500;
            ac41.Does_credit_stay_with_individual_or_flow__c = 'Individual';
            ac41.Advisor_Statement_Description__c = 'Test';
            //ac41.Approver_Title__c=null;
            //ac41.Approved_Declined_By__c=null;
            //ac41.Accommodation_Status__c='Manager Approved';
            ac41.Loan_Application__c=loanApp3.id;
            insert ac41;
            
            
            
        
        try{
            update accommodationUpdateList; 
            
            update newUpdateAccommodationList;
            LPL_ContractAccommodation_TriggerGateway clsAccomodation= new LPL_ContractAccommodation_TriggerGateway();
            clsAccomodation.processRecord(ac41);
            clsAccomodation.updateSelectedProposalStatus(ac41);
        }
        catch(Exception e){
            
            Boolean expectedExceptionThrown =  e.getMessage().contains('Please add Approver Title AND Approved/Declined By before approve. Please') ? true : false;
            //System.AssertEquals(expectedExceptionThrown, false);
        }
        
        
        Test.StopTest();
        
    }
    
    
    
    
}