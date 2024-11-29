#include "pep.h"
#include "sensor.h"
#include <Arduino.h>

static uint16_t report_interval = 5000;
static uint32_t last_report_time = 0;
static uint32_t last_serial_read_time = 0;
static bool read_and_report_started = false;

void process_command(const int command, const sensor_t *const sensor);

void pep_initialize(const uint16_t _report_interval)
{
    Serial.begin(SERIAL_BAUD_RATE);

    report_interval = _report_interval;

    // Ensure that the last times are already greater than their respective
    // interval so that the code in the pep_run() function can be executed right away
    last_report_time = millis() - report_interval;
    last_serial_read_time = millis() - SERIAL_POLL_INTERVAL;
}

void pep_run(sensor_t *const sensor)
{
    if (millis() - last_serial_read_time > SERIAL_POLL_INTERVAL)
    {
        if (Serial.available() > 0)
        {
            const int command = Serial.read();
            process_command(command, sensor);
        }

        last_serial_read_time = millis();
    }

    if (read_and_report_started == true && millis() - last_report_time > report_interval)
    {
        sensor_read(sensor);
        sensor_report_data(sensor);
        last_report_time = millis();
    }
}

void process_command(const int command, const sensor_t *const sensor)
{
    switch (command)
    {
        case COMMAND_START_READ_AND_REPORT:
            read_and_report_started = true;
            break;

        case COMMAND_END_READ_AND_REPORT:
            read_and_report_started = false;
            break;

        case COMMAND_REQUEST_DATA_LABELS:
            sensor_report_data_labels(sensor);
            break;

        case COMMAND_REQUEST_DATA_UNITS:
            sensor_report_data_units(sensor);
            break;

        default:
            break;
    }
}
