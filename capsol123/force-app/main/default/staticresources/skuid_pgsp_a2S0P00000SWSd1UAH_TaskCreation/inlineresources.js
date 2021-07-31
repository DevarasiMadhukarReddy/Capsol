(function(skuid){
skuid.snippet.register('populateApplication',function(args) {(function(skuid){    
   var $ = skuid.$;
    $(function(){
        var application = skuid.$M('Application');
        var applicationRow = application.data[0];
        var newTask = skuid.$M('newTask');
        var newTaskRow = newTask.data[0];
        
        newTask.updateRow(newTaskRow,{
           genesis__Application__c: applicationRow.Id,
           genesis__Application__r: applicationRow
        });
        // We need to go manually tell our Field Editor
        // to re-render its "Application__c" field.
        // Since a Field Editor registers itself as a List
        // on our newTask Model, we can do this 
        $.each(newTask.registeredLists,function(){
            $.each(this.renderedItems,function(){
               $.each(this.fields,function(){
                    if(this.id==='genesis__Application__c') this.render();
               });
            });
        });
    });
})(skuid);
});
}(window.skuid));