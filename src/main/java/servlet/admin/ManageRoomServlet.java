package servlet.admin;

import dao.RoomDAO;
import dao.CampsiteDAO;
import model.AvailableRoom;
import model.Campsite;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Manage Room Servlet
 * Handles CRUD operations for available rooms
 */
@WebServlet("/admin/ManageRoomServlet")
public class ManageRoomServlet extends HttpServlet {
    
    private RoomDAO roomDAO;
    private CampsiteDAO campsiteDAO;
    
    @Override
    public void init() throws ServletException {
        roomDAO = new RoomDAO();
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
            String campsiteIdStr = request.getParameter("campsiteId");
            
            if (action == null) {
                action = "list";
            }
            
            switch (action) {
                case "add":
                    // Get campsite details and forward to add room page
                    if (campsiteIdStr != null && !campsiteIdStr.trim().isEmpty()) {
                        int campsiteId = Integer.parseInt(campsiteIdStr);
                        Campsite campsite = campsiteDAO.getById(campsiteId);
                        if (campsite != null) {
                            request.setAttribute("campsite", campsite);
                            request.getRequestDispatcher("/admin/addRoom.jsp").forward(request, response);
                        } else {
                            response.sendRedirect("ManageRoomServlet?error=" + 
                                                java.net.URLEncoder.encode("Campsite not found", "UTF-8"));
                        }
                    } else {
                        response.sendRedirect("ManageRoomServlet?error=" + 
                                            java.net.URLEncoder.encode("Campsite ID is required", "UTF-8"));
                    }
                    break;
                    
                case "edit":
                    // Get room by ID and forward to edit page
                    String roomIdStr = request.getParameter("roomId");
                    if (roomIdStr != null && !roomIdStr.trim().isEmpty()) {
                        int roomId = Integer.parseInt(roomIdStr);
                        AvailableRoom room = roomDAO.getById(roomId);
                        if (room != null) {
                            request.setAttribute("room", room);
                            Campsite campsite = campsiteDAO.getById(room.getCampsiteId());
                            request.setAttribute("campsite", campsite);
                            request.getRequestDispatcher("/admin/editRoom.jsp").forward(request, response);
                        } else {
                            response.sendRedirect("ManageRoomServlet?error=" + 
                                                java.net.URLEncoder.encode("Room not found", "UTF-8"));
                        }
                    } else {
                        response.sendRedirect("ManageRoomServlet?error=" + 
                                            java.net.URLEncoder.encode("Invalid room ID", "UTF-8"));
                    }
                    break;
                    
                case "delete":
                    // Delete room
                    String deleteRoomIdStr = request.getParameter("id");
                    if (deleteRoomIdStr == null || deleteRoomIdStr.trim().isEmpty()) {
                        deleteRoomIdStr = request.getParameter("roomId");
                    }
                    String deleteCampsiteIdStr = request.getParameter("campsiteId");
                    if (deleteRoomIdStr != null && !deleteRoomIdStr.trim().isEmpty()) {
                        int roomId = Integer.parseInt(deleteRoomIdStr);
                        boolean deleted = roomDAO.delete(roomId);
                        String message = deleted ? "Room deleted successfully" : 
                                                  "Failed to delete room";
                        String redirectUrl = "ManageRoomServlet?success=" + 
                                           java.net.URLEncoder.encode(message, "UTF-8");
                        if (deleteCampsiteIdStr != null && !deleteCampsiteIdStr.trim().isEmpty()) {
                            redirectUrl += "&campsiteId=" + deleteCampsiteIdStr;
                        }
                        response.sendRedirect(redirectUrl);
                    } else {
                        response.sendRedirect("ManageRoomServlet?error=" + 
                                            java.net.URLEncoder.encode("Invalid room ID", "UTF-8"));
                    }
                    break;
                    
                case "toggle":
                    // Toggle room active status
                    String toggleRoomIdStr = request.getParameter("roomId");
                    String toggleCampsiteIdStr = request.getParameter("campsiteId");
                    if (toggleRoomIdStr != null && !toggleRoomIdStr.trim().isEmpty()) {
                        int roomId = Integer.parseInt(toggleRoomIdStr);
                        boolean toggled = roomDAO.toggleActive(roomId);
                        String message = toggled ? "Room status updated successfully" : 
                                                  "Failed to update room status";
                        String redirectUrl = "ManageRoomServlet?success=" + 
                                           java.net.URLEncoder.encode(message, "UTF-8");
                        if (toggleCampsiteIdStr != null && !toggleCampsiteIdStr.trim().isEmpty()) {
                            redirectUrl += "&campsiteId=" + toggleCampsiteIdStr;
                        }
                        response.sendRedirect(redirectUrl);
                    } else {
                        response.sendRedirect("ManageRoomServlet?error=" + 
                                            java.net.URLEncoder.encode("Invalid room ID", "UTF-8"));
                    }
                    break;
                    
                case "list":
                default:
                    // Get all rooms by campsite
                    if (campsiteIdStr != null && !campsiteIdStr.trim().isEmpty()) {
                        int campsiteId = Integer.parseInt(campsiteIdStr);
                        List<AvailableRoom> rooms = roomDAO.getAllByCampsite(campsiteId);
                        Campsite campsite = campsiteDAO.getById(campsiteId);
                        request.setAttribute("rooms", rooms);
                        request.setAttribute("campsite", campsite);
                        request.setAttribute("campsiteId", campsiteId);
                    } else {
                        // Get all rooms from all campsites
                        List<AvailableRoom> rooms = roomDAO.getAll();
                        request.setAttribute("rooms", rooms);
                    }
                    // Also load all campsites for the filter dropdown
                    List<Campsite> campsites = campsiteDAO.getAll();
                    request.setAttribute("campsites", campsites);
                    request.getRequestDispatcher("/admin/manageRoom.jsp").forward(request, response);
                    break;
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("ManageRoomServlet?error=" + 
                                java.net.URLEncoder.encode("Invalid ID format", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/admin/manageRoom.jsp").forward(request, response);
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
            String roomIdStr = request.getParameter("roomId");
            String campsiteIdStr = request.getParameter("campsiteId");
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String image = request.getParameter("image");
            String pricePerTentStr = request.getParameter("pricePerTent");
            String quotaStr = request.getParameter("quota");
            
            // Validate required fields
            if (campsiteIdStr == null || campsiteIdStr.trim().isEmpty() ||
                name == null || name.trim().isEmpty() ||
                pricePerTentStr == null || pricePerTentStr.trim().isEmpty() ||
                quotaStr == null || quotaStr.trim().isEmpty()) {
                response.sendRedirect("ManageRoomServlet?error=" + 
                                    java.net.URLEncoder.encode("All required fields must be filled", "UTF-8") +
                                    "&campsiteId=" + (campsiteIdStr != null ? campsiteIdStr : ""));
                return;
            }
            
            // Parse numeric values
            int campsiteId = Integer.parseInt(campsiteIdStr);
            BigDecimal pricePerTent = new BigDecimal(pricePerTentStr);
            int quota = Integer.parseInt(quotaStr);
            
            // Validate numeric values
            if (pricePerTent.compareTo(BigDecimal.ZERO) <= 0 || quota <= 0) {
                response.sendRedirect("ManageRoomServlet?error=" + 
                                    java.net.URLEncoder.encode("Price and quota must be positive", "UTF-8") +
                                    "&campsiteId=" + campsiteId);
                return;
            }
            
            // Create or update AvailableRoom object
            AvailableRoom room = new AvailableRoom();
            room.setCampsiteId(campsiteId);
            room.setName(name.trim());
            room.setLocation(location != null ? location.trim() : "");
            room.setDescription(description != null ? description.trim() : "");
            room.setImage(image != null ? image.trim() : "");
            room.setPricePerTent(pricePerTent);
            room.setQuota(quota);
            
            boolean success;
            String message;
            
            // Check if updating existing or adding new
            if (roomIdStr != null && !roomIdStr.trim().isEmpty()) {
                // Update existing room
                int roomId = Integer.parseInt(roomIdStr);
                room.setRoomId(roomId);
                // Preserve existing availableQuota when updating
                AvailableRoom existingRoom = roomDAO.getById(roomId);
                if (existingRoom != null) {
                    room.setAvailableQuota(existingRoom.getAvailableQuota());
                }
                success = roomDAO.update(room);
                message = success ? "Room updated successfully" : "Failed to update room";
            } else {
                // Add new room - set availableQuota = quota
                room.setAvailableQuota(quota);
                success = roomDAO.add(room);
                message = success ? "Room added successfully" : "Failed to add room";
            }
            
            // Redirect to room list with message
            response.sendRedirect("ManageRoomServlet?success=" + 
                                java.net.URLEncoder.encode(message, "UTF-8") +
                                "&campsiteId=" + campsiteId);
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            String campsiteIdStr = request.getParameter("campsiteId");
            response.sendRedirect("ManageRoomServlet?error=" + 
                                java.net.URLEncoder.encode("Invalid number format", "UTF-8") +
                                "&campsiteId=" + (campsiteIdStr != null ? campsiteIdStr : ""));
        } catch (Exception e) {
            e.printStackTrace();
            String campsiteIdStr = request.getParameter("campsiteId");
            response.sendRedirect("ManageRoomServlet?error=" + 
                                java.net.URLEncoder.encode("Error processing request: " + e.getMessage(), "UTF-8") +
                                "&campsiteId=" + (campsiteIdStr != null ? campsiteIdStr : ""));
        }
    }
}
