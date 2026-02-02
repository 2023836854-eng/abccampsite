# Quick Reference: Admin Quota Update

## 🎯 Quick Answer

**Where can admin update the available quota?**

Admins can update room quotas in the **Manage Rooms** section:
- **Path:** Admin Panel → Manage Rooms → Edit Room
- **URL:** `/admin/ManageRoomServlet?action=edit&roomId={id}`
- **Field:** "Quota (Max Tents)" field in the edit form

## 📊 Two Types of Quota

| Type | Description | Editable by Admin? |
|------|-------------|-------------------|
| **Quota** | Maximum capacity (total tents allowed) | ✅ Yes, via Edit Room |
| **Available Quota** | Current availability (remaining spots) | ❌ No, auto-managed by system |

## 🔄 Quick Steps to Update Quota

```
1. Login to Admin Panel
   ↓
2. Click "Manage Rooms" in sidebar
   ↓
3. Find the room in the table
   ↓
4. Click "Edit" button (yellow/pencil icon)
   ↓
5. Update "Quota (Max Tents)" field
   ↓
6. Click "Update Room"
   ↓
7. Done! ✓
```

## 🗺️ Admin Panel Navigation Map

```
Admin Dashboard
    │
    ├── Manage Bookings (/admin/ManageBookingServlet)
    │
    ├── Manage Campsites (/admin/ManageCampsiteServlet)
    │
    └── Manage Rooms (/admin/ManageRoomServlet)  ← YOU ARE HERE
            │
            ├── View All Rooms (default)
            │       │
            │       └── Filter by Campsite (dropdown)
            │
            ├── Add New Room
            │       └── /admin/ManageRoomServlet?action=add
            │           └── Form with Quota field
            │
            └── Edit Room  ← QUOTA UPDATE HERE
                    └── /admin/ManageRoomServlet?action=edit&roomId={id}
                        └── Form with Quota field (line 102-105 in editRoom.jsp)
```

## 📋 Room Table Columns

When viewing Manage Rooms, you'll see:

| Column | Description |
|--------|-------------|
| ID | Room identifier |
| Image | Room photo |
| Room Name | Name of the room |
| Campsite | Parent campsite |
| Location | Location within campsite |
| Price/Tent | Cost per tent |
| **Quota** | Maximum capacity (what you can edit) |
| **Available** | Current availability (system-managed) |
| Status | Active/Inactive |
| Actions | Edit/Toggle/Delete buttons |

## ⚙️ What Happens When You Update Quota?

### Scenario 1: Increase Quota
```
Before:  quota = 10, available_quota = 7
Action:  Change quota to 15
After:   quota = 15, available_quota = 7

Note: Available quota stays the same!
If you want to increase available spots, you may need database update.
```

### Scenario 2: Decrease Quota
```
Before:  quota = 10, available_quota = 7
Action:  Change quota to 8
After:   quota = 8, available_quota = 7

Warning: Be careful! Ensure no conflicts with existing bookings.
```

## 🔐 Important Notes

### What You CAN Do:
- ✅ Update maximum quota (capacity) via Edit Room
- ✅ Add new rooms with initial quota
- ✅ View current available quota in room list
- ✅ Delete or deactivate rooms

### What You CANNOT Do (Currently):
- ❌ Directly edit available_quota through UI
- ❌ Reset available quota to match quota
- ❌ Manually override available spots

### Why Available Quota is Auto-Managed:
- Ensures data integrity
- Prevents overbooking
- Automatically updates when bookings are made/cancelled
- Maintained through transactions to avoid race conditions

## 🔍 Code Location Reference

For developers:

| Component | File Path |
|-----------|-----------|
| Servlet | `/src/main/java/servlet/admin/ManageRoomServlet.java` |
| Add Form | `/src/main/webapp/admin/addRoom.jsp` |
| Edit Form | `/src/main/webapp/admin/editRoom.jsp` (lines 102-105) |
| List View | `/src/main/webapp/admin/manageRoom.jsp` |
| DAO | `/src/main/java/dao/RoomDAO.java` |
| Model | `/src/main/java/model/AvailableRoom.java` |

## 📚 Full Documentation

For comprehensive information, see:
- **[QUOTA_UPDATE_GUIDE.md](QUOTA_UPDATE_GUIDE.md)** - Complete quota management guide
- **[ADMIN_NAVIGATION_GUIDE.md](ADMIN_NAVIGATION_GUIDE.md)** - Admin panel navigation
- **[README.md](README.md)** - System overview

## 🆘 Common Issues

### "I can't see the quota field"
- Make sure you clicked "Edit" not just viewing the list
- Check you're on `/admin/editRoom.jsp` page

### "Quota updated but available quota didn't change"
- This is expected! Available quota is managed automatically
- It represents current bookings, not maximum capacity

### "Need to manually adjust available quota"
- Contact database administrator
- See "Manual Updates" section in QUOTA_UPDATE_GUIDE.md

## 📞 Need Help?

- Review the [full Quota Update Guide](QUOTA_UPDATE_GUIDE.md)
- Check [Admin Navigation Guide](ADMIN_NAVIGATION_GUIDE.md)
- Contact system administrator for database-level access
