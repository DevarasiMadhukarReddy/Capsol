/***
 * Created By Bhanu 10/26/2020 - Test class for cls_LPL_checkLoggedInUserAccess
 * 
 */
@isTest(seeAllData=false)
private  class cls_LPL_checkLoggedInUserAccessTest {
    testMethod static void testData(){
       

        cls_LPL_checkLoggedInUserAccess.checkLoggedInUserAccess('Opportunity');
        cls_LPL_checkLoggedInUserAccess.checkLoggedInUserAccess('Case');
        cls_LPL_checkLoggedInUserAccess.checkLoggedInUserAccess('Contact');
        cls_LPL_checkLoggedInUserAccess.checkLoggedInUserAccess1('Opportunity');
        cls_LPL_checkLoggedInUserAccess.checkLoggedInUserAccess1('Case');
        cls_LPL_checkLoggedInUserAccess.checkLoggedInUserAccess1('Contact');

    }
}