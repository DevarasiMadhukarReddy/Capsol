(function(skuid){
skuid.snippet.register('clickGenerateCreditMemo',function(args) {var params = arguments[0],
	$ = skuid.$;

skuid.component.getById('generateCreditMemoId').element.click();
//window.open('https://composer.congamerge.com?sessionId= 00D36000001G6XS%21ARcAQBqhqv9kduPLHVXzaiJh0wE4xMBqccYRTE4.zMtmj8chCNRgr7hFe3Ykxjyh8W7XNc7Ctqe.LsTlpVAhyxpB1i0CqTkD&serverUrl= https%3A%2F%2Fclotest-dev-ed.my.salesforce.com%2Fservices%2FSoap%2Fu%2F29.0%2F00D36000001G6XS&id=a2V360000007RBI&qvar0id=a4736000000MOVk&qvar1id=a4736000000MhBY &qvar0format=00010&qvar1format=00010&queryid=[signers]a4736000000Mh5Q, [narrative]a4736000000MhC7&TemplateId=a4F36000000HLIw&DS7=&SelectAttachments=1&SelectTemplates=2&SC0=1&SC1=Attachments&AttachmentParentID=&OFN=CreditMemo+-+V1&AWD=&FP0=1 &UF0=1&MFTS0=genesis__Version_Number__c&MFTSValue0=1','_blank');
});
skuid.snippet.register('CloseCreditMemoDialog',function(args) {var params = arguments[0],
	$ = skuid.$;

// window.parent.postMessage({type: 'action-credit-memo-dialog-close'}, '*');

closeTopLevelDialogAndRefresh();
});
skuid.snippet.register('NotifyDocumentTreeRefresh',function(args) {var params = arguments[0],
	$ = skuid.$;

// window.parent.postMessage({type: 'action-document-refresh'}, '*');
closeTopLevelDialogAndRefresh({iframeIds: ['document-iframe']});
});
}(window.skuid));