package com.gants.myiot.apps.processingservice.messaging;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.handler.annotation.Headers;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

import javax.jms.Session;

@Component

public class SensorProcessing {
  private static Logger log = LoggerFactory.getLogger(SensorProcessing.class);
  @JmsListener(destination = "sensor.topic")
  public void receiveMessage(@Payload String sensor,
                             @Headers MessageHeaders headers,
                             String message,
                             Session session) {
    log.info("Received " + "< " + sensor + " >");
  }
}
