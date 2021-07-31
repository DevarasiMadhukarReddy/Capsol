public class getLoanRecordTypes {
    Public string selectedname{get;set;}
    Public string recordTye {get;set;}
    public  String  headerdata {get;set;}
    public string url {get;set;}
        Public List<Selectoption> getselectedaccnamefields(){
            List<Selectoption> lstnamesel = new List<selectoption>();
            lstnamesel.add(new selectOption('', '- None -'));
            lstnamesel.add(new selectOption('Transition Assistance', 'Transition Assistance'));
            lstnamesel.add(new selectOption('Working Capital', 'Working Capital'));
                        
            return lstnamesel; 
        }
    
    public Pagereference redir(){

        //Pagereference pg = new Pagereference();
        if(selectedname == 'Transition Assistance'){
             headerdata= ApexPages.currentPage().getHeaders().get('Host');
            url='https://' + headerdata;
            recordTye= url+'/aEe/e?retURL=%2FaEe%2Fo&RecordType=0120e000000Q9Pa&ent=01I0e000000VFkW';
         system.debug('Transition Assistance@@@@'+url);
            Pagereference pg = new Pagereference(recordTye);
            system.debug('Growth loan@@@@'+pg);
            pg.setredirect(true);
            return pg;
        }else if(selectedname == 'Working Capital'){
           headerdata= ApexPages.currentPage().getHeaders().get('Host');
            url='https://' + headerdata;
            recordTye= url+'/aEe/e?retURL=%2FaEe%2Fo&RecordType=0120e000000Q9bL&ent=01I0e000000VFkW';
         system.debug('Working Capital@@@@'+url);
            Pagereference pg = new Pagereference(recordTye);
            system.debug('Growth loan@@@@'+pg);
            pg.setredirect(true);
            return pg;  
        }
        
        else
            return null;

    }
    
}