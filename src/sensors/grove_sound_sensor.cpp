#include "sensors/grove_sound_sensor.h"
#include "sensor.h"
#include <Arduino.h>

void grove_sound_sensor_read(sensor_t *const sensor);

typedef struct grove_sound_sensor_t
{
    sensor_t base;

    uint8_t pin;
    uint16_t noise_level;

    sensor_data_t data[1];
} grove_sound_sensor_t;

sensor_t *grove_sound_sensor_create(const uint8_t pin)
{
    grove_sound_sensor_t *const grove_sound_sensor =
        (grove_sound_sensor_t *const) malloc(sizeof(*grove_sound_sensor));

    grove_sound_sensor->base = (sensor_t) {
        .data_count = 1,
        .data = grove_sound_sensor->data,
        .read = grove_sound_sensor_read,
    };

    grove_sound_sensor->pin = pin;
    grove_sound_sensor->noise_level= 0.0;
    grove_sound_sensor->base.data[0].name = (const char *) "Noise Level";
    grove_sound_sensor->base.data[0].value = &grove_sound_sensor->noise_level;
    grove_sound_sensor->base.data[0].type = SENSOR_DATA_TYPE_INT;

    pinMode(grove_sound_sensor->pin, INPUT);

    sensor_ready();

    return (sensor_t *) grove_sound_sensor;
}

void grove_sound_sensor_read(sensor_t *const sensor)
{
    grove_sound_sensor_t *const grove_sound_sensor = (grove_sound_sensor_t *const) sensor;

    grove_sound_sensor->noise_level = analogRead(grove_sound_sensor->pin);
}
