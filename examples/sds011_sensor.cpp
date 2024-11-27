#include <Arduino.h>
#include "pep.h"
#include "sensors/sds011_sensor.h"

#define SDS011_TX_PIN 2
#define SDS011_RX_PIN 3

#define REPORT_INTERVAL 5000 // Report sensor data every 5 seconds

static sensor_t *sensor;

void setup()
{
    // Pulse-Eco Pocket has to be initialized before creating sensors
    pep_initialize(REPORT_INTERVAL);

    // Create a sensor of type SDS011
    sensor = sds011_sensor_create(SDS011_RX_PIN, SDS011_TX_PIN);
}

void loop()
{
    // Run Pulse-Eco Pocket
    pep_run(sensor);
}
