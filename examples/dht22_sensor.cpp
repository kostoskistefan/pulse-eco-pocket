#include <Arduino.h>
#include "pep.h"
#include "sensors/dht22_sensor.h"

#define DHT22_PIN 11

#define REPORT_INTERVAL 5000 // Report sensor data every 5 seconds

static sensor_t *sensor;

void setup()
{
    // Pulse-Eco Pocket has to be initialized before creating sensors
    pep_initialize(REPORT_INTERVAL);

    // Create a sensor of type DHT22
    sensor = dht22_sensor_create(DHT22_PIN);
}

void loop()
{
    // Run Pulse-Eco Pocket
    pep_run(sensor);
}
