trigger ChangeEloquaContactEmailAddressTgr on Contact (before insert, before update, after update) {
  if( trigger.isAfter )
  {
    set<string> theseEmails = new set<string>();
    set<id> theseIDs = new set<id>();
    for( Contact c : trigger.new ) 
    {
      if( c.Email != null && c.email != '' )
      {
      system.debug (c.email);
        theseEmails.add( c.email );
        theseIDs.add( c.id );
      }
    }

    map<string,string> emailsToChangeInEloqua = new map<string,string>();  
    for( Contact c : trigger.new )
    { 
      if(c != null
         && c.email != null 
         && c.email != '' 
         && trigger.oldMap.get( c.id ) != null
         && trigger.oldMap.get( c.id ).email != null
         && trigger.oldMap.get( c.id ).email != ''
         && c.email != trigger.oldMap.get( c.id ).email //only when changing it do we check 
        )
      {
//        system.debug ('add records ' + c.email + ' and ' + trigger.oldMap.get( c.id ).email);
        emailsToChangeInEloqua.put(trigger.oldMap.get( c.id ).email, c.email);
      }
    }

    if( emailsToChangeInEloqua.size()  > 0 )
    {
      ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress(emailsToChangeInEloqua);
//      system.debug ('class called');
    }
  }
}