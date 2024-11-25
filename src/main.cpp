#include <Arduino.h>
#include "sensor.h"
#include "sensor_dht22.h"

#define DHT22_PIN                  11
#define DHT22_INITIALIZATION_DELAY 2000 // DHT22 needs 1-2 seconds to get ready when first powering up

#define SERIAL_BAUD_RATE     9600
#define SERIAL_POLL_INTERVAL 100 // Check if serial data is available every 100 ms

#define REPORT_INTERVAL 5000 // Report sensor data every 5 seconds

#define COMMAND_START_READ_AND_REPORT '1'
#define COMMAND_END_READ_AND_REPORT   '0'

static sensor_t *dht22;
static uint32_t last_report_time = 0;
static uint32_t last_serial_read_time = 0;
static bool read_and_report_started = false;

void process_command(const int command);

void setup()
{
    // Open a serial port
    Serial.begin(SERIAL_BAUD_RATE);

    // Create a descriptor for the DHT22 sensor
    const dht22_descriptor_t dht22_descriptor = {
        .pin = DHT22_PIN,
        .initialization_delay = DHT22_INITIALIZATION_DELAY
    };

    // Create a sensor of type DH22T
    dht22 = sensor_create(
        (void *) &dht22_descriptor,
        dht22_initialize,
        dht22_read_and_report
    );

    // Initialize the DHT22 sensor
    sensor_initialize(dht22);

    // Ensure that the last times are already greater than their respective
    // interval so that the code in the loop() function can be executed right away
    last_report_time = millis() - REPORT_INTERVAL;
    last_serial_read_time = millis() - SERIAL_POLL_INTERVAL;
}

void loop()
{
    if (millis() - last_serial_read_time > SERIAL_POLL_INTERVAL)
    {
        if (Serial.available() > 0)
        {
            const int command = Serial.read();
            process_command(command);
        }

        last_serial_read_time = millis();
    }

    if (read_and_report_started == true && millis() - last_report_time > REPORT_INTERVAL)
    {
        sensor_read_and_report(dht22);
        last_report_time = millis();
    }
}

void process_command(const int command)
{
    switch (command)
    {
        case COMMAND_START_READ_AND_REPORT:
            read_and_report_started = true;
            break;

        case COMMAND_END_READ_AND_REPORT:
            read_and_report_started = false;
            break;

        default:
            break;
    }
}
