(* This models the pump current as a function of the control output. When the PID commands more output, the pump draws more current. 
If the current exceeds a threshold, the overcurrent alarm triggers. *)

(* It is used to detect errors such as current spikes when a pump jams and level seems to remain the same.
   Or level drops when pump runs dry which shows a current drop then a spike as motor overheats.
   It is used to detect mechanical, electrical, hydraulic faults. *)

(* Simulated pump current:
   Base current + proportional to output + noise *)
   
// 1 - Use of Linear Congruential Generator (LCG) to generate random number to simulate noise
   
// Update the LCG seed
GVL_Level.RandSeed := GVL_Level.RandSeed * 1664525 + 1013904223;
// Convert to REAL between 0 and 1
GVL_Level.Noise := TO_REAL(GVL_Level.RandSeed MOD 10000) / 10000.0;
// Scale to ±0.2 A
GVL_Level.Noise := (GVL_Level.Noise - 0.5) * 0.4;

// 2 - Power Layer Simulation

GVL_Level.Sim_Current := 1.0 +
                         (GVL_Level.Controller_Output * 0.08) +
                         GVL_Level.Noise;

GVL_Level.Overcurrent_Alarm := GVL_Level.Sim_Current > GVL_Level.Overcurrent_Threshold;
