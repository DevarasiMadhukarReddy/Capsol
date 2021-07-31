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
skuid.snippet.register('generatefinaloffer',function(args) {var params = arguments[0],
	$ = skuid.$;

var parentApp = skuid.model.getModel('Application');
//alert(parentApp.data[0].Id);

var result = sforce.apex.execute( 
    'Cls_FinalOfferCreation',
    'generateFinalOffer',
    {
        applicationID : parentApp.data[0].Id
    }
);

alert(result);
console.log(result);
//alert(r);
if(result[0] === "SUCCESS: Final offer created!") {
    window.location.reload();
}
});
(function(skuid){
var $ = skuid.$;
$(document.body).one('pageload',function(){
openLinksInNewTab();
});
})(skuid);;
skuid.snippet.register('TA Amount',function(args) {var params = arguments[0],
	$ = skuid.$;

var application = skuid.model.getModel('Application');
var childApplications = skuid.model.getModel('ChildApplications');
var highestValue = -Infinity;

$.each(childApplications.data, function(i, row){
    if(childApplications.getFieldValue(row,'Application_Type__c')  === 'Forgivable' ){
    highestValue = Math.max(highestValue, parseFloat((childApplications.getFieldValue(row,'TA_Amount__c') === undefined ? 0 : childApplications.getFieldValue(row,'TA_Amount__c'))));
 console.log('done');
    
    }
})
console.log('Highest'+highestValue);

try {
    application.updateRow(application.getFirstRow(),{
        TA_Amount__c : parseFloat(highestValue),
    });
    application.save();
} catch(e) {
    console.log('caught'+e);
}
});
}(window.skuid));