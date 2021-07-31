public class TaskControllerExtension {

    private final Task tsk;
    public List<Attachment> att{get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public TaskControllerExtension(ApexPages.StandardController stdController) {
        this.tsk = (Task)stdController.getRecord();
        
        
        tsk.recordtypeId=System.Label.Apex_Call_Recordtype;
        tsk.subject=System.Label.Apex_Call_Subject;
   
    }

   public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      
      return attachment;
    }
  set;
  }
  
 
 public PageReference uploadFile() {
 
    PageReference pr;

    attachment.OwnerId = UserInfo.getUserId();
    
    attachment.IsPrivate = true;

    try {
    
      if(tsk.whatId == null || !(String.valueOf(tsk.whatId).StartsWith('006')) )
      {
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Related To Field Can not be Blank and must contain Opportunity Value'));
           return null;
      }
      else
      {
          attachment.ParentId = tsk.whatId; // the record the file is attached to
          if(attachment.Body != null && attachment.name != null)
          insert attachment;
          
          att=[Select a.Id,a.ContentType,a.ParentId,a.Parent.Type,a.Parent.Name,a.OwnerId,
             a.Owner.Name, a.Name, a.LastModifiedDate, a.BodyLength From Attachment a where a.ParentId =:tsk.whatId order by a.LastModifiedDate DESC LIMIT 1];
          
      }
      
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      return null;
    } finally {
      attachment = new Attachment(); 
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    return null;
  }

    
}