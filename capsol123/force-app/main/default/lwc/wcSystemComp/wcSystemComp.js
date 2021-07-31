import { LightningElement,api  } from 'lwc';

export default class WcSystemComp extends LightningElement {
    @api systemInfo={
        "CreatedBy":null,
        "CreatedByLink":'',
        "CreatedDate":null,
        "LastModifiedBy":null,
        "LastModifiedByLink":'',
        "LastModifiedDate":null,
        "CLOApplicationId":null,
        "CLOCustomerGroup":null

    };
}