package utils;

/**
 * Email utility for mock email sending
 * Logs email details to console instead of actually sending emails
 */
public class EmailUtil {
    
    private static final String FROM_EMAIL = "noreply@abccampsite.com";
    private static final String FROM_NAME = "ABC Campsite System";
    
    /**
     * Send password reset TAC code
     * @param toEmail Recipient email
     * @param tacCode TAC code
     * @return true if email sent successfully
     */
    public static boolean sendPasswordResetTacCode(String toEmail, String tacCode) {
        String subject = "Password Reset Verification Code";
        
        StringBuilder body = new StringBuilder();
        body.append("Your verification code is ").append(tacCode).append(".\n\n");
        body.append("This code will expire in 10 minutes.\n\n");
        body.append("If you did not request this, please ignore this email.\n\n");
        body.append("Best regards,\n");
        body.append("ABC Campsite Team");
        
        return sendEmail(toEmail, subject, body.toString());
    }
    
    /**
     * Send booking confirmation email
     */
    public static boolean sendBookingConfirmation(String toEmail, String bookingId, 
                                                   String guestName, String campsiteName, 
                                                   String bookingDate, String checkoutDate, String totalPrice) {
        String subject = "Booking Confirmation - " + bookingId;
        
        StringBuilder body = new StringBuilder();
        body.append("Dear ").append(guestName).append(",\n\n");
        body.append("Your booking has been confirmed!\n\n");
        body.append("Booking Details:\n");
        body.append("- Booking ID: ").append(bookingId).append("\n");
        body.append("- Campsite: ").append(campsiteName).append("\n");
        body.append("- Check-in Date: ").append(bookingDate).append("\n");
        body.append("- Check-out Date: ").append(checkoutDate).append("\n");
        body.append("- Total Price: RM ").append(totalPrice).append("\n\n");
        body.append("Thank you for choosing ABC Campsite!\n\n");
        body.append("Best regards,\n");
        body.append("ABC Campsite Team");
        
        return sendEmail(toEmail, subject, body.toString());
    }
    
    /**
     * Send payment receipt email
     */
    public static boolean sendPaymentReceipt(String toEmail, String bookingId, 
                                             String transactionId, String amount) {
        String subject = "Payment Receipt - " + bookingId;
        
        StringBuilder body = new StringBuilder();
        body.append("Payment Received\n\n");
        body.append("Booking ID: ").append(bookingId).append("\n");
        body.append("Transaction ID: ").append(transactionId).append("\n");
        body.append("Amount: RM ").append(amount).append("\n\n");
        body.append("Thank you for your payment!\n\n");
        body.append("ABC Campsite Team");
        
        return sendEmail(toEmail, subject, body.toString());
    }
    
    /**
     * Send cancellation confirmation email
     */
    public static boolean sendCancellationEmail(String toEmail, String bookingId, String guestName) {
        String subject = "Booking Cancellation - " + bookingId;
        
        StringBuilder body = new StringBuilder();
        body.append("Dear ").append(guestName).append(",\n\n");
        body.append("Your booking ").append(bookingId).append(" has been cancelled.\n\n");
        body.append("If this was a mistake, please contact us.\n\n");
        body.append("Best regards,\n");
        body.append("ABC Campsite Team");
        
        return sendEmail(toEmail, subject, body.toString());
    }
    
    /**
     * Mock email sending method - logs to console instead of sending actual email
     * @param to Recipient email address
     * @param subject Email subject
     * @param body Email body content
     * @return true (always succeeds in mock mode)
     */
    private static boolean sendEmail(String to, String subject, String body) {
        System.out.println("========== MOCK EMAIL ==========");
        System.out.println("From: " + FROM_NAME + " <" + FROM_EMAIL + ">");
        System.out.println("To: " + to);
        System.out.println("Subject: " + subject);
        System.out.println("--------------------------------");
        System.out.println(body);
        System.out.println("================================");
        System.out.println();
        return true;
    }
}
