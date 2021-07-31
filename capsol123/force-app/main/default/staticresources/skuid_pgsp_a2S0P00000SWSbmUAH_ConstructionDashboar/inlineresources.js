(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
		var windowHeight = window.innerHeight;
        $('#construction-iframe').height(windowHeight);
	});
})(skuid);;
}(window.skuid));