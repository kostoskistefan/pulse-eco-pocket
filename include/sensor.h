#pragma once

#define SENSOR_ERRONEOUS_VALUE "$"
#define SENSOR_VALUE_SEPARATOR ";"

typedef struct sensor_t sensor_t;

typedef void (*initialization_function_t)(const sensor_t *const sensor);
typedef void (*read_and_report_function_t)(sensor_t *const sensor);

sensor_t *sensor_create(
    const void *descriptor,
    initialization_function_t initialization_function,
    read_and_report_function_t read_and_report_function
);

void sensor_initialize(sensor_t *const sensor);
void sensor_read_and_report(sensor_t *const sensor);

const void *sensor_get_descriptor(const sensor_t *const sensor);
