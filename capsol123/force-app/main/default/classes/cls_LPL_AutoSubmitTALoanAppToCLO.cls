/*This class is used to send when the TA Loan application status is updated as "Offer Accepted" to CLO from SF
* Created By Bhanu 12/23/2020 CS-2516- Update TA application Offer Accepted Criteria.
*
*
*/
global class cls_LPL_AutoSubmitTALoanAppToCLO implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful 
{
    global  List<String> loanApplicationIds = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        
        return Database.getQueryLocator('SELECT id,Status__c,RecordTypeId,Loan_SF_CLO_Status__c  from Loan_Application__c where Loan_SF_CLO_Status__c =false and Status__c= \'Offer Accepted\' and RecordType.Name= \'Transition Assistance\'');
    }
    
    global void execute(Database.BatchableContext BC, List<Loan_Application__c> loanApplication) 
    {
        try
        {
            MAP<string,List <Borrowers__c>> LoanApplicationBorrowersMap = new MAP<string,List <Borrowers__c>>();
            MAP<string,List <Proposal_Offer__c>> LoanApplicationProposalMap = new MAP<string,List <Proposal_Offer__c>>();
            List <Borrowers__c> BorrowersList = new List <Borrowers__c>();
            List<Proposal_Offer__c> propsList=new List<Proposal_Offer__c>();
            
            
            List <Borrowers__c> LoanApplicationBorrowersList = new List <Borrowers__c>();
            List <Proposal_Offer__c> LoanApplicationpropsList = new List <Proposal_Offer__c>();
            
            //Get all the Borrowers related to all the Loan Applications
            BorrowersList= [select Id, Name,Contact__r.RecordType.Name,Contact__r.Hire_Date__c ,Loan_Application__c,Loan_Application__r.Opportunity__r.StageName from Borrowers__c where Loan_Application__c=:loanApplication];
            
            //Get all the Proposals related to all the Loan Applications
            propsList = [select id,LoanApp_MD__c from Proposal_Offer__c where LoanApp_MD__c =:loanApplication]; 
            
            if(propsList.size()>0)
            {
                
                for(Proposal_Offer__c Props: propsList)
                {
                    
                    if(LoanApplicationProposalMap.get(Props.LoanApp_MD__c) == null)
                    {
                        LoanApplicationProposalMap.put(Props.LoanApp_MD__c,new List<Proposal_Offer__c>{Props});
                    }
                    else
                    {
                        LoanApplicationProposalMap.get(Props.LoanApp_MD__c).add(Props);
                    }
                    
                    
                }
                
            }
            
            if(BorrowersList.size()>0)
            {
                
                for(Borrowers__c Borrowers: BorrowersList)
                {
                    
                    if(LoanApplicationBorrowersMap.get(Borrowers.Loan_Application__c) == null)
                    {
                        LoanApplicationBorrowersMap.put(Borrowers.Loan_Application__c,new List<Borrowers__c>{Borrowers});
                    }
                    else
                    {
                        LoanApplicationBorrowersMap.get(Borrowers.Loan_Application__c).add(Borrowers);
                    }
                    
                    
                }
                
                for(String loanAppId : LoanApplicationBorrowersMap.keyset())
                {
                    LoanApplicationBorrowersList = LoanApplicationBorrowersMap.get(loanAppId);
                    
                    //Iterate Over the Borrowers
                    if(LoanApplicationBorrowersList.size()>0)
                    {
                        Integer cnt=0;
                        for(Borrowers__c Borrowers: LoanApplicationBorrowersList)
                        {
                            if( Borrowers.Contact__r.Hire_Date__c !=null && Borrowers.Loan_Application__r.Opportunity__r.StageName =='Closed-Joined' ) 
                            {
                                cnt=cnt+1;
                            }
                            
                        }
                        if(cnt== LoanApplicationBorrowersList.size() )
                        {
                            system.debug('Inside Finish method'+cnt);
                            //Get Proposal related to loan Application
                            LoanApplicationpropsList = LoanApplicationProposalMap.get(loanAppId);
                            List<Id> propIds = new List<Id>();
                            if(LoanApplicationpropsList.size()>0)
                            {
                                for(Proposal_Offer__c prop: LoanApplicationpropsList)
                                {
                                    propIds.add(prop.id);
                                }
                                
                            }
                            loanApplicationIds.add(loanAppId);
                            
                            System.enqueueJob(new cls_LPL_QueueTALoanApplicationToCLO(loanAppId));
                            for(Loan_Application__c loanRec: loanApplication)
                            {
                                if(loanRec.id == loanAppId)
                                {
                                    Loan_Application__c loanRecOne=loanRec;
                                    loanRecOne.Loan_SF_CLO_Status__c=true;
                                    update loanRecOne;
                                    
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
            
            
            
        }
        catch(Exception e){
            system.debug('An exception occurred: ' + e.getMessage());
            system.debug('An exception occurred: ' + e.getStackTraceString());
        }
        
    }
    
    global void finish(Database.BatchableContext BC) 
    {     
        system.debug('Inside Finish method'+loanApplicationIds);
        
        
    }
}