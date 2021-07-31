(function(skuid){
skuid.snippet.register('addDocumentCategories',function(args) {var params = arguments[0],
	$ = skuid.$;

var selectedIds = $.map(params.list.getSelectedItems(), function(item) {
    return item.row.Id;
});

var message = {
    type: 'action-document-category-add',
    definitionIds: selectedIds,
    documentCategoryIds: selectedIds
};

window.parent.postMessage(message, '*');
});
}(window.skuid));