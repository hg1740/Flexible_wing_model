# Flexible_wing_model

- The script produces a fixed end flexible wing model with folding wingtips.

- Currently the flexibility includes 3 wing bending modes and 2 torsional modes which can be changed or added in tbx_wing.Set_qs

Run the files:

1. Open and run Formulate_EoM.m. 

2. You should be able to see a function is generated which include equation of motions

3. Run Compute_response.m. The parameters can be modified accordingly e.g. wing stiffness EI and GJ...

4. You should see a constant time response, as the current initial conditions are set at the trimmed states. 

5. Compute_response.m firstly compute the trimmed status of the wing given wind speed and setting angle, see line 55 and 56
   Then compute the response with an initial condition X0, see line 73. 

6. The status flows the order:  1: qb1 2: qb2 3: qb3 4: qt1 5: qt2 6: thetaf 

7. qb represents bending terms and qt are torsional terms 

8. Now comment out line 73 'X0(1:Numofstate) = x;' Now the initial condition start with zero bending, torsion and wingtip fold angle

9. Run from line 65 - end, see the wing responses

10. you are welcome ! 