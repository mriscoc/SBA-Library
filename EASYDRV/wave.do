onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /easydrv_test/RST_I
add wave -noupdate /easydrv_test/CLK_I
add wave -noupdate /easydrv_test/STB_I
add wave -noupdate /easydrv_test/ADR_I
add wave -noupdate /easydrv_test/WE_I
add wave -noupdate /easydrv_test/DAT_I
add wave -noupdate /easydrv_test/INT_O
add wave -noupdate -divider <NULL>
add wave -noupdate /easydrv_test/ENABLE
add wave -noupdate /easydrv_test/DIR
add wave -noupdate /easydrv_test/STEP
add wave -noupdate /easydrv_test/RSTPOS
add wave -noupdate -divider <NULL>
add wave -noupdate /easydrv_test/i1/MotSt
add wave -noupdate /easydrv_test/i1/currPos
add wave -noupdate /easydrv_test/i1/setPos
add wave -noupdate /easydrv_test/i1/DIRSTUS
add wave -noupdate /easydrv_test/i1/ACTSTUS
add wave -noupdate /easydrv_test/i1/ENASTUS
add wave -noupdate /easydrv_test/i1/RSTSTUS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 183
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {954 ps}
