
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name MoneyManager -dir "D:/Repositories/ProySisDigAva/MoneyManager/planAhead_run_5" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "moneymanager.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {moneymanager.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top moneymanager $srcset
add_files [list {moneymanager.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
