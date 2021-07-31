/**
 * freezeUserController.cls
 * Description  : Controller Class of freeze User page .This class has logic to provide freeze user of the selected users. 
 * @Author      : Subhash Ghorpade
 * @version     : 1.0
 * @CreatedDate : January 17, 2015
 */

public class freezeUserController {

 
    //List of users as per search string
    
    public List<userwrapper> userList
    {
        get
        {
            if(userList == null)
                userList = new List<userwrapper>();
            return userList;
        }
        set;
    }
   public List<User> selectedUsers = new List<User>();
   public boolean isFreezeButtonDisabled{get;set;}
    
    public freezeUserController(){isFreezeButtonDisabled = true;}
    
    public string searchValue
    {
        get
        {
            if(searchValue == null)
                searchValue = '';
            return searchValue;
        }
        set;
    }
    
    //Get list of users as per search string    
    public PageReference getusers(){
        
        userList.clear();
        String finalSearchValue = '%' + searchValue + '%';
        for(User a : [select Id, Name,UserRole.Name,LastLoginDate from User where isactive=true and Name like :finalSearchValue ORDER BY Name])
        userList.add(new userwrapper(a));
        return null;
    }
    
     //Get list of selected Users
    public PageReference getSelected(){
        
        selectedusers.clear();
        isFreezeButtonDisabled = true;
        for(userwrapper accwrapper : userList){
                
            if(accwrapper.selected == true){   
            
                if(selectedusers.size()<1){
                                        
                        selectedusers.add(accwrapper.acc);
                        isFreezeButtonDisabled = false;
                
                }
                else{
                        
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You can not freeze more than 1 user at a time'));
                isFreezeButtonDisabled = true;
                
                }
        
            }
        }
        return null;
    }
    
    public List<User> GetSelectedusers()
    {
        if(selectedusers.size()>0)
        return selectedusers;
        else
        return null;
    }    
    
    public class userwrapper
    {
        public User acc{get; set;}
        public Boolean selected {get; set;}
        public userwrapper(user a)
        {
            acc = a;
            selected = false;
        }
    }
    
    //Freeze Users
    public PageReference freeze(){
    
       if(selectedUsers.size()>0 ){
       
               for(UserLogin a : [select Id,userId, IsFrozen from UserLogin where userId in : selectedUsers ]){
                        
                        a.IsFrozen = true;
                        update a;
                       
               }
                PageReference userPage = new ApexPages.PageReference('/apex/freezeUser');
                userPage.setRedirect(true);
                return userPage;
                }
        else {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select user to be freezed'));
                                return null;
        
        }   
        
    }

}