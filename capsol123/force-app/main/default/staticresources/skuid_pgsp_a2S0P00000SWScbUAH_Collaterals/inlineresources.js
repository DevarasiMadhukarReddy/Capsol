(function(skuid){
skuid.snippet.register('addDocCats',function(args) {try {
        //alert('called');
        var collateralModel = skuid.model.getModel('Collateral');
        var collaterals = collateralModel.data;
        //alert(collaterals.length);
        var param = new Object();
        var ids = [];
        for(var i = 0; i < collaterals.length; i++) {
            ids.push(collaterals[i].Id);
        }
        param.collateralIds = ids;
        var result = sforce.apex.execute('genesis.SkuidPostNewCollateral','addADCForCollateral', param);
    } catch (err) {
       alert(err);
       return;
    }
});
}(window.skuid));