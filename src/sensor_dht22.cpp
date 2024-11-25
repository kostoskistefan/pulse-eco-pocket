#include "sensor_dht22.h"
#include "sensor.h"
#include "sensor_id_table.h"
#include <Arduino.h>

#define TIMEOUT 1000

void dht22_initialize(const sensor_t *const sensor)
{
    const dht22_descriptor_t *const dht22_descriptor = (dht22_descriptor_t *) sensor_get_descriptor(sensor);

    pinMode(dht22_descriptor->pin, INPUT);

    // DHT22 needs 1-2 seconds to get ready when first powering up
    delay(dht22_descriptor->initialization_delay);

    // Indicate to the host that the sensor with ID is ready
    Serial.println(SENSOR_ID_DHT22);
}

static uint32_t expect_pulse(const uint8_t pin, const bool level)
{
    static const uint32_t timeout_clock_cycles = microsecondsToClockCycles(TIMEOUT);

    uint16_t count = 0;

    while (digitalRead(pin) == level)
    {
        if (count++ >= timeout_clock_cycles)
        {
            return TIMEOUT;
        }
    }

    return count;
}

void dht22_read_and_report(sensor_t *const sensor)
{
    const dht22_descriptor_t *const dht22_descriptor = (dht22_descriptor_t *) sensor_get_descriptor(sensor);
    const uint8_t pin = dht22_descriptor->pin;

    pinMode(pin, OUTPUT);
    digitalWrite(pin, LOW);
    delayMicroseconds(1100);
    pinMode(pin, INPUT);
    delayMicroseconds(55);

    noInterrupts();

    if (expect_pulse(pin, LOW) == TIMEOUT || expect_pulse(pin, HIGH) == TIMEOUT)
    {
        Serial.println(SENSOR_ERRONEOUS_VALUE);
        interrupts();
        return;
    }

    uint32_t cycles[80];

    for (int i = 0; i < 80; i += 2)
    {
        cycles[i] = expect_pulse(pin, LOW);
        cycles[i + 1] = expect_pulse(pin, HIGH);
    }

    interrupts();

    uint8_t data[5] = { 0 };

    for (int i = 0; i < 40; ++i)
    {
        const uint8_t cycle_index = i + i;
        const uint32_t low_cycles = cycles[cycle_index];
        const uint32_t high_cycles = cycles[cycle_index + 1];

        if (low_cycles == TIMEOUT || high_cycles == TIMEOUT)
        {
            Serial.println(SENSOR_ERRONEOUS_VALUE);
            return;
        }

        const uint8_t data_byte_index = i / 8;
        data[data_byte_index] = (data[data_byte_index] << 1) | (high_cycles > low_cycles);
    }

    if (data[4] != ((data[0] + data[1] + data[2] + data[3]) & 0xff))
    {
        Serial.println(SENSOR_ERRONEOUS_VALUE);
        return;
    }

    const float humidity = (data[0] << 8 | data[1]) * 0.1;
    float temperature = ((data[2] & 0x7f) << 8 | data[3]) * 0.1;
    if (data[2] & 0x80)
    {
        temperature *= -1;
    }

    Serial.print(humidity);
    Serial.print(SENSOR_VALUE_SEPARATOR);
    Serial.print(temperature);
    Serial.println();
}
