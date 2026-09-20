// Mock Tank Physics 
// A 1st order level model with inflow from the pump and outflow as the disturbance
// Level changes based on (inflow - outflow) * dt
// Controller Output is 0-100%, representing pump speed/valve position

GVL_Level.Level_PV := GVL_Level.Level_PV + (GVL_Level.Controller_Output - GVL_Level.Outflow_Disturbance) * GVL_Level.ScanTime * 0.01;
// The 0.01 value is arbitrary to keep level response ata  realistic range given output is 0-100
// The key is that Level_PV integrates the difference between inflow and outflow

// Clamp Level to 0-100%

IF GVL_Level.Level_PV > 100.0 THEN
	GVL_Level.Level_PV := 100.0;
ELSIF GVL_Level.Level_PV < 0.0 THEN
	GVL_Level.Level_PV := 0.0;
END_IF

