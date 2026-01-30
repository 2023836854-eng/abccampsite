package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Payment;
import utils.DBConnection;

public class PaymentDAO {
    
    public boolean create(Payment payment) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO payments(booking_id, payment_method, payment_date, amount, transaction_id, status, receipt_path) " +
                 "VALUES(?,?,?,?,?,?,?)")) {
            ps.setString(1, payment.getBookingId());
            ps.setString(2, payment.getPaymentMethod());
            ps.setTimestamp(3, payment.getPaymentDate());
            ps.setBigDecimal(4, payment.getAmount());
            ps.setString(5, payment.getTransactionId());
            ps.setString(6, payment.getStatus());
            ps.setString(7, payment.getReceiptPath());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Payment getById(int paymentId) {
        Payment payment = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT p.*, g.name as guest_name, c.name as campsite_name " +
                 "FROM payments p " +
                 "JOIN bookings b ON p.booking_id = b.booking_id " +
                 "JOIN guests g ON b.guest_id = g.guest_id " +
                 "JOIN campsites c ON b.campsite_id = c.campsite_id " +
                 "WHERE p.payment_id = ?")) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    payment = new Payment();
                    payment.setPaymentId(rs.getInt("payment_id"));
                    payment.setBookingId(rs.getString("booking_id"));
                    payment.setPaymentMethod(rs.getString("payment_method"));
                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
                    payment.setAmount(rs.getBigDecimal("amount"));
                    payment.setTransactionId(rs.getString("transaction_id"));
                    payment.setStatus(rs.getString("status"));
                    payment.setReceiptPath(rs.getString("receipt_path"));
                    payment.setCreatedAt(rs.getTimestamp("created_at"));
                    payment.setGuestName(rs.getString("guest_name"));
                    payment.setCampsiteName(rs.getString("campsite_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payment;
    }
    
    public Payment getByBookingId(String bookingId) {
        Payment payment = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT p.*, g.name as guest_name, c.name as campsite_name " +
                 "FROM payments p " +
                 "JOIN bookings b ON p.booking_id = b.booking_id " +
                 "JOIN guests g ON b.guest_id = g.guest_id " +
                 "JOIN campsites c ON b.campsite_id = c.campsite_id " +
                 "WHERE p.booking_id = ?")) {
            ps.setString(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    payment = new Payment();
                    payment.setPaymentId(rs.getInt("payment_id"));
                    payment.setBookingId(rs.getString("booking_id"));
                    payment.setPaymentMethod(rs.getString("payment_method"));
                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
                    payment.setAmount(rs.getBigDecimal("amount"));
                    payment.setTransactionId(rs.getString("transaction_id"));
                    payment.setStatus(rs.getString("status"));
                    payment.setReceiptPath(rs.getString("receipt_path"));
                    payment.setCreatedAt(rs.getTimestamp("created_at"));
                    payment.setGuestName(rs.getString("guest_name"));
                    payment.setCampsiteName(rs.getString("campsite_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payment;
    }
    
    public boolean updateStatus(int paymentId, String status) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE payments SET status=? WHERE payment_id=?")) {
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Payment> getAll() {
        List<Payment> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(
                 "SELECT p.*, g.name as guest_name, c.name as campsite_name " +
                 "FROM payments p " +
                 "JOIN bookings b ON p.booking_id = b.booking_id " +
                 "JOIN guests g ON b.guest_id = g.guest_id " +
                 "JOIN campsites c ON b.campsite_id = c.campsite_id " +
                 "ORDER BY p.created_at DESC")) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("payment_id"));
                payment.setBookingId(rs.getString("booking_id"));
                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setPaymentDate(rs.getTimestamp("payment_date"));
                payment.setAmount(rs.getBigDecimal("amount"));
                payment.setTransactionId(rs.getString("transaction_id"));
                payment.setStatus(rs.getString("status"));
                payment.setReceiptPath(rs.getString("receipt_path"));
                payment.setCreatedAt(rs.getTimestamp("created_at"));
                payment.setGuestName(rs.getString("guest_name"));
                payment.setCampsiteName(rs.getString("campsite_name"));
                list.add(payment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
