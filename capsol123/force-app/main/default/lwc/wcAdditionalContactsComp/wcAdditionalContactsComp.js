import { LightningElement,api } from 'lwc';

export default class WcAdditionalContactsComp extends LightningElement {
    @api additionalContacts={
        "AssignedRecruiter":null,
        "AssignedRecruiterLink":null,
        "InternalRecruiter":null,
        "InternalRecruiterLink":null,
        "BusinessDevelopment":null,
        "BusinessDevelopmentLink":null,
        "CaseOwnerName":null,
        "CaseOwnerLink":null,
        "PreparerName":'',
        "ServicerName":''
    };
    @api ea=false;
    @api eamon=false;
}