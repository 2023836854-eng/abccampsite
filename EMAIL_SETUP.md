# Email Configuration Setup Guide

This guide provides instructions for configuring the ABC Campsite application to send real emails using Gmail SMTP server.

## Overview

The application uses JavaMail API to send transactional emails including:
- Password reset verification codes (TAC)
- Booking confirmations
- Payment receipts
- Cancellation notices

All emails are sent from: `noreply@abccampsite.com`

## Prerequisites

Before configuring email functionality, ensure you have:
1. A Gmail account (recommended: `abcampsite.noreply@gmail.com`)
2. JavaMail API dependency added to the project (see Dependencies section)

## Required Environment Variables

The application requires the following environment variables to be set:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `SMTP_HOST` | Gmail SMTP server address | `smtp.gmail.com` |
| `SMTP_PORT` | SMTP port for TLS | `587` |
| `SMTP_USERNAME` | Gmail account email | `abcampsite.noreply@gmail.com` |
| `SMTP_PASSWORD` | Gmail app password (16 characters) | `xxxx xxxx xxxx xxxx` |

## Setup Instructions

### Step 1: Create Gmail Account

1. Go to [Gmail](https://mail.google.com)
2. Create a new account or use an existing one
3. Recommended email: `abcampsite.noreply@gmail.com`

### Step 2: Enable 2-Factor Authentication

1. Sign in to your Google Account
2. Go to **Security** section
3. Enable **2-Step Verification**
4. Follow the prompts to set up 2FA with your phone

### Step 3: Generate App Password

1. Go to [Google Account Security](https://myaccount.google.com/security)
2. Click on **2-Step Verification**
3. Scroll down to **App passwords** section
4. Click on **App passwords**
5. Select app: **Mail**
6. Select device: **Other (Custom name)**
7. Enter name: `ABC Campsite App`
8. Click **Generate**
9. Copy the 16-character password (format: `xxxx xxxx xxxx xxxx`)
10. **Important:** Save this password securely - you won't be able to see it again

### Step 4: Configure Environment Variables

Choose the appropriate method based on your deployment environment:

#### For Development (Windows)

1. Open **System Properties** → **Advanced** → **Environment Variables**
2. Under **User variables** or **System variables**, click **New**
3. Add each variable:
   ```
   Variable name: SMTP_HOST
   Variable value: smtp.gmail.com
   
   Variable name: SMTP_PORT
   Variable value: 587
   
   Variable name: SMTP_USERNAME
   Variable value: abcampsite.noreply@gmail.com
   
   Variable name: SMTP_PASSWORD
   Variable value: [your-16-character-app-password]
   ```
4. Click **OK** to save
5. **Restart your IDE** and Tomcat server for changes to take effect

#### For Development (Linux/Mac)

1. Edit your shell configuration file:
   ```bash
   # For bash
   nano ~/.bashrc
   
   # For zsh
   nano ~/.zshrc
   ```

2. Add the following lines:
   ```bash
   export SMTP_HOST="smtp.gmail.com"
   export SMTP_PORT="587"
   export SMTP_USERNAME="abcampsite.noreply@gmail.com"
   export SMTP_PASSWORD="your-16-character-app-password"
   ```

3. Save the file and reload:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

4. **Restart your IDE** and Tomcat server

#### For Tomcat Server

##### Option 1: Using catalina.sh (Linux/Mac)
1. Navigate to Tomcat's `bin` directory
2. Edit or create `setenv.sh`:
   ```bash
   nano setenv.sh
   ```
3. Add environment variables:
   ```bash
   export SMTP_HOST="smtp.gmail.com"
   export SMTP_PORT="587"
   export SMTP_USERNAME="abcampsite.noreply@gmail.com"
   export SMTP_PASSWORD="your-16-character-app-password"
   ```
4. Save and make it executable:
   ```bash
   chmod +x setenv.sh
   ```

##### Option 2: Using catalina.bat (Windows)
1. Navigate to Tomcat's `bin` directory
2. Edit or create `setenv.bat`:
   ```batch
   set SMTP_HOST=smtp.gmail.com
   set SMTP_PORT=587
   set SMTP_USERNAME=abcampsite.noreply@gmail.com
   set SMTP_PASSWORD=your-16-character-app-password
   ```

#### For IDE (Eclipse)

1. Right-click your project → **Run As** → **Run Configurations**
2. Select your Tomcat server configuration
3. Go to **Environment** tab
4. Click **New** to add each variable:
   - Name: `SMTP_HOST`, Value: `smtp.gmail.com`
   - Name: `SMTP_PORT`, Value: `587`
   - Name: `SMTP_USERNAME`, Value: `abcampsite.noreply@gmail.com`
   - Name: `SMTP_PASSWORD`, Value: `[your-app-password]`
5. Click **Apply** and **Close**
6. Restart the server

#### For IDE (IntelliJ IDEA)

1. Go to **Run** → **Edit Configurations**
2. Select your Tomcat configuration
3. Find **Environment variables** field
4. Click the browse button (📁)
5. Add each variable using the **+** button:
   ```
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USERNAME=abcampsite.noreply@gmail.com
   SMTP_PASSWORD=your-app-password
   ```
6. Click **OK** and restart the server

## Dependencies

### Using Maven (Recommended)

If using the provided `pom.xml`, the JavaMail dependency is already included:

```xml
<dependency>
    <groupId>com.sun.mail</groupId>
    <artifactId>javax.mail</artifactId>
    <version>1.6.2</version>
</dependency>
```

Run `mvn clean install` to download dependencies.

### Manual JAR Setup (Without Maven)

If not using Maven, download and add the following JARs to your project:

1. **javax.mail.jar** (version 1.6.2 or higher)
   - Download from: [Maven Repository](https://repo1.maven.org/maven2/com/sun/mail/javax.mail/1.6.2/javax.mail-1.6.2.jar)
   - Or from: [JavaMail GitHub](https://github.com/javaee/javamail/releases)

2. **activation.jar** (required by JavaMail)
   - Download from: [Maven Repository](https://repo1.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar)

3. Add to Eclipse project:
   - Create a `lib` folder in your project root (if not exists)
   - Copy the JAR files to the `lib` folder
   - Right-click project → **Properties**
   - Go to **Java Build Path** → **Libraries** tab
   - Click **Add JARs** (if JARs are in project) or **Add External JARs**
   - Select the JAR files and click **OK**

4. For web deployment, also copy JARs to:
   ```
   src/main/webapp/WEB-INF/lib/
   ```

## Testing Email Configuration

After setting up environment variables and restarting your server:

1. **Check Logs**: When the application starts, if environment variables are missing, you'll see:
   ```
   ERROR: SMTP configuration not set. Please configure environment variables:
     SMTP_HOST, SMTP_PORT, SMTP_USERNAME, SMTP_PASSWORD
   ```

2. **Test Password Reset**:
   - Go to the forgot password page
   - Enter a valid email address
   - Click submit
   - Check the email inbox for verification code

3. **Test Booking Confirmation**:
   - Complete a booking
   - Check the email inbox for booking confirmation

4. **Check Logs for Success**:
   ```
   Email sent successfully to: user@example.com
   ```

5. **Check Logs for Errors**:
   ```
   Failed to send email to: user@example.com
   Error: [error message]
   ```

## Email Methods

The following email methods are available and functional:

### 1. Password Reset TAC Code
```java
EmailUtil.sendPasswordResetTacCode(String toEmail, String tacCode)
```
Sends a 6-digit verification code for password reset. Code expires in 10 minutes.

### 2. Booking Confirmation
```java
EmailUtil.sendBookingConfirmation(
    String toEmail, String bookingId, String guestName, 
    String campsiteName, String bookingDate, String checkoutDate, String totalPrice
)
```
Sends booking confirmation with all booking details.

### 3. Payment Receipt
```java
EmailUtil.sendPaymentReceipt(
    String toEmail, String bookingId, String transactionId, String amount
)
```
Sends payment confirmation and receipt.

### 4. Cancellation Notice
```java
EmailUtil.sendCancellationEmail(
    String toEmail, String bookingId, String guestName
)
```
Sends booking cancellation confirmation.

## Troubleshooting

### Issue: "Authentication failed" error

**Cause:** Incorrect username or app password

**Solution:**
- Verify `SMTP_USERNAME` is correct
- Regenerate app password from Google Account
- Make sure you're using the app password, not your regular Gmail password

### Issue: "Connection timeout" or "Could not connect to SMTP host"

**Cause:** Network/firewall blocking SMTP connection

**Solution:**
- Check firewall settings allow outbound connections on port 587
- Try port 465 (SSL) instead of 587 (TLS) by updating `SMTP_PORT`
- Verify internet connection

### Issue: Environment variables not loaded

**Cause:** Server not restarted after setting variables

**Solution:**
- Completely restart Tomcat server
- Restart your IDE
- On Windows, restart Command Prompt/PowerShell
- Verify variables are set: `echo %SMTP_HOST%` (Windows) or `echo $SMTP_HOST` (Linux/Mac)

### Issue: "Less secure app access" warning

**Cause:** Old Gmail security setting (deprecated)

**Solution:**
- Use App Passwords instead (as described in Step 3)
- Enable 2-Factor Authentication
- Google has deprecated "less secure apps" - app passwords are the correct approach

### Issue: Emails going to spam

**Cause:** Gmail spam filters

**Solution:**
- Add `noreply@abccampsite.com` to recipient's contacts
- Check SPF/DKIM records if using custom domain
- For production, consider using a dedicated email service (SendGrid, AWS SES, etc.)

## Security Best Practices

1. **Never commit credentials** to version control
   - Add `.env` files to `.gitignore`
   - Use environment variables only

2. **Use App Passwords**, not regular Gmail passwords

3. **Restrict access** to environment variables on production servers

4. **Rotate passwords** periodically

5. **Monitor email logs** for suspicious activity

6. **Consider dedicated email service** for production:
   - SendGrid
   - Amazon SES
   - Mailgun
   - Postmark

## Production Considerations

For production deployment, consider:

1. **Using a dedicated email service** instead of Gmail (better deliverability, higher limits)
2. **Setting up proper SPF, DKIM, and DMARC records** for your domain
3. **Implementing rate limiting** to prevent email abuse
4. **Adding email templates** with HTML formatting
5. **Implementing retry logic** for failed emails
6. **Logging all email attempts** for audit purposes
7. **Using a proper sender domain** instead of @abccampsite.com

## Support

If you encounter issues:
1. Check application logs in Tomcat's `logs` directory
2. Verify all environment variables are set correctly
3. Test SMTP connection using a mail client (Thunderbird, Outlook)
4. Review Google Account security settings

For further assistance, contact the development team.

---

**Last Updated:** February 2024  
**Application Version:** 1.0.0
