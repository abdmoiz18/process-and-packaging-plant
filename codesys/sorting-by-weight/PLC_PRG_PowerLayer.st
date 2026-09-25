(* Power Layer - Simulated conveyor + Diverter current
   ---------------------------------------------------
   Base Current + Proportional to conveyor running + Diverter actuation + Noise *)
   
// Effective Load : Conveyor running + Diverter Actuating

(* It simulates the current drawn for conveyor and diverter to monitor, trend, and alarm.
   The load variable is the total mechanical load on the motor circuit*)

GVL_Sort.Load := 0.0;
IF GVL_Sort.Conveyor_Run THEN // Only conveyor runs, main motor draws current
	GVL_Sort.Load := GVL_Sort.Load + 50.0;
END_IF
IF GVL_Sort.Sort_Actuator THEN // Only diverter actuates, solenoid draws current
	GVL_Sort.Load := GVL_Sort.Load + 30.0;
END_IF

// LCG Noise 
(* Added for realism, too negligible to require filtering *)
GVL_Sort.RandSeed := GVL_Sort.RandSeed * GVL_Sort.LCG_Multiplier + GVL_Sort.LCG_Increment;
GVL_Sort.Noise := TO_REAL(GVL_Sort.RandSeed MOD GVL_Sort.LCG_Modulus) / TO_REAL(GVL_Sort.LCG_Modulus);
GVL_Sort.Noise := (GVL_Sort.Noise - 0.5) * GVL_Sort.Noise_Amplitude;

// Simulated Current
GVL_Sort.Sim_Current := GVL_Sort.Base_Current + (GVL_Sort.Load * GVL_Sort.Current_Scale_Factor) + GVL_Sort.Noise;

// Overcurrent Alarm
(* It's here and not in alarms because it depends on Sim_Current computed here, a design choice for convenience rather than a strict necessity*)
GVL_Sort.Overcurrent_Alarm := GVL_Sort.Sim_Current > GVL_Sort.Overcurrent_Threshold;
