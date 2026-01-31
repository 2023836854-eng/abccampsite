package utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Utility class to generate unique booking IDs
 * Format: BKG-YYYYMMDD-XXXX
 * Where XXXX is a sequential number reset daily
 */
public class BookingIdGenerator {
    
    private static final AtomicInteger sequence = new AtomicInteger(0);
    private static String lastDate = "";
    
    /**
     * Generate a unique booking ID
     * @return Booking ID in format BKG-YYYYMMDD-XXXX
     */
    public static synchronized String generateBookingId() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String currentDate = dateFormat.format(new Date());
        
        // Reset sequence if date changed
        if (!currentDate.equals(lastDate)) {
            sequence.set(0);
            lastDate = currentDate;
        }
        
        // Increment and get next sequence number
        int seq = sequence.incrementAndGet();
        
        // Format: BKG-YYYYMMDD-XXXX (padded with zeros)
        return String.format("BKG-%s-%04d", currentDate, seq);
    }
    
    /**
     * Generate transaction ID for payments
     * Format: TXN-XX-YYYYMMDD-XXX
     * Where XX is payment method code
     */
    public static String generateTransactionId(String paymentMethod) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HHmmss");
        String currentDate = dateFormat.format(new Date());
        String currentTime = timeFormat.format(new Date());
        
        String methodCode = getPaymentMethodCode(paymentMethod);
        
        return String.format("TXN-%s-%s-%s", methodCode, currentDate, currentTime);
    }
    
    /**
     * Get payment method code
     */
    private static String getPaymentMethodCode(String paymentMethod) {
        if (paymentMethod == null) return "XX";
        
        switch (paymentMethod) {
            case "Credit Card":
                return "CC";
            case "Debit Card":
                return "DC";
            case "Online Banking":
                return "OB";
            case "E-Wallet":
                return "EW";
            default:
                return "XX";
        }
    }
    
    /**
     * Generate password reset token
     */
    public static String generateResetToken() {
        return java.util.UUID.randomUUID().toString().replace("-", "");
    }
    
    /**
     * Generate 5-character TAC code for password reset
     * Mix of uppercase letters and numbers
     */
    public static String generateTacCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder(5);
        java.util.Random random = new java.util.Random();
        
        for (int i = 0; i < 5; i++) {
            code.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return code.toString();
    }
}
