/***
     * This class is used to check the  case to inittiate MonetizationLoan  App.used in Ligthning Component (Quick Action)
     * sprint 13-CS-1322

     * Author - Anil Gunti
     * Date  - 06/25
     * 
     * 
     */
global class EA2LoanCompController {
    @AuraEnabled
    public static Case collectCaseStatus(String recordId){
        try{
            Case CS=[select Id,Status,CaseNumber from Case where Id=:recordId ];
            return (CS.Status=='Completed'?CS:null);
        }catch(Exception ex){
            System.debug(ex);
            System.debug(ex.getMessage());
            System.debug(ex.getLineNumber());
        }
        return null;
    }
    
        @AuraEnabled
    Public static boolean checkLoggedInUserAccess(String source) {
      List<String> recordTypeNameSet = new List<String>();
        boolean access=false;
        Schema.DescribeSObjectResult R = Loan_Application__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        for( Schema.RecordTypeInfo recordType : RT )
        {
            if(recordType.isAvailable())
            { 
                recordTypeNameSet.add(recordType.Name);
                
            }
        }
        
        if(source=='Opportunity')
        {
            for(String RecordTypeName:recordTypeNameSet){
                if(RecordTypeName == 'Transition Assistance' || RecordTypeName =='Working Capital' ||  RecordTypeName == 'Backend TA'  )
                {
                    access=true;
                }
            }
        }
        else if(source=='Contact')
        {
            for(String RecordTypeName:recordTypeNameSet){
                if(RecordTypeName == 'Acquisition Loan' || RecordTypeName =='Growth Loan' || RecordTypeName=='Line of Credit' || RecordTypeName == 'Refinance Loan' )
                {
                    access=true;
                }
            }
        }
        else if(source=='Case')
        {
            for(String RecordTypeName:recordTypeNameSet){
                if(RecordTypeName == 'Monetization' || RecordTypeName =='Retention Loan' )
                {
                    access=true;
                }
            }
        }
        return  access;
    }
    
   
}