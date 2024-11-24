#include "sensor_mq2.h"
#include "sensor.h"
#include "sensor_id_table.h"
#include <Arduino.h>

void mq2_initialize(const sensor_t *const sensor)
{
    const mq2_descriptor_t *const mq2_descriptor = (mq2_descriptor_t *) sensor_get_descriptor(sensor);

    pinMode(mq2_descriptor->pin, INPUT);

    // Indicate to the host that the sensor with ID is ready
    Serial.println(SENSOR_ID_MQ2);
}

void mq2_read_and_report(sensor_t *const sensor)
{
    const mq2_descriptor_t *const mq2_descriptor = (mq2_descriptor_t *) sensor_get_descriptor(sensor);

    const uint16_t value = analogRead(mq2_descriptor->pin);

    Serial.println(value);
}
