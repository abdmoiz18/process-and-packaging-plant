// High alarm with hysteresis (5% deadband)
// This is to avoid spillage, overflow, environmental hazards, contact with electrical equipment
IF GVL_Level.Level_PV > 90.0 THEN 
	GVL_Level.High_Alarm := TRUE;
ELSIF GVL_Level.Level_PV < 85.0 THEN
	GVL_Level.High_Alarm := FALSE;
END_IF

// Low alarm with hysteresis
// This is to avoid motor overheating, cavitation, impeller damage, seal failure
IF GVL_Level.Level_PV < 10.0 THEN
	GVL_Level.Low_Alarm := TRUE;
ELSIF GVL_Level.Level_PV > 15.0 THEN
	GVL_Level.Low_Alarm := FALSE;
END_IF

// Hysteresis is used to prevent chatter

// High alarm trip (latched)
IF GVL_Level.High_Alarm THEN
    GVL_Level.High_Alarm_Trip := TRUE;
END_IF
