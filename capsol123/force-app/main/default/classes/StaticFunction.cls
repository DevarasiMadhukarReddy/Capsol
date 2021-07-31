public class StaticFunction {
private static boolean checkRecursive = true;
private static boolean checkRecursiveCustomerUpdatestoCLO = true; // Added by Amol - 10/27/2020
private static boolean checkRecursiveApplicationUpdatestoCLO = true; // Added by Amol - 11/13/2020
    public static boolean isRecursive = false; 
    public static boolean runOnce(){
        if(checkRecursive){
            checkRecursive=false;
            return true;
        }else{
            return checkRecursive;
        }
    }
    //Added by Amol - 10/27/2020 - Start
    public static boolean runOnceCustomerUpdatesToCLO(){
        if(checkRecursiveCustomerUpdatestoCLO){
            checkRecursiveCustomerUpdatestoCLO=false;
            return true;
        }else{
            return checkRecursiveCustomerUpdatestoCLO;
        }
    }
    // Added by Amol - 10/27/2020 - End
    //Added by Amol - 11/13/2020 - Start
    public static boolean runOnceApplicationUpdatesToCLO(){
        if(checkRecursiveApplicationUpdatestoCLO){
            checkRecursiveApplicationUpdatestoCLO=false;
            return true;
        }else{
            return checkRecursiveApplicationUpdatestoCLO;
        }
    }
    // Added by Amol - 11/13/2020 - End
}