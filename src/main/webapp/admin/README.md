# ABC Campsite Admin Panel

This directory contains the complete admin panel interface for the ABC Campsite booking system.

## 📁 Files Overview

### Authentication
- **login.jsp** - Admin login page with professional design and error handling

### Core Layout
- **sidebar.jsp** - Reusable sidebar navigation component (included in all admin pages)

### Dashboard
- **dashboard.jsp** - Main dashboard with statistics and Chart.js visualizations

### Booking Management
- **manageBooking.jsp** - View and manage all bookings with filters and actions

### Campsite Management
- **manageCampsite.jsp** - List all campsites
- **addCampsite.jsp** - Create new campsite
- **editCampsite.jsp** - Edit existing campsite

### Room Management
- **manageRoom.jsp** - List all rooms
- **addRoom.jsp** - Create new room
- **editRoom.jsp** - Edit existing room

## 🎨 Design Features

### Visual Design
- Modern gradient color schemes
- Bootstrap 5 framework
- Font Awesome 6 icons
- Responsive layout (mobile-friendly)
- Card-based UI with shadows
- Hover effects and animations
- Professional typography (Segoe UI)

### Color-Coded Status Badges
- **Green** (success): confirmed, paid, active
- **Yellow** (warning): pending
- **Red** (danger): cancelled, unpaid
- **Blue** (info): completed
- **Gray** (secondary): inactive

### Dashboard Charts (Chart.js)
1. Monthly Booking Trends (Line Chart)
2. Revenue by Campsite (Bar Chart)
3. Booking Status Distribution (Pie Chart)

## 🔒 Security Features

- ✅ Session validation on all admin pages
- ✅ Redirects to login if not authenticated
- ✅ NO inline SQL queries (uses servlets)
- ✅ Form validation (required fields, input types)
- ✅ Confirmation dialogs for destructive actions
- ✅ XSS protection via JSP escaping

## 🔗 Servlet Dependencies

The admin panel requires these servlets to be implemented:

### Authentication
- **AdminLoginServlet** - Handles admin login
- **LogoutServlet** - Handles logout

### Data Management
- **DashboardServlet** - Provides dashboard statistics and chart data
- **ManageBookingServlet** - Handles booking CRUD operations
- **ManageCampsiteServlet** - Handles campsite CRUD operations
- **ManageRoomServlet** - Handles room CRUD operations

## 📊 Data Flow

### Expected Request Attributes

#### DashboardServlet should provide:
- `totalBookings` (Integer)
- `upcomingBookings` (Integer)
- `ongoingBookings` (Integer)
- `totalRevenue` (Double)
- `totalGuests` (Integer)
- `recentBookings` (List<Map<String, Object>>)
- `bookingTrendsData` (JSON String)
- `revenueData` (JSON String)
- `statusData` (JSON String)

#### ManageBookingServlet should provide:
- `bookings` (List<Map<String, Object>>)
- `campsites` (List<Map<String, Object>>)
- `currentPage` (Integer)
- `totalPages` (Integer)
- `success` (String) - optional success message
- `error` (String) - optional error message

#### ManageCampsiteServlet should provide:
- `campsites` (List<Map<String, Object>>)
- `campsite` (Map<String, Object>) - for edit page
- `success` (String) - optional
- `error` (String) - optional

#### ManageRoomServlet should provide:
- `rooms` (List<Map<String, Object>>)
- `room` (Map<String, Object>) - for edit page
- `campsites` (List<Map<String, Object>>)
- `success` (String) - optional
- `error` (String) - optional

### Session Attributes Required:
- `adminName` (String) - Admin user's name

## 🚀 Usage

### Accessing the Admin Panel
1. Navigate to: `/admin/login.jsp`
2. Enter admin credentials
3. After login, redirected to dashboard

### Navigation Structure
```
Admin Panel
├── Dashboard (statistics, charts, recent bookings)
├── Manage Bookings (view, filter, update, cancel)
├── Manage Campsites (list, add, edit, delete, toggle)
└── Manage Rooms (list, add, edit, delete, toggle, filter by campsite)
```

## 📝 Form Validation

All forms include:
- Required field validation (HTML5)
- Proper input types (text, email, number, date, url, textarea)
- Min/max constraints where applicable
- Client-side validation before submission

## 🎯 Action Buttons

### Booking Actions
- **View** (eye icon) - View booking details
- **Update** (edit icon) - Update booking status
- **Cancel** (x icon) - Cancel booking (with confirmation)

### Campsite Actions
- **Edit** (edit icon) - Edit campsite details
- **Toggle** (eye/eye-slash) - Activate/deactivate campsite
- **Manage Rooms** (bed icon) - View rooms for this campsite
- **Delete** (trash icon) - Delete campsite (with confirmation)

### Room Actions
- **Edit** (edit icon) - Edit room details
- **Toggle** (eye/eye-slash) - Activate/deactivate room
- **Delete** (trash icon) - Delete room (with confirmation)

## 📱 Responsive Design

- Mobile-friendly sidebar navigation
- Responsive tables with horizontal scroll
- Card layouts adapt to screen size
- Touch-friendly buttons and forms

## 🎨 Customization

To customize colors/theme, modify the gradient values in each file's `<style>` section:
```css
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

## 📦 External Dependencies (CDN)

- Bootstrap 5.1.3
- Font Awesome 6.0.0
- Chart.js 3.9.1

## ✅ Best Practices Followed

1. **Separation of Concerns**: No business logic in JSP
2. **Security**: Session checks, no SQL injection risks
3. **Maintainability**: Reusable sidebar component
4. **User Experience**: Clear feedback messages, confirmations
5. **Accessibility**: Semantic HTML, proper labels
6. **Performance**: CDN resources, minimal inline styles
7. **Code Quality**: Consistent formatting, meaningful variable names

## 📄 License

Part of the ABC Campsite system.
