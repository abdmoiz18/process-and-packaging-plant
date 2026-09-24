{attribute 'qualified_only'}
VAR_GLOBAL
	// Mock Sorting Simulation
	Arrival_Timer : TON;
	Depart_Timer : TON;
	
	// Process variables
	Box_Present : BOOL; // TRUE when box is at weighing station
	Weight_PV : REAL := 450.0; // Measured weight (grams)
	Weight_Threshold_Low : REAL := 420.0; // Underweight below this
	Weight_Threshold_High : REAL := 480.0; // Overweight above this
	Conveyor_Run : BOOL; // Conveyor Motor Command
	Sort_Actuator : BOOL; // Diverter actuator (TRUE := divert)
	Box_Count : DINT; // Total boxes processed
	Reject_Count : DINT; // Rejected boxes
	ScanTime : REAL := 0.1; // Scan time (secs)
	
	// Random Weight
	RandSeed : DWORD := 12345;
	Noise : REAL;
	LCG_Multiplier : DWORD := 1664525;
	LCG_Increment : DWORD := 1013904223;
	LCG_Modulus : DWORD := 10000;
END_VAR
