package model;

import java.sql.Timestamp;

public class PasswordReset {
    private int resetId;
    private int guestId;
    private String resetToken;
    private String email;
    private Timestamp expiresAt;
    private boolean used;
    private Timestamp createdAt;

    // Constructors
    public PasswordReset() {}

    public PasswordReset(int guestId, String resetToken, String email, Timestamp expiresAt) {
        this.guestId = guestId;
        this.resetToken = resetToken;
        this.email = email;
        this.expiresAt = expiresAt;
    }

    // Getters and Setters
    public int getResetId() {
        return resetId;
    }

    public void setResetId(int resetId) {
        this.resetId = resetId;
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isUsed() {
        return used;
    }

    public void setUsed(boolean used) {
        this.used = used;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
