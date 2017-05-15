onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /pwmgen_test/i1/DC(0)
add wave -noupdate /pwmgen_test/i1/E
add wave -noupdate -radix unsigned /pwmgen_test/i1/CNT(0)
add wave -noupdate /pwmgen_test/PWM_O(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {205022458 ps} 0} {{Cursor 3} {307357487 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 186
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
configure wave -timelineunits ns
update
WaveRestoreZoom {195019786 ps} {326401036 ps}
