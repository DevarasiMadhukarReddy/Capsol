@isTest(SeeAllData=false) 
private class freezeUserControllerTest{
    
    static User ManagerUser;

  
    /**  
     * Method to initialize all the common data used accross testmethods
     */
    static testmethod void testcase1_freezeUser() {
        
        // create a IAS user and assign him to permission set provisioning team
        ManagerUser = testDataSetUpUtility.createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);
        ManagerUser = testDataSetUpUtility.assignUserToPermissionSet(ManagerUser,'Provisioning_Team_Freeze_User');
        
        
        System.runAs(ManagerUser) {
            
            
            freezeUserController controller = new freezeUserController();           
            
            ApexPages.currentPage().getParameters().put('searchValue', 'geo');
            controller.getusers();
            
            controller.userList.get(0).selected = true; 
            controller.selectedUsers.add(controller.userList[0].acc);
            controller.GetSelectedusers();
            controller.getSelected();
            controller.freeze();
        
        }
    }
    
    static testmethod void testcase2_freezeUser() {
        
        // create a IAS user and assign him to permission set provisioning team
        ManagerUser = testDataSetUpUtility.createNewUser(testDataSetUpUtility.ROLE_LPL, testDataSetUpUtility.PROFILE_IAS);
        ManagerUser = testDataSetUpUtility.assignUserToPermissionSet(ManagerUser,'Provisioning_Team_Freeze_User');
        
        
        System.runAs(ManagerUser) {         
            
            freezeUserController controller = new freezeUserController();       
            
            ApexPages.currentPage().getParameters().put('searchValue', 'geo');
            controller.getusers();          
            controller.userList.get(0).selected = true;
            controller.userList.get(1).selected = true; 
            controller.selectedUsers.add(controller.userList[0].acc);
            controller.selectedUsers.add(controller.userList[1].acc);
            controller.GetSelectedusers();
            controller.getSelected();
            controller.freeze();
        
        }
    }
    
    
}