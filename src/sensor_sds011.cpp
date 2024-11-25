#include "sensor_sds011.h"
#include "sensor.h"
#include "sensor_id_table.h"
#include <Arduino.h>

void sds011_sensor_initialize(const sensor_t *const sensor)
{
    const sds011_sensor_descriptor_t *const sds011_sensor_descriptor =
        (sds011_sensor_descriptor_t *) sensor_get_descriptor(sensor);

    sds011_sensor_descriptor->serial_port->begin(sds011_sensor_descriptor->serial_port_baud_rate);

    // Indicate to the host that the sensor with ID is ready
    Serial.println(SENSOR_ID_SDS011);
}

void sds011_sensor_read_and_report(sensor_t *const sensor)
{
    const sds011_sensor_descriptor_t *const sds011_sensor_descriptor =
        (sds011_sensor_descriptor_t *) sensor_get_descriptor(sensor);

    SoftwareSerial *const serial_port = sds011_sensor_descriptor->serial_port;

    int8_t length = 0;
    int pm10_serial = 0;
    int pm25_serial = 0;
    int checksum_is;
    int checksum_ok = 0;

    while (serial_port->available() > 0 && serial_port->available() >= (10 - length))
    {
        int value = int(serial_port->read());

        switch (length)
        {
            case 0:
                if (value != 170)
                {
                    length = -1;
                }
                break;

            case 1:
                if (value != 192)
                {
                    length = -1;
                }
                break;

            case 2:
                pm25_serial = value;
                checksum_is = value;
                break;

            case 3:
                pm25_serial += (value << 8);
                checksum_is += value;
                break;

            case 4:
                pm10_serial = value;
                checksum_is += value;
                break;

            case 5:
                pm10_serial += (value << 8);
                checksum_is += value;
                break;

            case 6:
                checksum_is += value;
                break;

            case 7:
                checksum_is += value;
                break;

            case 8:
                if (value == (checksum_is % 256))
                {
                    checksum_ok = 1;
                }
                else
                {
                    length = -1;
                }
                break;

            case 9:
                if (value != 171)
                {
                    length = -1;
                }
                break;

            default:
                break;
        }

        ++length;

        if (length == 10 && checksum_ok == 1)
        {
            Serial.print(pm10_serial / 10.0);
            Serial.println(pm25_serial / 10.0);
        }

        return;
    }

    Serial.println(SENSOR_ERRONEOUS_VALUE);
}
