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
                 "SELECT r.*, c.name as campsite_name FROM available_rooms r " +
                 "JOIN campsites c ON r.campsite_id = c.campsite_id " +
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
                 "SELECT r.*, c.name as campsite_name FROM available_rooms r " +
                 "JOIN campsites c ON r.campsite_id = c.campsite_id " +
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
                 "SELECT r.*, c.name as campsite_name FROM available_rooms r " +
                 "JOIN campsites c ON r.campsite_id = c.campsite_id " +
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
                 "INSERT INTO available_rooms(campsite_id, name, location, description, image, price_per_tent, quota, available_quota, is_active) " +
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
                 "UPDATE available_rooms SET campsite_id=?, name=?, location=?, description=?, image=?, " +
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
             PreparedStatement ps = con.prepareStatement("DELETE FROM available_rooms WHERE room_id=?")) {
            ps.setInt(1, roomId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Updates the available quota for a room in a thread-safe manner.
     * 
     * This method uses database-level locking (SELECT FOR UPDATE) to prevent race conditions
     * when multiple users are booking or cancelling at the same time.
     * 
     * The method implements a subtract-based approach:
     * - Positive quantity: DECREASES available quota (for bookings)
     *   Example: updateQuota(roomId, 5) decreases quota by 5
     * - Negative quantity: INCREASES available quota (for cancellations)
     *   Example: updateQuota(roomId, -5) increases quota by 5
     * 
     * SQL operation: available_quota = available_quota - quantity
     * 
     * @param roomId The ID of the room to update
     * @param quantity The amount to change the quota by (positive to decrease, negative to increase)
     * @return true if the update was successful, false if room not found or insufficient quota
     */
    public boolean updateQuota(int roomId, int quantity) {
        Connection con = null;
        PreparedStatement selectPs = null;
        PreparedStatement updatePs = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            con.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            String selectSql = "SELECT available_quota FROM available_rooms WHERE room_id = ? FOR UPDATE";
            selectPs = con.prepareStatement(selectSql);
            selectPs.setInt(1, roomId);
            rs = selectPs.executeQuery();

            if (!rs.next()) {
                con.rollback();
                return false;
            }

            int availableQuota = rs.getInt(1);
            // Check if we have enough quota only when decreasing (positive quantity)
            if (quantity > 0 && availableQuota < quantity) {
                con.rollback();
                return false;
            }

            String updateSql = "UPDATE available_rooms SET available_quota = available_quota - ? WHERE room_id = ?";
            updatePs = con.prepareStatement(updateSql);
            updatePs.setInt(1, quantity);
            updatePs.setInt(2, roomId);
            int rowsAffected = updatePs.executeUpdate();

            con.commit();
            return rowsAffected > 0;
        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (selectPs != null) {
                try {
                    selectPs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (updatePs != null) {
                try {
                    updatePs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    public List<AvailableRoom> getAll() {
        List<AvailableRoom> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(
                 "SELECT r.*, c.name as campsite_name FROM available_rooms r " +
                 "JOIN campsites c ON r.campsite_id = c.campsite_id " +
                 "ORDER BY c.name, r.name")) {
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean toggleActive(int roomId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE available_rooms SET is_active = NOT is_active WHERE room_id=?")) {
            ps.setInt(1, roomId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
