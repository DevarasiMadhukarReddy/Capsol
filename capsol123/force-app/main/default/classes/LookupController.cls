/***
     * This class is used to collect contact Details for all Loan Application
     * Story -CS-1324
     * 
     * Author - Anil Gunti
     * Date  - 06/25
     * 
     * Modified by Amol - 11/24/2020 - To show enterprise name along with Contacts in the borrowers lookup search.
     *CS-2896 Amol 02/11/2021 Differentiate a borrower on an application using a unique Identifier - CH01
     * 
     */


public without sharing class LookupController {
    @AuraEnabled(cacheable=true)
    public static List<object> lookupData(String ObjectName,String SearchText,String ObjectFilter,Boolean LA){
        try{
            String Filter='';
            String query='';

            if(ObjectName=='Contact'){
                //CH01 Start
                query='select Id,Account.Id,Account.Name,CRD_Number__c,Total_AUM_LoanApp__c,Total_Brokerage_AUM__c,Total_Advisory_AUM__c,Name,Modified_R_Type__c,Rep_Type__c,Master_Rep_ID__c,YTD_GDC__c,Prior_Yr_GDC__c,GP_ROA__c,(select Id,Gross_Profit_ROA__c from Advisor_Profitability__r order by LastmodifiedDate Desc limit 1),(Select Id,YTD_GDC_All__c,Prior_full_year_GDC_All__c from Financials__r order by LastmodifiedDate Desc limit 1) from '+ObjectName;
                //CH01 End
                query+=SearchText==''?' order by Name Limit 100':' where Account.Id != null AND Name like \''+SearchText+'%\''+Filter+ ' order by Name Limit 100';
                //return Database.query('select Id,Name,Modified_R_Type__c,Master_Rep_ID__c,YTD_GDC__c,Prior_Yr_GDC__c,GP_ROA__c,(select Id,Gross_Profit_ROA__c from Advisor_Profitability__r order by LastmodifiedDate Desc limit 1),(Select Id,YTD_GDC_All__c,Prior_full_year_GDC_All__c from Financials__r order by LastmodifiedDate Desc limit 1) from '+ObjectName+' where Name like \''+SearchText+'%\''+Filter+ ' Limit 100'); 
                return Database.query(query);
            }else{
                query='select Id,Name from '+ObjectName;
                query+=SearchText==''?' order by Name  Limit 100':' where Name like \''+SearchText+'%\''+Filter+ ' order by Name LIMIT 100';
                //return Database.query('select Id,Name from '+ObjectName+' where Name like \''+SearchText+'%\''+Filter+ ' Limit 100');
                return Database.query(query);
            }
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return new List<Object>();
    }
}