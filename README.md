# SimPower
Power analysis (simulated) for a 2 (within) by 3 (between) subjects ANOVA interaction term

This function will perform a simulated power analysis for a pre/post study with three conditions 
  
The function requires that the user provide many inputs, but are required for the simulation to be done properly.  
  
User must provide the Ns for each of the conditions (n1, n2, n3).  
User must provide the means for condition 1 at time 1 (m1_t1) and time 2 (m1_t2).  
Similarly user must provide the means for conditions 2 and 3.  
User must provide the standard deviations for condition 1 at time 1 (sd1_t1) and time 2 (sd1_t2).  
Similarly user must provide the std. devs. for conditions 2 and 3.  
The lower bound has a default value of 0 (can be set to negative inf).  
The upper bound has a default value of 100 (can be set to inf).  
Number of simulations to run is 5000, but fewer/more can be specified). 
