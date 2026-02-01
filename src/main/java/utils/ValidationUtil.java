package utils;

import java.util.regex.Pattern;

/**
 * Utility class for input validation
 */
public class ValidationUtil {
    
    // Email regex pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
    );
    
    // IC number pattern (Malaysian IC: YYMMDDPB###G - without dashes)
    // 12 digits: YYMMDD (6) + PB (2) + ###G (4 including check digit)
    private static final Pattern IC_PATTERN = Pattern.compile(
        "^\\d{12}$"
    );
    
    // Phone number pattern (Malaysian format - without dashes)
    // Mobile: 01X-XXXXXXX or 01X-XXXXXXXX (10 or 11 digits total)
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^01[0-9]\\d{7}$|^01[0-9]\\d{8}$"
    );
    
    /**
     * Validate email address
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }
    
    /**
     * Validate IC number
     */
    public static boolean isValidIC(String ic) {
        return ic != null && IC_PATTERN.matcher(ic).matches();
    }
    
    /**
     * Validate phone number
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        // Malaysian mobile format: 01XXXXXXXXX (10-11 digits without dashes)
        return PHONE_PATTERN.matcher(phone).matches();
    }
    
    /**
     * Validate password strength
     * At least 6 characters
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }
    
    /**
     * Validate string is not null or empty
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
    
    /**
     * Sanitize input to prevent XSS
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        
        return input.replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;");
    }
    
    /**
     * Validate integer range
     */
    public static boolean isValidRange(int value, int min, int max) {
        return value >= min && value <= max;
    }
    
    /**
     * Validate date format (YYYY-MM-DD)
     */
    public static boolean isValidDateFormat(String date) {
        if (date == null) return false;
        return Pattern.matches("^\\d{4}-\\d{2}-\\d{2}$", date);
    }
}
