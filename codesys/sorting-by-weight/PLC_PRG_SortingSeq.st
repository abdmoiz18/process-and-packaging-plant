(* State Machine for sorting sequence
   0 : Idle - waiting for a box
   1 : Stabilize - box present, wait for weight to settle (TON)
   2 : Classify - determine if good/reject
   3 : Divert - If reject, actuate the diverter for a fixed time
   4 : Clear - increment counters, wait for the box to leave *)
   
CASE GVL_Sort.State OF
	0: // IDLE - Waiting for a box
	// Diverters must be off and timers must be reset. Can't stabilize or classify a box that isn't there.
	// This state ends when a new box enters
	GVL_Sort.Sort_Actuator := FALSE;
	GVL_sort.Weight_Stable := FALSE;
	GVL_Sort.Stabilize_Timer(IN := FALSE);
	GVL_Sort.Divert_Timer(IN := FALSE);
	
	IF GVL_Sort.Box_Present AND NOT GVL_Sort.Prev_Box THEN
		GVL_Sort.State := 1;
	END_IF
	
	1 : // Stabilize - wait for weight to settle
	// A box just landed on the scale and the reading is bouncing, run a 500 ms timer, which is enough for the weight to settle.
	// This state ends when the 500 ms timer is done
	GVL_Sort.Stabilize_Timer(IN := TRUE, PT := T#500MS);
	
	IF GVL_Sort.Stabilize_Timer.Q THEN
		GVL_Sort.Weight_Stable := TRUE;
		GVL_Sort.State := 2;
	END_IF
	
	2 : // Classify - determine underweight/good/overweight
	// Compare weight to thresholds and set the classify_result variable to 0 (good), 1 (under), 2 (over)
	// This state lasts one scan and ends immediately, go to State 3 if reject, State 4 if good
	
	IF GVL_Sort.Weight_PV < GVL_Sort.Weight_Threshold_Low THEN
		GVL_Sort.Classify_Result := 1; // Underweight
	ELSIF GVL_Sort.Weight_PV > GVL_Sort.Weight_Threshold_High THEN
		GVL_Sort.Classify_Result := 2; // Overweight
	ELSE
		GVL_Sort.Classify_Result := 0; // Good
	END_IF
	
	IF GVL_Sort.Classify_Result <> 0 THEN
		GVL_Sort.State := 3; // Reject - divert
	ELSE
		GVL_Sort.State := 4; // Good - clear
	END_IF
	
	3: // Divert - actuate diverter for a fixed time
	// The box is a reject. Push it off with the diverter by setting Sort_Actuator := TRUE and run a 1 sec timer.
	// The diverter must stay on long enough (for a fixed time) to physically push the box off the converter and increment reject_count. One scan is not enough
	// The state ends when the timer is done
	IF GVL_Sort.Sort_Actuator_Enable THEN
		GVL_Sort.Sort_Actuator := TRUE;
	END_IF
	
	GVL_Sort.Divert_Timer(IN := TRUE, PT := T#1S);
	
	IF GVL_Sort.Divert_Timer.Q THEN
		GVL_Sort.Sort_Actuator := FALSE;
		GVL_Sort.Reject_Count := GVL_Sort.Reject_Count + 1;
		GVL_Sort.State := 4;
	END_IF
	
	4 : // Clear - increment counter, wait for the box to leave
	// The box is leaving the station. Increment count and wait for it to be gone
	// The state ends when variable Box_count is FALSE
	
	// We use a one-shot flag called Count_Done, because Box_Count increments every scan
	// If the box takes 2 seconds to leave and scantime is 100 ms, 20 increments are added where the correct value is one
	// Hence, Count_Done ensures it only increments once
    IF NOT GVL_Sort.Count_Done THEN
        GVL_Sort.Box_Count := GVL_Sort.Box_Count + 1;
        GVL_Sort.Count_Done := TRUE;
    END_IF

    IF NOT GVL_Sort.Box_Present THEN
        GVL_Sort.Count_Done := FALSE;
        GVL_Sort.State := 0;
    END_IF
	
END_CASE

// Posedge detection for Box_Present (State 0)
GVL_Sort.Prev_Box := GVL_Sort.Box_Present;
