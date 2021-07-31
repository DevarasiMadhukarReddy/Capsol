public class MergecontactpageController
{
    /****Start****/
    //Addingboolean value to check value in Lead Quality date and Lead Quality
    public boolean isSelectedLQDate{get;set;}
    public boolean isSelectedLQ{get;set;}
    public boolean isAllowContact;
    /******End****/
    public Id conRecId {get;set;}
    public List<contact> c {get;set;}
    public Contact con;
    public Id selectcon;
    public string Selectemail;
    public String Selectphone;
    public String SelLead;
    public string SelCRDNum;
    public String LPLMagazineid ;
    public string currentFirmHireDateid;
    public String prefNameid ;
    public String Lastnameid ;
    //public String pronunciationid ;
    public String titleid ;
    public String statusid ;
    //public String genderid ;
    //public string sourcetypeid;
    //public String dbaNameid ;
    public String gdcFromDiscoveryDatabaseid ;
    public String gdcFromOtherSourceid ;
    public String discoveryEmailBusinessTypeid ;
    public String accountid ;
    //public String institutionalGroupid ;
    //public String otherPhoneid ;
    public String mobilePhoneid ;
    public String faxid ;
    public String discoveryHomePhoneid ;
    public String discoveryContactPhoneid ;
    public String formPhoneid ;
    public String discoveryDataRepCRDid ;
    public String ownerId1;
    //public String IsReferralid ;
    //public String referralOverrideid ;
    //public String referralDateid ;
    public String discoveryEmailPersonalTypeid;
    public String sellAgainstDetailsid ;
    //public String prospectTypeid ;
    //public String prospectSourceid ;
    public String prospectCommentsid ;
    public String prospectStatusid ;
    //public String licensedInsAgentid ;
    public String dateBecameARepid ;
    //public String marketingClassificationid ;
    public String CFPid ;
    public String homePhoneid ;
    //public String assistantNameid ;
    //public String asstPhoneid ;
    //public String assistantEmailAddressid ;
    public String websiteid ;
    //public String transitionTrainingCompleteid ;
    //public String twitterAccountid ;
    //public String facebookLinkid ;
    public String leadScoreid ;
    //public String referralByid ;
    //public String referringAdvisorRepIDid ;
    //public String sourceTypeproid ;
    //public String marketingClassificationProspectid ;
    //public String mailerCodeProspectid ;
    //public String marketingCategoryid ;
    public String doNotCallid ;
    public String doNotMailid ;
    public String emailOptOutid ;
    public String GDCPrior12moid ;
    public String OnATeamid ;
    public String HadHOVid ;
    public String HadRDConversationid ;
    public String HadTechDemoid ;
    public String MarketingEmailOptOutid ;
    //public String LeadTypeid ;
    //public String ChannelOwnerChangeid ;
    public String HighestStageReachedid ;
    public String RecruiterProbabilityid ;
    public String InactiveDateid ;
    //public String LeadScoreExperimentid ;
    public String temp{get;set;}
    public String RecordTypeId ;
    public String CreatedByid ;
    public String LastModifiedByid ;
    public String LeadQualityid;
    public String LeadQualityDateid;
    public string DiscoveryEmailBusinessType2id;
    List<Contactwrapper1> ContactList = new List<Contactwrapper1>();
    public List<Contact> selectedContact = new List<Contact>();
    public boolean editSection {get;set;}
    public String query = null;    
    
    public Set<String> fieldNames = new Set<String>();
    
    public MergecontactpageController(){
        conRecId= ApexPages.currentpage().getparameters().get('recordID');
        con= [select id,LastName,accountid,Phone,Uniquekey__c,MobilePhone,UniqueKeyMobile__c,Data_Link2__DDL_RepID__c,Email,CRD_Number__c,Lead_Source__c,lastModifiedDate,CreatedDate  from contact where id =:ApexPages.currentpage().getparameters().get('recordID')];
        this.isSelectedLQDate = false;
        this.isSelectedLQ = false;
        this.isAllowContact = true;
    }
    
    public List<Contactwrapper1> getContacts(){    
        ContactList.clear();
        String allFields = getFields();
        String conPhone = con.Phone;
        String MobilePhone = con.Mobilephone;
        String conAccountId =con.AccountId;
        String conLastName=con.LastName;
        String officePhonekey = con.Uniquekey__c;
        String mobilePhonekey = con.UniqueKeyMobile__c;
        String crdkey = con.Data_Link2__DDL_RepID__c;
        String emailkey = con.Email;
        
        List<Contact> conList=[Select id,Lead_Quality__c,Lead_Quality_Date__c,Discovery_Email_Business_Type_2__c,Smart_List_Segment__c,Pref_Name__c,Pronunciation__c,Title,Gender__c,DBA_Name__c,GDC_from_Discovery_database__c,GDC_from_other_source__c,Email,Email_Unknown__c,Discovery_Email_Business_Type__c,Discovery_Email_Personal_Type__c,Pardot_Email__c,pi__campaign__c,Master_Comments__c,Pardot_Marketing_Channel__c,PardotActivityInput__c,Receive_Anniversary_Emails__c,duplicate_email__c,ELOQUA_Program_Builder_Counter__c,Channel__c,Request_To_Join_As__c,AccountId,Data_Link2__DDL_FirmID__c,Institutional_Group__c,Phone,OtherPhone,MobilePhone,Form_Phone__c,Fax,Discovery_Home_Phone__c,Discovery_Contact_Phone__c,CRD_Number__c,Data_Link2__DDL_RepID__c,CRD_Unknown__c,AUM_from_other_source__c,Last_Pardot_Marketing_Activity_Date__c,Other_AUM_Source__c,Advisor_Recuiting_Territory__c,Institutional_Recruiting_Territory__c,Territory_Segmentation__c,Discovery_Metro_Area__c,OwnerId,Business_Consultant_RM__c,BC_RM_Region__c,Role__c,Birthday_Checkbox__c,Recent_Activity_Date__c,Opportunity_created_date__c,Discovery_Home_Address_1__c,Discovery_Home_Address_2__c,Discovery_Home_City__c,Discovery_Home_State__c,Discovery_Home_Zip__c,Source_Type__c,Prospect_Type__c,Prospect_Source__c,Prospect_Comments__c,Prospect_Status__c,Number_of_FINRA_Registered_States__c,CFP__c,Marketing_Classification__c,Date_Became_a_Rep__c,Current_Firm_Hire_Date__c,Licensed_Ins_Agent__c,ChFC__c,Non_Producer__c,Dually_Registered__c,HomePhone,LPLCRM__Assistant_Name__c,AssistantPhone,Assistant_email_Address__c,Website__c,LinkedIn_Profile__c,Discovery_Professional_Website__c,Designations__c,Wedding_Anniversary__c,LPLCRM__Hobbies__c,Transition_Training_Complete__c,Twitter_Account__c,Facebook_link__c,Lead_Score_Background__c,Lead_Score_Feedback__c,Lead_Score_Feedback_Detail__c,IsReferral__c,Referral_Date__c,Referral_Override__c,Referral_By__c,Referring_Advisor_Rep_ID__c,Marketing_Classification_Prospect__c,Mailer_Code_Prospect__c,Marketing_Category__c,DoNotCall,Do_Not_Mail__c,HasOptedOutOfEmail,GDC_Prior_12_mo__c,On_a_Team__c,LPL_Magazine__c,BDA_Influence__c,Had_HOV__c,Had_RD_Conversation__c,Had_Tech_Demo__c,ELQ_Marketing_Email_Opt_Out__c,Internal_Recruiter_IRD__c,Assigned_Recruiter__c,Regional_VP__c,Lead_Type__c,Allow_Lead_Type_Change__c,Channel_Owner__c,Inactive_Reason__c,Highest_Stage_Reached__c,Status_Notes__c,Recruiter_Probability__c,Inactive_Date__c,Discovery_Date_Became_a_Rep_Date__c,RecordTypeId,Lead_Score_Experiment__c,Lead_Score__c,Rep_Status__c,Uniquekey__c,UniqueKeyMobile__c,Lead_Source__c,Source_Type_Prospect__c,firstName,lastName,MailingCity,MailingCountry,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStreet from Contact where ((Data_Link2__DDL_RepID__c = :con.Data_Link2__DDL_RepID__c AND Data_Link2__DDL_RepID__c!=null) OR (Email =: con.Email AND Email != null) OR (Lastname =:con.LastName AND AccountID=: con.AccountID and Phone=:con.phone) OR (MobilePhone =: con.MobilePhone AND LastName =:con.LastName AND AccountID =:con.AccountID)) AND (RecordType.Name = 'Contact Prospect' OR RecordType.Name = 'Pardot Prospect')];
        
        for(Contact c : conList){
            ContactList.add(new Contactwrapper1(c));
        }
        selectedContact.clear();
        if(ContactList.size()==2){
            for(Contactwrapper1 ccwrapper : ContactList){
                ccwrapper.selected = true;
                selectedContact.add(ccwrapper.cc);
                
            }
        }
        else if(ContactList.size()==3){
            for(Contactwrapper1 ccwrapper : ContactList){
                ccwrapper.selected = true;
                selectedContact.add(ccwrapper.cc);
            }
        }
        if(ContactList.size()>1){
            return ContactList;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No duplicates Found'));
            return null;
        }
    }
    
    /*------ Used in "MergecontactpageVF" page---------*/  
    public PageReference getSelected(){
        selectedContact.clear();
        for(Contactwrapper1 ccwrapper : ContactList){
            if(ccwrapper.selected == true){
                selectedContact.add(ccwrapper.cc);
                
            }
        }
        
        for(Contact c : selectedContact){
            if(string.isNotBlank(c.Lead_quality__c)){
                isAllowContact = false;
                break;
            }
        }
        
        if(selectedContact.size()<2){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select atleast 2 contacts to merge'));
            return null; 
        }
        
        if(selectedContact.size()>3){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You cannot select more than 3 contacts'));
            return null; 
        }
        else{
            editSection = true;
            return null;
        }
        
    }
    
    public List<Contact> GetSelectedContacts(){
        if(selectedContact.size()>0)
            return selectedContact;
        else
            return null;
    }    
    
    public class Contactwrapper1{
        public Contact cc{get; set;}
        public Boolean selected {get; set;}
        public Contactwrapper1(Contact c){
            cc = c;
            selected = false;
        }
    }
    /*------------- Start Input radio with Actionsupport-------------*/
    public void selectcon(){
        ID selcontactid = System.currentPagereference().getParameters().get('conid');
        Contact con = [Select Id,FirstName,LastName,Email,Phone,CRD_Number__c,Lead_Source__c from Contact where Id=:selcontactid];
        if(con!=null){
            selectcon=con.id;
            
        }
    }
    
    public void Selectemail(){
        String selemailid = System.currentPagereference().getParameters().get('email');
        String selphoneid = System.currentPagereference().getParameters().get('phone');
        String SelLeadid= System.currentPagereference().getParameters().get('Leadsource');
        String SelCRD= System.currentPagereference().getParameters().get('CRD');
        String LPLMagazine =System.currentPagereference().getParameters().get('LPL Magazine');
        String LastName =System.currentPagereference().getParameters().get('LastName');
        String prefName=System.currentPagereference().getParameters().get('prefName');
        //String pronunciation=System.currentPagereference().getParameters().get('pronunciation');
        String title=System.currentPagereference().getParameters().get('title');
        String status=System.currentPagereference().getParameters().get('status');
        //String gender=System.currentPagereference().getParameters().get('gender');
        //String dbaName=System.currentPagereference().getParameters().get('dbaName');
        String gdcFromDiscoveryDatabase=System.currentPagereference().getParameters().get('gdcFromDiscoveryDatabase');
        String gdcFromOtherSource=System.currentPagereference().getParameters().get('gdcFromOtherSource');
        String emailUnknown=System.currentPagereference().getParameters().get('emailUnknown');
        String discoveryEmailBusinessType=System.currentPagereference().getParameters().get('discoveryEmailBusinessType');
        String formComments=System.currentPagereference().getParameters().get('formComments');
        String processedMarketingCat=System.currentPagereference().getParameters().get('processedMarketingCat');
        String lastOfficeVisit=System.currentPagereference().getParameters().get('lastOfficeVisit');
        String account=System.currentPagereference().getParameters().get('account');
        //String institutionalGroup=System.currentPagereference().getParameters().get('institutionalGroup');
        //String otherPhone=System.currentPagereference().getParameters().get('otherPhone');
        String mobilePhone=System.currentPagereference().getParameters().get('mobilePhone');
        String formPhone=System.currentPagereference().getParameters().get('formPhone');
        String fax=System.currentPagereference().getParameters().get('fax');
        String discoveryHomePhone=System.currentPagereference().getParameters().get('discoveryHomePhone');
        String discoveryContactPhone=System.currentPagereference().getParameters().get('discoveryContactPhone');
        String discoveryDataRepCRD=System.currentPagereference().getParameters().get('discoveryDataRepCRD');
        String aumFromOtherSource=System.currentPagereference().getParameters().get('aumFromOtherSource');
        String otherAUMSource=System.currentPagereference().getParameters().get('otherAUMSource');
        String advisorRecruitingTerritory=System.currentPagereference().getParameters().get('advisorRecruitingTerritory');
        String institutionalRecruitingTerritory=System.currentPagereference().getParameters().get('institutionalRecruitingTerritory');
        String territorySegmentation=System.currentPagereference().getParameters().get('territorySegmentation');
        String ownerId=System.currentPagereference().getParameters().get('ownerId');
        //String IsReferral=System.currentPagereference().getParameters().get('IsReferral');
        //String referralOverride=System.currentPagereference().getParameters().get('referralOverride');
        //String referralDate=System.currentPagereference().getParameters().get('referralDate');
        String mailingAddress=System.currentPagereference().getParameters().get('mailingAddress');
        String sellAgainstDetails=System.currentPagereference().getParameters().get('sellAgainstDetails');
        //String prospectType=System.currentPagereference().getParameters().get('prospectType');
        //String prospectSource=System.currentPagereference().getParameters().get('prospectSource');
        String prospectComments=System.currentPagereference().getParameters().get('prospectComments');
        String prospectStatus=System.currentPagereference().getParameters().get('prospectStatus');
        String CFP=System.currentPagereference().getParameters().get('CFP');
        //String marketingClassification=System.currentPagereference().getParameters().get('marketingClassification');
        String dateBecameARep=System.currentPagereference().getParameters().get('dateBecameARep');
        String currentFirmHireDate=System.currentPagereference().getParameters().get('currentFirmHireDate');
        //String licensedInsAgent=System.currentPagereference().getParameters().get('licensedInsAgent');
        String ChFC=System.currentPagereference().getParameters().get('ChFC');
        String NonProducer=System.currentPagereference().getParameters().get('Non-Producer');
        String duallyRegistered=System.currentPagereference().getParameters().get('duallyRegistered');
        String homePhone=System.currentPagereference().getParameters().get('homePhone');
        //String assistantName=System.currentPagereference().getParameters().get('assistantName');
        //String asstPhone=System.currentPagereference().getParameters().get('asstPhone');
        //String assistantEmailAddress=System.currentPagereference().getParameters().get('assistantEmailAddress');
        String website=System.currentPagereference().getParameters().get('website');
        //String transitionTrainingComplete=System.currentPagereference().getParameters().get('transitionTrainingComplete');
        //String twitterAccount=System.currentPagereference().getParameters().get('twitterAccount');
        //String facebookLink=System.currentPagereference().getParameters().get('facebookLink');
        String leadScore=System.currentPagereference().getParameters().get('leadScore');
        //String referralBy=System.currentPagereference().getParameters().get('referralBy');
        //String referringAdvisorRepID=System.currentPagereference().getParameters().get('referringAdvisorRepID');
        //String sourceTypepro=System.currentPagereference().getParameters().get('sourceTypepros');
        //String marketingClassificationProspect=System.currentPagereference().getParameters().get('marketingClassificationProspect');
        //String mailerCodeProspect=System.currentPagereference().getParameters().get('mailerCodeProspect');
        //String marketingCategory=System.currentPagereference().getParameters().get('marketingCategory');
        String doNotCall=System.currentPagereference().getParameters().get('doNotCall');
        String doNotMail=System.currentPagereference().getParameters().get('doNotMail');
        String emailOptOut=System.currentPagereference().getParameters().get('emailOptOut');
        String GDCPrior12mo=System.currentPagereference().getParameters().get('GDC-Prior12mo');
        String OnATeam=System.currentPagereference().getParameters().get('On a Team');
        String HadHOV=System.currentPagereference().getParameters().get('Had HOV');
        String HadRDConversation=System.currentPagereference().getParameters().get('Had RD Conversation');
        String HadTechDemo=System.currentPagereference().getParameters().get('Had Tech Demo');
        String MarketingEmailOptOut=System.currentPagereference().getParameters().get('Marketing Email Opt Out');
        //String LeadType=System.currentPagereference().getParameters().get('Lead Type');
        //String ChannelOwnerChange=System.currentPagereference().getParameters().get('Channel Owner');
        String HighestStageReached=System.currentPagereference().getParameters().get('Highest Stage Reached');
        String RecruiterProbability=System.currentPagereference().getParameters().get('Recruiter Probability');
        String InactiveDate=System.currentPagereference().getParameters().get('Inactive Date');
        //String LeadScoreExperiment=System.currentPagereference().getParameters().get('Lead Score Experiment');
        String ContactRecordType=System.currentPagereference().getParameters().get('Contact Record Type');
        String CreatedBy=System.currentPagereference().getParameters().get('Created By');
        String LastModifiedBy=System.currentPagereference().getParameters().get('LastModifiedBy');
        
        //system.debug('#$#$#$#LQD'+leadqualitydate);
        //system.debug('#$#$#$LQ#'+leadquality);
        String discoveryEmailBusinessType2=System.currentPagereference().getParameters().get('discoveryEmailBusinessType2');
        String discoveryEmailPersonalType=System.currentPagereference().getParameters().get('discoveryEmailPersonalType');
        if(discoveryEmailPersonalType!=null)
            discoveryEmailPersonalTypeid=discoveryEmailPersonalType;
        if(selemailid!=null)
            Selectemail=selemailid ;
        if(selphoneid!=null)
            Selectphone=selphoneid;
        if(SelLeadid!=null)
            SelLead=SelLeadid;
        if(SelCRD!=null)
            SelCRDNum=SelCRD;
        if(LPLMagazine !=null)
            LPLMagazineid=LPLMagazine  ;
        if(LastName !=null)
            LastNameid=LastName ;
        if(prefName!=null)
            prefNameid=prefName;
        /*if(pronunciation!=null)
            pronunciationid=pronunciation; */
        if(title!=null)
            titleid=title ;
        if(status!=null)
            statusid=status;
        /*if(gender!=null)
            genderid=gender; 
        if(dbaName!=null)
            dbaNameid=dbaName;*/
        if(gdcFromDiscoveryDatabase!=null)
            gdcFromDiscoveryDatabaseid=gdcFromDiscoveryDatabase ;
        if(gdcFromOtherSource!=null)
            gdcFromOtherSourceid=gdcFromOtherSource;
        if(discoveryEmailBusinessType!=null)
            discoveryEmailBusinessTypeid=discoveryEmailBusinessType;
        if(account!=null)
            accountid=account ;
        /*if(institutionalGroup!=null)
            institutionalGroupid=institutionalGroup; */
        /*if(otherPhone!=null)
            otherPhoneid=otherPhone; */
        if(mobilePhone!=null)
            mobilePhoneid=mobilePhone;
        if(fax!=null)
            faxid=fax;
        if(discoveryHomePhone!=null)
            discoveryHomePhoneid=discoveryHomePhone;
        if(discoveryContactPhone!=null)
            discoveryContactPhoneid=discoveryContactPhone;
        if(formPhone!=null)
            formPhoneid=formPhone ;
        if(discoveryDataRepCRD!=null)
            discoveryDataRepCRDid=discoveryDataRepCRD;
        if(ownerId!=null)
            ownerId1=ownerId ;
        /*if(IsReferral!=null)
            IsReferralid=IsReferral; 
        if(referralOverride!=null)
            referralOverrideid=referralOverride; 
        if(referralDate!=null)
            referralDateid=referralDate; */
        
        if(sellAgainstDetails!=null)
            sellAgainstDetailsid=sellAgainstDetails;
        /* if(prospectType!=null)
            prospectTypeid=prospectType;
        if(prospectSource!=null)
            prospectSourceid=prospectSource;
        */
        if(prospectComments!=null)
            prospectCommentsid=prospectComments;
        if(prospectStatus!=null)
            prospectStatusid=prospectStatus;
        if(currentFirmHireDate!=null)
            currentFirmHireDateid=currentFirmHireDate;
        system.debug('#$#$#$#'+currentFirmHireDateid);
        /*if(licensedInsAgent!=null)
            licensedInsAgentid=licensedInsAgent; */
        if(dateBecameARep!=null)
            dateBecameARepid=dateBecameARep;
        /*if(marketingClassification!=null)
            marketingClassificationid=marketingClassification; */
        if(CFP!=null)
            CFPid=CFP;
        if(homePhone!=null)
            homePhoneid=homePhone;
        /*if(assistantName!=null)
            assistantNameid=assistantName ; 
        if(asstPhone!=null)
            asstPhoneid=asstPhone;
        if(assistantEmailAddress!=null)
            assistantEmailAddressid=assistantEmailAddress; */
        if(website!=null)
            websiteid=website;
        /*if(transitionTrainingComplete!=null)
            transitionTrainingCompleteid=transitionTrainingComplete; 
        if(twitterAccount!=null)
            twitterAccountid=twitterAccount; 
        if(facebookLink!=null)
            facebookLinkid=facebookLink ; */
        if(leadScore!=null)
            leadScoreid=leadScore;
        /*if(referralBy!=null)
            referralByid=referralBy; 
        if(referringAdvisorRepID!=null)
            referringAdvisorRepIDid=referringAdvisorRepID;
        if(sourceTypepro!=null)
            sourceTypeproid=sourceTypepro ;
        if(marketingClassificationProspect!=null)
            marketingClassificationProspectid=marketingClassificationProspect;
        if(mailerCodeProspect!=null)
            mailerCodeProspectid=mailerCodeProspect;
        /*if(marketingCategory!=null)
            marketingCategoryid=marketingCategory; */
        if(doNotCall!=null)
            doNotCallid=doNotCall ;
        if(doNotMail!=null)
            doNotMailid=doNotMail;
        if(emailOptOut!=null)
            emailOptOutid=emailOptOut;
        if(GDCPrior12mo!=null)
            GDCPrior12moid=GDCPrior12mo;
        if(OnATeam!=null)
            OnATeamid=OnATeam ;
        if(HadHOV!=null)
            HadHOVid=HadHOV;
        if(HadRDConversation!=null)
            HadRDConversationid=HadRDConversation   ;
        if(HadTechDemo!=null)
            HadTechDemoid=HadTechDemo ;
        if(MarketingEmailOptOut!=null)
            MarketingEmailOptOutid=MarketingEmailOptOut;
        /*if(LeadType!=null)
            LeadTypeid=LeadType; 
        if(ChannelOwnerChange!=null)
            ChannelOwnerChangeid=ChannelOwnerChange ; */
        
        if(HighestStageReached!=null)
            HighestStageReachedid=HighestStageReached ;
        if(RecruiterProbability!=null)
            RecruiterProbabilityid=RecruiterProbability;
        if(InactiveDate!=null)
            InactiveDateid=InactiveDate;
        /*if(LeadScoreExperiment!=null)
            LeadScoreExperimentid=LeadScoreExperiment; */
        if(ContactRecordType!=null)
            RecordTypeId=ContactRecordType  ;
        if(CreatedBy!=null)
            CreatedByid=CreatedBy   ;
        if(LastModifiedBy!=null)
            LastModifiedByid=LastModifiedBy ;
        
        /*if(String.isNotBlank(leadquality)){
            LeadQualityid=leadquality;
            isSelectedLQ = true;
        }
        system.debug('leadqualityid'+LeadQualityid);
        
        
        if(String.isNotBlank(leadqualitydate)){
            LeadQualityDateid=leadqualitydate;
            isSelectedLQDate = true;
        }  
         system.debug('LeadQualityDateid'+LeadQualityDateid);
        */
        if(discoveryEmailBusinessType2!=null)
            DiscoveryEmailBusinessType2id=discoveryEmailBusinessType2;
    }
	
		public void SelectLQ(){
			
			String leadquality=System.currentPagereference().getParameters().get('leadquality');
            //String leadqualitydate=System.currentPagereference().getParameters().get('leadqualitydate');
			if(String.isNotBlank(leadquality)){
            LeadQualityid=leadquality;
            isSelectedLQ = true;
        	}
        }
        Public void SelectLQDate(){
        	String leadqualitydate=System.currentPagereference().getParameters().get('leadqualitydate');
        if(String.isNotBlank(leadqualitydate)){
            LeadQualityDateid=leadqualitydate;
            isSelectedLQDate = true;
       		 }  
         system.debug('LeadQualityDateid'+LeadQualityDateid);
		}
    
    /*-------------End Input radio with Actionsupport-------------*/
    /*--------------------Merge button Functionality--------------------------------------*/
    public PageReference  save(){
        //BypassTrigger.ByPass('LPL_ContactTrigger');
        Set<ID> IDs=new Set<Id>();
        List<contact>dupe= new List<Contact>();   
        Contact master=new Contact();
        Contact mastercon = new Contact();
        try{
            for(Contact c1: selectedContact){
                if(c1.id==selectcon){
                    master=c1;
                }
                else{
                    IDs.add(c1.id);
                    dupe.add(c1);
                }
            }
            String allFields = getFields();
            String query = 'Select id, '+allFields+' from Contact where id in:Ids order by lastModifiedDate desc limit 1';
            List<Contact> lastModifiedRecord = Database.query(query);
            system.debug('I am here');
            if(master.id==null){
                system.debug('I am inside');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select a master'));
                return null; 
            }
            
                 system.debug('allowontact-'+isAllowContact);
                     system.debug('isSelectedLQDate-'+isSelectedLQDate);
                     system.debug('isSelectedLQ-'+isSelectedLQ);
            if(dupe.size()>0){
                if(!isAllowContact && !isSelectedLQDate){
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select both Lead Quality and Lead Quality Date'));
                    return null;
                }
                
                if(Selectemail!=null){
                    master.email =Selectemail;
                }
                if(Selectphone!=null){
                    master.phone=Selectphone;
                }
                if(SelLead!=null){
                    master.Lead_source__c=SelLead;
                }
                if(SelCRDNum!=null){
                    master.CRD_Number__c=SelCRDNum;
                }
                if(LPLMagazineid!=null){
                    master.LPL_Magazine__c=Boolean.valueOf(LPLMagazineid);
                }
                if(LastNameid!=null){
                    master.LastName=LastNameid ;
                }
                if(prefNameid!=null){
                    master.Pref_Name__c=prefNameid;
                }
                /*if(pronunciationid!=null){
                    master.Pronunciation__c=pronunciationid;
                }*/
                if(titleid!=null){
                    master.Title=titleid;
                }
                if(statusid!=null){
                    master.Rep_Status__c=statusid;
                }
                /*if(genderid!=null){
                    master.Gender__c=genderid;
                }
                if(dbaNameid!=null){
                    master.DBA_Name__c=dbaNameid;
                }*/
                if(gdcFromDiscoveryDatabaseid!=null){
                    master.GDC_from_Discovery_database__c=gdcFromDiscoveryDatabaseid;
                }
                if(gdcFromOtherSourceid!=null){
                    master.GDC_from_other_source__c=gdcFromOtherSourceid;
                }
                if(discoveryEmailBusinessTypeid!=null){
                    master.Discovery_Email_Business_Type__c=discoveryEmailBusinessTypeid;
                }if(accountid!=null){
                    master.AccountId=accountid;
                }
                /*if(institutionalGroupid!=null){
                    master.Institutional_Group__c=institutionalGroupid;
                }
                if(otherPhoneid!=null){
                    master.OtherPhone=otherPhoneid;
                }*/
                if(mobilePhoneid!=null){
                    master.MobilePhone=mobilePhoneid;
                }
                if(formPhoneid!=null){
                    master.Form_Phone__c=formPhoneid;
                }
                if(faxid!=null){
                    master.Fax=faxid;
                }
                if(discoveryHomePhoneid!=null){
                    master.Discovery_Home_Phone__c=discoveryHomePhoneid;
                }
                if(discoveryContactPhoneid!=null){
                    master.Discovery_Contact_Phone__c=discoveryContactPhoneid;
                }
                if(discoveryDataRepCRDid!=null){
                    master.Data_Link2__DDL_RepID__c=discoveryDataRepCRDid;
                }
                if(ownerId1!=null){
                    master.OwnerId=ownerId1;
                }
                /*if(IsReferralid!=null){
                    master.IsReferral__c=IsReferralid;
                }
                if(referralOverrideid!=null){
                    master.Referral_Override__c=Boolean.ValueOf(referralOverrideid);
                }
                if(referralDateid!=null){
                    master.Referral_Date__c=Date.valueOf(referralDateid);
                }*/
                if(sellAgainstDetailsid!=null){
                    master.Sell_Against_Details__c=sellAgainstDetailsid;
                }
                /*if(prospectTypeid!=null){
                    master.Prospect_Type__c=prospectTypeid;
                }
                if(prospectSourceid!=null){
                    master.Prospect_Source__c=prospectSourceid;
                }*/
                if(prospectCommentsid!=null){
                    master.Prospect_Comments__c=prospectCommentsid;
                }
                if(prospectStatusid!=null){
                    master.Prospect_Status__c=prospectStatusid;
                }
                if(currentFirmHireDateid!=null){
                    master.Current_Firm_Hire_Date__c=Date.ValueOf(currentFirmHireDateid);
                }
                /*if(licensedInsAgentid!=null){
                    master.Licensed_Ins_Agent__c=Boolean.valueof(licensedInsAgentid);
                }*/
                if(dateBecameARepid!=null){
                    master.Date_Became_a_Rep__c=Date.ValueOf(dateBecameARepid);
                    system.debug('#$#$#$#'+master.Date_Became_a_Rep__c);
                }
                /*if(marketingClassificationid!=null){
                    master.Marketing_Classification__c=marketingClassificationid;
                }*/
                if(CFPid!=null){
                    master.CFP__c=Boolean.valueOf(CFPid);
                }
                if(homePhoneid!=null){
                    master.HomePhone=homePhoneid;
                }
                /*if(assistantNameid!=null){
                    master.LPLCRM__Assistant_Name__c=assistantNameid;
                }
                if(asstPhoneid!=null){
                    master.AssistantPhone=asstPhoneid;
                }
                if(assistantEmailAddressid!=null){
                    master.Assistant_email_Address__c=assistantEmailAddressid;
                }*/
                if(websiteid!=null){
                    master.Website__c=websiteid;
                }
                /*if(transitionTrainingCompleteid!=null){
                    master.Transition_Training_Complete__c=Date.valueOf(transitionTrainingCompleteid);
                }
                if(twitterAccountid!=null){
                    master.Twitter_Account__c=twitterAccountid;
                }
                if(referringAdvisorRepIDid!=null){
                    master.Referring_Advisor_Rep_ID__c=referringAdvisorRepIDid;
                }
                if(referralByid!=null){
                    master.Referral_By__c=referralByid;
                }*/
                if(leadScoreid!=null){
                    master.Smart_List_Segment__c=leadScoreid;
                }
                /*if(facebookLinkid!=null){
                    master.Facebook_link__c=facebookLinkid;
                }
                if(mailerCodeProspectid!=null){
                    master.Mailer_Code_Prospect__c=mailerCodeProspectid;
                }
                if(marketingCategoryid!=null){
                    master.Marketing_Category__c=marketingCategoryid;
                }
                if(marketingClassificationProspectid!=null){
                    master.Marketing_Classification_Prospect__c=marketingClassificationProspectid;
                }
                if(sourceTypeid!=null){
                    master.Source_Type__c=sourceTypeid;
                }
                if(sourceTypeproid!=null){
                    master.Source_Type_Prospect__c=sourceTypeproid;
                }*/
                if(doNotCallid!=null){
                    master.DoNotCall=Boolean.valueOf(doNotCallid);
                }
                if(doNotMailid!=null){
                    master.Do_Not_Mail__c=Boolean.valueOf(doNotMailid);
                }
                if(emailOptOutid!=null){
                    master.HasOptedOutOfEmail=Boolean.valueOf(emailOptOutid);
                }
                if(GDCPrior12moid!=null){
                    master.GDC_Prior_12_mo__c=Decimal.ValueOf(GDCPrior12moid);
                }
                if(OnATeamid!=null){
                    master.On_a_Team__c=Boolean.valueOf(OnATeamid);
                }
                if(MarketingEmailOptOutid!=null){
                    master.ELQ_Marketing_Email_Opt_Out__c=Boolean.valueOf(MarketingEmailOptOutid);
                }
                if(HadTechDemoid!=null){
                    master.Had_Tech_Demo__c=Boolean.valueOf(HadTechDemoid);
                }
                if(HadRDConversationid!=null){
                    master.Had_RD_Conversation__c=Boolean.valueOf(HadRDConversationid);
                }
                if(HadHOVid!=null){
                    master.Had_HOV__c=Boolean.valueOf(HadHOVid);
                }
                /*if(LeadTypeid!=null){
                    master.Lead_Type__c=LeadTypeid;
                }
                if(LeadScoreExperimentid!=null){
                    master.Lead_Score_Experiment__c=Boolean.valueOf(LeadScoreExperimentid);
                }*/
                if(RecruiterProbabilityid!=null){
                    master.Recruiter_Probability__c=Decimal.ValueOf(RecruiterProbabilityid);
                }
                if(InactiveDateid!=null){
                    master.Inactive_Date__c=Date.ValueOf(InactiveDateid);
                }
                if(HighestStageReachedid!=null){
                    master.Highest_Stage_Reached__c=HighestStageReachedid;
                }
                /*if(ChannelOwnerChangeid!=null){
                    master.Channel_Owner__c=ChannelOwnerChangeid;
                }*/
                if(LeadQualityid!=null){
                    master.Lead_Quality__c=LeadQualityid;
                    system.debug('#$#$#$#'+master.Lead_Quality__c);
                }
                if(String.isNotBlank(LeadQualityDateid)){
                    master.Lead_Quality_Date__c = convertDate(LeadQualityDateid);
                    system.debug('#$#$#$#'+master.Lead_Quality_Date__c);
                }
                if(DiscoveryEmailBusinessType2id!=null){
                    master.Discovery_Email_Business_Type_2__c=DiscoveryEmailBusinessType2id;
                }
                if(ProspectStatusid!=null){
                    master.Inactive_Reason__c=ProspectStatusid;
                }
                
                for(String s:fieldNames){
                    if(master.get(s)==null || master.get(s)==false){
                        master.put(s,lastModifiedRecord[0].get(s));
                    }
                }
                //master.Is_Master_Contact__c = true;
            }    
            update master;
            
            mastercon = [Select id,firstName,lastName from Contact WHERE id=:master.Id];
            Contact[] duplicates= [Select id,firstName,lastName from Contact WHERE id =:IDs];
            
            Database.MergeResult[] results = Database.merge(mastercon, duplicates, false);
            for(Database.MergeResult res : results){
                if (res.isSuccess()){
                    // Get the master ID from the result and validate it
                    System.assertEquals(master.Id, res.getId());              
                    // Get the IDs of the merged records and display them
                    List<Id> mergedIds = res.getMergedRecordIds();               
                }
                else {
                    for(Database.Error err : res.getErrors()) {
                        // Write each error to the debug output
                        System.debug(err.getMessage());
                    }
                }
            }
        }
        catch(Exception e){
            
            LPL_CreateExceptionLog.createErrorRecordAsync('MergecontactpageController ','save',e.getMessage(),e.getLineNumber(),e.getTypeName());
            
        }
        PageReference pageRef = new PageReference('/' + mastercon.Id);
        
        return pageRef ;
    }
    
    public  PageReference cancel(){
        PageReference pageRef = new PageReference('/' + con.Id);
        return pageRef ;
    }
    
    public  PageReference Previous(){
        editSection=false;
        conRecId= ApexPages.currentpage().getparameters().get('recordID');
        PageReference pageRef = new PageReference('/apex/MergecontactpageVF?recordID='+conRecId);
        pageRef.setredirect(true);
        return pageRef ;
    }
    
    public String getFields(){
        String allFields='';
        List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {'Contact-Prospective Contact Pool'});
        Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
        for (Metadata.LayoutSection section : layoutMd.layoutSections) {
            for (Metadata.LayoutColumn column : section.layoutColumns) {
                if (column.layoutItems != null) {
                    for (Metadata.LayoutItem item : column.layoutItems) {
                        if(item.field != null){
                            if(item.behavior!=Metadata.UiBehavior.Readonly && item.field!='Name' && item.field!='MailingAddress'){
                                allFields += item.field+',';
                                fieldNames.add(item.field);
                            }
                        }
                    }
                }
            }
        }
        //Adding some ReadOnly fields and the compound fields
        Set<String> remainingFields = new Set<String>{'firstName','lastName','MailingCity','MailingCountry','MailingGeocodeAccuracy','MailingLatitude','MailingLongitude','MailingPostalCode','MailingState','MailingStreet'};
            fieldNames.addAll(remainingFields);
        
       allFields += 'firstName,lastName,MailingCity,MailingCountry,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStreet';
        return allFields;
    }
    //Adding logic to convert date field for Lead Quality Date
    private date convertDate(String inputDate) {        
        string year = '';
        string month = '';
        string day = '';
        string hour = '00';
        string minute = '00';
        string second = '00';
        string stringDate = '';

        
        List<String> inptDatePart = inputDate.split(' ');
        if (inptDatePart != null && !inptDatePart.isEmpty()) {
            day = inptDatePart[2];
            year = inptDatePart[5];
            
            string mon = inptDatePart[1];
            if (mon == 'Jan') {
                month = '01';
            } else if (mon == 'Feb') {
                month = '02';
            }
            else if (mon == 'Feb') {
                month = '02';
            }
            else if (mon == 'Mar') {
                month = '03';
            }
            else if (mon == 'Apr') {
                month = '04';
            }
            else if (mon == 'May') {
                month = '05';
            }
            else if (mon == 'Jun') {
                month = '06';
            }
            else if (mon == 'Jul') {
                month = '07';
            }
            else if (mon == 'Aug') {
                month = '08';
            }
            else if (mon == 'Sep') {
                month = '09';
            }
            else if (mon == 'Oct') {
                month = '10';
            }
            else if (mon == 'Nov') {
                month = '11';
            }
            else if (mon == 'Dec') {
                month = '12';
            } else {
            
            }
            stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second;
            Date myDate = date.valueOf(stringDate);
            return myDate;
        }
        return null;
    }
}