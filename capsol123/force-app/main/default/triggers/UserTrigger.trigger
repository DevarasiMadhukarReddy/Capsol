/***
 * Created By Bhanu 10/24/2020 CS-2072- Sprint 17 Provide Access to Loan application based on Team 
 * Created to assign permission set to User
 */
trigger UserTrigger on User (After Insert,after update,before Update) {

 if ((trigger.isInsert) && (trigger.isAfter)){
 
List<Id> userIds= new List<Id>();
for (User usr : trigger.new)
{
userIds.add(usr.Id);
}
UserPermissionSetAssignment.AssignPermissionSet(userIds);
//UserPermissionSetAssignment.AddRemoveUserFromGroups(userIds); //Commented by Bhanu on 11/25

}
 else if ((trigger.isUpdate) && (trigger.isAfter))
 {
 List<Id> userIds= new List<Id>();
 for (User usr : trigger.new)
 {
 userIds.add(usr.Id);

 }
  //UserPermissionSetAssignment.AddRemoveUserFromGroups(userIds);//Commented by Bhanu on 11/25
 }

}