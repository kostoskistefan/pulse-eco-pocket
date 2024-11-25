#pragma once

#include <stdint.h>

typedef struct sensor_t sensor_t;

typedef struct grove_sound_sensor_descriptor_t
{
    uint8_t pin;
} grove_sound_sensor_descriptor_t;

void grove_sound_sensor_initialize(const sensor_t *const sensor);
void grove_sound_sensor_read_and_report(sensor_t *const sensor);
