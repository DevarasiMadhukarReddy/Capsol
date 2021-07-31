/*
     * @author        : Rinku Yadav
     * @date          : 5 November, 2020
     * @description   : This class is written to read the string value from 
     *                  VisualForce Component VFEmailTempComp and logic for timezone.
*/
public class LPL_Controller_Formatted_Datetime {
	public DateTime date_time { get; set; } 
    public String defined_format { get; set; } 
    public Id assignedToId { get; set; }
    
    public String getFormattedDatetime() {
        User assignedUser = [ SELECT TimeZoneSidKey FROM User WHERE Id =: assignedToId ];
        Timezone tz = Timezone.getTimeZone(assignedUser.TimeZoneSidKey);
        
        //Timezone t = Timezone.getTimeZone(assignedUser);
        if (date_time == null) { 
            return ''; 
        }
        else { 
            if (defined_format == null) {
                return date_time.format(); //return the full date/time in user's locale and time zone
            }
            /***TimeZone Changes**/
            
            else if(tz.getID() == 'America/New_York' || tz.getID() =='America/Indiana/Indianapolis'){
                return date_time.format(defined_format,'America/New_York'); //EDT
            }
            else if(tz.getID() == 'America/Chicago'){
                return date_time.format(defined_format,'America/Chicago'); //CDT 
            }
            else if(tz.getID() == 'America/El_Salvador' || tz.getID() == 'America/Mexico_City'){
                return date_time.format(defined_format,'America/El_Salvador'); //CST
            }
            else if(tz.getID() == 'America/Denver'){
                return date_time.format(defined_format,'America/Denver'); //MDT
            }
            else if(tz.getID() == 'America/Phoenix'){
                return date_time.format(defined_format,'America/Phoenix'); //MST
            }
            else if(tz.getID() == 'America/Los_Angeles' || tz.getID() == 'America/Tijuana' ){
                return date_time.format(defined_format,'America/Los_Angeles'); //PDT
            }
            else{
                return date_time.format(defined_format,'EST');
            }
            
        }
    }
  }