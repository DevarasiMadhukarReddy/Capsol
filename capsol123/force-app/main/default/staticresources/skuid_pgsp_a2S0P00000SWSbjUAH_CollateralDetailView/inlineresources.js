(function(skuid){
skuid.snippet.register('LaunchEditCollateral',function(args) {var params = arguments[0],
	$ = skuid.$;
var applicationCollateral = skuid.model.getModel('AppCollateralAssociation').getFirstRow();
var title = 'Edit ' + applicationCollateral.genesis__Collateral__r.Name;
var skuidPage = 'CollateralDetails';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + applicationCollateral.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));