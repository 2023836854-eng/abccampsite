package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Admin;
import utils.DBConnection;

public class AdminDAO {
    
    public Admin login(String username, String password) {
        Admin admin = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM admin WHERE username = ? AND password = ? AND is_active = 1")) {
            ps.setString(1, username);
            ps.setString(2, password);
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
    
    public Admin getById(int adminId) {
        Admin admin = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM admin WHERE admin_id = ?")) {
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
             ResultSet rs = st.executeQuery("SELECT * FROM admin ORDER BY created_at DESC")) {
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
                 "INSERT INTO admin(username, password, full_name, email, role, is_active) VALUES(?,?,?,?,?,?)")) {
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
                 "UPDATE admin SET username=?, full_name=?, email=?, role=?, is_active=? WHERE admin_id=?")) {
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
             PreparedStatement ps = con.prepareStatement("DELETE FROM admin WHERE admin_id=?")) {
            ps.setInt(1, adminId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
