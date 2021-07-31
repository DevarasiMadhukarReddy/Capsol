import { LightningElement,api,track  } from 'lwc';

export default class WcFinancialDetailComp extends LightningElement {
    @api display=false;
    @api editRecord=false;
    @api showHeader=false;
    
    //this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'BussinessName':event.target.value}}));
    checkNumberlength(event){
        if(event.target.value.length>=15){
            event.preventDefault();
        }
        this.checkdecimalvalue(event);
    }
    checkdecimalvalue(event){
        //alert('d');
        //alert(event.target.value.split('.'));
        if(event.target.value.split('.').length==2){
            if(event.target.value.split('.')[1]>=3){
                event.preventDefault();
            }
        }
    }
    checkData(event){
        //alert(event.target.value);
        if(event.target.value=='0'){
            event.target.value='';
        }
    }
    @api financialData={
        'mfdh':0,
        'mfc':0,
        'va':0,
        'fa':0,
        'fi':0,
        'eq':0,
        'aiuitCash':0,
        'totAdvAum':0,
        'advRev':0,
        'broRev':0,
        'totAUM':0,
        'totProduction':0,
        'totMFC':0,
        'pGDC':0,
        'totBAUM':0,
        'ptotAUM':0,
        'ptotAdvAum':0,
        'ptotBAUM':0,
        'paiuitCash':0,
        'peq':0,
        'pfi':0,
        'pfa':0,
        'pva':0,
        'pmfc':0,
        'pmfdh':0

    };
    handle(event){

    }
    handlemfdh(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'mfdh': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handlemfc(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'mfc': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handleva(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'va': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handlefa(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'fa': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handlefi(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'fi' : event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handleeq(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'eq': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handleaiuitCash(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'aiuitCash': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handletotAdvAum(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'totAdvAum':event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handleadvRev(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'advRev':event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handlebroRev(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'broRev': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
    handletotMFC(event){this.dispatchEvent(new CustomEvent('handlefinancialdata',{detail:{'totMFC': event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value))}}));}
}