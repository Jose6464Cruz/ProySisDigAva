
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name PF_Height -dir "D:/Repositories/ProySisDigAva/PF_Height/planAhead_run_1" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/Repositories/ProySisDigAva/PF_Height/Height.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/Repositories/ProySisDigAva/PF_Height} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "Height.ucf" [current_fileset -constrset]
add_files [list {Height.ucf}] -fileset [get_property constrset [current_run]]
link_design
