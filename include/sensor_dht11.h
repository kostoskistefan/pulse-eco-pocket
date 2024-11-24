#pragma once

#include <stdint.h>

typedef struct sensor_t sensor_t;

typedef struct dht11_descriptor_t
{
    uint8_t pin;
    uint16_t initialization_delay;
} dht11_descriptor_t;

void dht11_initialize(const sensor_t *const sensor);
void dht11_read_and_report(sensor_t *const sensor);
