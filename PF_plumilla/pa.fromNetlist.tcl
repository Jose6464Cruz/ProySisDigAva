
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name PF_plumilla -dir "C:/Users/Jose Antonio/Desktop/ProyecSistemDigit/PF_plumilla/planAhead_run_3" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Jose Antonio/Desktop/ProyecSistemDigit/PF_plumilla/Servo_Controller.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Jose Antonio/Desktop/ProyecSistemDigit/PF_plumilla} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "Servo_Controller.ucf" [current_fileset -constrset]
add_files [list {Servo_Controller.ucf}] -fileset [get_property constrset [current_run]]
link_design
