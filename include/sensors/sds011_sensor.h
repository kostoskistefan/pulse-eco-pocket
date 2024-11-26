#pragma once

#include <stdint.h>

typedef struct sensor_t sensor_t;

sensor_t *sds011_sensor_create(const uint8_t rx_pin, const uint8_t tx_pin);
