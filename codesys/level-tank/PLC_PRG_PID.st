(* Our goal is to compute the manipulated variable (MV) for the level control loop using a
   discrete-time PID controller with anti-windup and bumpless transfer.
   
Controller Equation in continuous time is 
 u(t) = Kp * e(t)  +  Ki * ∫e(t)dt  +  Kd * de(t)/dt
 where u(t) is Controller_Output (MV), e(t) is Error (setpoint Level_SP - process variable Level_PV), Kp is proportional gain, Ki is integral gain, Kd is derivative gain
 
 Level_PV is measured tank level (0-100%), Level_SP is desired tank level, Controller_Output (MV) is pump speed/valve position (0-100%)
 
 We implement controller equation in time domain because that's what PLC can handle, it dosen't need the entire process (which CLTF offers)
 CLTF is for analysis and Kp pre-tuning (calculating offset, closed loop time constant, damping), not for implementation
 
The PID reads PV and SP, computes error, and outputs MV.
The process (mock tank or Factory I/O scene) receives MV and changes PV.

Servo Test keeps disturbance (outflow) constant and step changes in SP (eg: 40 to 60%) to measure tracking response, especially rise time, overshoot, settling time
Regulatory Test keeps SP constant and step changes SP (eg: 50 to 70%) to measure disturbance rejection

Both tests are performed in the mock simulation before Factory I/O.
The tuning log records results from both. 

After changing MV, the transient response is observed (changes in Servo and Regulatory related variables), measured in CODESYS watch window or Ignition trends.
rise time (time to reach 90% of final value), overshoot (peak value above SP in %), settling time (time to stay within 2% of SP), steady-state offset*)


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


(* INTEGRAL: Rectangular/Euler/Left Riemann Sum Approximation
     Continuous: I = ∫e(t)dt
     Discrete:   Integral := Integral + (Error * dt)
     Assumed constant error over each scan cycle. Good for small dt (100 ms). Error is O(dt).
	 Trapezoidal Rule is more accurate but more expensive to implement and unnecessary for small dt

DERIVATIVE: Backward Difference Approximation
  Continuous: D = de(t)/dt
  Discrete:   D_term := Kd * (Level_PV - Previous_PV) / dt
  Note that derivative is taken on (Level_PV - Prev_PV) over (Error - Prev_Error) to avoid "derivative kick" when SP changes abruptly.
  Also note that derivatives amplify sensor noise which is why PI is preferred for Level Tanks and real PLCs apply a filter to D, not noticeable in Mock Tank but there in Factory I/O

  A 1st order Low Pass Filter is used on D, using the Backward Euler Approximation, the industry standard
  Continuous: D(s) = Kd * s / (1 + Tf*s) * PV(s)
  Discrete:   D_filtered[k] = alpha * D_filtered[k-1] + (1-alpha) * D_raw[k]
  where:      alpha = Tf / (Tf + dt)
  Backward Euler is stable for any dt and Tf, only has one multiply-add per scan, avoids phase lead, has sufficient accuracy
  Forward Euler needs dt < 2Tf to be stable, Matched Pole-Zero uses exp(), hence both are rare in industry. Tustin (bilinear) is too complex and introduces phase lead near Nyquist frequency, but occassionally used in industry.
  
ANTI-WINDUP:
  Conditional integration: freeze integral when output is saturate and error would push it further into saturation.
     This prevents integral windup during startup or large setpoint steps. *)
	 
