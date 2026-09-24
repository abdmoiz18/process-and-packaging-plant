(* Mock Sorting Simulation
   Generates periodic box arrivals with random wieghts. Sorting logic reacts to Box_Present and Weight_PV.
   This POU is removed/disabled when Factory I/O is connected. 

   Box Cycle:
   1 - Every ~4 secs, a box arrives (Box_Present := TRUE)
   2 - A weight is generated (400-50 g range for example)
   3 - After ~3 secs, the box leaves (Box_Present := FALSE) *)
   
   // Box Arrival Timer fires every 4 secs when no box is present
   GVL_Sort.Arrival_Timer(IN:= NOT GVL_Sort.Box_Present, PT := T#4s);
   
   IF GVL_Sort.Arrival_Timer.Q AND NOT GVL_Sort.Box_Present THEN
	   GVL_Sort.Box_Present := TRUE;
	   
	   // Generate random weight in 400-500 grange using LCG
	   GVL_Sort.RandSeed := GVL_Sort.RandSeed * GVL_Sort.LCG_Multiplier + GVL_Sort.LCG_Increment;
	   GVL_Sort.Noise := TO_REAL(GVL_Sort.RandSeed MOD GVL_Sort.LCG_Modulus) / TO_REAL(GVL_Sort.LCG_Modulus);
	   GVL_Sort.Weight_PV := 400.0 + (GVL_Sort.Noise * 100.0);
   END_IF
   
   // Box departure timer : Box leaves after 3 secs
   GVL_Sort.Depart_Timer(IN := GVL_Sort.Box_Present, PT := T#3S);
   
   IF GVL_Sort.Depart_Timer.Q THEN
	   GVL_Sort.Box_Present := FALSE;
   END_IF
   
  
