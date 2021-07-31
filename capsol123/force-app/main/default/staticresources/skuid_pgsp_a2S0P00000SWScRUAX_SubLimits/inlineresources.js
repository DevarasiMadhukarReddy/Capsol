(function(skuid){
skuid.snippet.register('LaunchAddEditSublimitDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

var appId = skuid.page.params.id;
var title = 'Add New SubLimit ';
var skuidPage = 'AddModifySublimits';
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