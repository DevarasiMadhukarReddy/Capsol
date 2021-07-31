(function(skuid){
(function(skuid){
var $ = skuid.$;
	$(document.body).one('pageload',function(){
		// set height of window
        var windowHeight = window.innerHeight;
        $('#collateral-details-iframe').height(windowHeight);
        // trigger click of first item in queue
        $($('#application-collateral-queue .nx-item.nx-queue-item')[0]).trigger('click');
	});
})(skuid);;
skuid.snippet.register('UpdateCollateralDetailIframe',function(args) {var params = arguments[0],
	$ = skuid.$;

var url = $('#collateral-details-iframe').attr('src');
if (url.lastIndexOf('&id=') >= 0) {
    url = url.substring(0, url.lastIndexOf('&id=')) + '&id=' + params.row.Id + '&mode=read';
} else {
    url += '&id=' + params.row.Id + '&mode=read';
}
$('#collateral-details-iframe').attr('src', url);
$('#collateral-details-iframe').hide();
$('#collateral-details-iframe').on('load', function() {
    $("#collateral-details-iframe").show();
});
});
skuid.snippet.register('LaunchCollateralDialog',function(args) {var params = arguments[0],
	$ = skuid.$;
var appId = skuid.page.params.id;
var title = 'Manage Pledged Collateral';
var skuidPage = 'PledgeCollaterals';
var iframeUrl = '/apex/skuid__ui?page=' + skuidPage + '&id=' + appId;

openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));