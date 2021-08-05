package com.gants.myiot.apps.sensoreservice.controller;

import com.gants.myiot.apps.sensoreservice.model.Sensor;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@CrossOrigin(origins = "http://localhost:8080")
@RestController
@RequestMapping("/api")
public class SensorServiceController {


    private List<Sensor> sensorList = new ArrayList<>();

    @GetMapping("/sensor")
    public List<Sensor> getSensors() {
        return sensorList;
    }

    @PostMapping("/sensor/add")
    public void addSensor(@RequestBody Sensor body) {
        System.out.println(body);
        sensorList.add(body);
    }
}
