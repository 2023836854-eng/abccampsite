<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    Map<String, Object> room = (Map<String, Object>) request.getAttribute("room");
    if(room == null) {
        response.sendRedirect(request.getContextPath() + "/admin/ManageRoomServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Room - ABC Campsite Admin</title>
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
        .form-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .form-control, .form-select {
            padding: 12px;
            border-radius: 8px;
        }
        .btn-submit {
            padding: 12px 30px;
        }
    </style>
</head>
<body>
    <jsp:include page="sidebar.jsp" />
    
    <div class="main-content">
        <div class="container-fluid p-4">
            <div class="page-header">
                <h2><i class="fas fa-edit"></i> Edit Room</h2>
                <p class="text-muted mb-0">Update room information</p>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="form-container">
                        <form action="${pageContext.request.contextPath}/admin/ManageRoomServlet" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="<%= room.get("roomId") %>">
                            
                            <div class="mb-3">
                                <label for="campsiteId" class="form-label">Campsite</label>
                                <select class="form-select" id="campsiteId" name="campsiteId" disabled>
                                    <%
                                        List<Map<String, Object>> campsites = 
                                            (List<Map<String, Object>>) request.getAttribute("campsites");
                                        if(campsites != null) {
                                            for(Map<String, Object> campsite : campsites) {
                                                boolean isSelected = campsite.get("campsiteId").equals(room.get("campsiteId"));
                                    %>
                                    <option value="<%= campsite.get("campsiteId") %>" <%= isSelected ? "selected" : "" %>>
                                        <%= campsite.get("campsiteName") %> - <%= campsite.get("location") %>
                                    </option>
                                    <% 
                                            }
                                        }
                                    %>
                                </select>
                                <div class="form-text">Campsite cannot be changed once room is created</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="roomName" class="form-label">Room Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="roomName" name="roomName" 
                                       value="<%= room.get("roomName") %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="location" class="form-label">Location <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="location" name="location" 
                                       value="<%= room.get("location") %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="description" name="description" rows="4" 
                                          required><%= room.get("description") %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Image URL</label>
                                <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                                       value="<%= room.get("imageUrl") != null ? room.get("imageUrl") : "" %>">
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="pricePerTent" class="form-label">Price per Tent ($) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="pricePerTent" name="pricePerTent" 
                                           step="0.01" min="0" value="<%= room.get("pricePerTent") %>" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="quota" class="form-label">Quota (Max Tents) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="quota" name="quota" 
                                           min="1" value="<%= room.get("quota") %>" required>
                                </div>
                            </div>
                            
                            <div class="d-flex gap-2 mt-4">
                                <button type="submit" class="btn btn-primary btn-submit">
                                    <i class="fas fa-save"></i> Update Room
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/ManageRoomServlet" 
                                   class="btn btn-secondary btn-submit">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
