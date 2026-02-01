<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Campsite" %>
<%
    Campsite campsite = (Campsite) request.getAttribute("campsite");
    if(campsite == null) {
        response.sendRedirect(request.getContextPath() + "/admin/ManageCampsiteServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Campsite - ABC Campsite Admin</title>
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
                <h2><i class="fas fa-edit"></i> Edit Campsite</h2>
                <p class="text-muted mb-0">Update campsite information</p>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="form-container">
                        <form action="${pageContext.request.contextPath}/admin/ManageCampsiteServlet" method="post">
                            <input type="hidden" name="campsiteId" value="<%= campsite.getCampsiteId() %>">
                            
                            <div class="mb-3">
                                <label for="name" class="form-label">Campsite Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="<%= campsite.getName() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="location" class="form-label">Location <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="location" name="location" 
                                       value="<%= campsite.getLocation() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="description" name="description" rows="5" 
                                          required><%= campsite.getDescription() != null ? campsite.getDescription() : "" %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="image" class="form-label">Image URL</label>
                                <input type="url" class="form-control" id="image" name="image" 
                                       value="<%= campsite.getImage() != null ? campsite.getImage() : "" %>">
                                <div class="form-text">Enter a URL for the campsite image (optional)</div>
                            </div>
                            
                            <div class="d-flex gap-2 mt-4">
                                <button type="submit" class="btn btn-primary btn-submit">
                                    <i class="fas fa-save"></i> Update Campsite
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/ManageCampsiteServlet" 
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
