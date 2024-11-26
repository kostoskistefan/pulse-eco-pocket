#pragma once

#include <stdint.h>

#define COMMAND_START_READ_AND_REPORT   'S'
#define COMMAND_END_READ_AND_REPORT     'E'
#define COMMAND_REQUEST_DATA_DESCRIPTOR 'R'

#define SERIAL_BAUD_RATE     9600
#define SERIAL_POLL_INTERVAL 100 // Check if serial data is available every 100 ms

typedef struct sensor_t sensor_t;

void pep_initialize(const uint16_t report_interval);
void pep_run(sensor_t *const sensor);
