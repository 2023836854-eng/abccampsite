<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Campsite" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Campsites - ABC Campsite Admin</title>
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
        .table-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .campsite-image {
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
                    <h2><i class="fas fa-map-marked-alt"></i> Manage Campsites</h2>
                    <p class="text-muted mb-0">View and manage all campsites</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/addCampsite.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Campsite
                </a>
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
                                <th>Name</th>
                                <th>Location</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Campsite> campsites = 
                                    (List<Campsite>) request.getAttribute("campsites");
                                if(campsites != null && !campsites.isEmpty()) {
                                    for(Campsite campsite : campsites) {
                                        boolean isActive = campsite.isActive();
                            %>
                            <tr>
                                <td><strong>#<%= campsite.getCampsiteId() %></strong></td>
                                <td>
                                    <img src="<%= campsite.getImage() != null && !campsite.getImage().isEmpty() ? campsite.getImage() : "../images/default-campsite.jpg" %>" 
                                         class="campsite-image" alt="Campsite">
                                </td>
                                <td><strong><%= campsite.getName() %></strong></td>
                                <td><%= campsite.getLocation() %></td>
                                <td>
                                    <% 
                                        String desc = campsite.getDescription();
                                        if(desc != null && desc.length() > 100) {
                                            out.print(desc.substring(0, 100) + "...");
                                        } else {
                                            out.print(desc);
                                        }
                                    %>
                                </td>
                                <td>
                                    <span class="badge bg-<%= isActive ? "success" : "secondary" %>">
                                        <%= isActive ? "Active" : "Inactive" %>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/admin/ManageCampsiteServlet?action=edit&campsiteId=<%= campsite.getCampsiteId() %>" 
                                           class="btn btn-sm btn-warning action-btn">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/ManageCampsiteServlet?action=toggle&campsiteId=<%= campsite.getCampsiteId() %>" 
                                           class="btn btn-sm btn-<%= isActive ? "secondary" : "success" %> action-btn">
                                            <i class="fas fa-<%= isActive ? "eye-slash" : "eye" %>"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/ManageRoomServlet?campsiteId=<%= campsite.getCampsiteId() %>" 
                                           class="btn btn-sm btn-info action-btn">
                                            <i class="fas fa-bed"></i>
                                        </a>
                                        <button onclick="deleteCampsite(<%= campsite.get("campsiteId") %>)" 
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
                                <td colspan="7" class="text-center text-muted py-4">
                                    <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                    No campsites found
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
        function deleteCampsite(id) {
            if(confirm('Are you sure you want to delete this campsite? This will also delete all associated rooms.')) {
                window.location.href = '${pageContext.request.contextPath}/admin/ManageCampsiteServlet?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>
