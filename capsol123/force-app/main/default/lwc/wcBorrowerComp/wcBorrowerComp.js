import { LightningElement,track,api } from 'lwc';
import icon_star from '@salesforce/resourceUrl/icon_star';

export default class WcBorrowerComp extends LightningElement {
    @api editRecord=false;
    @api showHeader=false;
    @api quickclassic=false;
    @track firstblock=false;
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    @api taRecord=false;
    @api hideWizard=false;
    @api workingCapitl = false;
    //Ends
    @track LA=true;
    @api bowArr;
    @track count=2;
    @track imgdata=icon_star;
    connectedCallback(){
       
        //this.addNewBow();
    }
    addNewBow(){
        //alert(JSON.stringify(this.bowArr));
        let Arr=[];
       // Arr=Arr.concat(this.bowArr);
        this.bowArr.forEach(Element=>{
            let temp=Object.assign({}, Element);
            Arr.push(temp);
        });
        //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
        Arr.push({ContactId:null,Contact:null,pAUM:0,loanSplit:0,backendSplit:0,repayableSplit:0,AUMATT:0,primary:false,Uname:'Bow'+this.count,avail:false});
      //Ends
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
    handleSplitSum(event){
      
        let ARR=[];
        let Arr=[]
        Arr=Arr.concat(this.bowArr);
        Arr.forEach(Element=>{
           
            let temp=Object.assign({}, Element);
            if(event.target.id.split('-')[0]===temp.Uname){
                temp.pAUM= event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value));
               
                
               if(this.workingCapitl ==false){
                temp.loanSplit=temp.pAUM;
                temp.backendSplit=temp.pAUM;
                temp.repayableSplit=temp.pAUM;

               }
              

                            
            }
            ARR.push(temp);
        });
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));

    }
    //Start Bhanu 8/13/2020 CS-1811 - Custom UI enhancement - Loan Split %
    checkData(event){
        //alert(event.target.value);
        if(event.target.value=='0'){
            event.target.value='';
        }
    }
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
    handleBackendSplitSum(event){
      
        let ARR=[];
        let Arr=[]
        Arr=Arr.concat(this.bowArr);
        Arr.forEach(Element=>{
           
            let temp=Object.assign({}, Element);
            if(event.target.id.split('-')[0]===temp.Uname){
                temp.backendSplit= event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value));
            
            }
            ARR.push(temp);
        });
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));

    }
    handleRepayableSplitSum(event){
      
        let ARR=[];
        let Arr=[]
        Arr=Arr.concat(this.bowArr);
        Arr.forEach(Element=>{
           
            let temp=Object.assign({}, Element);
            if(event.target.id.split('-')[0]===temp.Uname){
                temp.repayableSplit= event.target.value==null?0:(event.target.value==''?0:parseFloat(event.target.value));
            }
            ARR.push(temp);
        });
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));

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
                }else{
                    temp.Contact=null;
                    temp.ContactId=null;
                }
               
               
               
            }
            ARR.push(temp);
        });
       
        this.dispatchEvent(new CustomEvent('handleborrower',{detail:ARR}));

    }
    checkData(){
        if(this.bowArr.length==0){
            return true;
        }
        this.bowArr.forEach(Element=>{
            if(Element.Contact==null){
               return false;
            }
        });
        return true;
    }

}