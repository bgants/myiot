package com.gants.myiot.apps.sensoreservice.controller;

import com.gants.myiot.apps.sensoreservice.model.Sensor;
import com.gants.myiot.apps.sensoreservice.service.SensorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "http://localhost:8080")
@RestController
@RequestMapping("/api")
public class SensorServiceController {
    @Autowired
    SensorService sensorService;

    @GetMapping("/sensor")
    public Iterable<Sensor> getSensors() {
        return sensorService.getSensors();
    }

    @PostMapping("/sensor/add")
    public void addSensor(@RequestBody Sensor body) {
        System.out.println(body);
        sensorService.saveSensor(body);
    }
}
