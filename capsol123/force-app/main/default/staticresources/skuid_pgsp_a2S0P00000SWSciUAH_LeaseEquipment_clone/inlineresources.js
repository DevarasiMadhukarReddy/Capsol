(function(skuid){
skuid.snippet.register('calcFinAmt',function(args) {// Get reference to our Application model
var appModel = skuid.$M('AppEquipmentModel'); 
// Get reference to the first row
var appRow = appModel.getFirstRow();
try {
    var result = sforce.apex.execute(
        'genesis.SkuidPricingCtrl',
        'generatePricing', { 
            applicationId : appRow.genesis__Application__c 
        }
    );
    console.log(result); 
} catch (err) {
    console.log('Error getting pricing: ' + err.description);
}
});
skuid.snippet.register('createNewEquipment',function(args) {var params = arguments[0],
	$ = skuid.$;
var leaseAppEquipmentModel = skuid.model.getModel('LeaseAppEquipmentModel');
var equiMasterModel = skuid.model.getModel('EquiMasterModel');
// Get reference to the first row
var leaseAppEquipmentRows = leaseAppEquipmentModel.data;
var equiMasterRows = equiMasterModel.data
if(leaseAppEquipmentRows){
    equiMasterRows = [];
   for(i=0; i<leaseAppEquipmentRows.length; i++){
        console.log(i);
        var obj = leaseAppEquipmentRows[i];
        if(obj.Id){
            if(!obj.genesis__Equipment__c){
                console.log(obj.Id);
                 var newRow = equiMasterModel.createRow({
                    additionalConditions: [
                        { field: 'genesis__Make__c', value: 'George' + i},
                    ], doAppend: false
                }); 
                
            }else{
                console.log(obj.Name);
                equiMasterRows.push(obj.genesis__Equipment__r);
            }
        }
    } 
    
    for(i=0; i<leaseAppEquipmentRows.length; i++){
        console.log(i);
        console.log(leaseAppEquipmentRows[i]);
        console.log(equiMasterRows[i]);
        
    }
}
});
}(window.skuid));