/***
 * Created By Bhanu 10/24/2020 CS-2072- Sprint 17 Provide Access to Loan application based on Team 
 * 
 */
 global class cls_LPL_checkLoggedInUserAccess 
{
    
     @AuraEnabled
    webservice static boolean checkLoggedInUserAccess(String source) {
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
    
      @AuraEnabled
    Public static boolean checkLoggedInUserAccess1(String source) {
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