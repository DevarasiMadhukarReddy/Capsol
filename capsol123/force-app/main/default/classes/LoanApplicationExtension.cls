/***
     * This class is used to set boolean paramenters to display OOB pages and Custom UI
     * 
     * 
     *      * 
     * Author - Amol Deshpande
     * 
     * 
     * 
     */
public class LoanApplicationExtension {
    public Boolean show{get;set;}
    public Boolean showRepayable{get;set;}
    public LoanApplicationExtension(ApexPages.StandardController stdController) {
        Loan_Application__c Record=(Loan_Application__c)stdController.getRecord();
        this.show=(Record.RecordType.Name=='Transition Assistance' || Record.RecordType.Name=='Working Capital' || Record.RecordType.Name=='Retention Loan' || Record.RecordType.Name=='Monetization')?false:true;
        this.showRepayable=(Record.RecordType.Name=='Acquisition Loan' || Record.RecordType.Name=='Backend TA' || Record.RecordType.Name=='Growth Loan' || Record.RecordType.Name=='Line of Credit' || Record.RecordType.Name=='Refinance Loan')?false:true;
    }
   
}