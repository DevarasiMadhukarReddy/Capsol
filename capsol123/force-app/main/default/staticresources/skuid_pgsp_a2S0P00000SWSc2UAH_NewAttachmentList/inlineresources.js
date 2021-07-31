(function(skuid){
skuid.snippet.register('addDocuments',function(args) {var params = arguments[0],
	$ = skuid.$;

var selectedIds = $.map(params.list.getSelectedItems(), function(item) {
    return item.row.Id;
});

var id = getIdfromUrl(window.location.search.substring(1));

var message = {
    type: 'action-document-add',
    documentCategoryId: id,
    documentIds: selectedIds
};

window.parent.postMessage(message, '*');

function getIdfromUrl(query) {
    var id;
	$.each(query.split('&'), function(index, value) {
		var pair = value.split('=');
		if (pair[0] === 'id') {
			id = pair[1];
		}
	});
	return id;
}
});
skuid.snippet.register('SelectUploadedFiles',function(args) {var params = arguments[0],
	$ = skuid.$;

var allAttachments = params.model.data;
var origAttachments = getCurrentAttachments();

var origIds = $.map(origAttachments, function(attachment, i) {
    return attachment.Id;
});

var newAttachments = $.grep(allAttachments, function(attachment, i) {
    return $.inArray(attachment.Id, origIds) == -1;
});

var newIds = $.map(newAttachments, function(attachment, i) {
    return attachment.Id;
});

var attachmentTable = skuid.$('#attachment-table').data('object');

$.each(newIds, function(index, id) {
    var checkbox = $(attachmentTable.list.renderedItems[id].element).find('input[type=checkbox]');
    if (!checkbox.attr('checked')) {
        checkbox.trigger('click');
    }
});
});
skuid.snippet.register('RenderFileName',function(args) {var field = arguments[0],
    value = arguments[1],
	$ = skuid.$;

field.element.text(value);
});
}(window.skuid));