import {
    LightningElement,
    track,
    wire,
    api
} from 'lwc';
import lookupData from '@salesforce/apex/LookupController.lookupData';

export default class LookupComp extends LightningElement {
    @api selectedRecord;
    @track RecordList = [];
    @track SearchKeyword = '';
    @track Message = null;
    @track showList = false;
    @track spinner = false;
    @api displayName = '';
    @api objectName = '';
    @api filter = '';
    @api LA;


    @track alertmsg = '';
    @track shwalert = false;
    @track alertStyle = '';

    @api
    getRecordId() {
        return this.selectedRecord.Id;
    }

    @api
    checkValidity() {
        if (this.selectedRecord != null) {

            return true;
        } else {

            return false;
        }
    }

    @api
    reportValidity() {
        if (this.alertmsg == '') {
            this.alertStyle = '';
            this.shwalert = false;
        } else {
            this.alertStyle = 'border-color:red';
            this.shwalert = true;
        }
    }

    @api
    setCustomValidity(msg) {
        this.alertmsg = msg;
    }

    onblur() {
        let blurInt = setInterval(() => {
            clearInterval(blurInt);
            this.RecordList = [];
            this.showList = false;
            this.template.querySelector('[data-id="searchRes"]').className = this.template.querySelector('[data-id="searchRes"]').className.replace('slds-is-close', 'slds-is-open');
        }, 200);

    }
    clear() {
        this.selectedRecord = null;
        this.dispatchEvent(new CustomEvent('handlelookupdata', {
            detail: this.selectedRecord
        }));
        this.SearchKeyword = '';
        this.showList = false;
        this.onfocus();
    }
    onfocus() {
        //this.showList=true;
        /*this.spinner=true;
        /*
        this.SearchKeyword='';
        if(this.template.querySelector('[data-id="SearchText"]')!=null){
            this.template.querySelector('[data-id="SearchText"]').value='';
        }
        this.collectlookupData();*/

    }
    keyPressController(event) {
        if (event.target.value == null || event.target.value == undefined || event.target.value == '') {
            this.showList = false;
            return;
        }
        this.showList = true;
        this.spinner = true;
        this.SearchKeyword = event.target.value;
        this.collectlookupData();
    }

    collectlookupData() {

        console.log(this.SearchKeyword);
        this.showList = true;
        lookupData({
                'ObjectName': this.objectName,
                'SearchText': this.SearchKeyword,
                'ObjectFilter': this.filter,
                'LA': (this.LA == null || this.LA == undefined ? false : true)
            })
            .then(suc => {
                console.log(JSON.stringify(suc));

                console.log(this.template.querySelector('[data-id="searchRes"]'));
                if (suc != null) {
                    if (suc.length > 0) {
                        this.Message = null;
                        this.RecordList = suc;

                    } else {
                        this.RecordList = [];
                        this.Message = 'No Result Found...';
                    }


                }
                this.spinner = false;
            }).catch(err => {
                alert('Please Check with Administrator!');
            });
    }
    onselectData(event) {
        let itemid = event.target.id.split('-')[0];
        console.log('itemid' + itemid);
        console.log('template' + this.template.querySelector('[data-id="' + itemid + '"]'));
        if (this.template.querySelector('[data-id="' + itemid + '"]') != null) {
            this.selectedRecord = this.template.querySelector('[data-id="' + itemid + '"]').onClickRecord();
            console.log('this.selectedRecord' + this.selectedRecord);
            this.dispatchEvent(new CustomEvent('handlelookupdata', {
                detail: this.selectedRecord
            }));
            this.showList = false;
        }


    }

}