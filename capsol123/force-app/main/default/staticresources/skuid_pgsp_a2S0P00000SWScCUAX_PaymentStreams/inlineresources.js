(function(skuid){
skuid.snippet.register('LaunchAddEditPaymentStreamDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.page.params.id;
var title = 'Add New Payment Stream ';
var skuidPage = 'AddModifyPaymentStreams';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&appId=' + appId;

if(params && params.row && params.row.Name){
    title = 'Edit ' + params.row.Name;
    iframeUrl = iframeUrl + '&id=' + params.row.Id;
}

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));