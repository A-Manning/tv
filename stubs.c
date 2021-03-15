#include <libcec/ceccloader.h>

libcec_connection_t new_connection() {
    libcec_configuration config;
    libcecc_reset_configuration(&config);
    config.deviceTypes.types[0] = CEC_DEVICE_TYPE_RECORDING_DEVICE;
    return libcec_initialise(&config);
}
