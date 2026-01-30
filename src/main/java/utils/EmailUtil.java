package utils;

/**
 * Email utility for sending emails
 * Note: This is a placeholder implementation
 * For production, use JavaMail API with proper SMTP configuration
 * TODO: Implement with JavaMail API when email server is configured
 */
public class EmailUtil {
    
    // SMTP Configuration (to be configured)
    // For security, load SMTP settings (especially credentials) from environment variables.
    // Example environment variables:
    //   SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD
    private static final String SMTP_HOST = System.getenv("SMTP_HOST");
    private static final String SMTP_PORT = System.getenv("SMTP_PORT");
    private static final String SMTP_USERNAME = System.getenv("SMTP_USERNAME");
    private static final String SMTP_PASSWORD = System.getenv("SMTP_PASSWORD");
    private static final String FROM_EMAIL = "noreply@abccampsite.com";
    private static final String FROM_NAME = "ABC Campsite System";
    
    /**
     * Send password reset email
     * @param toEmail Recipient email
     * @param resetToken Reset token
     * @param guestName Guest name
     * @return true if email sent successfully
     */
    public static boolean sendPasswordResetEmail(String toEmail, String resetToken, String guestName) {
        String subject = "Password Reset Request - ABC Campsite";
        String resetLink = "http://localhost:8080/abccampsite/resetpassword.jsp?token=" + resetToken;
        
        StringBuilder body = new StringBuilder();
        body.append("Dear ").append(guestName).append(",\n\n");
        body.append("You have requested to reset your password for ABC Campsite.\n\n");
        body.append("Please click the link below to reset your password:\n");
        body.append(resetLink).append("\n\n");
        body.append("This link will expire in 1 hour.\n\n");
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
     * Generic email sending method
     * TODO: Implement with JavaMail API
     */
    private static boolean sendEmail(String to, String subject, String body) {
        // Placeholder implementation
        // In production, use JavaMail API:
        /*
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            
            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);
            
            Transport.send(message);
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        */
        
        // For now, just log to console
        System.out.println("=== EMAIL SENT ===");
        System.out.println("To: " + to);
        System.out.println("Subject: " + subject);
        System.out.println("Body: " + body);
        System.out.println("==================");
        
        return true; // Assume success for development
    }
}
