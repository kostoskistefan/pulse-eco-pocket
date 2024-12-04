#include "sensors/sds011_sensor.h"
#include "sensor.h"
#include <Arduino.h>
#include <SoftwareSerial.h>

#define MS_READ_TIMEOUT 4000

#define BASE_DATA_ID_PM25 0
#define BASE_DATA_ID_PM10 1

static const uint8_t command_set_query_reporting_mode[19] = {
    0xaa, // Head
    0xb4, // Command ID
    0x02, // Data byte 1
    0x01, // Data byte 1
    0x01, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0xff, // Device byte 1
    0xff, // Device byte 2
    0x02, // Checksum - Lower 8 bits from the sum of the data from Data Byte 1 to Device Byte 2
    0xab  // Tail
};

static const uint8_t command_query_data[19] = {
    0xaa, // Head
    0xb4, // Command ID
    0x04, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0x00, // Data byte 1
    0xff, // Device byte 1
    0xff, // Device byte 2
    0x02, // Checksum - Lower 8 bits from the sum of the data from Data Byte 1 to Device Byte 2
    0xab  // Tail
};

void sds011_read(sensor_t *const sensor);

typedef struct sds011_t
{
    sensor_t base;

    SoftwareSerial *serial;

    float pm25;
    float pm10;

    sensor_data_t data[2];
} sds011_t;

sensor_t *sds011_sensor_create(const uint8_t rx_pin, const uint8_t tx_pin)
{
    sds011_t *const sds011 = (sds011_t *const) malloc(sizeof(*sds011));

    sds011->base = (sensor_t) {
        .data_count = 2,
        .data = sds011->data,
        .read = sds011_read,
    };

    sds011->serial = new SoftwareSerial(rx_pin, tx_pin);
    sds011->serial->begin(9600);

    sds011->pm10 = 0.0;
    sds011->pm25 = 0.0;

    sds011->base.data[BASE_DATA_ID_PM25].value = &sds011->pm25;
    sds011->base.data[BASE_DATA_ID_PM25].label = (const char *) "PM2.5";
    sds011->base.data[BASE_DATA_ID_PM25].unit = (const char *) "ug/m3";
    sds011->base.data[BASE_DATA_ID_PM25].type = SENSOR_DATA_TYPE_FLOAT;

    sds011->base.data[BASE_DATA_ID_PM10].value = &sds011->pm10;
    sds011->base.data[BASE_DATA_ID_PM10].label = (const char *) "PM10";
    sds011->base.data[BASE_DATA_ID_PM10].unit = (const char *) "ug/m3";
    sds011->base.data[BASE_DATA_ID_PM10].type = SENSOR_DATA_TYPE_FLOAT;

    sds011->serial->write(command_set_query_reporting_mode, 19);
    sds011->serial->flush();

    while (sds011->serial->available() > 0)
    {
        sds011->serial->read();
    }

    sensor_read((sensor_t *) sds011);

    sensor_ready();

    return (sensor_t *) sds011;
}

void sds011_read(sensor_t *const sensor)
{
    sds011_t *const sds011 = (sds011_t *const) sensor;

    uint8_t response[10];

    sds011->serial->write(command_query_data, 19);
    sds011->serial->flush();

    const uint32_t start_read_time = millis();

    while (sds011->serial->available() < 10)
    {
        if (millis() - start_read_time > MS_READ_TIMEOUT)
        {
            return;
        }

        delay(10);
    }

    sds011->serial->readBytes(response, 10);

    if (response[0] != 0xaa || response[1] != 0xc0)
    {
        return;
    }

    uint8_t checksum = 0;

    for (uint8_t i = 2; i < 8; ++i)
    {
        checksum += response[i];
    }

    checksum &= 0xff;

    if (checksum == response[8])
    {
        sds011->pm25 = (float) (((response[3] << 8) | response[2]) / 10.0);
        sds011->pm10 = (float) (((response[5] << 8) | response[4]) / 10.0);
    }
}
