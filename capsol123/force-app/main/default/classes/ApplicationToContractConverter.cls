global class ApplicationToContractConverter {
    
    Webservice static String convertToCLContract(String appId, String appType, String interestRate) {
        Savepoint sp = Database.setSavepoint();
        String res; 
        loan.GlobalLoanUtilFacade loanFacade = new loan.GlobalLoanUtilFacade();
        date systemDate = loanFacade.getCurrentSystemDate();
        genesis.ConvertApplicationCtrl ctrl = new genesis.ConvertApplicationCtrl();
        try{
            
            genesis__Applications__c app = [SELECT Id, Name, genesis__Expected_First_Payment_Date__c, Application_Type__c, genesis__Interest_Rate__c,No_Payments__c
                                            FROM genesis__Applications__c WHERE Id = :appId LIMIT 1];
            Date firstPaymentDate;
            if((!(String.valueOf(app.Application_Type__c)).equals(ConstantsCl.FORGIVABLE_LOAN)) && (!(String.valueOf(app.Application_Type__c)).equals(ConstantsCl.RETENTION_LOAN)) ) {
                firstPaymentDate = loan.DateUtil.getNextCycleDate(systemDate, systemDate.day(), ConstantsCl.LOAN_PAYMENT_FREQUENCY_SEMI_MONTHLY , null, null, 1);
            } else {
                firstPaymentDate = loan.DateUtil.getNextCycleDate(systemDate, systemDate.day(), ConstantsCl.LOAN_PAYMENT_FREQUENCY_MONTHLY , null, null, 1);
            }
            app.genesis__Expected_First_Payment_Date__c = firstPaymentDate;
            UPDATE app;
            
            if((!(String.valueOf(app.Application_Type__c)).equals(ConstantsCl.FORGIVABLE_LOAN)) && (!(String.valueOf(app.Application_Type__c)).equals(ConstantsCl.RETENTION_LOAN)) ) {
            
                genesis__Rate_Schedule_Setup__c rate_setup = new genesis__Rate_Schedule_Setup__c();
                genesis__Rate_Schedule_Setup__c rate_setup2 = new genesis__Rate_Schedule_Setup__c();
                
                rate_setup.genesis__Application__c = app.Id;
                rate_setup.genesis__Interest_Rate__c = 0;
                rate_setup.genesis__sequence__c = 1;
                rate_setup.genesis__Start_Date__c = systemDate;
                
                rate_setup2.genesis__Application__c = app.Id;
                rate_setup2.genesis__Interest_Rate__c = app.genesis__Interest_Rate__c;
                rate_setup2.genesis__sequence__c = 2;
                rate_setup2.genesis__Start_Date__c = loan.DateUtil.getNextCycleDate(systemDate, systemDate.day(), ConstantsCl.LOAN_PAYMENT_FREQUENCY_SEMI_MONTHLY , firstPaymentDate, null, Integer.valueOf(app.No_Payments__c));
                
                List<genesis__Rate_Schedule_Setup__c> rateList = new List<genesis__Rate_Schedule_Setup__c>(); 
                rateList.add(rate_setup);
                rateList.add(rate_setup2);
                
                try {
                    INSERT rateList;
                    res = ctrl.convertApplication(app.Id);
                } catch(Exception e) {
                    throw new genesis.OriginationException(e.getMessage()+ 'at line number:'+e.getLineNumber());
                }
            }
         }catch(Exception e){
             Database.Rollback(sp);
             return 'Contract generation failed. Error : ' + e.getMessage();
         }
         return res;
    }
}