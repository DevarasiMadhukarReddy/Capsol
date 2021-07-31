(function(skuid){
skuid.snippet.register('generatePricing',function(args) {var scModels = skuid.model.getModel('Application');
var scRow = scModels.data[0]; 
var result = sforce.apex.execute('genesis.SkuidPricingCtrl','generatePricing',
{   
        applicationId : scRow.Id
});
alert(result);
window.location.reload();
});
}(window.skuid));