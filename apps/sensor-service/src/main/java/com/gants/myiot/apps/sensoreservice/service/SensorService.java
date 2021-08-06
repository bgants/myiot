package com.gants.myiot.apps.sensoreservice.service;

import com.gants.myiot.apps.sensoreservice.messaging.SensorMessage;
import com.gants.myiot.apps.sensoreservice.messaging.SensorMessagingService;
import com.gants.myiot.apps.sensoreservice.model.Sensor;
import com.gants.myiot.apps.sensoreservice.model.SensorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SensorService {

    @Autowired
    SensorRepository sensorRepository;

    @Autowired
    SensorMessagingService sensorMessagingService;

    @Transactional
    //https://dzone.com/articles/transaction-synchronization-and-spring-application
    public Sensor saveSensor(Sensor sensor) {

        Sensor newSensor = sensorRepository.save(sensor);
        SensorMessage message = new SensorMessage();
        message.setMessage("Sensor " + sensor.getName() + " created");

        sensorMessagingService.sendSensorMessage(message);

        return newSensor;
    }

    public Iterable<Sensor> getSensors()  {
        return sensorRepository.findAll();
    }
}
