// 1. Process Simulation (or Factory I/O inputs later)
IF GVL_sort.Simulation_Mode THEN
	PLC_PRG_MockSort();
END_IF

// 2. Alarms (detect abnormal conditions, runs before interlocks so that Downstream_Fault or Box_Jam_Alarms inhibits conveyor)
PLC_PRG_Alarms();

// 3. Interlocks (decide if converter/diverter can run
Interlocks_LD();

// 4. Sorting Sequence (state machine, counters, diverter, runs after Interlocks to keep Sort_Actuator_Enable fresh)
PLC_PRG_SortingSeq();

// 5. Power Layer (monitor equipment health)
PLC_PRG_PowerLayer();
