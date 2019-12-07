
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name Proyecto_final_Scanner_last -dir "C:/Users/Jose Antonio/Desktop/ProyecSistemDigit/Proyecto_final_Scanner_last/planAhead_run_1" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Jose Antonio/Desktop/ProyecSistemDigit/Proyecto_final_Scanner_last/Scanner_Last.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Jose Antonio/Desktop/ProyecSistemDigit/Proyecto_final_Scanner_last} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "Scanner_Last.ucf" [current_fileset -constrset]
add_files [list {Scanner_Last.ucf}] -fileset [get_property constrset [current_run]]
link_design
