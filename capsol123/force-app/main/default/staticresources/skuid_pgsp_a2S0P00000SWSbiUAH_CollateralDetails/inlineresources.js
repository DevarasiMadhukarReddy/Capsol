(function(skuid){
skuid.snippet.register('fieldRenderMode',function(args) {var field = arguments[0],
    value = arguments[1];
var renderMode = skuid.page.params.mode;
fieldModeToRender(field,value,renderMode);
});
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,collateral-details-iframe']});
});
}(window.skuid));