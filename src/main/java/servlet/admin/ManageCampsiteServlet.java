package servlet.admin;

import dao.CampsiteDAO;
import model.Campsite;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Manage Campsite Servlet
 * Handles CRUD operations for campsites
 */
@WebServlet("/admin/ManageCampsiteServlet")
public class ManageCampsiteServlet extends HttpServlet {
    
    private CampsiteDAO campsiteDAO;
    
    @Override
    public void init() throws ServletException {
        campsiteDAO = new CampsiteDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!SessionUtil.isAdminLoggedIn(request)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "add":
                    // Forward to add campsite page
                    request.getRequestDispatcher("/admin/addCampsite.jsp").forward(request, response);
                    break;
                    
                case "edit":
                    // Get campsite by ID and forward to edit page
                    String editIdStr = request.getParameter("campsiteId");
                    if (editIdStr != null && !editIdStr.trim().isEmpty()) {
                        int campsiteId = Integer.parseInt(editIdStr);
                        Campsite campsite = campsiteDAO.getById(campsiteId);
                        if (campsite != null) {
                            request.setAttribute("campsite", campsite);
                            request.getRequestDispatcher("/admin/editCampsite.jsp").forward(request, response);
                        } else {
                            response.sendRedirect("ManageCampsiteServlet?error=" + 
                                                java.net.URLEncoder.encode("Campsite not found", "UTF-8"));
                        }
                    } else {
                        response.sendRedirect("ManageCampsiteServlet?error=" + 
                                            java.net.URLEncoder.encode("Invalid campsite ID", "UTF-8"));
                    }
                    break;
                    
                case "delete":
                    // Delete campsite
                    String deleteIdStr = request.getParameter("campsiteId");
                    if (deleteIdStr != null && !deleteIdStr.trim().isEmpty()) {
                        int campsiteId = Integer.parseInt(deleteIdStr);
                        boolean deleted = campsiteDAO.delete(campsiteId);
                        String message = deleted ? "Campsite deleted successfully" : 
                                                  "Failed to delete campsite";
                        response.sendRedirect("ManageCampsiteServlet?message=" + 
                                            java.net.URLEncoder.encode(message, "UTF-8"));
                    } else {
                        response.sendRedirect("ManageCampsiteServlet?error=" + 
                                            java.net.URLEncoder.encode("Invalid campsite ID", "UTF-8"));
                    }
                    break;
                    
                case "toggle":
                    // Toggle campsite active status
                    String toggleIdStr = request.getParameter("campsiteId");
                    if (toggleIdStr != null && !toggleIdStr.trim().isEmpty()) {
                        int campsiteId = Integer.parseInt(toggleIdStr);
                        boolean toggled = campsiteDAO.toggleActive(campsiteId);
                        String message = toggled ? "Campsite status updated successfully" : 
                                                  "Failed to update campsite status";
                        response.sendRedirect("ManageCampsiteServlet?message=" + 
                                            java.net.URLEncoder.encode(message, "UTF-8"));
                    } else {
                        response.sendRedirect("ManageCampsiteServlet?error=" + 
                                            java.net.URLEncoder.encode("Invalid campsite ID", "UTF-8"));
                    }
                    break;
                    
                case "list":
                default:
                    // Get all campsites and forward to list page
                    List<Campsite> campsites = campsiteDAO.getAll();
                    request.setAttribute("campsites", campsites);
                    request.getRequestDispatcher("/admin/manageCampsite.jsp").forward(request, response);
                    break;
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("ManageCampsiteServlet?error=" + 
                                java.net.URLEncoder.encode("Invalid campsite ID format", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/admin/manageCampsite.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!SessionUtil.isAdminLoggedIn(request)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            // Get form parameters
            String campsiteIdStr = request.getParameter("campsiteId");
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String image = request.getParameter("image");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty() || 
                location == null || location.trim().isEmpty()) {
                response.sendRedirect("ManageCampsiteServlet?error=" + 
                                    java.net.URLEncoder.encode("Name and location are required", "UTF-8"));
                return;
            }
            
            Campsite campsite = new Campsite();
            campsite.setName(name.trim());
            campsite.setLocation(location.trim());
            campsite.setDescription(description != null ? description.trim() : "");
            campsite.setImage(image != null ? image.trim() : "");
            
            boolean success;
            String message;
            
            // Check if updating existing or adding new
            if (campsiteIdStr != null && !campsiteIdStr.trim().isEmpty()) {
                // Update existing campsite
                int campsiteId = Integer.parseInt(campsiteIdStr);
                campsite.setCampsiteId(campsiteId);
                success = campsiteDAO.update(campsite);
                message = success ? "Campsite updated successfully" : "Failed to update campsite";
            } else {
                // Add new campsite
                success = campsiteDAO.add(campsite);
                message = success ? "Campsite added successfully" : "Failed to add campsite";
            }
            
            // Redirect to list with message
            response.sendRedirect("ManageCampsiteServlet?message=" + 
                                java.net.URLEncoder.encode(message, "UTF-8"));
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("ManageCampsiteServlet?error=" + 
                                java.net.URLEncoder.encode("Invalid campsite ID format", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageCampsiteServlet?error=" + 
                                java.net.URLEncoder.encode("Error processing request: " + e.getMessage(), "UTF-8"));
        }
    }
}
