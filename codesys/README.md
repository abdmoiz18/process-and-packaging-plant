# CODESYS Implementation

In CODESYS, the Level Tank implements manual PID logic with anti-windup, interlocks, alarms with hysteresis, and a simulated power layer. The Sorting Station implements box arrival, weight classification, diverter timing with TON timers, counters, and its own power layer.

Both CODESYS instances expose their tags via OPC UA to a single Ignition Gateway, which hosts seperate HMI screens for each area plus an overview screen for the whole plant.

This directory is planned to have seperate directories for Level Tank and Weight Sorting Station each consisting of GVLs and CODESYS implementation
