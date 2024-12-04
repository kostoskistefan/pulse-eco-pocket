#pragma once

#include <stdint.h>

typedef enum sensor_data_type_t
{
    SENSOR_DATA_TYPE_INT,
    SENSOR_DATA_TYPE_FLOAT,
} sensor_data_type_t;

typedef struct sensor_data_t
{
    const char *label;
    const char *unit;
    void *value;
    sensor_data_type_t type;
} sensor_data_t;

typedef struct sensor_t
{
    uint8_t data_count;
    sensor_data_t *data;
    void (*read)(struct sensor_t *const sensor); 
} sensor_t;

void sensor_ready(void);
void sensor_read(sensor_t *const sensor);
void sensor_report_data(const sensor_t *const sensor);
void sensor_report_labels_and_units(const sensor_t *const sensor);
