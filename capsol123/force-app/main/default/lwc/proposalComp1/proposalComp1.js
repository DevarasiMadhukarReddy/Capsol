import {
    LightningElement,
    wire,
    api,
    track
} from 'lwc';

export default class ProposalComp1 extends LightningElement {
    @track data = [];
    @api deleteDataList = [];
    @track max = 5;
    @track count = 0;
    @api editProposal = false;
    //Modified By Bhanu 9/9/2020 changes Start  1891
    @api
    addProposal() {

        if (this.max > this.data.length) {
            this.count++;
            this.data.push({
                'OfferName': '',
                'Platform': '',
                'TermLength': '',
                'UWType': '',
                'Campaign': '',
                'Branch': '',
                'POP': null,
                'OSJLEName': '',
                'DisableCampaignName': true,
                'aliasPlatform': 'Platform' + this.count,
                'aliasBranch': 'Branch' + this.count,
                'aliasTermLength': 'TermLength' + this.count,
                'aliasUWType': 'UWType' + this.count,
                'aliasCampaign': 'Campaign' + this.count,
                'aliasOSJLEName': 'OSJLEName' + this.count,
                'slno': 'it' + this.count
            });
        } else {
            //Commented by Amol 09/08
            // alert('Proposal limit exceeded!');
        }

    }
    //Changes ends
    @api
    deleteProposal(event) {

        let ArrData = [];
        this.data.forEach(element => {
            if (event.target.id.split('-')[0] != element.slno) {
                ArrData.push(element);
            } else {
                if (element.POP != null) {
                    this.deleteDataList.push(element.POP.Id);
                }
            }
        });
        this.data = ArrData;
    }
    @api
    setData(pData) {
        let ArrData = [];
        this.count = 0;
        pData.forEach(Element => {
            this.count++;
            Element.slno = 'it' + ArrData.length;
            Element.aliasPlatform = 'Platform' + ArrData.length;
            Element.aliasBranch = 'Branch' + ArrData.length;
            Element.aliasTermLength = 'TermLength' + ArrData.length;
            Element.aliasUWType = 'UWType' + ArrData.length;
            Element.aliasCampaign = 'Campaign' + ArrData.length;
            Element.aliasOSJLEName = 'OSJLEName' + ArrData.length;
            Element.aliasUWTypeDisable = false;
            if (ArrData.length === 0) {
                Element.first = true;
            } else {
                Element.first = false;
            }
            ArrData.push(Element);

        });
        this.data = ArrData;
    }
    @api
    collectProposal() {
        let ArrData = [];
        this.data.forEach(Element => {


            //Element.OfferName=this.template.querySelector(Element.slno+'OfferName')!=null?this.template.querySelector(Element.slno+'OfferName').value:'';
            Element.TermLength = this.template.querySelector('[data-id="' + Element.aliasTermLength + '"]') != null ? this.template.querySelector('[data-id="' + Element.aliasTermLength + '"]').value : '';
            Element.UWType = this.template.querySelector('[data-id="' + Element.aliasUWType + '"]') != null ? this.template.querySelector('[data-id="' + Element.aliasUWType + '"]').value : '';
            Element.CampaignName = this.template.querySelector('[data-id="' + Element.aliasCampaign + '"]') != null ? this.template.querySelector('[data-id="' + Element.aliasCampaign + '"]').value : '';
            Element.Branch = this.template.querySelector('[data-id="' + Element.aliasBranch + '"]') != null ? this.template.querySelector('[data-id="' + Element.aliasBranch + '"]').value : '';
            Element.OSJLEName = this.template.querySelector('[data-id="' + Element.aliasOSJLEName + '"]') != null ? this.template.querySelector('[data-id="' + Element.aliasOSJLEName + '"]').value : '';
            Element.Platform = this.template.querySelector('[data-id="' + Element.aliasPlatform + '"]') != null ? this.template.querySelector('[data-id="' + Element.aliasPlatform + '"]').value : '';





            //Element.OfferName=this.template.querySelector(Element.slno+'OfferName')!=null?this.template.querySelector(Element.slno+'OfferName').value:'';
            ArrData.push(Element);
        });
        //alert(JSON.stringify(ArrData));
        return ArrData;
    }
    get platformPicklistValues() {
        return [{
                label: 'Corp',
                value: 'Corp'
            },
            {
                label: 'Hybrid',
                value: 'Hybrid'
            },
            {
                label: 'Premium',
                value: 'Premium'
            },
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            {
                label: 'Linsco/Employee Model',
                value: 'Linsco/Employee Model'
            }
            // CS- 2536 Modified by Amol - 11/05/2020 End
        ];
    }

    get branchPicklistValues() {
        return [{
                label: 'In-branch / LE',
                value: 'In-branch / LE'
            },
            {
                label: 'New Branch / HOS',
                value: 'New Branch / HOS'
            }
        ];

    }
    //Modified By Bhanu 9/9/2020 changes Start  1891
    UWTypePicklist(event) {

        let ArrData = [];
        this.data.forEach(element => {
            if (event.target.id.split('-')[0] == element.aliasUWType) {
                let temp = element;
                let UWType = this.template.querySelector('[data-id="' + element.aliasUWType + '"]') != null ? this.template.querySelector('[data-id="' + element.aliasUWType + '"]').value : '';
                if (UWType === 'Campaign') {
                    temp.DisableCampaignName = false;
                    temp.CampaignName = '';
                } else {
                    temp.DisableCampaignName = true;

                }

                ArrData.push(temp);
            } else {
                ArrData.push(element);
            }


        });

        this.data = ArrData;



    } //Changes ends
    get termLengthPicklistValues() {
        return [
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            /* {
                 label: '3 Years',
                 value: '3 Years'
             },
             {
                 label: '5 Years',
                 value: '5 Years'
             },*/
            // CS- 2536 Modified by Amol - 11/05/2020 End
            {
                label: '7 Years',
                value: '7 Years'
            },
            // madhu added 9 years on 27/08/2020 CS-1991
            {
                label: '9 Years',
                value: '9 Years'
            },
            {
                label: '10 Years',
                value: '10 Years'
            }
        ];
    }

    get uWTypePicklistValues() {
        return [{
                label: 'Standard',
                value: 'Standard'
            },

            {
                label: 'Enhanced',
                value: 'Enhanced'
            },

            {
                label: 'Campaign',
                value: 'Campaign'
            }


        ];
    }
    get CampaignPicklistValues() {
        return [{
                label: 'Wirehouse Experiment',
                value: 'Wirehouse Experiment'
            },
            // CS- 2536 Modified by Amol - 11/05/2020 Start
            /* {
                 label: 'EOY',
                 value: 'EOY'
             },*/
            // CS- 2536 Modified by Amol - 11/05/2020 End
            {
                label: 'Other',
                value: 'Other'
            },
        ];
    }
    //Madhu added CS-3154 and CS-3348 The characters included are alpha-numeric, full stops, commas, and space
    // madhu started 4232021
    @api handleproposalValidation() {
        console.log('Proposal11111' + JSON.stringify(this.data));
        var regex = new RegExp("^[a-zA-Z0-9 ,.\n]*$");
        let searchCmp = this.template.querySelectorAll(".addproposal");
        var errorFound = true;
        var newLine = "\n";
        var errMsg = "Error: check for special " + newLine + "characters in field." + newLine + "Only Alpha numeric, space," + newLine + "full stops and commas are accepted in this fields";
        for (var i = 0; i < this.data.length; i++) {

            console.log('key :' + this.data[i].OSJLEName);
            if (this.data[i].OSJLEName != null && this.data[i].OSJLEName != '' && !regex.test(this.data[i].OSJLEName)) {
                errorFound = false;
                searchCmp[i].setCustomValidity("Error: check for special characters in field.Only Alpha numeric, space, full stops and commas are accepted in this fields");
                // searchCmp[i].setCustomValidity(errMsg);
                searchCmp[i].reportValidity();
                //break;
            } else {
                searchCmp[i].setCustomValidity("");
                searchCmp[i].reportValidity();
            }

        }

        return errorFound;
    }
    // ended 4232021

}