(function(skuid){
skuid.snippet.register('createTransactionRoom',function(args) {var appModel = skuid.model.getModel('LOCApplication');
var appRow = appModel.data[0];

try {
sforce.apex.execute('genesis.SkuidTransactionRoomCtrl','createTransactionRoom',
    {   
        applicationId : appRow.Id
    });
} catch(err) {
    alert(err);
}
window.location.reload();
});
skuid.snippet.register('convert',function(args) {var appModel = skuid.model.getModel('LOCApplication');
var appRow = appModel.data[0];

try {
    var ret = sforce.apex.execute('genesis.ConvertApplicationCtrl','convertApplicationToContract',
    {   
        appId : appRow.Id
    });
    alert(ret);
} catch(err) {
    alert(err);
}
window.location.reload();
});
}(window.skuid));