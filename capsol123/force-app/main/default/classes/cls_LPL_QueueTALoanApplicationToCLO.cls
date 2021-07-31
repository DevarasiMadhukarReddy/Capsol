/*This Queueable class is used to send when the TA Loan application status is updated as "Offer Accepted" to CLO from SF
* Created By Bhanu 12/23/2020 CS-2516- Update TA application Offer Accepted Criteria.
*
*
*************************************************************************************************************************/
public class cls_LPL_QueueTALoanApplicationToCLO implements Queueable {
    string loanAppId;
    public cls_LPL_QueueTALoanApplicationToCLO (string loanAppId) {
        this.loanAppId = loanAppId;
    }
    public void execute(QueueableContext context) {
        List<Id> propIds = new List<Id>();
        List<Proposal_Offer__c> propsList=new List<Proposal_Offer__c>();
        propsList = [select id,LoanApp_MD__c from Proposal_Offer__c where LoanApp_MD__c =:loanAppId]; 
        for(Proposal_Offer__c Prop: propsList)
        {
            
            propIds.add(prop.id);
            
        }
        cls_LPL_SendLoan_ProposalUpdatestoMule.makePostCallout(Id.valueOf(loanAppId),propIds);
        //cls_LPL_SendSFDatatoMulesoft.makePostCallout(loanAppId,propIds);    
    }
}