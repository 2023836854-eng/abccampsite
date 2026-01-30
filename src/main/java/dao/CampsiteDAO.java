package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Campsite;
import utils.DBConnection;

public class CampsiteDAO {
    
    public List<Campsite> getAll() {
        List<Campsite> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM campsite ORDER BY created_at DESC")) {
            while (rs.next()) {
                Campsite campsite = new Campsite();
                campsite.setCampsiteId(rs.getInt("campsite_id"));
                campsite.setName(rs.getString("name"));
                campsite.setLocation(rs.getString("location"));
                campsite.setDescription(rs.getString("description"));
                campsite.setImage(rs.getString("image"));
                campsite.setActive(rs.getBoolean("is_active"));
                campsite.setCreatedAt(rs.getTimestamp("created_at"));
                campsite.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(campsite);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Campsite> getActive() {
        List<Campsite> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM campsite WHERE is_active = 1 ORDER BY name")) {
            while (rs.next()) {
                Campsite campsite = new Campsite();
                campsite.setCampsiteId(rs.getInt("campsite_id"));
                campsite.setName(rs.getString("name"));
                campsite.setLocation(rs.getString("location"));
                campsite.setDescription(rs.getString("description"));
                campsite.setImage(rs.getString("image"));
                campsite.setActive(rs.getBoolean("is_active"));
                campsite.setCreatedAt(rs.getTimestamp("created_at"));
                campsite.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(campsite);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Campsite getById(int campsiteId) {
        Campsite campsite = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM campsite WHERE campsite_id = ?")) {
            ps.setInt(1, campsiteId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    campsite = new Campsite();
                    campsite.setCampsiteId(rs.getInt("campsite_id"));
                    campsite.setName(rs.getString("name"));
                    campsite.setLocation(rs.getString("location"));
                    campsite.setDescription(rs.getString("description"));
                    campsite.setImage(rs.getString("image"));
                    campsite.setActive(rs.getBoolean("is_active"));
                    campsite.setCreatedAt(rs.getTimestamp("created_at"));
                    campsite.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return campsite;
    }
    
    public boolean add(Campsite campsite) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO campsite(name, location, description, image, is_active) VALUES(?,?,?,?,?)")) {
            ps.setString(1, campsite.getName());
            ps.setString(2, campsite.getLocation());
            ps.setString(3, campsite.getDescription());
            ps.setString(4, campsite.getImage());
            ps.setBoolean(5, campsite.isActive());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean update(Campsite campsite) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE campsite SET name=?, location=?, description=?, image=?, is_active=? WHERE campsite_id=?")) {
            ps.setString(1, campsite.getName());
            ps.setString(2, campsite.getLocation());
            ps.setString(3, campsite.getDescription());
            ps.setString(4, campsite.getImage());
            ps.setBoolean(5, campsite.isActive());
            ps.setInt(6, campsite.getCampsiteId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(int campsiteId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM campsite WHERE campsite_id=?")) {
            ps.setInt(1, campsiteId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean toggleActive(int campsiteId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE campsite SET is_active = NOT is_active WHERE campsite_id=?")) {
            ps.setInt(1, campsiteId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
