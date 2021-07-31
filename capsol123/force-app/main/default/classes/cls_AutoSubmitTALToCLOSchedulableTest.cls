/*Test class for cls_LPL_AutoSubmitTALoanAppToCLO
* Created By Bhanu 12/24/2020 CS-2516- Update TA application Offer Accepted Criteria.
*
*
*****************************************************************************************/
@isTest
public class cls_AutoSubmitTALToCLOSchedulableTest {
    public static testMethod void testexecuteMethod()
    {
        System.Test.StartTest();
        cls_LPL_AutoSubmitTALToCLOSchedulable  prbObj = new cls_LPL_AutoSubmitTALToCLOSchedulable();
        String sch = '0 0 0 15 3 ? 2050'; 
        system.schedule('test',sch,prbObj); 
        system.Test.stopTest();
    }

}