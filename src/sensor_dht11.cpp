#include "sensor_dht11.h"
#include "sensor.h"
#include "sensor_id_table.h"
#include <Arduino.h>

void dht11_initialize(const sensor_t *const sensor)
{
    const dht11_descriptor_t *const dht11_descriptor = (dht11_descriptor_t *) sensor_get_descriptor(sensor);

    pinMode(dht11_descriptor->pin, INPUT);

    // DHT11 needs 1-2 seconds to get ready when first powering up
    delay(dht11_descriptor->initialization_delay);

    // Indicate to the host that the sensor with ID is ready
    Serial.println(SENSOR_ID_DHT11);
}

void dht11_read_and_report(sensor_t *const sensor)
{
    const dht11_descriptor_t *const dht11_descriptor = (dht11_descriptor_t *) sensor_get_descriptor(sensor);

    const uint8_t pin = dht11_descriptor->pin;

}
