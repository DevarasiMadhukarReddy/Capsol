/***
 * Created By Bhanu 10/28/2020 CS-2072- Sprint 17 Provide Access to Loan application based on Team 
 * 
 */
global class UserPermissionSetAssignment
{


@future(callout=true)
Public static  void AssignPermissionSet(List<id> UserList)
{

List<PermissionSet> per=new List<PermissionSet> ();

 per=[SELECT Id,IsCustom,IsOwnedByProfile,Label,LastModifiedById,LastModifiedDate,LicenseId,Name FROM PermissionSet where Label='Capsol Restrict Loan Application Access'];

List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
for (User u : [SELECT ID,IsActive FROM User WHERE Id=:UserList])
{ 
    PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = per[0].Id, AssigneeId = u.Id);
    permissionSetList.add(psa);
}
try{
    upsert permissionSetList;
}catch(exception e)
{
    system.debug('exception caught' + e);
}


}

@future
public static void AddRemoveUserFromGroups(List<id> UserList)
{
    Group g=[SELECT Id, DeveloperName from Group Where DeveloperName='LPL_IAS_IS_User_Loan_Group'];  
    List<GroupMember> listGroupMember =new List<GroupMember>();      
    List<User> users=[Select Id, Name, User.Profile.Name, User.IsActive from user Where Id=:UserList]; 
   
    Set<ID> setGroupId = new Set<Id>();
    Set<ID> setUserOrGroupId = new Set<Id>();
   
    for (User user : users)
    {
        //Remove User to the group
        if(user.Profile.Name != 'LPL IAS User' && user.Profile.Name != 'LPL IS User')
        {
                setGroupId.add(g.id);
                setUserOrGroupId.add(user.id);
            
            }
            //Add User to the Group
           else  if(user.Profile.Name == 'LPL IAS User' || user.Profile.Name == 'LPL IS User')
           {
             GroupMember gm= new GroupMember(); 
                gm.GroupId=g.id;
                gm.UserOrGroupId = user.id;
                listGroupMember.add(gm);
            }
    }
        //Remove User
    if( setGroupId.size() > 0 && setUserOrGroupId.size() > 0 )
    {
        List<GroupMember> ListGM  = [ Select Id from GroupMember where UserOrGroupID in :setUserOrGroupId and GroupId  in :setGroupId ];
        if(ListGM.size() > 0 )
        {
            delete ListGM;
        }
        
    }
    //Add User
    if( listGroupMember.size() >0)
    {
    insert listGroupMember;
    }
    
    
}

}