<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = (String) session.getAttribute("adminName");
    String currentPage = request.getRequestURI();
    if(adminName == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp?error=session");
        return;
    }
%>
<style>
    .sidebar {
        min-height: 100vh;
        background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
        color: white;
        position: fixed;
        top: 0;
        left: 0;
        width: 260px;
        padding: 0;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        z-index: 1000;
    }
    .sidebar-header {
        padding: 25px 20px;
        background: rgba(0,0,0,0.2);
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }
    .sidebar-header h4 {
        margin: 0;
        font-weight: 600;
        font-size: 1.3rem;
    }
    .sidebar-header .admin-info {
        margin-top: 10px;
        padding-top: 10px;
        border-top: 1px solid rgba(255,255,255,0.1);
        font-size: 0.85rem;
        opacity: 0.9;
    }
    .sidebar-menu {
        padding: 20px 0;
        list-style: none;
        margin: 0;
    }
    .sidebar-menu li {
        margin: 0;
    }
    .sidebar-menu a {
        display: block;
        padding: 15px 25px;
        color: rgba(255,255,255,0.8);
        text-decoration: none;
        transition: all 0.3s;
        border-left: 3px solid transparent;
    }
    .sidebar-menu a:hover {
        background: rgba(255,255,255,0.1);
        color: white;
        border-left-color: #3498db;
    }
    .sidebar-menu a.active {
        background: rgba(255,255,255,0.15);
        color: white;
        border-left-color: #3498db;
        font-weight: 600;
    }
    .sidebar-menu a i {
        margin-right: 12px;
        width: 20px;
        text-align: center;
    }
    .sidebar-footer {
        position: absolute;
        bottom: 0;
        width: 100%;
        padding: 20px;
        background: rgba(0,0,0,0.2);
        border-top: 1px solid rgba(255,255,255,0.1);
    }
    .main-content {
        margin-left: 260px;
        min-height: 100vh;
        background: #f5f6fa;
    }
</style>

<div class="sidebar">
    <div class="sidebar-header">
        <h4><i class="fas fa-campground"></i> ABC Campsite</h4>
        <div class="admin-info">
            <i class="fas fa-user-shield"></i>
            <strong><%= adminName %></strong>
            <div class="text-muted small mt-1">Administrator</div>
        </div>
    </div>
    
    <ul class="sidebar-menu">
        <li>
            <a href="${pageContext.request.contextPath}/admin/DashboardServlet" 
               class="<%= currentPage.contains("dashboard") ? "active" : "" %>">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/ManageBookingServlet" 
               class="<%= currentPage.contains("Booking") ? "active" : "" %>">
                <i class="fas fa-calendar-check"></i> Manage Bookings
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/ManageCampsiteServlet" 
               class="<%= currentPage.contains("Campsite") ? "active" : "" %>">
                <i class="fas fa-map-marked-alt"></i> Manage Campsites
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/ManageRoomServlet" 
               class="<%= currentPage.contains("Room") ? "active" : "" %>">
                <i class="fas fa-bed"></i> Manage Rooms
            </a>
        </li>
    </ul>
    
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light btn-sm w-100">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</div>
