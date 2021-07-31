@isTest
public class clsCustomUIControllerTest {
    
    @isTest
    static void test1(){
        Account Acc=wcLoanApplicationControllerTest.createAccount('AccName');
        Contact con=wcLoanApplicationControllerTest.CreateContact('FName', 'LName', Acc.Id);
        String data='{"businessLegalNameDBA":"dfgdf","noOfAdvisors":"0345345","legalEntity":"Sole Proprietorship","currentRegistration":"RIA","currentCustodian":"ertert","mutualFundsDirectlyHeld":343,"advisorTotalAUM":"17547.00","mutualFundsCustodied":3434,"variableAnnuties":3434,"fixedAnnuties":3434,"fixedIncome":3434,"equity":34,"aiUITCash":3434,"totalAdvisoryAUM":0,"advisoryRevenue":3434,"totalProduction":"3468.00","brokerageRevenue":34,"rowProRow":5,"platformPicklist1":"Hybrid","branchPicklist1":"New Branch / HOS","osjLEName1":"dfg","termLength1":"7 Years","uWTypePicklist1":"Simplified","campaignName1":"retert","platformPicklist2":"Corporate","branchPicklist2":"New Branch / HOS","osjLEName2":"tret","termLength2":"5 Years","uWTypePicklist2":"Premium Model","campaignName2":"ertert","platformPicklist3":"Corporate","branchPicklist3":"New Branch / HOS","osjLEName3":"ertert","termLength3":"7 Years","uWTypePicklist3":"Premium Model","campaignName3":"ertert","platformPicklist4":"Corporate","branchPicklist4":"New Branch / HOS","osjLEName4":"ert","termLength4":"7 Years","uWTypePicklist4":"Premium Model","campaignName4":"ertert","platformPicklist5":"Hybrid","branchPicklist5":"New Branch / HOS","osjLEName5":"ertert","termLength5":"5 Years","uWTypePicklist5":"Premium Model","campaignName5":"retertert","AdditionalComment":"reterterterterter","borrowers":[{"ContactId":"'+con.Id+'","pAUM":1,"AUMATT":"0.08","primary":true,"Uname":"Bow1","avail":false}]}';
        clsCustomUIController.saveLoanAppObj(data,null);
        clsCustomUIController.loanAppWrapperObj te=new clsCustomUIController.loanAppWrapperObj();
        te.aumAttributable='';
        te.primaryContact=true;
        te.platformPicklist1='';
        te.platformPicklist2='';
        te.platformPicklist3='';
        te.platformPicklist4='';
        te.platformPicklist5='';
        te.branchPicklist1='';
        te.branchPicklist2='';
        te.branchPicklist3='';
        te.branchPicklist4='';
        te.branchPicklist5='';
        te.osjLEName1='';
        te.osjLEName2='';
        te.osjLEName3='';
        te.osjLEName4='';
        te.osjLEName5='';
        te.termLength1='';
        te.termLength2='';
        te.termLength3='';
        te.termLength4='';
        te.termLength5='';
        te.uWTypePicklist1='';
        te.uWTypePicklist2='';
        te.uWTypePicklist3='';
        te.uWTypePicklist4='';
        te.uWTypePicklist5='';
        te.campaignPicklist1='';
        te.campaignPicklist2='';
        te.campaignPicklist3='';
        te.campaignPicklist4='';
        te.campaignPicklist5='';
        te.rowProRow=0;
        
        
        
        
        
        
    }
}