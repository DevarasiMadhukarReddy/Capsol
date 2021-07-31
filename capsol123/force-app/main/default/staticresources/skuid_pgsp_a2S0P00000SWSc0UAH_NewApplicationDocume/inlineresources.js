(function(skuid){
skuid.snippet.register('OpenPreviewDialog',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var attachmentRow = skuid.model.getModel('NewAttachmentModel').getFirstRow();
var title = attachmentRow.Name;
var iframeUrl = '/servlet/servlet.FileDownload?file=' + attachmentRow.Id;
		
openTopLevelDialog({
    title: title,
    iframeUrl: iframeUrl
});
});
}(window.skuid));