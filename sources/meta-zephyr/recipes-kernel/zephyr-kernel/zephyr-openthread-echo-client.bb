include zephyr-sample.inc

ZEPHYR_SRC_DIR = "${S}/samples/net/sockets/echo_client"

ZEPHYR_MODULES_append = "\;${S}/modules/lib/mbedtls"
ZEPHYR_MODULES_append = "\;${S}/modules/lib/openthread"

EXTRA_OECMAKE += "-DOVERLAY_CONFIG=overlay-ot.conf"

# The overlay config and OpenThread itself imposes some specific requirements
# towards the boards (e.g. flash layout and ieee802154 radio) so we need to
# limit to known working machines here.
COMPATIBLE_MACHINE = "(arduino-nano-33-ble)"
