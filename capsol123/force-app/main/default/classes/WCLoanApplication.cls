global without sharing class WCLoanApplication {
    webservice static List<String> checkLoanappliction(String recId)
    {       
        return wcLoanApplicationController.checkLoanappliction(recId);
    }
}