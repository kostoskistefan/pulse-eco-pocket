#pragma once

#include <stdint.h>

typedef struct sensor_t sensor_t;

sensor_t *dht22_sensor_create(const uint8_t pin);
