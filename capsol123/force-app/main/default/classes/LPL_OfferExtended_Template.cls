/***
 * Created By Madhukar Reddy 10/12/2020 CS-42- Sprint 17 Offer Extended Email Notification Enhancement - TA Application
 * CS-2507 EAUM Fix Modified by Amol - 11/11/2020 - CH01
 * CS-2848 Enhancement - Approval Email Notification modifided by Madhukar Reddy CH02
 * CS-3346 Approval Email: Round up currency fields to whole numbers- Modified by Bhanu- 4/21/2021 - CH03
 * CS-3780 Backend Calculation Dates - Modified by Amol - 05/13/2021 - CH04
 */
public  class LPL_OfferExtended_Template
{
    public Id Loanid {get;set;}
    
    String strRecordDevName = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByName().get('TA Proposal').getDeveloperName();
      id strRecordDevName12 = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByDeveloperName().get('TA_Proposal_Record_Type').getRecordTypeId();
      String strRecordDevNames = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByName().get('Repayable').getDeveloperName();
    //String strRecordDevName1 = Schema.SObjectType.Proposal_Offer__c.getRecordTypeInfosByName().get('General Proposal').getDeveloperName();
    // System.debug('Record Developer Name ====> '+strRecordDevName);
    public List<Proposal_Offer__c> getopptys()
    {
        
      List<Proposal_Offer__c> prosoff;
        prosoff = [SELECT Name,Date__c,Business_NamDBA__c,Expiration__c,Verified_AUM__c,Approved_T12__c,TA_Amount__c,Max_TA_Amount__c,OSJ__c,Interest_Rate__c,Backend_Bps__c,Backend_Hurdle__c,Platform__c,Branch__c,
                   Loan_Term__c,Level_Payout__c,Campaign__c,Fee_Waivers__c,Admin_Fees__c,Notes__c,Loan_Amount__c FROM Proposal_Offer__c WHERE LoanApp_MD__c =: Loanid and RecordType.DeveloperName =: strRecordDevName ];
        return prosoff ;
    
    }
    
    public List<Proposal_Offer__c> getopptys1()
    {
        
        List<Proposal_Offer__c> prosoff;
        prosoff = [SELECT Name,Date__c,Business_NamDBA__c,Expiration__c,Verified_AUM__c,Approved_T12__c,TA_Amount__c,Max_TA_Amount__c,OSJ__c,Interest_Rate__c,Backend_Bps__c,Backend_Hurdle__c,Platform__c,Branch__c,
                   Loan_Term__c,Level_Payout__c,Campaign__c,Fee_Waivers__c,Admin_Fees__c,Notes__c,Loan_Amount__c FROM Proposal_Offer__c WHERE LoanApp_MD__c =: Loanid and RecordType.DeveloperName =: strRecordDevNames ];
        return prosoff ;
    }
    
    public List<Proposal_Offer__c> getopptys12()
    {
        
        List<Proposal_Offer__c> prosoff;
        // CH01 Start
        prosoff = [SELECT Name,Expected_EAUM__c,LoanApp_MD__r.Current_Registration__c,LoanApp_MD__r.Expected_AUM__c,LoanApp_MD__r.Opportunity__r.Name,LoanApp_MD__r.name,LoanApp_MD__r.status__c,Date__c,Business_NamDBA__c,Expiration__c,Verified_AUM__c,Expected_AUM__c,Approved_T12__c,TA_Amount__c,Max_TA_Amount__c,OSJ__c,Interest_Rate__c,Backend_Bps__c,Backend_Hurdle__c,Platform__c,Branch__c,
                   Loan_Term__c,Level_Payout__c,Campaign__c,Fee_Waivers__c,Admin_Fees__c,Notes__c,Loan_Amount__c,
                   //TA_of_EAUM__c,
                   LoanApp_MD__r.CurrentCustodian__c FROM Proposal_Offer__c WHERE LoanApp_MD__c =: Loanid order by createdDate ASC limit 1];
       // CH01 End
        return prosoff ;
    }
    
    public List<PropWrapper> ForgivableData;
    public List<PropWrapper> RepayableData;
    
    public List<PropWrapper> getdta(){
        try{
            
            List<Proposal_Offer__c> prosoff = [SELECT TA_of_VAUM__c,TA_of_EAUM__c,Name,Date__c,TA_of_Verified_AUM_Percent__c,Business_NamDBA__c,Expiration__c,Verified_AUM__c,TA_of_GDC__c,Approved_T12__c,TA_Amount__c,Max_TA_Amount__c,OSJ__c,Interest_Rate__c,Backend_Bps__c,Backend_Hurdle__c,Platform__c,Branch__c,
                                               Loan_Term__c,Level_Payout__c,Campaign__c,Fee_Waivers__c,Admin_Fee__c,Notes__c,Loan_Amount__c,Loan_Clause__c,TA_of_Expected_AUM__c,
                                               // CH04 Start
                                               //Backend_Date_1__c,Backend_Date_2__c, 
                                               // CH04 End                                               
                                               Backend_TA_Potential__c,Total_TA_Potential__c,Upfront_GDC__c FROM Proposal_Offer__c WHERE LoanApp_MD__c =: Loanid and RecordTypeId =: strRecordDevName12 ];
          // if(!test.isrunningtest()){,
           // if(prosoff.size()>0 ){
            if(prosoff!=null && !prosoff.isEmpty()){
           // if(!prosoff.isEmpty() ){
                 List<PropWrapper> pData=new List<PropWrapper>();
                LPL_OfferExtended_Template.PropWrapper HeaderData=new LPL_OfferExtended_Template.PropWrapper('Offer #');
                LPL_OfferExtended_Template.PropWrapper MaxTAAMTData=new LPL_OfferExtended_Template.PropWrapper('Max TA Amount ($)');
               // LPL_OfferExtended_Template.PropWrapper AccTAAMTData=new LPL_OfferExtended_Template.PropWrapper('Accepted TA Amount');
                LPL_OfferExtended_Template.PropWrapper IntRateData=new LPL_OfferExtended_Template.PropWrapper('TA Rate(% of Verified)');
                //Commneted below line as per confimation from Abdul - 11/12/2020 - Amol
                LPL_OfferExtended_Template.PropWrapper IntRateExpected=new LPL_OfferExtended_Template.PropWrapper('TA Rate(% of Expected)');
               LPL_OfferExtended_Template.PropWrapper IntRateGDC=new LPL_OfferExtended_Template.PropWrapper('Upfront % GDC');
               // LPL_OfferExtended_Template.PropWrapper BackenDate=new LPL_OfferExtended_Template.PropWrapper('Backend Calucation Date1'); 
               // LPL_OfferExtended_Template.PropWrapper BackenDate1=new LPL_OfferExtended_Template.PropWrapper('Backend Calucation Date2'); 
                LPL_OfferExtended_Template.PropWrapper BackendBPSData=new LPL_OfferExtended_Template.PropWrapper('Backend (Bps)');
                LPL_OfferExtended_Template.PropWrapper BackendHurdleData=new LPL_OfferExtended_Template.PropWrapper('Backend Hurdle ($)*');
                LPL_OfferExtended_Template.PropWrapper BackendTAPotential=new LPL_OfferExtended_Template.PropWrapper('Backend TA Potential ');
                LPL_OfferExtended_Template.PropWrapper TotalTAPotential=new LPL_OfferExtended_Template.PropWrapper('Total TA Potential ');
                LPL_OfferExtended_Template.PropWrapper PlatformData=new LPL_OfferExtended_Template.PropWrapper('Platform**');
                LPL_OfferExtended_Template.PropWrapper BranchData=new LPL_OfferExtended_Template.PropWrapper('Branch**');
                LPL_OfferExtended_Template.PropWrapper OSJData=new LPL_OfferExtended_Template.PropWrapper('OSJ**');
                LPL_OfferExtended_Template.PropWrapper TermData=new LPL_OfferExtended_Template.PropWrapper('Term (year)');
                LPL_OfferExtended_Template.PropWrapper PayoutData=new LPL_OfferExtended_Template.PropWrapper('Payout(%)');                
                LPL_OfferExtended_Template.PropWrapper CampaignData=new LPL_OfferExtended_Template.PropWrapper('Campaign');
                LPL_OfferExtended_Template.PropWrapper WaviersData=new LPL_OfferExtended_Template.PropWrapper('Fee Waivers($)');
                LPL_OfferExtended_Template.PropWrapper AdminFeesData=new LPL_OfferExtended_Template.PropWrapper('Admin Fees (Bps)');
               // LPL_OfferExtended_Template.PropWrapper NoteData=new LPL_OfferExtended_Template.PropWrapper('Note');
               // LPL_OfferExtended_Template.PropWrapper LoannautoData=new LPL_OfferExtended_Template.PropWrapper('LoannautoData');
              //  LPL_OfferExtended_Template.PropWrapper Clause=new LPL_OfferExtended_Template.PropWrapper('Clause');
                                
                for(Proposal_Offer__c pf:prosoff){
                    //HeaderData.COlValues.add(pf.Name==null?'':''+pf.Name);
                    HeaderData.COlValues.add(pf.Name.remove('Forgivable'));
                   // MaxTAAMTData.COlValues.add(pf.Max_TA_Amount__c==null?'':''+pf.Max_TA_Amount__c);
                   if(pf.Max_TA_Amount__c!=null){
                   Decimal d = pf.Max_TA_Amount__c;
                     List<String> args = new String[]{'0','number','###,###,##'};
                     String ds = String.format(d.round(System.RoundingMode.HALF_EVEN).format(), args);
                     //CH03 start
                      MaxTAAMTData.COlValues.add('$'+ds); 
                     //MaxTAAMTData.COlValues.add('$'+d.round(System.RoundingMode.HALF_EVEN));
                     //CH03 Ends
                     }
                   // AccTAAMTData.COlValues.add(pf.TA_Amount__c==null?'':''+pf.TA_Amount__c);
                    IntRateData.COlValues.add(pf.TA_of_VAUM__c==null?'':''+pf.TA_of_VAUM__c+'%'); // CS-2551 - Amol -11/17/2020
                    //Commneted below line as per confimation from Abdul - 11/12/2020 - Amol
                    IntRateExpected.COlValues.add(pf.TA_of_EAUM__c==null?'':''+pf.TA_of_EAUM__c +'%');
                    IntRateGDC.COlValues.add(pf.Upfront_GDC__c==null?'':''+pf.Upfront_GDC__c +'%');
                   // BackenDate.COlValues.add(pf.Backend_Date_1__c==null?'':''+pf.Backend_Date_1__c);
                   // BackenDate1.COlValues.add(pf.Backend_Date_2__c==null?'':''+pf.Backend_Date_2__c);
                    BackendBPSData.COlValues.add(pf.Backend_Bps__c==null?'':''+pf.Backend_Bps__c+' '+'bps');
                    // BackendHurdleData.COlValues.add(pf.Backend_Hurdle__c==null?'':''+pf.Backend_Hurdle__c);
                    if(pf.Backend_Hurdle__c!=null){
                    Decimal d1 = pf.Backend_Hurdle__c;
                     List<String> args1 = new String[]{'0','number','###,###,##'};
                    String ds1 = String.format(d1.round(System.RoundingMode.HALF_EVEN).format(), args1 );
                     // CH03 start
                     BackendHurdleData.COlValues.add('$'+ds1);
                    // BackendHurdleData.COlValues.add('$'+ d1.round(System.RoundingMode.HALF_EVEN));
                     //CH03 Ends
                     }
                    //BackendTAPotential.COlValues.add(pf.Backend_TA_Potential__c==null?'':''+pf.Backend_TA_Potential__c);
                    //CH02 start
                    if(pf.Backend_TA_Potential__c!=null){
                     Decimal d6 = pf.Backend_TA_Potential__c;
                    List<String> args6 = new String[]{'0','number','###,###,##'};
                 
                      String ds6 = String.format(d6.round(System.RoundingMode.HALF_EVEN).format(), args6 );
                    //CH03 start
                    BackendTAPotential.COlValues.add('$'+ds6); 
                   //BackendTAPotential.COlValues.add('$'+ d6.intValue());
                     //CH03 Ends
                     }
                   // TotalTAPotential.COlValues.add(pf.Total_TA_Potential__c==null?'':''+pf.Total_TA_Potential__c);
                   if(pf.Total_TA_Potential__c!=null){
                     Decimal d7 = pf.Total_TA_Potential__c;
                    List<String> args7 = new String[]{'0','number','###,###,##'};
                    String ds7 = String.format(d7.round(System.RoundingMode.HALF_EVEN).format(), args7 );
                     //CH03 start
                     TotalTAPotential.COlValues.add('$'+ds7); 
                    // TotalTAPotential.COlValues.add('$'+d7.intValue()); 
                      //CH03 Ends
                     }
                     // CH02 End
                    PlatformData.COlValues.add(pf.Platform__c==null?'':''+pf.Platform__c);
                    BranchData.COlValues.add(pf.Branch__c==null?'':''+pf.Branch__c);
                    OSJData.COlValues.add(pf.OSJ__c==null?'':''+pf.OSJ__c);
                    TermData.COlValues.add(pf.Loan_Term__c==null?'':''+pf.Loan_Term__c);
                    PayoutData.COlValues.add(pf.Level_Payout__c==null?'':''+pf.Level_Payout__c +'%');
                    CampaignData.COlValues.add(pf.Campaign__c==null?'':''+pf.Campaign__c);
                   // WaviersData.COlValues.add(pf.Fee_Waivers__c==null?'':''+pf.Fee_Waivers__c);
                   if(pf.Fee_Waivers__c!=null){
                     Decimal d3 = pf.Fee_Waivers__c;
                    List<String> args2 = new String[]{'0','number','#,###.0'};
                    String ds3 = String.format(d3.format(), args2);
                     WaviersData.COlValues.add('$'+ds3); 
                     }
                   // AdminFeesData.COlValues.add(pf.Admin_Fees__c==null?'':''+pf.Admin_Fees__c +'bps');
                   if(pf.Admin_Fee__c!=null){
                     Decimal d4 = pf.Admin_Fee__c;
                    List<String> args4 = new String[]{'0','number','#,###.0'};
                    String ds4 = String.format(d4.format(), args4);
                     AdminFeesData.COlValues.add(+ds4+' '+'bps'); 
                     }
                     // CH02 Start
                 //   NoteData.COlValues.add(pf.Notes__c==null?'':''+pf.Notes__c);
                    // CH02 End
                  //  LoannautoData.COlValues.add(pf.Date__c==null?'':''+pf.Date__c);
                   // Clause.COlValues.add(pf.Loan_Clause__c==null?'':''+pf.Loan_Clause__c); 
                    
                } 
                pData.add( HeaderData );
                pData.add( MaxTAAMTData );
              //pData.add( AccTAAMTData );
                pData.add( IntRateData );
                //Commneted below line as per confimation from Abdul - 11/12/2020 - Amol
                pData.add( IntRateExpected );
                pData.add( IntRateGDC );
              //  pData.add( BackenDate );
              //  pData.add( BackenDate1 );
                pData.add( BackendBPSData );
                pData.add( BackendHurdleData );
                pData.add( BackendTAPotential );
                pData.add( TotalTAPotential);
                pData.add( PlatformData );
                pData.add( BranchData );
                pData.add( OSJData );
                pData.add( TermData );
                pData.add( PayoutData );
                pData.add( CampaignData );
                pData.add( WaviersData );
                pData.add( AdminFeesData );
              //  pData.add( NoteData );
              //  pData.add( LoannautoData );
              //  pData.add( Clause );
                
                return pData;
            }
           
        }catch(Exception ex){
            return null;
        }
        return null;
        
    }
    
    
    
    public class PropWrapper{
        public String ColHeader{get;set;}
        public List<Object> COlValues{get;Set;}
        public PropWrapper(String Name){
            ColHeader=Name;
            COlValues=new List<Object>();
        }
    }
}