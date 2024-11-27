#include <Arduino.h>
#include "pep.h"
#include "sensors/grove_sound_sensor.h"

#define GROVE_SOUND_SENSOR_PIN A3

#define REPORT_INTERVAL 5000 // Report sensor data every 5 seconds

static sensor_t *sensor;

void setup()
{
    // Pulse-Eco Pocket has to be initialized before creating sensors
    pep_initialize(REPORT_INTERVAL);

    // Create a sensor of type Grove Sound Sensor
    sensor = grove_sound_sensor_create(GROVE_SOUND_SENSOR_PIN);
}

void loop()
{
    // Run Pulse-Eco Pocket
    pep_run(sensor);
}
