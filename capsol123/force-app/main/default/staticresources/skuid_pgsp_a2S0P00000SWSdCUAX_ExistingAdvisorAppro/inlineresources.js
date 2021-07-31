(function(skuid){
skuid.snippet.register('newSnippet',function(args) {/*var params = arguments[0];
var url = 'https://composer.congamerge.com/composer8/index.html?SolMgr=1&sessionId=' +sforce.connection.sessionId
                + '&serverUrl=' + skuid.model.getModel('Application').data[0].Random


    + '&id=a5k0v0000008PBy';


console.log('ello'+url);

var merges = skuid.$('<div>').html(params.model.mergeRow(params.row,url));



window.open(merges.text(),'CongaComposer');*/


var params = arguments[0],
$ = skuid.$;


var calc = skuid.model.getModel('Application');

var row1 = calc.data[0];
try{
   
   calc.updateRow(calc.getFirstRow(),
   {
       Guidance__c : false
   });
   calc.save();
   console.log('done');
} catch(e) {
   console.log('caught'+e);
}
});
(function(skuid){
var $ = skuid.$;
$(document.body).one('pageload',function(){
openLinksInNewTab();
});
})(skuid);;
}(window.skuid));