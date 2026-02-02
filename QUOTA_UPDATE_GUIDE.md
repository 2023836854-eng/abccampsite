# Admin Quota Update Guide

## Overview
This guide explains how administrators can update the available quota for campsite rooms in the ABC Campsite system.

## Understanding Quota Types

The system uses two types of quota for campsite rooms:

### 1. **Quota** (Maximum Capacity)
- Represents the **total maximum capacity** of tents that can be accommodated in a room
- This is the **base quota** that defines the room's capacity
- Set during room creation and can be updated by admin
- Example: If a room can accommodate 10 tents maximum, quota = 10

### 2. **Available Quota** (Current Availability)
- Represents the **current number of available spots** for booking
- This value **decreases** when bookings are made
- This value **increases** when bookings are cancelled
- Managed automatically by the system during booking operations
- Example: If quota is 10 and 3 tents are booked, available_quota = 7

## Where Admin Can Update Quota

### Location in Admin Panel

Administrators can update room quota through the **Manage Rooms** section:

1. **Navigate to Manage Rooms:**
   - Login to Admin Panel: `http://localhost:8080/abccampsite/admin/login.jsp`
   - Click on **"Manage Rooms"** in the sidebar navigation
   - URL: `/admin/ManageRoomServlet`

2. **Access Options:**
   - From Dashboard → Click "Manage Rooms" in sidebar
   - Direct URL: `http://localhost:8080/abccampsite/admin/ManageRoomServlet`

## How to Update Maximum Quota

### Updating Room Quota (Maximum Capacity)

**Step 1: Navigate to Manage Rooms**
- From the admin sidebar, click **"Manage Rooms"**
- You'll see a list of all rooms across all campsites

**Step 2: Find the Room**
- Use the campsite filter dropdown to narrow down rooms by campsite
- Locate the room you want to update in the table
- The table displays:
  - Room ID
  - Room Name
  - Campsite
  - Location
  - Price per Tent
  - **Quota** (maximum capacity)
  - **Available** (current availability)
  - Status (Active/Inactive)

**Step 3: Edit the Room**
- Click the **Edit button** (yellow button with pencil icon) for the desired room
- You'll be redirected to `/admin/ManageRoomServlet?action=edit&roomId={id}`
- The edit form will load with current room details

**Step 4: Update Quota Field**
- In the edit form, locate the **"Quota (Max Tents)"** field
- This field shows the current maximum capacity
- Enter the new maximum capacity value
- Must be a positive integer (minimum 1)

**Step 5: Save Changes**
- Click the **"Update Room"** button
- The system will save the new quota value
- You'll be redirected back to the room list with a success message

### Important Notes About Quota Updates

⚠️ **What Happens When You Update Quota:**

1. **Increasing Quota:**
   - When you increase the quota, the available_quota is **NOT automatically increased**
   - Example: If quota was 10, available_quota was 7, and you change quota to 15
   - Result: quota = 15, but available_quota remains 7
   - You need to manually adjust available_quota if needed (see below)

2. **Decreasing Quota:**
   - Be careful when decreasing quota below current bookings
   - The system allows this but may cause negative available_quota
   - Best practice: Only decrease quota when you're sure it won't affect active bookings

## How Available Quota is Managed

### Automatic Updates (System-Managed)

The `available_quota` is automatically updated by the system in these scenarios:

#### 1. **During Room Creation** (`ManageRoomServlet.doPost`)
```
When adding a new room:
- Admin sets quota (e.g., 10)
- System automatically sets available_quota = quota
- Result: quota = 10, available_quota = 10
```

#### 2. **During Booking** (`BookingServlet`)
```
When a guest makes a booking:
- Guest books 3 tents in a room with available_quota = 10
- System calls RoomDAO.updateQuota(roomId, 3)
- Result: available_quota = 10 - 3 = 7
```

#### 3. **During Booking Cancellation** (`UpdateBookingServlet`)
```
When a booking is cancelled:
- A booking for 3 tents is cancelled
- System adds 3 back to available_quota
- Result: available_quota = 7 + 3 = 10
```

### Manual Updates (Advanced)

⚠️ **Currently Not Available in UI**

The `available_quota` field is NOT directly editable in the admin UI for safety reasons. It's managed automatically by the booking system to maintain data integrity.

If you need to manually adjust `available_quota` (for special circumstances), you have two options:

#### Option 1: Update Through Room Edit (Future Enhancement)
Currently, the edit form (`editRoom.jsp`) only exposes the `quota` field, not `available_quota`. 

To enable manual updates, the system would need to be enhanced to:
1. Add an `available_quota` field to the edit form
2. Add validation to ensure available_quota ≤ quota
3. Update `ManageRoomServlet.doPost` to handle available_quota updates

#### Option 2: Direct Database Update (Advanced Users Only)
⚠️ **Use with extreme caution!** Only for emergency situations.

```sql
-- View current quota values
SELECT room_id, name, quota, available_quota 
FROM available_rooms 
WHERE room_id = {room_id};

-- Update available_quota (if absolutely necessary)
UPDATE available_rooms 
SET available_quota = {new_value} 
WHERE room_id = {room_id};

-- Example: Reset available_quota to match quota
UPDATE available_rooms 
SET available_quota = quota 
WHERE room_id = 5;
```

**Warning:** Direct database updates bypass application logic and may cause inconsistencies. Only use when:
- You understand the implications
- You have backed up the database
- You're addressing a specific emergency situation

## Workflow Examples

### Example 1: Adding a New Room
```
Admin Action:
1. Click "Add New Room" → /admin/ManageRoomServlet?action=add
2. Fill in room details:
   - Name: "Lakeside Room A"
   - Location: "Near Lake"
   - Price: $50.00
   - Quota: 15
3. Click "Create Room"

System Result:
- Creates new room
- Sets quota = 15
- Sets available_quota = 15
```

### Example 2: Updating Room Capacity
```
Current State:
- Room: "Mountain View"
- quota = 10
- available_quota = 7 (3 tents booked)

Admin Action:
1. Go to Manage Rooms
2. Click Edit on "Mountain View"
3. Change Quota from 10 to 12
4. Click "Update Room"

System Result:
- quota = 12
- available_quota = 7 (unchanged)
- Room can now accommodate 12 tents total
- Still has 7 tents available for booking
```

### Example 3: Resetting Available Quota After Maintenance
```
Scenario: Room was under maintenance, need to reset availability

Current State:
- Room: "Forest Retreat"
- quota = 20
- available_quota = 0 (manually set to 0 for maintenance)

Admin Action:
Option A - Update quota to trigger recalculation:
1. Edit room and set quota to same value (20)
2. This doesn't automatically reset available_quota

Option B - Database update:
1. Connect to database
2. Run: UPDATE available_rooms SET available_quota = quota WHERE room_id = X;
```

## Troubleshooting

### Issue 1: "Available quota shows negative number"
**Cause:** More bookings than quota allows (data inconsistency)

**Solution:**
1. Check bookings for this room
2. Cancel excess bookings or
3. Increase quota to accommodate bookings
4. Manually update available_quota via database

### Issue 2: "Quota update doesn't reflect in bookings"
**Cause:** Updating quota doesn't automatically update available_quota

**Solution:**
- This is expected behavior
- Available_quota represents current availability, not maximum
- It's calculated as: quota - total_booked_tents
- Only adjust available_quota if you need to override this

### Issue 3: "Can't decrease quota below current bookings"
**Cause:** System doesn't prevent this, but it creates inconsistency

**Solution:**
- Before decreasing quota, ensure:
  1. No active bookings exceed new quota
  2. Cancel or modify bookings if needed
  3. Then update quota

## Code References

For developers who need to understand the implementation:

### Files Involved in Quota Management

1. **Database Schema:** `/database/schema.sql`
   - Table: `available_rooms`
   - Columns: `quota`, `available_quota`

2. **Model:** `/src/main/java/model/AvailableRoom.java`
   - Properties: `quota`, `availableQuota`

3. **DAO:** `/src/main/java/dao/RoomDAO.java`
   - Methods:
     - `add(AvailableRoom room)` - Creates room with quota
     - `update(AvailableRoom room)` - Updates room including quota
     - `updateQuota(int roomId, int quantity)` - Decreases available_quota

4. **Servlet:** `/src/main/java/servlet/admin/ManageRoomServlet.java`
   - Handles GET and POST for room management
   - Processes quota updates from edit form

5. **JSP Pages:**
   - `/src/main/webapp/admin/addRoom.jsp` - Add new room form
   - `/src/main/webapp/admin/editRoom.jsp` - Edit room form (includes quota field)
   - `/src/main/webapp/admin/manageRoom.jsp` - Room list view

### Quota Update Flow

```
User Interface (editRoom.jsp)
    ↓
    HTML Form with quota field
    ↓
ManageRoomServlet.doPost()
    ↓
    Parses quota from request
    Creates AvailableRoom object
    Sets room.setQuota(quota)
    ↓
RoomDAO.update(room)
    ↓
    UPDATE available_rooms SET quota=? WHERE room_id=?
    ↓
Database Updated
```

### Available Quota Update Flow (Booking)

```
BookingServlet.doPost()
    ↓
    Guest creates booking for X tents
    ↓
RoomDAO.updateQuota(roomId, X)
    ↓
    SELECT available_quota FOR UPDATE (locks row)
    Checks: available_quota >= X
    UPDATE available_rooms SET available_quota = available_quota - X
    ↓
Database Updated
```

## Summary

### What Admins CAN Do:
✅ Update **quota** (maximum capacity) through Manage Rooms → Edit Room
✅ View current **available_quota** in the room list table
✅ Add new rooms with initial quota
✅ Delete rooms
✅ Toggle room active/inactive status

### What Admins CANNOT Do (Currently):
❌ Directly edit **available_quota** through the UI
❌ Reset available_quota to match quota through UI
❌ Override available_quota for special circumstances through UI

### Recommended Actions:
1. **For normal operations:** Use the Edit Room feature to update maximum quota
2. **For available_quota issues:** Contact system administrator or database admin
3. **For development:** Consider adding available_quota field to edit form with proper validation

## Related Documentation

- [Admin Navigation Guide](ADMIN_NAVIGATION_GUIDE.md) - General admin navigation
- [README.md](README.md) - System overview and features
- [Database Schema](database/schema.sql) - Complete database structure

## Support

For additional assistance with quota management:
- Review the Admin Navigation Guide
- Check Tomcat logs for errors
- Contact system administrator for database-level issues
