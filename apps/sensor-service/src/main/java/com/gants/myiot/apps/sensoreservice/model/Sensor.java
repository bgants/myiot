package com.gants.myiot.apps.sensoreservice.model;

import com.gants.myiot.apps.sensoreservice.enums.SensorStatus;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.Objects;

@Entity
public class Sensor {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;
    private String location;
    private SensorStatus status;

    public Sensor() {
    }

    public Sensor(Long id, String name, String location, SensorStatus status) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.status = status;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public SensorStatus getStatus() {
        return status;
    }

    public void setStatus(SensorStatus status) {
        this.status = status;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Sensor)) return false;
        Sensor sensor = (Sensor) o;
        return Objects.equals(getId(), sensor.getId()) && Objects.equals(getName(),
                sensor.getName()) && Objects.equals(getLocation(),
                sensor.getLocation()) && getStatus() == sensor.getStatus();
    }

    @Override
    public int hashCode() {
        return Objects.hash(getId(), getName(), getLocation(), getStatus());
    }

    @Override
    public String toString() {
        return "Sensor{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                ", status=" + status +
                '}';
    }
}
