#include "sensor_grove_sound.h"
#include "sensor.h"
#include "sensor_id_table.h"
#include <Arduino.h>

void grove_sound_sensor_initialize(const sensor_t *const sensor)
{
    const grove_sound_sensor_descriptor_t *const grove_sound_sensor_descriptor =
        (grove_sound_sensor_descriptor_t *) sensor_get_descriptor(sensor);

    pinMode(grove_sound_sensor_descriptor->pin, INPUT);

    // Indicate to the host that the sensor with ID is ready
    Serial.println(SENSOR_ID_GROVE_SOUND);
}

void grove_sound_sensor_read_and_report(sensor_t *const sensor)
{
    const grove_sound_sensor_descriptor_t *const grove_sound_sensor_descriptor =
        (grove_sound_sensor_descriptor_t *) sensor_get_descriptor(sensor);

    const uint16_t value = analogRead(grove_sound_sensor_descriptor->pin);

    Serial.println(value);
}
