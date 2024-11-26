#include "sensors/dht22_sensor.h"
#include "sensor.h"
#include <Arduino.h>

#define TIMEOUT 1000

#define BASE_DATA_ID_HUMIDITY    0
#define BASE_DATA_ID_TEMPERATURE 1

void dht22_read(sensor_t *const sensor);

typedef struct dht22_t
{
    sensor_t base;

    uint8_t pin;

    float humidity;
    float temperature;

    sensor_data_t data[2];
} dht22_t;

sensor_t *dht22_sensor_create(const uint8_t pin)
{
    dht22_t *const dht22 = (dht22_t *const) malloc(sizeof(*dht22));

    dht22->base = (sensor_t) {
        .data_count = 2,
        .data = dht22->data,
        .read = dht22_read,
    };

    dht22->pin = pin;
    pinMode(dht22->pin, INPUT);

    dht22->humidity = 0.0;
    dht22->temperature = 0.0;

    dht22->base.data[BASE_DATA_ID_HUMIDITY].name = (const char *) "Humidity";
    dht22->base.data[BASE_DATA_ID_HUMIDITY].value = &dht22->humidity;
    dht22->base.data[BASE_DATA_ID_HUMIDITY].type = SENSOR_DATA_TYPE_FLOAT;

    dht22->base.data[BASE_DATA_ID_TEMPERATURE].name = (const char *) "Temperature";
    dht22->base.data[BASE_DATA_ID_TEMPERATURE].value = &dht22->temperature;
    dht22->base.data[BASE_DATA_ID_TEMPERATURE].type = SENSOR_DATA_TYPE_FLOAT;

    // DHT22 needs 1-2 seconds to get ready when first powering up
    delay(2000);

    sensor_ready();

    return (sensor_t *) dht22;
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

void dht22_read(sensor_t *const sensor)
{
    dht22_t *const dht22 = (dht22_t *const) sensor;

    pinMode(dht22->pin, OUTPUT);
    digitalWrite(dht22->pin, LOW);
    delayMicroseconds(1100);
    pinMode(dht22->pin, INPUT);
    delayMicroseconds(55);

    noInterrupts();

    if (expect_pulse(dht22->pin, LOW) == TIMEOUT || expect_pulse(dht22->pin, HIGH) == TIMEOUT)
    {
        dht22->humidity = 0;
        dht22->temperature = 0;
        interrupts();
        return;
    }

    uint32_t cycles[80];

    for (int i = 0; i < 80; i += 2)
    {
        cycles[i] = expect_pulse(dht22->pin, LOW);
        cycles[i + 1] = expect_pulse(dht22->pin, HIGH);
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
            dht22->humidity = 0;
            dht22->temperature = 0;
            return;
        }

        const uint8_t data_byte_index = i / 8;
        data[data_byte_index] = (data[data_byte_index] << 1) | (high_cycles > low_cycles);
    }

    if (data[4] != ((data[0] + data[1] + data[2] + data[3]) & 0xff))
    {
        dht22->humidity = 0;
        dht22->temperature = 0;
        return;
    }

    dht22->humidity = (data[0] << 8 | data[1]) * 0.1;
    dht22->temperature = ((data[2] & 0x7f) << 8 | data[3]) * ((data[2] & 0x80) ? -0.1 : 0.1);
}
