<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ABC Campsite Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    <style>
        body {
            background: #f5f6fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .stat-card {
            border-radius: 10px;
            padding: 25px;
            color: white;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.2);
        }
        .stat-card h3 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 10px 0;
        }
        .stat-card p {
            margin: 0;
            opacity: 0.9;
            font-size: 0.95rem;
        }
        .stat-card i {
            font-size: 3rem;
            opacity: 0.3;
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
        }
        .card-blue { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .card-green { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .card-orange { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .card-purple { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        .card-red { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
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
        .page-header {
            background: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <jsp:include page="sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
            <div class="page-header">
                <h2><i class="fas fa-tachometer-alt"></i> Dashboard</h2>
                <p class="text-muted mb-0">Overview of ABC Campsite System</p>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-3 mb-3">
                    <div class="stat-card card-blue position-relative">
                        <p>Total Bookings (This Month)</p>
                        <h3><%= request.getAttribute("totalBookings") != null ? request.getAttribute("totalBookings") : 0 %></h3>
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card card-green position-relative">
                        <p>Upcoming Bookings</p>
                        <h3><%= request.getAttribute("upcomingBookings") != null ? request.getAttribute("upcomingBookings") : 0 %></h3>
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card card-orange position-relative">
                        <p>Ongoing Bookings</p>
                        <h3><%= request.getAttribute("ongoingBookings") != null ? request.getAttribute("ongoingBookings") : 0 %></h3>
                        <i class="fas fa-camping"></i>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card card-purple position-relative">
                        <p>Total Revenue (This Month)</p>
                        <h3>$<%= request.getAttribute("totalRevenue") != null ? 
                            new DecimalFormat("#,##0.00").format(request.getAttribute("totalRevenue")) : "0.00" %></h3>
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="stat-card card-red position-relative">
                        <p>Total Guests</p>
                        <h3><%= request.getAttribute("totalGuests") != null ? request.getAttribute("totalGuests") : 0 %></h3>
                        <i class="fas fa-users"></i>
                    </div>
                </div>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-8">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-line"></i> Monthly Booking Trends</h5>
                        <canvas id="bookingTrendsChart"></canvas>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-pie"></i> Booking Status</h5>
                        <canvas id="statusPieChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="chart-container">
                        <h5 class="mb-3"><i class="fas fa-chart-bar"></i> Revenue by Campsite</h5>
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="table-container">
                <h5 class="mb-3"><i class="fas fa-list"></i> Recent Bookings</h5>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Guest Name</th>
                                <th>Campsite</th>
                                <th>Check-in</th>
                                <th>Check-out</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String, Object>> recentBookings = 
                                    (List<Map<String, Object>>) request.getAttribute("recentBookings");
                                if(recentBookings != null && !recentBookings.isEmpty()) {
                                    for(Map<String, Object> booking : recentBookings) {
                            %>
                            <tr>
                                <td>#<%= booking.get("bookingId") %></td>
                                <td><%= booking.get("guestName") %></td>
                                <td><%= booking.get("campsiteName") %></td>
                                <td><%= booking.get("checkinDate") %></td>
                                <td><%= booking.get("checkoutDate") %></td>
                                <td>
                                    <% 
                                        String status = (String) booking.get("bookingStatus");
                                        String statusClass = "secondary";
                                        if("confirmed".equalsIgnoreCase(status)) statusClass = "success";
                                        else if("pending".equalsIgnoreCase(status)) statusClass = "warning";
                                        else if("cancelled".equalsIgnoreCase(status)) statusClass = "danger";
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
                                <td>$<%= new DecimalFormat("#,##0.00").format(booking.get("totalAmount")) %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8" class="text-center text-muted">No recent bookings</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const bookingTrendsData = <%= request.getAttribute("bookingTrendsData") != null ? 
            request.getAttribute("bookingTrendsData") : "{\"labels\":[],\"data\":[]}" %>;
        const revenueData = <%= request.getAttribute("revenueData") != null ? 
            request.getAttribute("revenueData") : "{\"labels\":[],\"data\":[]}" %>;
        const statusData = <%= request.getAttribute("statusData") != null ? 
            request.getAttribute("statusData") : "{\"labels\":[],\"data\":[]}" %>;
        
        new Chart(document.getElementById('bookingTrendsChart'), {
            type: 'line',
            data: {
                labels: bookingTrendsData.labels,
                datasets: [{
                    label: 'Bookings',
                    data: bookingTrendsData.data,
                    borderColor: '#667eea',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } }
            }
        });
        
        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: {
                labels: revenueData.labels,
                datasets: [{
                    label: 'Revenue ($)',
                    data: revenueData.data,
                    backgroundColor: 'rgba(102, 126, 234, 0.8)',
                    borderColor: '#667eea',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } }
            }
        });
        
        new Chart(document.getElementById('statusPieChart'), {
            type: 'doughnut',
            data: {
                labels: statusData.labels,
                datasets: [{
                    data: statusData.data,
                    backgroundColor: ['#28a745', '#ffc107', '#dc3545', '#6c757d']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true
            }
        });
    </script>
</body>
</html>
