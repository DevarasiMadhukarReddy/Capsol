import { LightningElement,api,track} from 'lwc';
import icon_star from '@salesforce/resourceUrl/icon_star';

export default class EaRetentionBorrower extends LightningElement {
    @api classic=false;
    @api quickAction=false;
    @api editRecord=false;
    @api showHeader=false; 
    @api lastPage=false;
    @api bowArr;
    @track count=2;
    @track imgdata=icon_star;
      //Start Bhanu 13-8-20-
      @track hideWizard = false;
      //Ends  

    addNewBow(){
        //alert(JSON.stringify(this.bowArr));
        let Arr=[];
       // Arr=Arr.concat(this.bowArr);
        this.bowArr.forEach(Element=>{
            let temp=Object.assign({}, Element);
            Arr.push(temp);
        });
 //Start Bhanu 13-8-20-
        Arr.push({totAUM:0,totAdvAUM:0,totBroAUM:0,ContactId:null,Contact:null,MasterRepId:null,MasterRType:null,YTDGDC:null,PYGDC:null,GPROA:null,primary:false,Uname:'Bow'+this.count,avail:false,loanSplit:0});
      //End
        this.count++;

        //alert(JSON.stringify(this.bowArr));
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:Arr}));
        
    }
    rmBow(event){
        let ARR=[];
        let Arr=[]
        Arr=Arr.concat(this.bowArr);
        Arr.forEach(Element=>{
            let temp=Object.assign({}, Element);
            if(event.target.id.split('-')[0]!==temp.Uname){
                ARR.push(temp);
            }
        });
        //this.bowArr=ARR;
        //alert(JSON.stringify(ARR));
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));
       
    }
    handlePrimary(event){
        //alert(event.target.id);
        let ARR=[];
        let Arr=[]
        Arr=Arr.concat(this.bowArr);
        Arr.forEach(Element=>{
            let temp=Object.assign({}, Element);
            if(event.target.id.split('-')[0]===temp.Uname){
                temp.primary=true;
            }else{
                temp.primary=false;
            }
            ARR.push(temp);
        });
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));

    }

//Start Bhanu 13-8-20-
    handleLoanSplitSum(event){
      
        let ARR=[];
        let Arr=[]
        Arr=Arr.concat(this.bowArr);
        Arr.forEach(Element=>{
           
            let temp=Object.assign({}, Element);
            if(event.target.id.split('-')[0]===temp.Uname){
                temp.loanSplit= event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value));
               
            }
            ARR.push(temp);
        });
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));

    }
    checkData(event){
        //alert(event.target.value);
        if(event.target.value=='0'){
            event.target.value='';
        }
    }
      //Ends
   
    handlelookupdata(event){
        
        let ARR=[];
        let Arr=[]
        Arr=Arr.concat(this.bowArr);
        Arr.forEach(Element=>{
           
            let temp=Object.assign({}, Element);
           
            if(event.target.id.split('-')[0]===temp.Uname){
                if(event.detail!=null){
                    temp.Contact=event.detail;
                    temp.ContactId=event.detail.Id;
                    temp.MasterRType=event.detail.Rep_Type__c!=null?event.detail.Rep_Type__c:'';
                  //Start Bhanu 13-8-20-
                    temp.loanSplit=event.detail.Loan_Split__c!=null?event.detail.Loan_Split__c:'0';
                   
                    //Ends
                    temp.MasterRepId=event.detail.Master_Rep_ID__c!=null?event.detail.Master_Rep_ID__c:'';
                    temp.totAUM=event.detail.Total_AUM_LoanApp__c!=null?event.detail.Total_AUM_LoanApp__c:null;
                    temp.totAdvAUM=event.detail.Total_Advisory_AUM__c!=null?event.detail.Total_Advisory_AUM__c:null;
                    temp.totBroAUM=event.detail.Total_Brokerage_AUM__c!=null?event.detail.Total_Brokerage_AUM__c:null;
                    if(event.detail.Financials__r!=null){
                        temp.YTDGDC=event.detail.Financials__r[0].YTD_GDC_All__c!=null?event.detail.Financials__r[0].YTD_GDC_All__c:'';
                        temp.PYGDC=event.detail.Financials__r[0].Prior_full_year_GDC_All__c!=null?event.detail.Financials__r[0].Prior_full_year_GDC_All__c:''; 
                    }else{
                        temp.YTDGDC='';
                        temp.PYGDC=''; 
                    }
                   
                    if(event.detail.Advisor_Profitability__r!=null){
                        temp.GPROA=event.detail.Advisor_Profitability__r[0].Gross_Profit_ROA__c!=null?event.detail.Advisor_Profitability__r[0].Gross_Profit_ROA__c:'';
                    }else{
                        temp.GPROA='';
                    }
                }else{
                    temp.Contact=null;
                    temp.ContactId=null;
                    temp.MasterRepId='';
                    temp.MasterRType='';
                    temp.YTDGDC='';
                    temp.PYGDC='';
                    temp.GPROA='';
                    //Start Bhanu 13-8-20-
                    temp.loanSplit=0;
                  
                    //End
                }
               
               
               
            }
            ARR.push(temp);
        });
       
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));

    }

}