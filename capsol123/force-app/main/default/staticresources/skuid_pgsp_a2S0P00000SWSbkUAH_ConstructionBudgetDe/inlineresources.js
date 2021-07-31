(function(skuid){
skuid.snippet.register('LaunchConstructionLineItemDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var title = 'Construction Activity Line Items';
var skuidPage = 'ConstructionLineItems';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + params.item.row.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
skuid.snippet.register('LaunchCreateMilestonesFromTemplate',function(args) {var budget = skuid.model.getModel('ConstructionBudget').getFirstRow();
var title = 'Disbursement Templates';
var skuidPage = 'DisbursementTemplates';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + budget.Id;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));