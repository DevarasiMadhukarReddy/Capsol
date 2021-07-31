(function(skuid){
skuid.snippet.register('createChangeMemo',function(args) {/**
*  Purpose: Used for setting paramemters for displaying create new change memo editor and hiding others
*  Where: create new change memo button
*
* @name  createChangeMemo.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

var newChangeMemo = skuid.model.getModel('ChangeMemo');
var newChangeMemoRow = newChangeMemo.data[0];

if(!newChangeMemoRow){
    var newChangeMemoRow = newChangeMemo.createRow({
        additionalConditions: [
            { field: 'showCreateMemo', value:true },
            { field: 'showExistingMemo', value: false },

        ]
    });

}else{
    newChangeMemo.updateRow(newChangeMemoRow ,
                        { showCreateMemo : true ,
                          showExistingMemo : false });


}
});
skuid.snippet.register('showExisting',function(args) {/**
*  Purpose: Used for setting paramemters for displaying shoe existing change memo editor and hiding others
*  Where: create new change memo button
*
* @name  showExisting.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

$('#createMemoButton').removeClass('selected-btn');
$('#showExistingMemoButton').addClass('selected-btn');

var newChangeMemo = skuid.model.getModel('ChangeMemo');
var newChangeMemoRow = newChangeMemo.data[0];

if(!newChangeMemoRow){
    var newChangeMemoRow = newChangeMemo.createRow({
        additionalConditions: [
            { field: 'showCreateMemo', value:false },
            { field: 'showExistingMemo', value: true },

        ]
    });

}else{
    newChangeMemo.updateRow(newChangeMemoRow ,
                        { showCreateMemo : false ,
                          showExistingMemo : true });

}
});
skuid.snippet.register('clickHandler',function(args) {/**
*  Purpose: Used for invokinng show existing change memo after creating new chamge memo
*  Where: save button of create new change memo editor
*
* @name  clickHandler.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   06-18-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

//click handler
skuid.component.getById('showExistingMemoButton').element.click();
});
skuid.snippet.register('makeRowsReadOnly',function(args) {var $ = skuid.$;
var field = arguments[0];
var value = arguments[1];

console.log('field..',field);
console.log('value.',value);

var cellElem = field.element;
cellElem.text( value );


if(value != 'Pending'){
    field.row.mode = 'readonly';
}
});
skuid.snippet.register('NotifyDocumentTreeRefresh',function(args) {var params = arguments[0],
    $ = skuid.$;

// window.parent.postMessage({type: 'action-document-refresh'}, '*');
toTopLevelAndRefresh({iframeIds: ['document-iframe']});
});
skuid.snippet.register('clickSubmitForApprovalVFbutton',function(args) {/**
*  Purpose: Used to click hidden Submit for Approval VF button from action framework
*  Where: onclick of Submit for approval
*
* @name  clickSubmitForApprovalVFbutton.js
* @author  Ashish Kumar Singh
* @version 1.0
* @since   07-21-2016
*/


//a DOM element that Skuid will add, in place, into the parent / container component in which you've placed this custom component.
//Get a reference to this element
var params = arguments[0],
$ = skuid.$;    //declares that we are using skuid custom jQuery

skuid.component.getById('submitForApprovalVfButtonId').element.click();
});
}(window.skuid));