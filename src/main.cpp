#include <Arduino.h>
#include "sensor.h"
#include "sensor_mq2.h"
// #include "sensor_dht11.h"

#define MQ2_PIN A0

// #define DHT11_PIN                  4
// #define DHT11_INITIALIZATION_DELAY 2000 // DHT11 needs 1-2 seconds to get ready when first powering up

#define SERIAL_BAUD_RATE           9600
#define SERIAL_POLLING_INTERVAL_MS 500
#define COMMAND_READ_AND_REPORT    '0'

// sensor_t *dht11;
sensor_t *mq2;

void process_command(const int command);

void setup()
{
    // Open a serial port
    Serial.begin(SERIAL_BAUD_RATE);

    // Create a sensor of type DHT11
    // const dht11_descriptor_t dht11_descriptor = {
    //     .pin = DHT11_PIN,
    //     .initialization_delay = DHT11_INITIALIZATION_DELAY
    // };

    // dht11 = sensor_create(
    //     (void *) &dht11_descriptor,
    //     dht11_initialize,
    //     dht11_read_and_report
    // );

    // // Initialize the DHT11 sensor
    // sensor_initialize(dht11);

    const mq2_descriptor_t mq2_descriptor = {
        .pin = MQ2_PIN
    };

    mq2 = sensor_create((void *) &mq2_descriptor, mq2_initialize, mq2_read_and_report);

    sensor_initialize(mq2);
}

void loop()
{
    if (Serial.available() > 0)
    {
        const int command = Serial.read();
        process_command(command);
    }

    delay(SERIAL_POLLING_INTERVAL_MS);
}

void process_command(const int command)
{
    switch (command)
    {
        case COMMAND_READ_AND_REPORT:
            sensor_read_and_report(mq2);
            break;

        // TODO: Auto mode

        default:
            break;
    }
}
