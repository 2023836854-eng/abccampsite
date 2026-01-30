<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - ABC Campsite Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f5f6fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .page-header {
            background: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .filters-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .table-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .badge {
            padding: 5px 10px;
            font-size: 0.75rem;
        }
        .action-btn {
            padding: 5px 10px;
            font-size: 0.75rem;
            margin: 2px;
        }
    </style>
</head>
<body>
    <jsp:include page="sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
            <div class="page-header">
                <h2><i class="fas fa-calendar-check"></i> Manage Bookings</h2>
                <p class="text-muted mb-0">View and manage all campsite bookings</p>
            </div>
            
            <div class="filters-card">
                <form action="${pageContext.request.contextPath}/admin/ManageBookingServlet" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select">
                            <option value="">All Status</option>
                            <option value="pending" <%= "pending".equals(request.getParameter("status")) ? "selected" : "" %>>Pending</option>
                            <option value="confirmed" <%= "confirmed".equals(request.getParameter("status")) ? "selected" : "" %>>Confirmed</option>
                            <option value="cancelled" <%= "cancelled".equals(request.getParameter("status")) ? "selected" : "" %>>Cancelled</option>
                            <option value="completed" <%= "completed".equals(request.getParameter("status")) ? "selected" : "" %>>Completed</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Campsite</label>
                        <select name="campsite" class="form-select">
                            <option value="">All Campsites</option>
                            <%
                                List<Map<String, Object>> campsites = 
                                    (List<Map<String, Object>>) request.getAttribute("campsites");
                                if(campsites != null) {
                                    for(Map<String, Object> campsite : campsites) {
                                        int id = (Integer) campsite.get("campsiteId");
                                        String selectedCampsite = request.getParameter("campsite");
                                        boolean isSelected = selectedCampsite != null && selectedCampsite.equals(String.valueOf(id));
                            %>
                            <option value="<%= id %>" <%= isSelected ? "selected" : "" %>>
                                <%= campsite.get("campsiteName") %>
                            </option>
                            <% 
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">From Date</label>
                        <input type="date" name="fromDate" class="form-control" 
                               value="<%= request.getParameter("fromDate") != null ? request.getParameter("fromDate") : "" %>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">To Date</label>
                        <input type="date" name="toDate" class="form-control"
                               value="<%= request.getParameter("toDate") != null ? request.getParameter("toDate") : "" %>">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-filter"></i> Filter
                        </button>
                    </div>
                </form>
            </div>
            
            <% if(request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Guest Name</th>
                                <th>Email</th>
                                <th>Campsite</th>
                                <th>Room</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Total</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String, Object>> bookings = 
                                    (List<Map<String, Object>>) request.getAttribute("bookings");
                                if(bookings != null && !bookings.isEmpty()) {
                                    for(Map<String, Object> booking : bookings) {
                            %>
                            <tr>
                                <td><strong>#<%= booking.get("bookingId") %></strong></td>
                                <td><%= booking.get("guestName") %></td>
                                <td><%= booking.get("email") %></td>
                                <td><%= booking.get("campsiteName") %></td>
                                <td><%= booking.get("roomName") %></td>
                                <td><%= booking.get("checkinDate") %></td>
                                <td><%= booking.get("checkoutDate") %></td>
                                <td>
                                    <% 
                                        String status = (String) booking.get("bookingStatus");
                                        String statusClass = "secondary";
                                        if("confirmed".equalsIgnoreCase(status)) statusClass = "success";
                                        else if("pending".equalsIgnoreCase(status)) statusClass = "warning";
                                        else if("cancelled".equalsIgnoreCase(status)) statusClass = "danger";
                                        else if("completed".equalsIgnoreCase(status)) statusClass = "info";
                                    %>
                                    <span class="badge bg-<%= statusClass %>"><%= status %></span>
                                </td>
                                <td>
                                    <% 
                                        String paymentStatus = (String) booking.get("paymentStatus");
                                        String paymentClass = "secondary";
                                        if("paid".equalsIgnoreCase(paymentStatus)) paymentClass = "success";
                                        else if("pending".equalsIgnoreCase(paymentStatus)) paymentClass = "warning";
                                    %>
                                    <span class="badge bg-<%= paymentClass %>"><%= paymentStatus %></span>
                                </td>
                                <td><strong>$<%= new DecimalFormat("#,##0.00").format(booking.get("totalAmount")) %></strong></td>
                                <td>
                                    <div class="btn-group">
                                        <button class="btn btn-sm btn-info action-btn" 
                                                onclick="viewBooking(<%= booking.get("bookingId") %>)">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <% if(!"cancelled".equalsIgnoreCase(status) && !"completed".equalsIgnoreCase(status)) { %>
                                        <button class="btn btn-sm btn-warning action-btn" 
                                                onclick="updateStatus(<%= booking.get("bookingId") %>)">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger action-btn" 
                                                onclick="cancelBooking(<%= booking.get("bookingId") %>)">
                                            <i class="fas fa-times"></i>
                                        </button>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="11" class="text-center text-muted py-4">
                                    <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                    No bookings found
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <%
                    Integer currentPage = (Integer) request.getAttribute("currentPage");
                    Integer totalPages = (Integer) request.getAttribute("totalPages");
                    if(currentPage != null && totalPages != null && totalPages > 1) {
                %>
                <nav class="mt-3">
                    <ul class="pagination justify-content-center">
                        <li class="page-item <%= currentPage <= 1 ? "disabled" : "" %>">
                            <a class="page-link" href="?page=<%= currentPage - 1 %>">Previous</a>
                        </li>
                        <% for(int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= i == currentPage ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                        </li>
                        <% } %>
                        <li class="page-item <%= currentPage >= totalPages ? "disabled" : "" %>">
                            <a class="page-link" href="?page=<%= currentPage + 1 %>">Next</a>
                        </li>
                    </ul>
                </nav>
                <% } %>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewBooking(id) {
            window.location.href = '${pageContext.request.contextPath}/admin/ManageBookingServlet?action=view&id=' + id;
        }
        
        function updateStatus(id) {
            const newStatus = prompt('Enter new status (pending/confirmed/completed):');
            if(newStatus) {
                window.location.href = '${pageContext.request.contextPath}/admin/ManageBookingServlet?action=updateStatus&id=' + id + '&status=' + newStatus;
            }
        }
        
        function cancelBooking(id) {
            if(confirm('Are you sure you want to cancel this booking?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/ManageBookingServlet?action=cancel&id=' + id;
            }
        }
    </script>
</body>
</html>
