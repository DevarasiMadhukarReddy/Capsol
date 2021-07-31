/**
 * LPL_Utility.cls
 * Description  : This is utility class for any generic method. 
 * 
 * @Author      : Amit Verma(Cognizant)
 * @version     : 1.0
 * @CreatedDate : August 15,2018
 */


public without sharing class LPL_Utility{


//This method can return html formated string that can be used for forming html emails in tabular format
//Input: map of fieldname and Value
public static string getTableEmailBody(map<String,String> fm){

String htmlBody = '';

//open table..
htmlBody = '<table border="1" style="border-collapse: collapse"><caption>Time Trade Invitation Details</caption><tr><th>Field</th><th>Values</th></tr>';

//iterate over list and output columns/data into table rows...
for(String l: fm.keySet()){

  String fieldName;  
  if(l.contains('00P')){
     fieldName = 'Attachment Title';
  }
  else{
     fieldName = l; 
  }
    
    String fieldValue = fm.get(l); 
   
    htmlBody += '<tr><td>' + fieldName + '</td><td>' + fieldValue + '</td></tr>';

}

//close table...
htmlBody += '</table>';

system.debug('Email Body: ' + htmlBody);   

return htmlBody;

}

}