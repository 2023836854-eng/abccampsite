package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.AvailableRoom;
import utils.DBConnection;

public class RoomDAO {
    
    public List<AvailableRoom> getAllByCampsite(int campsiteId) {
        List<AvailableRoom> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT r.*, c.name as campsite_name FROM available_room r " +
                 "JOIN campsite c ON r.campsite_id = c.campsite_id " +
                 "WHERE r.campsite_id = ? ORDER BY r.created_at DESC")) {
            ps.setInt(1, campsiteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AvailableRoom room = new AvailableRoom();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setCampsiteId(rs.getInt("campsite_id"));
                    room.setName(rs.getString("name"));
                    room.setLocation(rs.getString("location"));
                    room.setDescription(rs.getString("description"));
                    room.setImage(rs.getString("image"));
                    room.setPricePerTent(rs.getBigDecimal("price_per_tent"));
                    room.setQuota(rs.getInt("quota"));
                    room.setAvailableQuota(rs.getInt("available_quota"));
                    room.setActive(rs.getBoolean("is_active"));
                    room.setCreatedAt(rs.getTimestamp("created_at"));
                    room.setUpdatedAt(rs.getTimestamp("updated_at"));
                    room.setCampsiteName(rs.getString("campsite_name"));
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<AvailableRoom> getActiveByCampsite(int campsiteId) {
        List<AvailableRoom> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT r.*, c.name as campsite_name FROM available_room r " +
                 "JOIN campsite c ON r.campsite_id = c.campsite_id " +
                 "WHERE r.campsite_id = ? AND r.is_active = 1 ORDER BY r.name")) {
            ps.setInt(1, campsiteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AvailableRoom room = new AvailableRoom();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setCampsiteId(rs.getInt("campsite_id"));
                    room.setName(rs.getString("name"));
                    room.setLocation(rs.getString("location"));
                    room.setDescription(rs.getString("description"));
                    room.setImage(rs.getString("image"));
                    room.setPricePerTent(rs.getBigDecimal("price_per_tent"));
                    room.setQuota(rs.getInt("quota"));
                    room.setAvailableQuota(rs.getInt("available_quota"));
                    room.setActive(rs.getBoolean("is_active"));
                    room.setCreatedAt(rs.getTimestamp("created_at"));
                    room.setUpdatedAt(rs.getTimestamp("updated_at"));
                    room.setCampsiteName(rs.getString("campsite_name"));
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public AvailableRoom getById(int roomId) {
        AvailableRoom room = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT r.*, c.name as campsite_name FROM available_room r " +
                 "JOIN campsite c ON r.campsite_id = c.campsite_id " +
                 "WHERE r.room_id = ?")) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    room = new AvailableRoom();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setCampsiteId(rs.getInt("campsite_id"));
                    room.setName(rs.getString("name"));
                    room.setLocation(rs.getString("location"));
                    room.setDescription(rs.getString("description"));
                    room.setImage(rs.getString("image"));
                    room.setPricePerTent(rs.getBigDecimal("price_per_tent"));
                    room.setQuota(rs.getInt("quota"));
                    room.setAvailableQuota(rs.getInt("available_quota"));
                    room.setActive(rs.getBoolean("is_active"));
                    room.setCreatedAt(rs.getTimestamp("created_at"));
                    room.setUpdatedAt(rs.getTimestamp("updated_at"));
                    room.setCampsiteName(rs.getString("campsite_name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return room;
    }
    
    public boolean add(AvailableRoom room) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO available_room(campsite_id, name, location, description, image, price_per_tent, quota, available_quota, is_active) " +
                 "VALUES(?,?,?,?,?,?,?,?,?)")) {
            ps.setInt(1, room.getCampsiteId());
            ps.setString(2, room.getName());
            ps.setString(3, room.getLocation());
            ps.setString(4, room.getDescription());
            ps.setString(5, room.getImage());
            ps.setBigDecimal(6, room.getPricePerTent());
            ps.setInt(7, room.getQuota());
            ps.setInt(8, room.getAvailableQuota());
            ps.setBoolean(9, room.isActive());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean update(AvailableRoom room) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE available_room SET campsite_id=?, name=?, location=?, description=?, image=?, " +
                 "price_per_tent=?, quota=?, available_quota=?, is_active=? WHERE room_id=?")) {
            ps.setInt(1, room.getCampsiteId());
            ps.setString(2, room.getName());
            ps.setString(3, room.getLocation());
            ps.setString(4, room.getDescription());
            ps.setString(5, room.getImage());
            ps.setBigDecimal(6, room.getPricePerTent());
            ps.setInt(7, room.getQuota());
            ps.setInt(8, room.getAvailableQuota());
            ps.setBoolean(9, room.isActive());
            ps.setInt(10, room.getRoomId());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean delete(int roomId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM available_room WHERE room_id=?")) {
            ps.setInt(1, roomId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateQuota(int roomId, int quantity) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE available_room SET available_quota = available_quota - ? WHERE room_id=?")) {
            ps.setInt(1, quantity);
            ps.setInt(2, roomId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
