#pragma once

#include <stdint.h>

typedef struct sensor_t sensor_t;

typedef struct dht22_sensor_descriptor_t
{
    uint8_t pin;
    uint16_t initialization_delay;
} dht22_sensor_descriptor_t;

void dht22_sensor_initialize(const sensor_t *const sensor);
void dht22_sensor_read_and_report(sensor_t *const sensor);
