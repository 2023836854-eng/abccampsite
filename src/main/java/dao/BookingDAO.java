package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Booking;
import utils.DBConnection;

public class BookingDAO {
    
    public boolean create(Booking booking) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO booking(booking_id, guest_id, campsite_id, room_id, booking_date, checkout_date, " +
                 "num_tents, total_price, status, payment_status) VALUES(?,?,?,?,?,?,?,?,?,?)")) {
            ps.setString(1, booking.getBookingId());
            ps.setInt(2, booking.getGuestId());
            ps.setInt(3, booking.getCampsiteId());
            ps.setInt(4, booking.getRoomId());
            ps.setDate(5, booking.getBookingDate());
            ps.setDate(6, booking.getCheckoutDate());
            ps.setInt(7, booking.getNumTents());
            ps.setBigDecimal(8, booking.getTotalPrice());
            ps.setString(9, booking.getStatus());
            ps.setString(10, booking.getPaymentStatus());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Booking getById(String bookingId) {
        Booking booking = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT b.*, g.name as guest_name, g.ic as guest_ic, g.phone as guest_phone, g.email as guest_email, " +
                 "c.name as campsite_name, r.name as room_name " +
                 "FROM booking b " +
                 "JOIN guest g ON b.guest_id = g.guest_id " +
                 "JOIN campsite c ON b.campsite_id = c.campsite_id " +
                 "JOIN available_room r ON b.room_id = r.room_id " +
                 "WHERE b.booking_id = ?")) {
            ps.setString(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new Booking();
                    booking.setBookingId(rs.getString("booking_id"));
                    booking.setGuestId(rs.getInt("guest_id"));
                    booking.setCampsiteId(rs.getInt("campsite_id"));
                    booking.setRoomId(rs.getInt("room_id"));
                    booking.setBookingDate(rs.getDate("booking_date"));
                    booking.setCheckoutDate(rs.getDate("checkout_date"));
                    booking.setNumTents(rs.getInt("num_tents"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setCancellationReason(rs.getString("cancellation_reason"));
                    booking.setCancelledAt(rs.getTimestamp("cancelled_at"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setUpdatedAt(rs.getTimestamp("updated_at"));
                    booking.setGuestName(rs.getString("guest_name"));
                    booking.setGuestIc(rs.getString("guest_ic"));
                    booking.setGuestPhone(rs.getString("guest_phone"));
                    booking.setGuestEmail(rs.getString("guest_email"));
                    booking.setCampsiteName(rs.getString("campsite_name"));
                    booking.setRoomName(rs.getString("room_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return booking;
    }
    
    public List<Booking> getByGuestId(int guestId) {
        List<Booking> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT b.*, g.name as guest_name, g.ic as guest_ic, g.phone as guest_phone, g.email as guest_email, " +
                 "c.name as campsite_name, r.name as room_name " +
                 "FROM booking b " +
                 "JOIN guest g ON b.guest_id = g.guest_id " +
                 "JOIN campsite c ON b.campsite_id = c.campsite_id " +
                 "JOIN available_room r ON b.room_id = r.room_id " +
                 "WHERE b.guest_id = ? ORDER BY b.created_at DESC")) {
            ps.setInt(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getString("booking_id"));
                    booking.setGuestId(rs.getInt("guest_id"));
                    booking.setCampsiteId(rs.getInt("campsite_id"));
                    booking.setRoomId(rs.getInt("room_id"));
                    booking.setBookingDate(rs.getDate("booking_date"));
                    booking.setCheckoutDate(rs.getDate("checkout_date"));
                    booking.setNumTents(rs.getInt("num_tents"));
                    booking.setTotalPrice(rs.getBigDecimal("total_price"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setCancellationReason(rs.getString("cancellation_reason"));
                    booking.setCancelledAt(rs.getTimestamp("cancelled_at"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setUpdatedAt(rs.getTimestamp("updated_at"));
                    booking.setGuestName(rs.getString("guest_name"));
                    booking.setGuestIc(rs.getString("guest_ic"));
                    booking.setGuestPhone(rs.getString("guest_phone"));
                    booking.setGuestEmail(rs.getString("guest_email"));
                    booking.setCampsiteName(rs.getString("campsite_name"));
                    booking.setRoomName(rs.getString("room_name"));
                    list.add(booking);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Booking> getAll() {
        List<Booking> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(
                 "SELECT b.*, g.name as guest_name, g.ic as guest_ic, g.phone as guest_phone, g.email as guest_email, " +
                 "c.name as campsite_name, r.name as room_name " +
                 "FROM booking b " +
                 "JOIN guest g ON b.guest_id = g.guest_id " +
                 "JOIN campsite c ON b.campsite_id = c.campsite_id " +
                 "JOIN available_room r ON b.room_id = r.room_id " +
                 "ORDER BY b.created_at DESC")) {
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getString("booking_id"));
                booking.setGuestId(rs.getInt("guest_id"));
                booking.setCampsiteId(rs.getInt("campsite_id"));
                booking.setRoomId(rs.getInt("room_id"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setCheckoutDate(rs.getDate("checkout_date"));
                booking.setNumTents(rs.getInt("num_tents"));
                booking.setTotalPrice(rs.getBigDecimal("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setPaymentStatus(rs.getString("payment_status"));
                booking.setCancellationReason(rs.getString("cancellation_reason"));
                booking.setCancelledAt(rs.getTimestamp("cancelled_at"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setUpdatedAt(rs.getTimestamp("updated_at"));
                booking.setGuestName(rs.getString("guest_name"));
                booking.setGuestIc(rs.getString("guest_ic"));
                booking.setGuestPhone(rs.getString("guest_phone"));
                booking.setGuestEmail(rs.getString("guest_email"));
                booking.setCampsiteName(rs.getString("campsite_name"));
                booking.setRoomName(rs.getString("room_name"));
                list.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean updateStatus(String bookingId, String status) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE booking SET status=? WHERE booking_id=?")) {
            ps.setString(1, status);
            ps.setString(2, bookingId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePaymentStatus(String bookingId, String paymentStatus) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE booking SET payment_status=? WHERE booking_id=?")) {
            ps.setString(1, paymentStatus);
            ps.setString(2, bookingId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean cancel(String bookingId, String reason) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE booking SET status='Cancelled', cancellation_reason=?, cancelled_at=NOW() WHERE booking_id=?")) {
            ps.setString(1, reason);
            ps.setString(2, bookingId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Booking> getUpcoming() {
        List<Booking> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(
                 "SELECT b.*, g.name as guest_name, g.ic as guest_ic, g.phone as guest_phone, g.email as guest_email, " +
                 "c.name as campsite_name, r.name as room_name " +
                 "FROM booking b " +
                 "JOIN guest g ON b.guest_id = g.guest_id " +
                 "JOIN campsite c ON b.campsite_id = c.campsite_id " +
                 "JOIN available_room r ON b.room_id = r.room_id " +
                 "WHERE b.booking_date >= CURDATE() AND b.status IN ('Pending', 'Confirmed') " +
                 "ORDER BY b.booking_date ASC LIMIT 10")) {
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setBookingId(rs.getString("booking_id"));
                booking.setGuestId(rs.getInt("guest_id"));
                booking.setCampsiteId(rs.getInt("campsite_id"));
                booking.setRoomId(rs.getInt("room_id"));
                booking.setBookingDate(rs.getDate("booking_date"));
                booking.setCheckoutDate(rs.getDate("checkout_date"));
                booking.setNumTents(rs.getInt("num_tents"));
                booking.setTotalPrice(rs.getBigDecimal("total_price"));
                booking.setStatus(rs.getString("status"));
                booking.setPaymentStatus(rs.getString("payment_status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                booking.setGuestName(rs.getString("guest_name"));
                booking.setGuestIc(rs.getString("guest_ic"));
                booking.setGuestPhone(rs.getString("guest_phone"));
                booking.setGuestEmail(rs.getString("guest_email"));
                booking.setCampsiteName(rs.getString("campsite_name"));
                booking.setRoomName(rs.getString("room_name"));
                list.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            ResultSet rs = st.executeQuery("SELECT COUNT(*) as total FROM booking");
            if (rs.next()) {
                stats.put("totalBookings", rs.getInt("total"));
            }
            rs.close();
            
            rs = st.executeQuery("SELECT COUNT(*) as total FROM booking WHERE status = 'Pending'");
            if (rs.next()) {
                stats.put("pendingBookings", rs.getInt("total"));
            }
            rs.close();
            
            rs = st.executeQuery("SELECT COUNT(*) as total FROM booking WHERE status = 'Confirmed'");
            if (rs.next()) {
                stats.put("confirmedBookings", rs.getInt("total"));
            }
            rs.close();
            
            rs = st.executeQuery("SELECT SUM(total_price) as total FROM booking WHERE payment_status = 'Paid'");
            if (rs.next()) {
                stats.put("totalRevenue", rs.getBigDecimal("total"));
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}
