(function(skuid){
(function(skuid){
	var $ = skuid.$;
	$(document.body).one('pageload',function(){
	    showIconicBtnLabelAsTooltip();
	});
})(skuid);;
skuid.snippet.register('ManageStages',function(args) {var params = arguments[0],
	$ = skuid.$;

var popover = $('.webui-popover')[0];
if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
    $('#manage-stages').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=NGTaskList&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '620px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').attr('id', 'task-list-popover');
    			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-stages').webuiPopover('show');
}
});
skuid.snippet.register('ManageLoanTeamPopOver',function(args) {var params = arguments[0],
	$ = skuid.$;
console.log(' popup session app id :: ' + sessionStorage.selectApplicationId);
var popover = $('.webui-popover')[0];
if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
	$('#manage-loan-team-members').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=LoanTeamMembers&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '620px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-loan-team-members').webuiPopover('show');
}
});
skuid.snippet.register('ManageApplicationNotes',function(args) {var params = arguments[0],
	$ = skuid.$;
var popover = $('.webui-popover')[0];

if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
	$('#manage-notes').webuiPopover({
	    trigger: 'manual',
	    type : 'iframe',
	    url: '/apex/skuid__ui?page=ManageApplicationNotes&id=' + sessionStorage.getItem('selectApplicationId'),
	    width: '620px',
	    placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
    			var popover = element[0];
    			$(popover).css('bottom', 0);
    			$(popover).find('.webui-popover-content').css('padding', 0);
    			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
    			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-notes').webuiPopover('show');
}
});
skuid.snippet.register('ManageMyTasks',function(args) {var params = arguments[0],
	$ = skuid.$;
var appId = sessionStorage.selectApplicationId;
var popover = $('.webui-popover')[0];
if (popover && $(popover).is(':visible')) {
	$('.webui-popover').remove();
} else {
    $('#manage-my-tasks').webuiPopover({
		trigger: 'manual',
		type: 'iframe',
		url: '/apex/skuid__ui?page=UserNotificationList&id=' + sessionStorage.getItem('selectApplicationId'),
		width: '620px',
		placement: 'bottom-left',
		closeable: true,
		onShow: function(element) {
			var popover = element[0];
			$(popover).css('bottom', 0);
			$(popover).find('.webui-popover-content').css('padding', 0);
			$(popover).find('.webui-popover-content > iframe').css('width', '600px');
			$(popover).find('.webui-popover-content > iframe').css('height', $(popover).css('height'));
		},
		onHide: function() {
		    $('.webui-popover').remove();
		}
	});
	$('#manage-my-tasks').webuiPopover('show');
}
});
}(window.skuid));