#Define target part and create output directory
set partNum xc7z020clg400-1
set projectDir [pwd]
set outputDir $projectDir/build
file mkdir $outputDir
set files [glob -nocomplain "$outputDir/*"]
if {[llength $files] != 0} {
    # clear folder contents
    puts "deleting contents of $outputDir"
    file delete -force {*}[glob -directory $outputDir *]; 
} else {
    puts "$outputDir is empty"
}

#Reference HDL and constraint source files
# read_vhdl -library usrDefLib [ glob path/to/vhdl/sources/*.vhdl ]
read_verilog [glob $projectDir/RTL/*.v]
read_xdc $projectDir/Constraints/Arty-Z7-20-Master.xdc

#Run Synthesis
synth_design -top top -part $partNum
write_checkpoint -force $outputDir/Synthesis.runs/post_synth.dcp
report_timing_summary -file $outputDir/Synthesis.runs/post_synth_timing_summary.rpt
report_utilization -file $outputDir/Synthesis.runs/post_synth_util.rpt

#run optimization
opt_design
place_design
report_clock_utilization

#get timing violations and run optimizations if needed
if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
 puts "Found setup timing violations => running physical optimization"
 phys_opt_design
}
write_checkpoint -force $outputDir/Implementation.runs/post_place.dcp
report_utilization -file $outputDir/Implementation.runs/post_place_util.rpt
report_timing_summary -file $outputDir/Implementation.runs/post_place_timing_summary.rpt

#Route design and generate bitstream
route_design -directive Explore
write_checkpoint -force $outputDir/Implementation.runs/post_route.dcp
report_route_status -file $outputDir/Implementation.runs/post_route_status.rpt
report_timing_summary -file $outputDir/Implementation.runs/post_route_timing_summary.rpt
report_power -file $outputDir/Implementation.runs/post_route_power.rpt
report_drc -file $outputDir/Implementation.runs/post_imp_drc.rpt
write_verilog -force $outputDir/Implementation.runs/impl_netlist.v -mode timesim -sdf_anno true
write_bitstream -force $outputDir/nameOfBitstream.bit