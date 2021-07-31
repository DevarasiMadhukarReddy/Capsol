(function(skuid){
skuid.snippet.register('generateScoreCard',function(args) {var scModels = skuid.model.getModel('Application');
var scRow = scModels.data[0]; 
var result = sforce.apex.execute('genesis.ScorecardAPI','generateScorecard',
{   
        applicationId : scRow.Id
});
alert(result);
window.location.reload();
});
}(window.skuid));