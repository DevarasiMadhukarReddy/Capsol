(function(skuid){
skuid.snippet.register('CloseDialog',function(args) {var params = arguments[0],
    $ = skuid.$;
closeTopLevelDialogAndRefresh({iframeIds: ['deal-dashboard-iframe,loan-details-iframe']});
});
}(window.skuid));