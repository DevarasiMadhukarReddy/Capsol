public class getRecordTypes {
    Public string selectedname{get;set;}
    Public string recordTye {get;set;}
    public  String  headerdata {get;set;}
    public string url {get;set;}
        Public List<Selectoption> getselectedaccnamefields(){
            List<Selectoption> lstnamesel = new List<selectoption>();
            lstnamesel.add(new selectOption('', '- None -'));
            lstnamesel.add(new selectOption('Growth loan', 'Growth loan'));
            lstnamesel.add(new selectOption('Acquisition loan', 'Acquisition loan'));
            lstnamesel.add(new selectOption('Line of Credit', 'Line of Credit'));
            lstnamesel.add(new selectOption('Refinance Loan', 'Refinance Loan'));
            lstnamesel.add(new selectOption('Retention Loan', 'Retention Loan'));
            
            return lstnamesel; 
        }
    
    public Pagereference redir(){
        
        if(selectedname == 'Growth loan'){
            headerdata= ApexPages.currentPage().getHeaders().get('Host');
            url='https://' + headerdata;
            recordTye= url+'/aEe/e?retURL=%2FaEe%2Fo&RecordType=0120e000000Q9bI&ent=01I0e000000VFkW';
         system.debug('Growth loan@@@@'+url);
            Pagereference pg = new Pagereference(recordTye);
            system.debug('Growth loan@@@@'+pg);
            pg.setredirect(true);
            return pg;
        }else if(selectedname == 'Acquisition loan'){
          headerdata= ApexPages.currentPage().getHeaders().get('Host');
            url='https://' + headerdata;
            recordTye= url+'/aEe/e?retURL=%2FaEe%2Fo&RecordType=0120e000000Q9bH&ent=01I0e000000VFkW';
         system.debug('Acquisition loan'+url);
            Pagereference pg = new Pagereference(recordTye);
            system.debug('Acquisition loans@@@@'+pg);
            pg.setredirect(true);
            return pg;  
        }
        else if(selectedname == 'Line of Credit'){
         headerdata= ApexPages.currentPage().getHeaders().get('Host');
            url='https://' + headerdata;
            recordTye= url+'/aEe/e?retURL=%2FaEe%2Fo&RecordType=0120e000000Q9bJ&ent=01I0e000000VFkW';
         system.debug('Line of Credit@@@@'+url);
            Pagereference pg = new Pagereference(recordTye);
            system.debug('Line of Credit@@@@'+pg);
            pg.setredirect(true);
            return pg;   
        }
        else if(selectedname == 'Refinance Loan'){
          headerdata= ApexPages.currentPage().getHeaders().get('Host');
            url='https://' + headerdata;
            recordTye= url+'/aEe/e?retURL=%2FaEe%2Fo&RecordType=0120e000000Q9bK&ent=01I0e000000VFkW';
         system.debug('Refinance Loans@@@@'+url);
            Pagereference pg = new Pagereference(recordTye);
            system.debug('Refinance Loan@@@@'+pg);
            pg.setredirect(true);
            return pg;  
        }
         else if(selectedname == 'Retention Loan'){
          headerdata= ApexPages.currentPage().getHeaders().get('Host');
            url='https://' + headerdata;
            recordTye= url+'/aEe/e?retURL=%2FaEe%2Fo&RecordType=0120e000000Q9Pb&ent=01I0e000000VFkW';
         system.debug('Retention Loans@@@@'+url);
            Pagereference pg = new Pagereference(recordTye);
            system.debug('Retention Loan@@@@'+pg);
            pg.setredirect(true);
            return pg;  
        }
        else
            return null;

    }
    
}