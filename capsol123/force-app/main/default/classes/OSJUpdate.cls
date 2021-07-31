/*OSJ ID and Branch ID Update*/
public class OSJUpdate {
    
    @InvocableMethod
    public static void OSJName(List<Id> conid){
        if(conid != null && conid.size()>0){
            List<contact> conupdate = new List<contact>();
            List<contact> conlist = [SELECT id,OSJ_ID__c,Branch_ID__c,New_Large_Small_Enterprise_Name__c FROm contact WHERE Id in:conid];
            
            for(Contact con:conlist){
                 if(con.OSJ_ID__c =='38W0' ){
                    con.New_Large_Small_Enterprise_Name__c = 'Financial Resources Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                 }
                else if(con.OSJ_ID__c =='1658' ){
                    con.New_Large_Small_Enterprise_Name__c = 'Andrew Keller';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                 }
                else if(con.OSJ_ID__c == '2073'){
                    con.New_Large_Small_Enterprise_Name__c = 'Goss Wealth Management';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '2087'){
                    con.New_Large_Small_Enterprise_Name__c = 'IHT Wealth Management';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '2190'){
                    con.New_Large_Small_Enterprise_Name__c = 'Global Retirement Partners';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '7712'){
                    con.New_Large_Small_Enterprise_Name__c = 'Independent Advisor Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
               else if(con.OSJ_ID__c == '8900'){
                    con.New_Large_Small_Enterprise_Name__c = 'Financial Advocates';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '9140'){
                    con.New_Large_Small_Enterprise_Name__c = 'Marc Stone Cfp';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '9692'){
                    con.New_Large_Small_Enterprise_Name__c = 'David Fernquist';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '9840'){
                    con.New_Large_Small_Enterprise_Name__c = 'Private Advisor Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '9925'){
                    con.New_Large_Small_Enterprise_Name__c = 'Christopher Neubert';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '00D1'){
                    con.New_Large_Small_Enterprise_Name__c = 'Northeast Planning';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0CN7'){
                    con.New_Large_Small_Enterprise_Name__c = 'Tobin Jenkins Cfp';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0FC7'){
                    con.New_Large_Small_Enterprise_Name__c = 'Stratos';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0MB9'){
                    con.New_Large_Small_Enterprise_Name__c = 'Susan Kuhlenbeck';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0V94'){
                    con.New_Large_Small_Enterprise_Name__c = 'Thomas Blumer';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0WK9'){
                    con.New_Large_Small_Enterprise_Name__c = '360 Wealth Management';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0WV0'){
                    con.New_Large_Small_Enterprise_Name__c = 'Great Valley';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0XD3'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Center for Wealth Planning';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0XP1'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'IFG Investors';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                }
                else if(con.OSJ_ID__c == '0XP6'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Advisors Pride';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '10E0'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'The NETWORK';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '15M0'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Northeast Planning';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '16H4'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Financial Resources Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '16M0'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Financial Resources Group';
                        con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                        }
                else if(con.OSJ_ID__c == '18D8'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Merit Financial Advisors';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '18P4'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Flagship Harbor Advisors';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1B23'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Integrated Financial Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1DW8'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'U.S. Wealth';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1FD4'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Golden State Wealth Mgmt';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1KH6'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Danilo Kawasaki';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1KN3'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'The NETWORK';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1KP1'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Level Four';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1VD4'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Householder';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1XP6'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'The Monitor Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '20E6'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Good Life';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '21Y7'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Wealth Consulting Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '27H3'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Northeast Planning';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '2B19'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Integrated Financial Partners';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '2HD0'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Discovery Financial';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '2HR5'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Gateway Financial';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '2J14'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Trilogy Financial';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '2P40'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Advisors Southeastern Alliance';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '2PW1'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Life Brokerage Financial Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'C009'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Highpoint';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'C062'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Inc Advisors';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'C301'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Center for Wealth Planning';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'C518'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Bay Financial';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'D166'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Thiesen Dueker';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'D292'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Western Wealth Advisors';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'E197'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Russell Gebhard';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'E345'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Cornerstone Wealth Management';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'F721'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Perennial Financial Services';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'F811'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Independent Advisor Alliance';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'G012'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'IHT Wealth Management';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'WG01'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Wealth Enhancement Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1V24'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'James Mars';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == 'C005'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Joseph Esposito';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '9140'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Marc Stone';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '20A9'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Mark Bredin';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '10R8'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Reagan Wagner';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '1XP6'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'The Monitor Group';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.OSJ_ID__c == '0CN7'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Tobin Jenkins';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.Branch_ID__c == 'F748'){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Joseph Elliott';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                
                else if((con.Branch_ID__c == '2H58' || con.Branch_ID__c == '2H59' || con.Branch_ID__c =='2H60' || con.Branch_ID__c =='2H61' || 
                         con.Branch_ID__c =='2H63' || con.Branch_ID__c =='2H65' || con.Branch_ID__c =='2H66' || con.Branch_ID__c =='2H67' || 
                         con.Branch_ID__c == '2H70' || con.Branch_ID__c =='2H71' || con.Branch_ID__c =='2H72' || con.Branch_ID__c =='2H73' || 
                         con.Branch_ID__c =='2H74' ||con.Branch_ID__c =='2H75' || con.Branch_ID__c =='2H76' || con.Branch_ID__c =='2H77' || 
                         con.Branch_ID__c =='2H79' || con.Branch_ID__c =='2H80' || con.Branch_ID__c =='2HN0' ||con.Branch_ID__c =='2JD7' || con.Branch_ID__c =='2JD8')){ 
                    con.New_Large_Small_Enterprise_Name__c =  'Zuk Financial';
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                    }
                else if(con.Branch_ID__c == '1598' || con.Branch_ID__c == '2802' || con.Branch_ID__c == '1MH7' || con.Branch_ID__c == '2MK6' ||
                        con.Branch_ID__c == '2WG1' || con.Branch_ID__c == '2X52' || con.Branch_ID__c == '2XF8' || con.Branch_ID__c == 'A346' || 
                        con.Branch_ID__c == 'A351' || con.Branch_ID__c == 'A556'){ 
                            con.New_Large_Small_Enterprise_Name__c =  'Andrew Keller';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                        }
                else if(con.Branch_ID__c == '2PH2' || con.Branch_ID__c == '2PH3' || con.Branch_ID__c == '2PK4' || con.Branch_ID__c == '2PK5' ||
                        con.Branch_ID__c == '2PK6' || con.Branch_ID__c == '2PK7' || con.Branch_ID__c == '2PK8' || con.Branch_ID__c == '2PK9' ||
                        con.Branch_ID__c == '2PM0' || con.Branch_ID__c == '2PM1' || con.Branch_ID__c == '2PM2' || con.Branch_ID__c == '2PM4' ||
                        con.Branch_ID__c == '2PM5' || con.Branch_ID__c == '2PT5' || con.Branch_ID__c == '2PT6' || con.Branch_ID__c == '2PT7' ||
                        con.Branch_ID__c == '2PT8' || con.Branch_ID__c == '2PT9' || con.Branch_ID__c == '2PV0' || con.Branch_ID__c == '2PV1' ||
                        con.Branch_ID__c == '37G6'){ 
                            con.New_Large_Small_Enterprise_Name__c =  'Christopher Edwards Financial Associates';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                        }
                
                
                else if(con.Branch_ID__c == '1JK8'){
                        con.New_Large_Small_Enterprise_Name__c =  'Delynn Zell';
                        con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                        }
                else if(con.Branch_ID__c == '2W67' || con.Branch_ID__c == '2XK5' || con.Branch_ID__c == '2XN3' || con.Branch_ID__c == '2XN7' ||
                        con.Branch_ID__c == '2XN8' || con.Branch_ID__c == '2XN9' || con.Branch_ID__c == '2XP0' || con.Branch_ID__c == '2XR1' ||
                        con.Branch_ID__c == '2XR2' || con.Branch_ID__c == '2Y13' || con.Branch_ID__c == '2Y22' || con.Branch_ID__c == '2Y23' ||
                        con.Branch_ID__c == '2Y24' || con.Branch_ID__c == '2Y26' || con.Branch_ID__c == '2Y27' || con.Branch_ID__c == 'NH6L' ||
                        con.Branch_ID__c == '2Y29' || con.Branch_ID__c == '2Y33' || con.Branch_ID__c == '2Y35' || con.Branch_ID__c == '2Y36' ||
                        con.Branch_ID__c == '2Y42' || con.Branch_ID__c == '2Y45' || con.Branch_ID__c == '2Y52' || con.Branch_ID__c == '2Y89' ||
                        con.Branch_ID__c == '2Y93' || con.Branch_ID__c == '2YA2' || con.Branch_ID__c == '2YA7' || con.Branch_ID__c == '2YB2' ||
                        con.Branch_ID__c == '2YE5' || con.Branch_ID__c == '2YF3' || con.Branch_ID__c == '31R7' || con.Branch_ID__c == '34A4' ||
                        con.Branch_ID__c == '34G0' || con.Branch_ID__c == 'NG6L' || con.Branch_ID__c == 'NG9L' || con.Branch_ID__c == 'NH0L' ||
                        con.Branch_ID__c == 'NH1L' ){ 
                            con.New_Large_Small_Enterprise_Name__c = 'Exemplar';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                        }
                else if(con.Branch_ID__c == '3754' || con.Branch_ID__c == '3788' || con.Branch_ID__c == '3791' || con.Branch_ID__c == '3792' ||
                        con.Branch_ID__c == '3793' || con.Branch_ID__c == '3796' || con.Branch_ID__c == '3797' || con.Branch_ID__c == '3798' ||
                        con.Branch_ID__c == '3799' || con.Branch_ID__c == '3823' || con.Branch_ID__c == '3836' || con.Branch_ID__c == '3839' ||
                        con.Branch_ID__c == '3851' || con.Branch_ID__c == '3867' || con.Branch_ID__c == '3879' || con.Branch_ID__c == '3885' ||
                        con.Branch_ID__c == '3899' || con.Branch_ID__c == '18AN' || con.Branch_ID__c == '25XN' || con.Branch_ID__c == '28GN' ||
                        con.Branch_ID__c == '37A2' || con.Branch_ID__c == '37A3' || con.Branch_ID__c == '37A5' || con.Branch_ID__c == '37A6' ||
                        con.Branch_ID__c == '37A7' || con.Branch_ID__c == '37A9' || con.Branch_ID__c == '37D2' || con.Branch_ID__c == '37D3' ||
                        con.Branch_ID__c == '37D6' || con.Branch_ID__c == '37H4' || con.Branch_ID__c == '37J2' || con.Branch_ID__c == '37J5' ||
                        con.Branch_ID__c == '37K1' || con.Branch_ID__c == '37M9' || con.Branch_ID__c == '37R3' || con.Branch_ID__c == '37R9' ||
                        con.Branch_ID__c == '37V7' || con.Branch_ID__c == '37X1' || con.Branch_ID__c == '37XN' || con.Branch_ID__c == '37Y7' ||
                        con.Branch_ID__c == '37Y8' || con.Branch_ID__c == '38D9' || con.Branch_ID__c == '38G4' || con.Branch_ID__c == '38H1' ||
                        con.Branch_ID__c == '38N0' || con.Branch_ID__c == '38N8' || con.Branch_ID__c == '38P6' || con.Branch_ID__c == '38V8' ||
                        con.Branch_ID__c == '38X1' || con.Branch_ID__c == '38X3' || con.Branch_ID__c == '38X5' || con.Branch_ID__c == '38X6' ||
                        con.Branch_ID__c == '3J0N' || con.Branch_ID__c == '42KN' || con.Branch_ID__c == '4J3N' || con.Branch_ID__c == '70TN' ||
                        con.Branch_ID__c == '864N' || con.Branch_ID__c == 'B24N' || con.Branch_ID__c == '37E0' || con.Branch_ID__c == '38E0'
                        ){
                        con.New_Large_Small_Enterprise_Name__c = 'JFC Financial Services, Inc.';
                        con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                        }
                else if(con.Branch_ID__c == '2HH6' || con.Branch_ID__c == '2HM9' || con.Branch_ID__c == '2J01' || con.Branch_ID__c == '2JA3' ||
                        con.Branch_ID__c == '2JA4' || con.Branch_ID__c == '2JC5' || con.Branch_ID__c == '2JC6' || con.Branch_ID__c == '2JC8' ||
                        con.Branch_ID__c == '2JD0' || con.Branch_ID__c == '2JD2' || con.Branch_ID__c == '2JE5' || con.Branch_ID__c == '2JE6' ||
                        con.Branch_ID__c == '2JH9' || con.Branch_ID__c == '2Y12' || con.Branch_ID__c == '33V9' || con.Branch_ID__c == '34N7' ||
                        con.Branch_ID__c == '36W1'){ 
                            con.New_Large_Small_Enterprise_Name__c =  'The Pugh Group';
                            con.Updated_Large_Small_Enterprise_Advisor__c = 'YES';
                        }
                else{
                    con.Updated_Large_Small_Enterprise_Advisor__c = 'NO';
                    con.New_Large_Small_Enterprise_Name__c =  '';
                    }
                conupdate.add(con);   
            }
            if(conupdate.size()>0){
                update conupdate;
                }
        }
        
    }
}