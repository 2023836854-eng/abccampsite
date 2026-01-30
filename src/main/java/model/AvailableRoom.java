package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class AvailableRoom {
    private int roomId;
    private int campsiteId;
    private String name;
    private String location;
    private String description;
    private String image;
    private BigDecimal pricePerTent;
    private int quota;
    private int availableQuota;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // For display purposes
    private String campsiteName;

    // Constructors
    public AvailableRoom() {}

    public AvailableRoom(int roomId, int campsiteId, String name, BigDecimal pricePerTent) {
        this.roomId = roomId;
        this.campsiteId = campsiteId;
        this.name = name;
        this.pricePerTent = pricePerTent;
    }

    // Getters and Setters
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getCampsiteId() {
        return campsiteId;
    }

    public void setCampsiteId(int campsiteId) {
        this.campsiteId = campsiteId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public BigDecimal getPricePerTent() {
        return pricePerTent;
    }

    public void setPricePerTent(BigDecimal pricePerTent) {
        this.pricePerTent = pricePerTent;
    }

    public int getQuota() {
        return quota;
    }

    public void setQuota(int quota) {
        this.quota = quota;
    }

    public int getAvailableQuota() {
        return availableQuota;
    }

    public void setAvailableQuota(int availableQuota) {
        this.availableQuota = availableQuota;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCampsiteName() {
        return campsiteName;
    }

    public void setCampsiteName(String campsiteName) {
        this.campsiteName = campsiteName;
    }
}
