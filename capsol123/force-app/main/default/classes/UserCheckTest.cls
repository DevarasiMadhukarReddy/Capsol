/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UserCheckTest {
    
    static testMethod void myUnitTest() {
        List<User> users = new List<User>{};
        String profileId = [select Profile.Id from User where Id = :UserInfo.getUserId()].profile.Id;
        for(Integer i = 0; i < 250; i++){
            User a = new User( Username = 'hrwf' + i + '@2dimtech.com',
            Lastname = 'Schmo',
            Firstname = 'Joe',
            Email = 'hr@2dimtech.com',
            Alias = 'Test9029',
            IsActive = true,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = profileId,
            LanguageLocaleKey = 'en_US');
            users.add(a);
        }
        insert users;
        
        users[0].IsActive = false;
        update users;
    }
}