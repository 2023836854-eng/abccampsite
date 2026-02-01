<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, model.AvailableRoom, model.Campsite" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Rooms - ABC Campsite Admin</title>
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
        .room-image {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
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
            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <h2><i class="fas fa-bed"></i> Manage Rooms</h2>
                    <p class="text-muted mb-0">View and manage all campsite rooms</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/addRoom.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Room
                </a>
            </div>
            
            <div class="filters-card">
                <form action="${pageContext.request.contextPath}/admin/ManageRoomServlet" method="get" class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Filter by Campsite</label>
                        <select name="campsiteId" class="form-select" onchange="this.form.submit()">
                            <option value="">All Campsites</option>
                            <%
                                List<Campsite> campsites = 
                                    (List<Campsite>) request.getAttribute("campsites");
                                String selectedCampsite = request.getParameter("campsiteId");
                                if(campsites != null) {
                                    for(Campsite campsite : campsites) {
                                        int id = campsite.getCampsiteId();
                                        boolean isSelected = selectedCampsite != null && selectedCampsite.equals(String.valueOf(id));
                            %>
                            <option value="<%= id %>" <%= isSelected ? "selected" : "" %>>
                                <%= campsite.getName() %>
                            </option>
                            <% 
                                    }
                                }
                            %>
                        </select>
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
                                <th>ID</th>
                                <th>Image</th>
                                <th>Room Name</th>
                                <th>Campsite</th>
                                <th>Location</th>
                                <th>Price/Tent</th>
                                <th>Quota</th>
                                <th>Available</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<AvailableRoom> rooms = 
                                    (List<AvailableRoom>) request.getAttribute("rooms");
                                if(rooms != null && !rooms.isEmpty()) {
                                    for(AvailableRoom room : rooms) {
                                        boolean isActive = room.isActive();
                                        int quota = room.getQuota();
                                        int availableQuota = room.getAvailableQuota();
                            %>
                            <tr>
                                <td><strong>#<%= room.getRoomId() %></strong></td>
                                <td>
                                    <img src="<%= room.getImage() != null && !room.getImage().isEmpty() ? room.getImage() : "../images/default-room.jpg" %>" 
                                         class="room-image" alt="Room">
                                </td>
                                <td><strong><%= room.getName() %></strong></td>
                                <td><%= room.getCampsiteName() != null ? room.getCampsiteName() : "" %></td>
                                <td><%= room.getLocation() %></td>
                                <td><strong>$<%= new DecimalFormat("#,##0.00").format(room.getPricePerTent()) %></strong></td>
                                <td><%= quota %></td>
                                <td>
                                    <span class="badge bg-<%= availableQuota > 0 ? "success" : "danger" %>">
                                        <%= availableQuota %>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-<%= isActive ? "success" : "secondary" %>">
                                        <%= isActive ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/admin/ManageRoomServlet?action=edit&roomId=<%= room.getRoomId() %>" 
                                           class="btn btn-sm btn-warning action-btn">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/ManageRoomServlet?action=toggle&roomId=<%= room.getRoomId() %>" 
                                           class="btn btn-sm btn-<%= isActive ? "secondary" : "success" %> action-btn">
                                            <i class="fas fa-<%= isActive ? "eye-slash" : "eye" %>"></i>
                                        </a>
                                        <button onclick="deleteRoom(<%= room.getRoomId() %>)" 
                                                class="btn btn-sm btn-danger action-btn">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="10" class="text-center text-muted py-4">
                                    <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                    No rooms found
                                </td>
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
        function deleteRoom(id) {
            if(confirm('Are you sure you want to delete this room?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/ManageRoomServlet?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>
