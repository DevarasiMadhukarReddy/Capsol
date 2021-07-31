public with sharing class testDataSetUpUtility {
    
    public static final String ROLE_LPL = 'LPL Financial';
   
    public static final String PROFILE_IAS = 'LPL IAS User';

    private static Map<String,Id> mapRoleNameToId = new Map<String,Id>();
    private static Map<String,Id> mapProfileNameToId = new Map<String,Id>(); 
    
    static {
        for(UserRole ur : [select Id, Name from UserRole where Name IN (:ROLE_LPL)]) {
            mapRoleNameToId.put(ur.Name, ur.Id);
        }
        
        for(Profile prof : [select Id, Name from Profile where Name IN (:PROFILE_IAS)]) {
            mapProfileNameToId.put(prof.Name, prof.Id);
        }
    }
    
    
    
     /**  
     * Create a new user
     * @return User      create a new user and return it.
     */
    public static User getNewUserCreated() {
        User user = new User(
            Username = getRandomUsername(7)+'@lpltest.com',
            Email = getRandomUsername(7)+'@lpltest.com',
            LastName = 'Test User '+getRandomUsername(3),
            Alias = getRandomUsername(6),
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey='UTF-8'
        );
        return user;
    }
    
     /**  
     * To create a new user with given role and profile
     * @param roleName      Role of the user to be created  
     * @param profileName   Profile of the user to be created
     * @return User         returns the newly created user.
     */
    public static User createNewUser(String roleName, String profileName) {
        User u = getNewUserCreated();
        u.ProfileId = mapProfileNameToId.get(profileName);
        u.UserRoleId = mapRoleNameToId.get(roleName);
        insert u;
        
        return u;
    }
    
    /**  
     * method to generate a random string to be used as username
     * @param len           length of the random string to be generated  
     * @return String       random string of the given length
     */
    public static String getRandomUsername(Integer len) {
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key.substring(0,len);
    }
    
     /**  
     * To create a new user with given role and profile
     * @param roleName      Role of the user to be created  
     * @param profileName   Profile of the user to be created
     * @return User         returns the newly created user.
     */
    public static User assignUserToPermissionSet(User  u, String permissionSetName) {
              
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        
        return u;
    }
   
   
   /**  
     * Create a new Contact
     * @return Contact      create a new Contact and return it.
     */
    public static Contact getNewContactCreated() {
    
        account salesforceaccount=getNewAccountCreated();
        insert salesforceaccount;
       
        user internalAdvisoryConsultant = createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);   
        user regionalAdvisoryConsultant = createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);      
        user integrationManager = createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);
        user InternalAnnuityConsultantc = createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);
        user InternalAIConsultantc=createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);        
        
        Contact con = new Contact(
            
            Master_Rep_ID__c='12345',
            LastName='testcontactLastName',
            Conversion_Date__c= Date.newInstance(2015, 2, 17),
            LPLCRM__Assistant_Name__c= 'Test Assistant_Name__c '+getRandomUsername(9),
            //Name= 'Name'+getRandomUsername(7),
            AccountId=salesforceaccount.id
            ,Phone='1111111111'
            ,Role__c='Test Role'
            ,Role_Override__c='Test Role_Override'
            ,Description='Test Description'
            ,Website__c='www.test.com'
            ,Internal_Advisory_Consultant__c=internalAdvisoryConsultant.id
            ,Regional_Advisory_Consultant__c=regionalAdvisoryConsultant.id
            ,Integration_Manager__c=integrationManager.id
            ,Internal_Annuity_Consultant__c=InternalAnnuityConsultantc.id
            ,Internal_AI_Consultant__c=InternalAIConsultantc.id            
            ,Internal_Insurance_Specialist__c='Test Internal_Insurance_Specialist'
            ,External_Insurance_Specialist__c='Test External_Insurance_Specialist'
            ,BC_RM_Region__c='Test BC_RM_Region__c'
            ,Advisory_Territory__c='Test Advisory'
            ,Service_360_Team__c='Test Service_360_Team'
            ,Designated_Principal__c='Test Designated_Principal'
            ,Education_Consultant__c='Test Education_Consultant'
            ,Retirement_Partners_RM__c='Test Retirement_Partners',
             Email = 'testAem@lpltest.com'            
        );
        
        System.debug('Contact details=============================='+con);
        return con;
    }
    
    
    /**  
     * Create a new Account
     * @return Account      create a new Account and return it.
     */
    public static Account getNewAccountCreated() {
        Account acc = new Account(
            name = getRandomUsername(7)+'Test Account'        
        );
        return acc;
    }
    
     /**  
     * Create a new Exceptions_History__c 
     * @return Exceptions_History__c create a new Exceptions_History__c and return it.
     */
    public static Exceptions_History__c getNewExceptionCreated() {
    
         user ApprovedBy=createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);        
        
         Exceptions_History__c excep = new Exceptions_History__c(
                  
            Name= 'Test Exception'+ getRandomUsername(7)
            , Expiration_or_Review_Date__c=Date.newInstance(2015, 2, 17)
            , Exception_Value__c='TestExce'
            , Exception_Type__c='Exce'
            , Exception_Does_Not_Expire__c=true 
    
        );
        return excep;
    }
    
}