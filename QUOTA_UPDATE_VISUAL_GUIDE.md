# Visual Guide: Admin Quota Update Flow

## 🗺️ Complete Admin Navigation Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         ADMIN LOGIN                                  │
│                   /admin/login.jsp                                   │
│                                                                       │
│           Username: admin     Password: ••••••                       │
│                      [Login Button]                                  │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      ADMIN DASHBOARD                                 │
│                   /admin/DashboardServlet                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐             │
│  │ Total        │  │ Total        │  │ Revenue      │             │
│  │ Bookings     │  │ Campsites    │  │ This Month   │             │
│  └──────────────┘  └──────────────┘  └──────────────┘             │
│                                                                       │
│  Sidebar:                                                            │
│  ├─ Dashboard                                                        │
│  ├─ Manage Bookings                                                  │
│  ├─ Manage Campsites                                                 │
│  └─ Manage Rooms    ◄─── CLICK HERE FOR QUOTA UPDATE               │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                       MANAGE ROOMS                                   │
│                  /admin/ManageRoomServlet                            │
│                                                                       │
│  Filter: [All Campsites ▼]              [+ Add New Room]            │
│                                                                       │
│  ┌───┬──────┬─────────┬──────────┬────────┬───────┬───────┬────┐  │
│  │ID │Image │Room Name│Campsite  │Price   │Quota  │Avail. │Acts│  │
│  ├───┼──────┼─────────┼──────────┼────────┼───────┼───────┼────┤  │
│  │1  │[IMG] │Lake View│Riverside │$50.00  │10     │7      │[E] │  │
│  │2  │[IMG] │Mountain │Highland  │$60.00  │15     │12     │[E] │  │
│  │3  │[IMG] │Forest   │Woodland  │$45.00  │8      │0      │[E] │  │
│  └───┴──────┴─────────┴──────────┴────────┴───────┴───────┴────┘  │
│                                                       ▲               │
│                    Click [E] to Edit  ───────────────┘               │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         EDIT ROOM                                    │
│         /admin/ManageRoomServlet?action=edit&roomId=1                │
│                                                                       │
│  Campsite: [Riverside Campsite] (cannot change)                     │
│                                                                       │
│  Room Name: [Lake View Room          ]  ◄─── Edit room name        │
│                                                                       │
│  Location:  [Near the lake entrance  ]  ◄─── Edit location         │
│                                                                       │
│  Description:                                                        │
│  ┌──────────────────────────────────┐                               │
│  │ Beautiful lakeside location with │   ◄─── Edit description       │
│  │ scenic views...                  │                               │
│  └──────────────────────────────────┘                               │
│                                                                       │
│  Image URL: [https://example.com/... ]  ◄─── Edit image URL        │
│                                                                       │
│  Price per Tent: [50.00              ]  ◄─── Edit price            │
│                                                                       │
│  ╔══════════════════════════════════════════════════════╗          │
│  ║ Quota (Max Tents): [10] ◄────── UPDATE QUOTA HERE!! ║          │
│  ╚══════════════════════════════════════════════════════╝          │
│                           ▲                                          │
│                           │                                          │
│              This field updates the MAXIMUM CAPACITY                │
│              (available_quota is auto-managed by system)            │
│                                                                       │
│  [Update Room]  [Cancel]                                            │
└────────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      SUCCESS MESSAGE                                 │
│                                                                       │
│  ✓ Room updated successfully                                        │
│                                                                       │
│  Back to Manage Rooms list...                                       │
└─────────────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow: What Happens Behind the Scenes

```
┌───────────────────┐
│  Admin edits      │
│  quota field      │
│  (changes 10→15)  │
└─────────┬─────────┘
          │
          ▼
┌───────────────────────────────────────┐
│  editRoom.jsp                         │
│  <input name="quota" value="15">      │
└─────────┬─────────────────────────────┘
          │ HTTP POST
          ▼
┌───────────────────────────────────────┐
│  ManageRoomServlet.doPost()           │
│  - Reads form data                    │
│  - Validates quota > 0                │
│  - Creates AvailableRoom object       │
│  - room.setQuota(15)                  │
└─────────┬─────────────────────────────┘
          │
          ▼
┌───────────────────────────────────────┐
│  RoomDAO.update(room)                 │
│  UPDATE available_rooms               │
│  SET quota = 15                       │
│  WHERE room_id = 1                    │
└─────────┬─────────────────────────────┘
          │
          ▼
┌───────────────────────────────────────┐
│  Database Updated                     │
│  ┌────────────────────────┐          │
│  │ room_id: 1             │          │
│  │ quota: 15      ◄── NEW │          │
│  │ available_quota: 7     │          │
│  └────────────────────────┘          │
│  Note: available_quota NOT changed!  │
└───────────────────────────────────────┘
```

## 📊 Quota vs Available Quota Explained

```
┌─────────────────────────────────────────────────────────────┐
│                        ROOM CAPACITY                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Total Quota (Max Capacity) = 10 tents                      │
│  ████████████████████████████████████████████████           │
│  ┌────────────────────┬────────────────────────────┐       │
│  │   BOOKED (3)       │    AVAILABLE (7)          │       │
│  │   🏕️🏕️🏕️           │    ⬜⬜⬜⬜⬜⬜⬜            │       │
│  └────────────────────┴────────────────────────────┘       │
│                                                               │
│  ┌──────────────────────────────────────────────┐          │
│  │ Admin can update:                            │          │
│  │ • Quota (max capacity)     ✅ Via Edit Form  │          │
│  │ • Available Quota          ❌ Auto-managed   │          │
│  └──────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

## 🎬 Step-by-Step Screenshots Locations

### Step 1: Admin Login
- **File:** `/admin/login.jsp`
- **Action:** Enter credentials
- **What to see:** Login form with username/password fields

### Step 2: Dashboard
- **URL:** `/admin/DashboardServlet`
- **Action:** View dashboard and locate sidebar
- **What to see:** Statistics, charts, and sidebar navigation

### Step 3: Manage Rooms List
- **URL:** `/admin/ManageRoomServlet`
- **Action:** View all rooms in table format
- **What to see:** 
  - Quota column (maximum capacity)
  - Available column (current availability)
  - Edit button for each room

### Step 4: Edit Room Form
- **URL:** `/admin/ManageRoomServlet?action=edit&roomId={id}`
- **Action:** Click Edit button on a room
- **What to see:**
  - Form with all room fields
  - **Quota (Max Tents)** field (line 102-105 in editRoom.jsp)
  - Update Room button

### Step 5: Update Quota
- **Action:** Change quota value and submit
- **What to see:** Success message and return to room list

## 🔍 Field Comparison Table

| Aspect | Quota (Max Capacity) | Available Quota |
|--------|---------------------|-----------------|
| **What it is** | Maximum number of tents allowed | Current available spots |
| **Location in UI** | Edit Room form, line 102-105 | Room list table, "Available" column |
| **Editable?** | ✅ Yes, by admin | ❌ No, system-managed |
| **When it changes** | When admin updates it | When bookings are made/cancelled |
| **Database column** | `quota` | `available_quota` |
| **Java property** | `room.getQuota()` | `room.getAvailableQuota()` |
| **Form field name** | `name="quota"` | Not in form |
| **Can be increased?** | ✅ Yes | Only indirectly via cancellations |
| **Can be decreased?** | ✅ Yes (be careful!) | Only via new bookings |

## 💡 Key Insights

### Why Available Quota is Auto-Managed

```
┌─────────────────────────────────────────────┐
│  Guest Books 3 Tents                        │
└─────────┬───────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────┐
│  RoomDAO.updateQuota(roomId, 3)             │
│  1. Lock the row (FOR UPDATE)               │
│  2. Check: available_quota >= 3             │
│  3. Decrease: available_quota -= 3          │
│  4. Commit transaction                      │
└─────────────────────────────────────────────┘
          
Benefits:
✅ Prevents overbooking
✅ Race condition safe
✅ Data integrity maintained
✅ No manual errors
```

### When to Update Quota vs Available Quota

| Scenario | Update Quota? | Update Available Quota? |
|----------|--------------|------------------------|
| Room expansion (more space) | ✅ Increase quota | ⚠️ Maybe via DB |
| Room reduction (less space) | ✅ Decrease quota | ❌ Let system manage |
| After maintenance | ❌ Keep same | ⚠️ Maybe reset via DB |
| New bookings | ❌ Don't change | ✅ Auto-decreases |
| Cancelled bookings | ❌ Don't change | ✅ Auto-increases |

## 📞 Quick Help

### "Where exactly do I click to update quota?"
```
1. Admin sidebar → "Manage Rooms"
2. Find your room in the table
3. Click yellow "Edit" button (pencil icon)
4. Update "Quota (Max Tents)" field
5. Click "Update Room"
```

### "Why didn't available quota change when I updated quota?"
```
This is normal! They are independent values:
- Quota = What you can SET
- Available Quota = Current availability (system calculates this)
```

### "How do I reset available quota to match quota?"
```
Currently requires database access:
UPDATE available_rooms 
SET available_quota = quota 
WHERE room_id = {id};

Or contact your database administrator.
```

## 📚 Related Documentation

- **[QUOTA_UPDATE_GUIDE.md](QUOTA_UPDATE_GUIDE.md)** - Full detailed guide
- **[QUOTA_UPDATE_QUICK_REFERENCE.md](QUOTA_UPDATE_QUICK_REFERENCE.md)** - Quick lookup
- **[ADMIN_NAVIGATION_GUIDE.md](ADMIN_NAVIGATION_GUIDE.md)** - Navigation help
- **[README.md](README.md)** - System overview
