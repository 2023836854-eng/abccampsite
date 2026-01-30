<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Room - ABC Campsite Admin</title>
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
                <h2><i class="fas fa-plus-circle"></i> Add New Room</h2>
                <p class="text-muted mb-0">Create a new campsite room</p>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="form-container">
                        <form action="${pageContext.request.contextPath}/admin/ManageRoomServlet" method="post">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="mb-3">
                                <label for="campsiteId" class="form-label">Campsite <span class="text-danger">*</span></label>
                                <select class="form-select" id="campsiteId" name="campsiteId" required>
                                    <option value="">Select a campsite</option>
                                    <%
                                        List<Map<String, Object>> campsites = 
                                            (List<Map<String, Object>>) request.getAttribute("campsites");
                                        if(campsites != null) {
                                            for(Map<String, Object> campsite : campsites) {
                                    %>
                                    <option value="<%= campsite.get("campsiteId") %>">
                                        <%= campsite.get("campsiteName") %> - <%= campsite.get("location") %>
                                    </option>
                                    <% 
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="roomName" class="form-label">Room Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="roomName" name="roomName" 
                                       placeholder="Enter room name (e.g., Room A1, Lakeside Room)" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="location" class="form-label">Location <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="location" name="location" 
                                       placeholder="Enter location within campsite" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="description" name="description" rows="4" 
                                          placeholder="Enter room description and features" required></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Image URL</label>
                                <input type="url" class="form-control" id="imageUrl" name="imageUrl" 
                                       placeholder="https://example.com/room-image.jpg">
                                <div class="form-text">Enter a URL for the room image (optional)</div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="pricePerTent" class="form-label">Price per Tent ($) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="pricePerTent" name="pricePerTent" 
                                           step="0.01" min="0" placeholder="0.00" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="quota" class="form-label">Quota (Max Tents) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="quota" name="quota" 
                                           min="1" placeholder="10" required>
                                </div>
                            </div>
                            
                            <div class="d-flex gap-2 mt-4">
                                <button type="submit" class="btn btn-primary btn-submit">
                                    <i class="fas fa-save"></i> Create Room
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
