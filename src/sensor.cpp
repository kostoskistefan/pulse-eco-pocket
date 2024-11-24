#include "sensor.h"
#include <stdlib.h>

struct sensor_t
{
    const void *descriptor;
    initialization_function_t initialization_function;
    read_and_report_function_t read_and_report_function;
};

sensor_t *sensor_create(
    const void *descriptor,
    initialization_function_t initialize_function,
    read_and_report_function_t read_and_report_function
)
{
    sensor_t *sensor = (sensor_t *) malloc(sizeof(*sensor));

    sensor->descriptor = descriptor;
    sensor->initialization_function = initialize_function;
    sensor->read_and_report_function = read_and_report_function;

    return sensor;
}

void sensor_initialize(sensor_t *const sensor)
{
    sensor->initialization_function(sensor);
}

void sensor_read_and_report(sensor_t *const sensor)
{
    sensor->read_and_report_function(sensor);
}

const void *sensor_get_descriptor(const sensor_t *const sensor)
{
    return sensor->descriptor;
}
