# Answer: Where Admin Can Update Available Quota

## Direct Answer

**Admin can update room quota in the "Manage Rooms" section of the admin panel.**

### Quick Navigation:
1. Login to Admin Panel: `/admin/login.jsp`
2. Click **"Manage Rooms"** in the sidebar
3. Find the room you want to update
4. Click the **Edit button** (yellow/pencil icon)
5. Update the **"Quota (Max Tents)"** field
6. Click **"Update Room"** to save

### URL Path:
```
/admin/ManageRoomServlet?action=edit&roomId={room_id}
```

## Important Distinction

The system has **TWO types of quota**:

### 1. **Quota** (Maximum Capacity) ✅ Admin Can Update
- **What:** Total maximum number of tents the room can hold
- **Where to update:** Admin Panel → Manage Rooms → Edit Room
- **Form field:** "Quota (Max Tents)"
- **File:** `/admin/editRoom.jsp` (lines 102-105)
- **Editable:** ✅ YES, through the admin UI

### 2. **Available Quota** (Current Availability) ⚠️ System-Managed
- **What:** Current number of available spots (quota minus booked tents)
- **Where to view:** Admin Panel → Manage Rooms (list view, "Available" column)
- **Editable:** ❌ NO, automatically managed by the booking system
- **Changes when:** Bookings are created or cancelled

## Visual Summary

```
┌──────────────────────────────────────────────────────────┐
│                    MANAGE ROOMS PAGE                      │
│              /admin/ManageRoomServlet                     │
├──────────────────────────────────────────────────────────┤
│                                                            │
│  Room List Table:                                         │
│  ┌────┬────────┬───────┬──────────┬──────────┐          │
│  │ ID │  Name  │ Price │  Quota   │Available │          │
│  ├────┼────────┼───────┼──────────┼──────────┤          │
│  │ 1  │ Lake   │ $50   │    10    │    7     │ [Edit]   │
│  │ 2  │ Forest │ $45   │    15    │   12     │ [Edit] ◄─┐
│  └────┴────────┴───────┴──────────┴──────────┘          │
│                                ▲        ▲                 │
│                                │        └─────────────────┤
│                   Can Update   │         View Only        │
│                   This Value   │         (Auto-managed)   │
│                                │                          │
│                    Click [Edit] to update                 │
└──────────────────────────────┬───────────────────────────┘
                               │
                               ▼
┌──────────────────────────────────────────────────────────┐
│                      EDIT ROOM FORM                       │
│    /admin/ManageRoomServlet?action=edit&roomId=2          │
├──────────────────────────────────────────────────────────┤
│                                                            │
│  Campsite: [Forest Campsite] (read-only)                 │
│                                                            │
│  Room Name: [Forest Room]                                │
│                                                            │
│  Location: [Near hiking trail]                           │
│                                                            │
│  Price per Tent: [45.00]                                 │
│                                                            │
│  ╔═══════════════════════════════════════════╗          │
│  ║  Quota (Max Tents): [15] ◄── UPDATE HERE ║          │
│  ╚═══════════════════════════════════════════╝          │
│                                                            │
│  [Update Room] [Cancel]                                  │
└──────────────────────────────────────────────────────────┘
```

## What You Need to Know

### ✅ What Admins CAN Do:

1. **Update Maximum Quota (Capacity)**
   - Via Manage Rooms → Edit Room
   - Change the "Quota (Max Tents)" field
   - This sets the total capacity

2. **View Current Available Quota**
   - In the Manage Rooms table
   - Shows how many spots are currently free

3. **Add New Rooms with Initial Quota**
   - Via Manage Rooms → Add New Room
   - Set initial quota for new rooms

### ❌ What Admins CANNOT Do (Currently):

1. **Directly Edit Available Quota through UI**
   - This field is not in the edit form
   - It's automatically calculated by the system
   - Protected to prevent overbooking

2. **Manually Reset Available Quota**
   - Would require database access
   - Intentionally restricted for data integrity

## Why Available Quota is System-Managed

The `available_quota` field is automatically managed to:
- ✅ Prevent overbooking
- ✅ Maintain data consistency
- ✅ Handle concurrent bookings safely
- ✅ Automatically update when bookings change

### Automatic Updates:

```
Initial State:
  quota = 10, available_quota = 10

Guest books 3 tents:
  quota = 10, available_quota = 7  (auto-decreased)

Guest cancels booking:
  quota = 10, available_quota = 10 (auto-increased)

Admin increases quota to 15:
  quota = 15, available_quota = 7  (unchanged - this is correct!)
```

## Complete Documentation

For more detailed information, see:

1. **[QUOTA_UPDATE_VISUAL_GUIDE.md](QUOTA_UPDATE_VISUAL_GUIDE.md)**
   - Visual diagrams and flowcharts
   - Step-by-step screenshots guide
   - Data flow explanations

2. **[QUOTA_UPDATE_QUICK_REFERENCE.md](QUOTA_UPDATE_QUICK_REFERENCE.md)**
   - Quick lookup table
   - Common scenarios
   - Troubleshooting tips

3. **[QUOTA_UPDATE_GUIDE.md](QUOTA_UPDATE_GUIDE.md)**
   - Comprehensive guide
   - Technical details
   - Code references
   - Database operations

4. **[ADMIN_NAVIGATION_GUIDE.md](ADMIN_NAVIGATION_GUIDE.md)**
   - General admin navigation
   - Troubleshooting
   - All admin features

## Summary

**Question:** "In which part of admin can update the available quota?"

**Answer:** 
- **Where:** Admin Panel → Manage Rooms → Edit Room
- **What field:** "Quota (Max Tents)"
- **What it updates:** Maximum capacity (not the current availability)
- **Current availability:** Shown in the room list but auto-managed by the system

The term "available quota" in your question could mean:
1. **If you mean "quota" (max capacity):** ✅ Admin can update via Edit Room form
2. **If you mean "available_quota" (current availability):** ⚠️ This is auto-managed, not directly editable

Both values are visible in the Manage Rooms interface, but only the maximum quota is editable by admins through the UI.
