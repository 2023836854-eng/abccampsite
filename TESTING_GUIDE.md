# Quick Testing Guide

## How to Test the Fixes

### Prerequisites
1. Database running with sample data loaded
2. Application deployed on Tomcat
3. Access to the application at `http://localhost:8080/abccampsite/`

---

## Test 1: Admin Login Fix

### Steps:
1. **Navigate to admin login**
   ```
   http://localhost:8080/abccampsite/admin/login.jsp
   ```

2. **Enter credentials**
   - Username: `admin`
   - Password: `admin123`

3. **Click "Login to Admin Panel"**

### Expected Result: ✅
- Login successful
- Redirected to `/admin/dashboard.jsp`
- Admin session created
- Can see admin dashboard with statistics

### If it fails: ❌
- Check database has admin user with hashed password
- Run: `SELECT * FROM admins WHERE username='admin';`
- Password should be: `240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9`
- If not, run `database/sample_data.sql` to create admin account

---

## Test 2: Payment Page Fix

### Steps:

#### A. Create a Booking First
1. **Login as guest**
   ```
   http://localhost:8080/abccampsite/login.jsp
   ```
   - IC: `900101-01-1234`
   - Password: `password123`

2. **Browse campsites**
   - Click "View Available Rooms" from dashboard
   - Select a campsite and room

3. **Create booking**
   - Select booking date (future date)
   - Choose number of tents
   - Click "Proceed to Payment"

#### B. Test Payment Page
4. **Verify payment page loads**
   - Should see URL: `payment.jsp?bookingId=BK20240131-XXXX`
   - Should display booking summary with:
     - Booking ID
     - Campsite name
     - Room name
     - Check-in and check-out dates
     - Number of tents
     - Total amount in RM

5. **Select payment method**
   - Choose one of:
     - Credit Card
     - Debit Card
     - Online Banking
     - E-Wallet

6. **Click "Proceed to Payment"**

### Expected Result: ✅
- Payment form displays correctly with modern UI
- Booking summary shows all details
- Can select payment method
- Form submits to PaymentServlet
- Redirected to receipt page after payment
- Booking status changed to "Confirmed"
- Payment status changed to "Paid"

### If it fails: ❌
Check these files:
- `src/main/webapp/payment.jsp` - Should be the new version (362 lines)
- `src/main/java/servlet/PaymentServlet.java` - Should exist and be mapped to `/PaymentServlet`
- Database tables: `bookings`, `payments` should exist

---

## Visual Verification

### Admin Login Page
**What you should see:**
- Modern login form with gradient background (purple/blue)
- User shield icon
- "ABC Campsite Admin Portal" heading
- Username and password fields with icons
- "Login to Admin Panel" button
- "Back to Main Site" link

### Payment Page
**What you should see:**
- Gradient header (purple/blue) with credit card icon
- "Complete Payment" heading
- Booking summary in gray box with:
  - All booking details in rows
  - Total amount in colored box
- "Select Payment Method" section with 4 options:
  - Credit Card (blue icon)
  - Debit Card (green icon)
  - Online Banking (teal icon)
  - E-Wallet (orange icon)
- "Proceed to Payment" button (gradient)
- "Back to Bookings" button (gray)

---

## Common Issues and Solutions

### Issue: Admin login fails with "Invalid username or password"
**Solution:**
1. Check database connection
2. Verify admin user exists in database
3. Check password is hashed correctly (should be 64-character hex string)
4. Try running: `UPDATE admins SET password='240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9' WHERE username='admin';`

### Issue: Payment page shows error or old version
**Solution:**
1. Clear browser cache
2. Restart Tomcat server
3. Verify `payment.jsp` is the new version:
   ```bash
   head -5 src/main/webapp/payment.jsp
   ```
   Should show: `<%@ page import="dao.BookingDAO, model.Booking, utils.SessionUtil" %>`
4. Check `payment_old_backup.jsp` exists (backup of old version)

### Issue: Payment page redirects to login
**Solution:**
1. Guest must be logged in first
2. Booking must belong to the logged-in guest
3. Check session timeout (30 minutes)

### Issue: Payment submission does nothing
**Solution:**
1. Check PaymentServlet is deployed
2. Verify URL mapping: `/PaymentServlet`
3. Check browser console for JavaScript errors
4. Verify payment method is selected before submitting

---

## Database Verification Queries

### Check admin user:
```sql
SELECT * FROM admins WHERE username = 'admin';
```
Expected: One row with hashed password

### Check booking status after payment:
```sql
SELECT booking_id, status, payment_status 
FROM bookings 
ORDER BY created_at DESC 
LIMIT 1;
```
Expected: status = 'Confirmed', payment_status = 'Paid'

### Check payment record:
```sql
SELECT * FROM payments 
ORDER BY payment_date DESC 
LIMIT 1;
```
Expected: Record with booking_id, payment_method, transaction_id, status='Completed'

---

## Testing Checklist

### Admin Login
- [ ] Can access admin login page
- [ ] Login with admin/admin123 succeeds
- [ ] Redirected to admin dashboard
- [ ] Can see admin navigation sidebar
- [ ] Can logout successfully

### Payment Flow
- [ ] Can login as guest
- [ ] Can create a booking
- [ ] Redirected to payment page with bookingId
- [ ] Payment page displays booking summary correctly
- [ ] All booking details are accurate
- [ ] Total amount matches calculation
- [ ] Can select payment method
- [ ] Submit button works
- [ ] Redirected to receipt page
- [ ] Receipt shows payment details
- [ ] Booking status updated to Confirmed
- [ ] Payment status updated to Paid
- [ ] Payment record created in database

### Security
- [ ] Cannot access payment page without login
- [ ] Cannot pay for another user's booking
- [ ] Cannot pay for already paid booking
- [ ] SQL injection attempts fail (use prepared statements)
- [ ] Session timeout works after 30 minutes

### UI/UX
- [ ] Payment page has modern, professional design
- [ ] Responsive on mobile devices
- [ ] Icons display correctly
- [ ] Gradient colors render properly
- [ ] Form validation works
- [ ] Error messages display clearly

---

## Quick Fix Commands

### If database needs reset:
```bash
mysql -u root -p abccampsite < database/schema.sql
mysql -u root -p abccampsite < database/sample_data.sql
```

### If admin password needs reset:
```sql
UPDATE admins 
SET password = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9' 
WHERE username = 'admin';
```

### If Tomcat needs restart:
```bash
# Stop Tomcat
./bin/shutdown.sh

# Start Tomcat
./bin/startup.sh

# Or from Eclipse/IDE
Right-click project → Run As → Run on Server
```

---

## Success Indicators

✅ **Admin Login Working:**
- Login successful with admin/admin123
- Dashboard loads with charts and statistics
- Can navigate to other admin pages

✅ **Payment Page Working:**
- Modern UI with gradient and icons
- Booking summary displays correctly
- Payment methods selectable
- Form submits to PaymentServlet
- Receipt generated after payment
- Database updated correctly

---

## Need Help?

If tests fail, check:
1. `PAYMENT_ADMIN_FIX_SUMMARY.md` - Detailed explanation of changes
2. `BEFORE_AFTER_COMPARISON.md` - Code comparison
3. Server logs for errors
4. Browser console for JavaScript errors
5. Database connection settings in `utils/DBConnection.java`

**All tests should pass!** ✅
