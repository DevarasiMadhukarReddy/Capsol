trigger ChangeEloquaLeadEmailAddressTgr on Lead (before insert, before update, after update) {
  if( trigger.isAfter )
  {
    set<string> theseEmails = new set<string>();
    set<id> theseIDs = new set<id>();
    for( Lead l : trigger.new ) 
    {
      if( l.Email != null && l.email != '' )
      {
      system.debug (l.email);
        theseEmails.add( l.email );
        theseIDs.add( l.id );
      }
    }

    map<string,string> emailsToChangeInEloqua = new map<string,string>();  
    for( Lead l : trigger.new )
    { 
      if(l != null
         && l.email != null 
         && l.email != '' 
         && trigger.oldMap.get( l.id ) != null
         && trigger.oldMap.get( l.id ).email != null
         && trigger.oldMap.get( l.id ).email != ''
         && l.email != trigger.oldMap.get( l.id ).email //only when changing it do we check 
        )
      {
//        system.debug ('add records ' + l.email + ' and ' + trigger.oldMap.get( c.id ).email);
        emailsToChangeInEloqua.put(trigger.oldMap.get( l.id ).email, l.email);
      }
    }

    if( emailsToChangeInEloqua.size()  > 0 )
    {
      ChangeEloquaEmailAddressCls.ChangeEloquaEmailAddress(emailsToChangeInEloqua);
//      system.debug ('class called');
    }
  }
}