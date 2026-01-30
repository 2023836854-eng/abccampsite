package dao;

import java.sql.*;
import model.PasswordReset;
import utils.DBConnection;

public class PasswordResetDAO {
    
    public boolean createToken(int guestId, String email, String token, Timestamp expiresAt) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "INSERT INTO password_reset(guest_id, email, reset_token, expires_at, used) VALUES(?,?,?,?,0)")) {
            ps.setInt(1, guestId);
            ps.setString(2, email);
            ps.setString(3, token);
            ps.setTimestamp(4, expiresAt);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public PasswordReset getByToken(String token) {
        PasswordReset reset = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM password_reset WHERE reset_token = ?")) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    reset = new PasswordReset();
                    reset.setResetId(rs.getInt("reset_id"));
                    reset.setGuestId(rs.getInt("guest_id"));
                    reset.setResetToken(rs.getString("reset_token"));
                    reset.setEmail(rs.getString("email"));
                    reset.setExpiresAt(rs.getTimestamp("expires_at"));
                    reset.setUsed(rs.getBoolean("used"));
                    reset.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reset;
    }
    
    public boolean validateToken(String token) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM password_reset WHERE reset_token = ? AND used = 0 AND expires_at > NOW()")) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean markAsUsed(String token) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE password_reset SET used = 1 WHERE reset_token = ?")) {
            ps.setString(1, token);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteExpired() {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "DELETE FROM password_reset WHERE expires_at < NOW()")) {
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
