package servlet.admin;

import dao.BookingDAO;
import dao.GuestDAO;
import dao.CampsiteDAO;
import model.Booking;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import utils.DBConnection;

/**
 * Admin Dashboard Servlet
 * Displays statistics and overview of the campsite system
 */
@WebServlet("/admin/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private GuestDAO guestDAO;
    private CampsiteDAO campsiteDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        guestDAO = new GuestDAO();
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
            // Get database connection
            Connection con = DBConnection.getConnection();
            
            // Get total bookings this month
            int totalBookings = getTotalBookingsThisMonth(con);
            request.setAttribute("totalBookings", totalBookings);
            
            // Get upcoming bookings (check-in date in the future)
            int upcomingBookings = getUpcomingBookings(con);
            request.setAttribute("upcomingBookings", upcomingBookings);
            
            // Get ongoing bookings (currently active)
            int ongoingBookings = getOngoingBookings(con);
            request.setAttribute("ongoingBookings", ongoingBookings);
            
            // Get total revenue this month
            BigDecimal totalRevenue = getTotalRevenueThisMonth(con);
            request.setAttribute("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
            
            // Get total guests count
            int totalGuests = guestDAO.getCount();
            request.setAttribute("totalGuests", totalGuests);
            
            // Get recent bookings
            List<Map<String, Object>> recentBookings = getRecentBookings(con);
            request.setAttribute("recentBookings", recentBookings);
            
            // Get booking trends data (last 12 months)
            String bookingTrendsData = getBookingTrendsData(con);
            request.setAttribute("bookingTrendsData", bookingTrendsData);
            
            // Get revenue by campsite data
            String revenueData = getRevenueData(con);
            request.setAttribute("revenueData", revenueData);
            
            // Get status distribution data
            String statusData = getStatusData(con);
            request.setAttribute("statusData", statusData);
            
            con.close();
            
            // Forward to dashboard page
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    private int getTotalBookingsThisMonth(Connection con) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM bookings " +
                     "WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) " +
                     "AND YEAR(created_at) = YEAR(CURRENT_DATE())";
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    private int getUpcomingBookings(Connection con) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM bookings " +
                     "WHERE booking_date > CURRENT_DATE() " +
                     "AND status NOT IN ('Cancelled', 'Completed')";
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    private int getOngoingBookings(Connection con) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM bookings " +
                     "WHERE booking_date <= CURRENT_DATE() " +
                     "AND checkout_date >= CURRENT_DATE() " +
                     "AND status NOT IN ('Cancelled', 'Completed')";
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    private BigDecimal getTotalRevenueThisMonth(Connection con) throws SQLException {
        String sql = "SELECT SUM(total_price) as total FROM bookings " +
                     "WHERE payment_status = 'Paid' " +
                     "AND MONTH(created_at) = MONTH(CURRENT_DATE()) " +
                     "AND YEAR(created_at) = YEAR(CURRENT_DATE())";
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }
    
    private List<Map<String, Object>> getRecentBookings(Connection con) throws SQLException {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.booking_date, b.checkout_date, b.status, " +
                     "b.payment_status, b.total_price, g.name as guest_name, c.name as campsite_name " +
                     "FROM bookings b " +
                     "JOIN guests g ON b.guest_id = g.guest_id " +
                     "JOIN campsites c ON b.campsite_id = c.campsite_id " +
                     "ORDER BY b.created_at DESC LIMIT 10";
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> booking = new HashMap<>();
                booking.put("bookingId", rs.getString("booking_id"));
                booking.put("guestName", rs.getString("guest_name"));
                booking.put("campsiteName", rs.getString("campsite_name"));
                booking.put("checkinDate", rs.getDate("booking_date"));
                booking.put("checkoutDate", rs.getDate("checkout_date"));
                booking.put("bookingStatus", rs.getString("status"));
                booking.put("paymentStatus", rs.getString("payment_status"));
                booking.put("totalAmount", rs.getBigDecimal("total_price"));
                bookings.add(booking);
            }
        }
        return bookings;
    }
    
    private String getBookingTrendsData(Connection con) throws SQLException {
        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");
        
        LocalDate now = LocalDate.now();
        for (int i = 11; i >= 0; i--) {
            LocalDate month = now.minusMonths(i);
            String monthLabel = month.format(DateTimeFormatter.ofPattern("MMM yyyy"));
            
            String sql = "SELECT COUNT(*) as total FROM bookings " +
                         "WHERE MONTH(created_at) = ? AND YEAR(created_at) = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, month.getMonthValue());
                ps.setInt(2, month.getYear());
                try (ResultSet rs = ps.executeQuery()) {
                    int count = 0;
                    if (rs.next()) {
                        count = rs.getInt("total");
                    }
                    
                    if (i < 11) {
                        labels.append(",");
                        data.append(",");
                    }
                    labels.append("\"").append(monthLabel).append("\"");
                    data.append(count);
                }
            }
        }
        
        labels.append("]");
        data.append("]");
        
        return "{\"labels\":" + labels.toString() + ",\"data\":" + data.toString() + "}";
    }
    
    private String getRevenueData(Connection con) throws SQLException {
        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");
        
        String sql = "SELECT c.name, SUM(b.total_price) as revenue " +
                     "FROM bookings b " +
                     "JOIN campsites c ON b.campsite_id = c.campsite_id " +
                     "WHERE b.payment_status = 'Paid' " +
                     "GROUP BY c.campsite_id, c.name " +
                     "ORDER BY revenue DESC LIMIT 10";
        
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    labels.append(",");
                    data.append(",");
                }
                first = false;
                labels.append("\"").append(rs.getString("name")).append("\"");
                data.append(rs.getBigDecimal("revenue").doubleValue());
            }
        }
        
        labels.append("]");
        data.append("]");
        
        return "{\"labels\":" + labels.toString() + ",\"data\":" + data.toString() + "}";
    }
    
    private String getStatusData(Connection con) throws SQLException {
        StringBuilder labels = new StringBuilder("[");
        StringBuilder data = new StringBuilder("[");
        
        String[] statuses = {"Confirmed", "Pending", "Cancelled", "Completed"};
        boolean first = true;
        
        for (String status : statuses) {
            String sql = "SELECT COUNT(*) as total FROM bookings WHERE status = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, status);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt("total");
                        if (count > 0) {  // Only include statuses with data
                            if (!first) {
                                labels.append(",");
                                data.append(",");
                            }
                            first = false;
                            labels.append("\"").append(status).append("\"");
                            data.append(count);
                        }
                    }
                }
            }
        }
        
        labels.append("]");
        data.append("]");
        
        return "{\"labels\":" + labels.toString() + ",\"data\":" + data.toString() + "}";
    }
}
