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
	
	// Simulation Control
	Simulation_Mode : BOOL := TRUE; // TRUE := mock, FALSE := Factory I/O
	Downstream_Fault : BOOL; // Downstream jam or fault
	Sort_Actuator_Enable : BOOL;
	
	// Random Weight
	RandSeed : DWORD := 12345;
	Noise : REAL;
	LCG_Multiplier : DWORD := 1664525;
	LCG_Increment : DWORD := 1013904223;
	LCG_Modulus : DWORD := 10000;
	
	// Sequence Internals
	State : INT; // Of the state machine
	Stabilize_Timer : TON; // Weight stabilization timer
	Divert_Timer : TON; // Diverter actuation timer
	Prev_Box : BOOL; // For posedge detecttion
	Weight_Stable : BOOL; // TRUE when weight reading is valid
	Classify_Result : INT; // 0=good, 1=underweight, 2=overweight
	Count_Done : BOOL;
	
	// Power Layer
	Load : REAL;
	Sim_Current : REAL;
	Overcurrent_Alarm : BOOL;
	Overcurrent_Threshold : REAL := 8.0;
	Base_Current : REAL := 1.0;
	Current_Scale_Factor : REAL := 0.07;
	Noise_Amplitude : REAL := 0.4;
	
	// Alarm Internals
	Box_Jam_Alarm : BOOL; // Box present for too long
	Jam_Timer : TON;
	
	// I/O Scaling for Factory I/O (later)
	Weight_Raw : INT;
	Conveyor_Command_Raw : INT;
	Diverter_Command_Raw : INT;
	Raw_Max : REAL := 27648.0;
END_VAR
