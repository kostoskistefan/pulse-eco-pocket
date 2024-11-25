#pragma once

#include <stdint.h>
#include <SoftwareSerial.h>

typedef struct sensor_t sensor_t;

typedef struct sds011_sensor_descriptor_t
{
    SoftwareSerial *serial_port;
    uint32_t serial_port_baud_rate;
    uint16_t initialization_delay;
} sds011_sensor_descriptor_t;

void sds011_sensor_initialize(const sensor_t *const sensor);
void sds011_sensor_read_and_report(sensor_t *const sensor);
