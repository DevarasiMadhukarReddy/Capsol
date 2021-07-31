(function(skuid){
skuid.snippet.register('RenderCreditReportColumn',function(args) {var field = arguments[0],
    value = arguments[1],
	$ = skuid.$;

var url = field.row.ints__Credit_Report_Attachment__c;
var reportId = url.substring(url.lastIndexOf('/')+1);

field.element.html('<a>' + value + ' <i class="fa fa-expand"></i></a>');

field.element.on('click', function(evt) {
    openPreviewDialog(reportId);
    return false;
});

function openPreviewDialog(reportId) {
	var dialogHeight = $(window).height();
	var dialogWidth = $(window).width();

	var iframe = $('<iframe width="100%" height="100%" frameBorder="0"/>');
	iframe.attr('src', '/servlet/servlet.FileDownload?file=' + reportId);

	$(document.body).append($('<div id="document-preview-dialog"></div>').append(iframe));

	$('#document-preview-dialog').dialog({
		modal: true,
		title: 'Credit Report',
		width: dialogWidth,
		height: dialogHeight,
		draggable: false,
		resizable: false,
		close: function(evt, ui) {
			$(document.body).find('#document-preview-dialog').remove();
		}
	});
}
});
}(window.skuid));