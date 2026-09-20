# Process and Packaging Plant

This is a GitHub repository to simulate a small hybrid plant made of two independent areas: a level tank process and a weight-based sorting station. The level tank area represents a continuous process, where a pump or valve is controlled to maintain a liquid level inside the tank. The sorting area represents a discrete packaging process, where boxes arrive on a conveyor belt, are weighed, and are diverted if underweight or overweight.

These two areas are built as seperate Factory I/O scenes, controlled by seperate CODESYS Programs, and then supervised together through a single Ignition SCADA system. They are not physically connected in the simulation, the plant is unified at the SCADA layer, where one overview screen, a shared alarm summary, and a facility-wide power dashboard bring both areas together.

# Planned Implementation 

In CODESYS, the Level Tank implements manual PID logic with anti-windup, interlocks, alarms with hysteresis, and a simulated power layer. The Sorting Station implements box arrival, weight classification, diverter timing with TON timers, counters, and its own power layer.

Both CODESYS instances expose their tags via OPC UA to a single Ignition Gateway, which hosts seperate HMI screens for each area plus an overview screen for the whole plant.

This project is to demonstrate practical skills in continuous control, discrete sequencing, OPC UA integratrion, alarm management, and power monitoring, and it serves as a portfolio piece that builds on an earlier work in an AHU control system.

---
