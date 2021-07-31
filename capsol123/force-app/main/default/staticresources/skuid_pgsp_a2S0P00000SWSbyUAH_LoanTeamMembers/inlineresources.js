(function(skuid){
(function(skuid){
	var $ = skuid.$;
	//$(document.body).one('pageload',function(){
	$('.nx-page').one('pageload',function(){
	    var iframeHeight = window.innerHeight - 65;
	    $('iframe').height(iframeHeight);
		showIconicBtnLabelAsTooltip();
	});
})(skuid);;
}(window.skuid));