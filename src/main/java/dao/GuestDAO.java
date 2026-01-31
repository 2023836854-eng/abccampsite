package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Guest;
import utils.DBConnection;

public class GuestDAO {
    
    public boolean register(Guest guest) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO guests(name, ic, password, phone, email, address, dob) VALUES(?,?,?,?,?,?,?)")) {
            ps.setString(1, guest.getName());
            ps.setString(2, guest.getIc());
            ps.setString(3, guest.getPassword());
            ps.setString(4, guest.getPhone());
            ps.setString(5, guest.getEmail());
            ps.setString(6, guest.getAddress());
            ps.setDate(7, guest.getDob() != null ? new java.sql.Date(guest.getDob().getTime()) : null);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Guest login(String ic, String password) {
        Guest guest = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM guests WHERE ic = ? AND password = ?")) {
            ps.setString(1, ic);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setName(rs.getString("name"));
                    guest.setIc(rs.getString("ic"));
                    guest.setPassword(rs.getString("password"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setEmail(rs.getString("email"));
                    guest.setAddress(rs.getString("address"));
                    guest.setDob(rs.getDate("dob"));
                    guest.setCreatedAt(rs.getTimestamp("created_at"));
                    guest.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return guest;
    }
    
    public Guest getById(int guestId) {
        Guest guest = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM guests WHERE guest_id = ?")) {
            ps.setInt(1, guestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setName(rs.getString("name"));
                    guest.setIc(rs.getString("ic"));
                    guest.setPassword(rs.getString("password"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setEmail(rs.getString("email"));
                    guest.setAddress(rs.getString("address"));
                    guest.setDob(rs.getDate("dob"));
                    guest.setCreatedAt(rs.getTimestamp("created_at"));
                    guest.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return guest;
    }
    
    public Guest getByEmail(String email) {
        Guest guest = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM guests WHERE email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setName(rs.getString("name"));
                    guest.setIc(rs.getString("ic"));
                    guest.setPassword(rs.getString("password"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setEmail(rs.getString("email"));
                    guest.setAddress(rs.getString("address"));
                    guest.setDob(rs.getDate("dob"));
                    guest.setCreatedAt(rs.getTimestamp("created_at"));
                    guest.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return guest;
    }
    
    public Guest getByIc(String ic) {
        Guest guest = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM guests WHERE ic = ?")) {
            ps.setString(1, ic);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setName(rs.getString("name"));
                    guest.setIc(rs.getString("ic"));
                    guest.setPassword(rs.getString("password"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setEmail(rs.getString("email"));
                    guest.setAddress(rs.getString("address"));
                    guest.setDob(rs.getDate("dob"));
                    guest.setCreatedAt(rs.getTimestamp("created_at"));
                    guest.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return guest;
    }
    
    public Guest getByIcAndEmail(String ic, String email) {
        Guest guest = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM guests WHERE ic = ? AND email = ?")) {
            ps.setString(1, ic);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setName(rs.getString("name"));
                    guest.setIc(rs.getString("ic"));
                    guest.setPassword(rs.getString("password"));
                    guest.setPhone(rs.getString("phone"));
                    guest.setEmail(rs.getString("email"));
                    guest.setAddress(rs.getString("address"));
                    guest.setDob(rs.getDate("dob"));
                    guest.setCreatedAt(rs.getTimestamp("created_at"));
                    guest.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return guest;
    }
    
    public boolean updateProfile(Guest guest) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE guests SET name=?, phone=?, email=?, address=?, dob=? WHERE guest_id=?")) {
            ps.setString(1, guest.getName());
            ps.setString(2, guest.getPhone());
            ps.setString(3, guest.getEmail());
            ps.setString(4, guest.getAddress());
            ps.setDate(5, guest.getDob() != null ? new java.sql.Date(guest.getDob().getTime()) : null);
            ps.setInt(6, guest.getGuestId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePassword(int guestId, String newPassword) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE guests SET password=? WHERE guest_id=?")) {
            ps.setString(1, newPassword);
            ps.setInt(2, guestId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getCount() {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) as total FROM guests")) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
