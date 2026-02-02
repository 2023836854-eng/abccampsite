# 🚀 QUICK START: Update Room Quota

> **Question:** Where can admin update the available quota?  
> **Answer:** Admin Panel → Manage Rooms → Edit Room

---

## ⚡ 30-Second Guide

1. Login to admin panel
2. Click **"Manage Rooms"** in sidebar
3. Find your room in the table
4. Click **Edit** button (yellow pencil icon)
5. Update **"Quota (Max Tents)"** field
6. Click **"Update Room"**
7. Done! ✓

---

## 🎯 Key Points

### What You Can Update
✅ **Quota** = Maximum capacity (total tents allowed)
- Field: "Quota (Max Tents)"
- Location: Edit Room form

### What's Auto-Managed  
⚠️ **Available Quota** = Current availability (spots remaining)
- Shows in: Room list table
- Updates: Automatically when bookings change

---

## 📍 Quick Navigation

```
http://localhost:8080/abccampsite/admin/login.jsp
    ↓
Dashboard → Sidebar → "Manage Rooms"
    ↓
/admin/ManageRoomServlet
    ↓
Click [Edit] on any room
    ↓
/admin/ManageRoomServlet?action=edit&roomId={id}
    ↓
Update "Quota (Max Tents)" field
    ↓
Click "Update Room" → DONE!
```

---

## 📊 Quick Example

**Before Update:**
- Quota: 10 tents
- Available: 7 tents (3 booked)

**You Update Quota to 15:**
- Quota: 15 tents ✓ (updated)
- Available: 7 tents (unchanged - still 3 booked)

**After Guest Cancels (3 tents):**
- Quota: 15 tents
- Available: 10 tents ✓ (auto-increased)

---

## 📚 Need More Help?

| I Need... | Read This... |
|-----------|-------------|
| Quick answer | [ANSWER_QUOTA_UPDATE.md](ANSWER_QUOTA_UPDATE.md) |
| Step-by-step | [QUOTA_UPDATE_QUICK_REFERENCE.md](QUOTA_UPDATE_QUICK_REFERENCE.md) |
| Visual guide | [QUOTA_UPDATE_VISUAL_GUIDE.md](QUOTA_UPDATE_VISUAL_GUIDE.md) |
| Full details | [QUOTA_UPDATE_GUIDE.md](QUOTA_UPDATE_GUIDE.md) |
| All docs | [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) |

---

**That's it!** You now know where to update room quota. 🎉

For detailed information, start with [ANSWER_QUOTA_UPDATE.md](ANSWER_QUOTA_UPDATE.md)
