/*
Class Name                : baqViewController 
Class Description         : View controller for baqViewPage
Developer Name            : Sai Kethu - CTS
Created Date              : 11/10/16
               
##############Change History#############
CH.No       Description                                         Developer           Date
------------------------------------------------------------------------------------------------
CH-01    
LCR019 Opportunity - BAQ VF page     BAQ lightning functionality                      Sujit                 12/28/2018
CH-03 Added Prior_Firm_Type__c in the query                      Vaibhav Jain        02/18/2019      

*/

public class baqViewController {
    
    
    public baqViewController(ApexPages.StandardController controller){   
    
    }
    
    public baq__C baq{
        get{
            if(baq == null){
               
                if (baqUrlId != null) {
                    
                    baq = [SELECT    Id, Name, Use_for_TAT_Verification_Only__c, Current_Trailing_12_GDC__c, Contact__c, X2yr_Prior_GDC__c,
                                     Opportunity__c, X3yr_Prior_GDC__c, Current_Firm__c, X4yr_Prior_GDC__c, Broker_Dealer_Shutdown__c, AUM_Other__c,
                                     Current_Custodian__c, Joining_RIA_or_Corporate__c, Number_of_Advisors__c, GDC_SAM_SWM__c, AUM_SAM_SWM__c,
                                     Accounts_SAM_SWM__c, SAM_SWM_Avg_Fee__c, GDC_Separately_Managed_Accounts__c, AUM_Separately_Managed_Accounts__c,
                                     Accounts_Separately_Managed_Accounts__c, Separately_Managed_Accounts_Avg_Fee__c, GDC_MWP__c, AUM_PWP__c, 
                                     Accounts_PWP__c,PWP_Avg_Fee__c, GDC_PWP__c, AUM_MWP__c, Accounts_MWP__c, MWP_Avg_Fee__c, GDC_OMP__c, AUM_OMP__c,
                                     Accounts_OMP__c, OMP_Avg_Fee__c, GDC_GWP__c, AUM_GWP__c, Accounts_GWP__c, GWP_Avg_Fee__c, GDC_TAMPs_or_3rd_Party__c,
                                     AUM_TAMPs_or_3rd_Party__c, Accounts_TAMPs_or_3rd_Party__c, TAMPs_or_3rd_Party_Avg_Fee__c, GDC_Financial_Planning__c,
                                     AUM_Financial_Planning__c, Accounts_Financial_Planning__c, Financial_Planning_Avg_Fee__c, Prior_Firm_Type__c       //CH-03 Added Prior_Firm_Type__c in the query 
                                     FROM baq__C WHERE Id = :baqUrlId];
                } 
            }
            else {
                baq = new baq__C ();
                
            }            
            return baq;
        }
        set{
            baq = value;
            baqUrlId = value.Id;
        } 
    
    }
    private Id baqUrlId;
    
    //LCR019 Opportunity - BAQ VF page  Started 
    @AuraEnabled
    public static baq__C getDetails(Id recordId){
        baq__C baq = [SELECT    Id, Name, Use_for_TAT_Verification_Only__c, Current_Trailing_12_GDC__c, Contact__c, X2yr_Prior_GDC__c,
                      Opportunity__c,Opportunity__r.Name, X3yr_Prior_GDC__c, Current_Firm__c, X4yr_Prior_GDC__c, Broker_Dealer_Shutdown__c, 
                      Current_Custodian__c, Joining_RIA_or_Corporate__c, Number_of_Advisors__c, GDC_SAM_SWM__c, AUM_SAM_SWM__c,AUM_Other__c,
                      Accounts_SAM_SWM__c, SAM_SWM_Avg_Fee__c, GDC_Separately_Managed_Accounts__c, AUM_Separately_Managed_Accounts__c,
                      Accounts_Separately_Managed_Accounts__c, Separately_Managed_Accounts_Avg_Fee__c, GDC_MWP__c, AUM_PWP__c, 
                      Accounts_PWP__c,PWP_Avg_Fee__c, GDC_PWP__c, AUM_MWP__c, Accounts_MWP__c, MWP_Avg_Fee__c, GDC_OMP__c, AUM_OMP__c,
                      Accounts_OMP__c, OMP_Avg_Fee__c, GDC_GWP__c, AUM_GWP__c, Accounts_GWP__c, GWP_Avg_Fee__c, GDC_TAMPs_or_3rd_Party__c,
                      AUM_TAMPs_or_3rd_Party__c, Accounts_TAMPs_or_3rd_Party__c, TAMPs_or_3rd_Party_Avg_Fee__c, GDC_Financial_Planning__c,Status__c,
                      AUM_Mutual_Funds__c,Total_Fee_Based_AUM_Number_Field__c,Percentage_of_Mutual_Funds_Held_Direct__c,Total_Avg_Fee_Number_Field__c,
                      AUM_Variable_Annuities__c,Total_Advisory_Brokerage_AUM__c,AUM_Fixed_Annuities__c,AUM_Equity__c,AUM_Fixed_Income__c,Total_Transactional_Brokerage_AUM__c,Level_Payout_Request__c,
                      Affiliation_1__c,Branch_1__c,OSJ_LE_1__c,Affiliation_2__c,Branch_2__c,OSJ_LE_2__c,Affiliation_3__c,Branch_3__c,OSJ_LE_3__c,Previous_LPL_Advisor__c,Request_for_Fee_Reduction__c,
                      AUM_Financial_Planning__c, Accounts_Financial_Planning__c,Additional_Comments__c, Financial_Planning_Avg_Fee__c,Createddate, createdby.Name,lastmodifieddate,Lastmodifiedby.Name,Prior_Firm_Type__c      //CH-03 Added Prior_Firm_Type__c in the query 
                      FROM baq__C WHERE Id = :recordId];
        
        return baq;
    }
    
    @AuraEnabled
    public static void deleteBaq(String recordId){
        Baq__c recToDelete = [Select Id from Baq__c Where Id=:recordId];
        delete recToDelete;
    }
//LCR019 Opportunity - BAQ VF page   Ended 
    
}