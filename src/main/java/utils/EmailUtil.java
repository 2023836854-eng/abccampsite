package utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * Email utility for sending emails via JavaMail API
 * Uses Gmail SMTP server for sending transactional emails
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
     * Generic email sending method using JavaMail API
     * @param to Recipient email address
     * @param subject Email subject
     * @param body Email body content
     * @return true if email sent successfully, false otherwise
     */
    private static boolean sendEmail(String to, String subject, String body) {
        // Print passkey to Eclipse IDE console
        System.out.println("SMTP Password: " + SMTP_PASSWORD);
        
        // Validate environment variables
        if (SMTP_HOST == null || SMTP_PORT == null || SMTP_USERNAME == null || SMTP_PASSWORD == null) {
            System.err.println("ERROR: SMTP configuration not set. Please configure environment variables:");
            System.err.println("  SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD");
            System.err.println("Email will not be sent to: " + to);
            return false;
        }
        
        try {
            // Configure SMTP properties for Gmail
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.trust", SMTP_HOST);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // Create authenticator with credentials
            Authenticator auth = new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
                }
            };
            
            // Create session with authentication
            Session session = Session.getInstance(props, auth);
            
            // Create email message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);
            
            // Send the email
            Transport.send(message);
            
            System.out.println("Email sent successfully to: " + to);
            return true;
            
        } catch (MessagingException e) {
            System.err.println("Failed to send email to: " + to);
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Unexpected error sending email to: " + to);
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
