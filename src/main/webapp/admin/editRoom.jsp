<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.AvailableRoom, model.Campsite" %>
<%
    AvailableRoom room = (AvailableRoom) request.getAttribute("room");
    Campsite campsite = (Campsite) request.getAttribute("campsite");
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
                            <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">
                            <input type="hidden" name="campsiteId" value="<%= room.getCampsiteId() %>">
                            
                            <div class="mb-3">
                                <label for="campsiteName" class="form-label">Campsite</label>
                                <input type="text" class="form-control" id="campsiteName" 
                                       value="<%= campsite != null ? campsite.getName() : room.getCampsiteName() %>" disabled>
                                <div class="form-text">Campsite cannot be changed once room is created</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="name" class="form-label">Room Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="<%= room.getName() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="location" class="form-label">Location <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="location" name="location" 
                                       value="<%= room.getLocation() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="description" name="description" rows="4" 
                                          required><%= room.getDescription() != null ? room.getDescription() : "" %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="image" class="form-label">Image URL</label>
                                <input type="url" class="form-control" id="image" name="image" 
                                       value="<%= room.getImage() != null ? room.getImage() : "" %>">
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="pricePerTent" class="form-label">Price per Tent ($) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="pricePerTent" name="pricePerTent" 
                                           step="0.01" min="0" value="<%= room.getPricePerTent() %>" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="quota" class="form-label">Quota (Max Tents) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="quota" name="quota" 
                                           min="1" value="<%= room.getQuota() %>" required>
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
