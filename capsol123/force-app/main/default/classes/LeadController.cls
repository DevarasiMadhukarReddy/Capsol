/*-------------------------------------------------------------------------------------
This class serves as the Base Framework for different Lead operations.
History
<Date>           <Authors Name>        <Brief Description of Change>
APR-24-2021		 Indrasen			   LBSFNS-29 - WEB FORM To Lead.
--------------------------------------------------------------------------------------*/
public class LeadController implements Queueable {
    
    public List<Contact> contList;
    
    public LeadController(List<Contact> updContacts){
        this.contList = updContacts;
    }
    
    
    public void execute(QueueableContext context){
        if(!Test.isRunningTest())
            LBS_LeadControllerHandler.createLead(contList);
    }
}