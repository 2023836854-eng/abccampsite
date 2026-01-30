package model;

import java.sql.Timestamp;

public class Campsite {
    private int campsiteId;
    private String name;
    private String location;
    private String description;
    private String image;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Campsite() {}

    public Campsite(int campsiteId, String name, String location) {
        this.campsiteId = campsiteId;
        this.name = name;
        this.location = location;
    }

    // Getters and Setters
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
}
