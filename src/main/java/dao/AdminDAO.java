package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Admin;
import utils.DBConnection;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class AdminDAO {
    
    public Admin login(String username, String password) {
        Admin admin = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM admins WHERE username = ? AND password = ? AND is_active = 1")) {
            ps.setString(1, username);
            // Hash the password using SHA-256 before comparing
            ps.setString(2, hashPasswordSHA256(password));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPassword(rs.getString("password"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setRole(rs.getString("role"));
                    admin.setActive(rs.getBoolean("is_active"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                    admin.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }
    
    /**
     * Hash password using SHA-256 (for compatibility with existing data)
     * Note: This is for compatibility with sample data that uses simple SHA-256
     */
    private String hashPasswordSHA256(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    public Admin getById(int adminId) {
        Admin admin = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM admins WHERE admin_id = ?")) {
            ps.setInt(1, adminId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setAdminId(rs.getInt("admin_id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setPassword(rs.getString("password"));
                    admin.setFullName(rs.getString("full_name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setRole(rs.getString("role"));
                    admin.setActive(rs.getBoolean("is_active"));
                    admin.setCreatedAt(rs.getTimestamp("created_at"));
                    admin.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }
    
    public List<Admin> getAll() {
        List<Admin> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM admins ORDER BY created_at DESC")) {
            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setFullName(rs.getString("full_name"));
                admin.setEmail(rs.getString("email"));
                admin.setRole(rs.getString("role"));
                admin.setActive(rs.getBoolean("is_active"));
                admin.setCreatedAt(rs.getTimestamp("created_at"));
                admin.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(admin);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean add(Admin admin) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO admins(username, password, full_name, email, role, is_active) VALUES(?,?,?,?,?,?)")) {
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getPassword());
            ps.setString(3, admin.getFullName());
            ps.setString(4, admin.getEmail());
            ps.setString(5, admin.getRole());
            ps.setBoolean(6, admin.isActive());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean update(Admin admin) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE admins SET username=?, full_name=?, email=?, role=?, is_active=? WHERE admin_id=?")) {
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getFullName());
            ps.setString(3, admin.getEmail());
            ps.setString(4, admin.getRole());
            ps.setBoolean(5, admin.isActive());
            ps.setInt(6, admin.getAdminId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(int adminId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM admins WHERE admin_id=?")) {
            ps.setInt(1, adminId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
