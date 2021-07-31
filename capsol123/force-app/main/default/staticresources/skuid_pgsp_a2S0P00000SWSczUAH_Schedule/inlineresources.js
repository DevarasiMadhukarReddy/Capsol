(function(skuid){
skuid.snippet.register('generateSchedule',function(args) {var scModels = skuid.model.getModel('SchAppModel');
var scRow = scModels.data[0]; 
var result = sforce.apex.execute('genesis.SkuidNewApplication','generateSchedule',
{   
        applicationId : scRow.Id
});
alert(result);
window.location.reload();
});
skuid.snippet.register('DeleteRow',function(args) {var param=skuid.model.getModel('Holiday_Schedule').getFirstRow().Id;
skuid.model.getModel('Holiday_Schedule').deleteRow({Id:param});
skuid.model.getModel('Holiday_Schedule').save();
});
}(window.skuid));