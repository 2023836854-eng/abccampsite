package utils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Utility class for session management
 */
public class SessionUtil {
    
    // Session attribute keys
    public static final String GUEST_ID = "guestId";
    public static final String GUEST_NAME = "guestName";
    public static final String GUEST_EMAIL = "guestEmail";
    public static final String GUEST_IC = "guestIc";
    public static final String GUEST_PHONE = "guestPhone";
    public static final String GUEST_ADDRESS = "guestAddress";
    
    public static final String ADMIN_ID = "adminId";
    public static final String ADMIN_USERNAME = "adminUsername";
    public static final String ADMIN_NAME = "adminName";
    public static final String ADMIN_ROLE = "adminRole";
    
    public static final String USER_TYPE = "userType"; // "guest" or "admin"
    
    /**
     * Check if user is logged in
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        String userType = (String) session.getAttribute(USER_TYPE);
        return userType != null;
    }
    
    /**
     * Check if guest is logged in
     */
    public static boolean isGuestLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        String userType = (String) session.getAttribute(USER_TYPE);
        return "guest".equals(userType) && session.getAttribute(GUEST_ID) != null;
    }
    
    /**
     * Check if admin is logged in
     */
    public static boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        String userType = (String) session.getAttribute(USER_TYPE);
        return "admin".equals(userType) && session.getAttribute(ADMIN_ID) != null;
    }
    
    /**
     * Get guest ID from session
     */
    public static Integer getGuestId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        return (Integer) session.getAttribute(GUEST_ID);
    }
    
    /**
     * Get admin ID from session
     */
    public static Integer getAdminId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        return (Integer) session.getAttribute(ADMIN_ID);
    }
    
    /**
     * Set guest session
     */
    public static void setGuestSession(HttpSession session, int guestId, String name, 
                                       String email, String ic, String phone, String address) {
        session.setAttribute(USER_TYPE, "guest");
        session.setAttribute(GUEST_ID, guestId);
        session.setAttribute(GUEST_NAME, name);
        session.setAttribute(GUEST_EMAIL, email);
        session.setAttribute(GUEST_IC, ic);
        session.setAttribute(GUEST_PHONE, phone);
        session.setAttribute(GUEST_ADDRESS, address);
        
        // Set session timeout to 30 minutes
        session.setMaxInactiveInterval(30 * 60);
    }
    
    /**
     * Set admin session
     */
    public static void setAdminSession(HttpSession session, int adminId, String username, 
                                       String fullName, String role) {
        session.setAttribute(USER_TYPE, "admin");
        session.setAttribute(ADMIN_ID, adminId);
        session.setAttribute(ADMIN_USERNAME, username);
        session.setAttribute(ADMIN_NAME, fullName);
        session.setAttribute(ADMIN_ROLE, role);
        
        // Set session timeout to 30 minutes
        session.setMaxInactiveInterval(30 * 60);
    }
    
    /**
     * Clear session
     */
    public static void clearSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
    
    /**
     * Get redirect URL after login
     */
    public static String getRedirectUrl(HttpServletRequest request, String defaultUrl) {
        String redirect = request.getParameter("redirect");
        if (redirect != null && !redirect.isEmpty()) {
            return redirect;
        }
        return defaultUrl;
    }
}
