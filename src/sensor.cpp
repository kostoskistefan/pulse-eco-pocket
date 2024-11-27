#include "sensor.h"
#include <Arduino.h>

#define SENSOR_READY_BYTE '1'

void sensor_ready(void)
{
    Serial.write(SENSOR_READY_BYTE);
    Serial.flush();
}

void sensor_read(sensor_t *const sensor)
{
    sensor->read(sensor);
}

void sensor_report_data(const sensor_t *const sensor)
{
    String data;

    for (uint8_t i = 0; i < sensor->data_count; ++i)
    {
        switch (sensor->data[i].type)
        {
            case SENSOR_DATA_TYPE_INT:
                data += String(*((int *)sensor->data[i].value));
                break;

            case SENSOR_DATA_TYPE_FLOAT:
                data += String(*((float *)sensor->data[i].value));
                break;
        }

        data += ";";
    }

    Serial.println(data);
    Serial.flush();
}

void sensor_report_data_descriptors(const sensor_t *const sensor)
{
    String data;

    for (uint8_t i = 0; i < sensor->data_count; ++i)
    {
        data += String(sensor->data[i].name);
        data += ";";
    }

    Serial.println(data);
    Serial.flush();
}
