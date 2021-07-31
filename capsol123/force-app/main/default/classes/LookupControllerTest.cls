@isTest(seeAlldata=false)
public class LookupControllerTest {
	@isTest
    static void  test1(){
        LookupController.lookupData('User', ''+UserInfo.getFirstName(), '',true);
    }
    @isTest
    static void  test2(){
        LookupController.lookupData('User', ''+UserInfo.getFirstName(), 'test',false);
    }
    @isTest
    static void  test3(){
        LookupController.lookupData('Contact', ''+UserInfo.getFirstName(), '',true);
    }
}