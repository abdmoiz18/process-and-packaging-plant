{attribute 'qualified_only'}
VAR_GLOBAL
	Level_PV : REAL := 50.0; // Process variable (measured level, 0-100%)
	Level_SP : REAL := 50.0; // Setpoint
	Kp : REAL := 2.0; // Proportional Gain (starting)
	Ki : REAL := 0.1; // Integral Gain (starting)
	Kd : REAL := 0; // Derivative Gain (initially zero)
	Controller_Output : REAL := 50; // PID Output, 0-100%
	Pump_Enable : BOOL; // Final Control Element
	Mode_Auto : BOOL := TRUE; // TRUE = PID, FALSE = Manual
	Prev_Mode_Auto : BOOL;
	Manual_Output : REAL := 0.0; // Manual Output value
	High_Alarm : BOOL;
	Low_Alarm : BOOL;
	High_Alarm_Trip : BOOL; // Trip for interlock
	Sim_Current : REAL; // Simulated pump current
	Overcurrent_Alarm : BOOL; 
	Overcurrent_Threshold : REAL := 8.0; // Amps
	Outflow_Disturbance : REAL := 20.0; // Load Disturbance 
	ScanTime : REAL := 0.1; // Scan time in seconds
	
	// For P-only Control
	Error : REAL;
    Prev_Error : REAL;
	P_Term : REAL;
	
	// For Integral and Anti-Windup
	I_Term : REAL;
	Integral : REAL;
	Output_Saturated : BOOL;
	Tf : REAL := 0.5; // Ideally 5-10x ScanTime as a rule of thumb
	
	// For Derivative and 1st Order Low Pass Filter
	D_Term : REAL;
	D_Raw : REAL;
	D_Filtered : REAL;
	Alpha : REAL;
	Prev_PV : REAL;
END_VAR

