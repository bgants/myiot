package com.gants.myiot.apps.sensoreservice.messaging;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Service;

@Service
public class SensorMessagingService implements MessagingService {
    private JmsTemplate jms;

    @Autowired
    SensorMessagingService(JmsTemplate jms) {
        this.jms = jms;
    }

    @Override
    public void sendSensorMessage(SensorMessage message) {
        jms.convertAndSend("sensor.topic", message);
    }
}
