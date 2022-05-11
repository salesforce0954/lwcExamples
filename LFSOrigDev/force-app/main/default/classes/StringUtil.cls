/**
 * Contains utility methods for working with text strings.
 */
public class StringUtil {
    public static final String EMPTY_STRING = '';
    
    /**
     * Join a list of string values into a single string with each value separated by the specified
     * delimiter.
     */

    public static String joinList(String delimiter, List<String> values) {
        if (values == null || values.isEmpty()) {
            return EMPTY_STRING;
        }
        
        delimiter = isNull(delimiter, EMPTY_STRING);
        
        String s = EMPTY_STRING;
        for (Integer i = 0; i < values.size(); i++) {
            if (i > 0) {
                s += delimiter;
            }
            s += isNull(values.get(i), EMPTY_STRING);
        }
        return s;
    }
    
    // Return status value # for risk review
    public static Integer statNum(String s){
        if(s=='Review Started'){return 0;}
        else if(s=='Lodged with Credit'){return 1;}
        else if(s=='Accepted by Credit'){return 2;}
        else if(s=='Approved'){return 3;}
        else if(s=='Declined'){return 4;}
        else if(s=='Letter of Offer Issued'){return 5;}
        else if(s=='Request Received by Docs Team'){return 6;}
        else if(s=='Docs Issued'){return 7;}
        else if(s=='Docs Returned'){return 8;}
        else if(s=='Funded/Operational'){return 9;}
        else if(s=='Lost'){return 10;}
        else{return 99;}
    }
    
    
    /**
     * Returns the specified value if it is not null; otherwise, the specified replacement value
     * is returned.
     */
    public static String isNull(String value, String replacementValue) {
        return value != null ? value : isNull(replacementValue, EMPTY_STRING);
    }
    
    /**
     * Returns the specified value if it is not null; otherwise, an empty string is returned.
     */
    public static String isNull(String value) {
        return isNull(value, EMPTY_STRING);
    }

}