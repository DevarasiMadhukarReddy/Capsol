/***
     * This class is used to check the  case to inittiate MonetizationLoan  App.used in javascript button on case object
     * sprint 13-CS-1322

     * Author - Anil Gunti
     * Date  - 06/25
     * 
     * 
     */
global with sharing class caseController {
    webservice static boolean loadLoanApplication(Id caseId){
        try{
            Case CS=[select Id,Status,CaseNumber from Case where Id=:caseId  and Status='Completed'];
            return true;
        }catch(Exception ex){
            return false;
        }
          
    }
}