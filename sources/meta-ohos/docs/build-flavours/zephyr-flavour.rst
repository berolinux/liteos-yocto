.. SPDX-FileCopyrightText: Huawei Inc.
..
.. SPDX-License-Identifier: CC-BY-4.0

.. _Zephyr_Kernel:

Zephyr Kernel Build Flavour
###########################

All Scenarios OS Zephyr build flavour is based on *allscenarios-zephyr* distribution (distro configuration).

Supported images:

* Zephyr comes with multiple sample applications. Take a look into
  ``sources/meta-zephyr/recipes-kernel/zephyr-kernel/`` to see available recipes.
  You can extend them by adding recipes that `use sample applications provided with Zephyr <https://github.com/zephyrproject-rtos/zephyr/tree/master/samples>`_
  or your own applications.

Supported machines (default in **bold**):

* **qemu-x86**
* qemu-cortex-m3
* 96b-nitrogen (96Boards Nitrogen)
* 96b-avenger96 (96Boards Avenger96)
* arduino-nano-33-ble (Arduino Nano 33 BLE and Arduino Nano 33 BLE Sense)
* nrf52840dk-nrf52840 (Nordic Semiconductor nRF 52840 Development Kit)

Build steps example:

.. code-block:: console

    $ TEMPLATECONF=../sources/meta-ohos/flavours/zephyr . ./sources/poky/oe-init-build-env build-ohos-zephyr
    $ bitbake zephyr-philosophers

You can test the image built for the qemu-x86 target by issuing:

.. code-block:: console

    $ runqemu qemu-x86

After successful bootup, the output of the application will be similar to:

.. code-block:: console

    Booting from ROM..*** Booting Zephyr OS build zephyr-v2.4.0  ***
    Philosopher 0 [P: 3]  THINKING [  300 ms ]
    Philosopher 1 [P: 2]   EATING  [  575 ms ]
    Philosopher 2 [P: 1]        STARVING
    Philosopher 3 [P: 0]   EATING  [  525 ms ]
    Philosopher 4 [C: -1]  THINKING [  475 ms ]

To exit qemu, use the following key combination: *Ctrl-a followed by 'x'*.
