// Proportional-only Control 

GVL_Level.Error := GVL_Level.Level_SP - GVL_Level.Level_PV;
GVL_Level.P_Term := GVL_Level.Kp * GVL_Level.Error;
GVL_Level.Controller_Output := GVL_Level.P_Term;

// Clamp Output to 0-100% 

IF GVL_Level.Controller_Output > 100.0 THEN
	GVL_Level.Controller_Output := 100.0;
ELSIF GVL_Level.Controller_Output < 0.0 THEN
	GVL_Level.Controller_Output := 0.0;
END_IF
