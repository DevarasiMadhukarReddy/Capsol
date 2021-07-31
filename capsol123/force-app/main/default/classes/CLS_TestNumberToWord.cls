@isTest
private class CLS_TestNumberToWord {
    static testMethod void testNumberToWord(){
         
         Test.startTest();
         //CLS_NumberToWord.words(loanId); 
         String result = CLS_NumberToWord.english_number(6000);
         system.assertEquals('Six Thousand', result);
         String result1 = CLS_NumberToWord.english_number(100);
         system.assertEquals('One Hundred', result1);
         String result2 = CLS_NumberToWord.english_number(10);
         String result3 = CLS_NumberToWord.english_number(55);
         Test.stoptest();
         
     }
    
    static testMethod void validateConvert_nn() {
        String result = CLS_NumberToWord.convert_nn(1000);
        System.assertNotEquals('One Thousand', result);
    }
    
    static testMethod void validateConvert_nn2() {
        String result = CLS_NumberToWord.convert_nn(90);
        System.assertEquals('Ninety', result);
    }
    
    static testMethod void validateAmountWords() {
        String result = CLS_NumberToWord.amountWords(123);
        System.assertEquals('One Hundred Twenty Three', result);
    }
    
    static testMethod void validateWords() {
        genesis__applications__c app = new genesis__applications__c();
        app.genesis__Loan_Amount__c = 1000;
        INSERT app;
        
        List<Id> appList = new List<Id>();
        appList.add(app.Id);
        CLS_NumberToWord.words(appList);
    }

}