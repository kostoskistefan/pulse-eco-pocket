#pragma once

#include <stdint.h>

typedef struct sensor_t sensor_t;

typedef struct mq2_descriptor_t
{
    uint8_t pin;
} mq2_descriptor_t;

void mq2_initialize(const sensor_t *const sensor);
void mq2_read_and_report(sensor_t *const sensor);
