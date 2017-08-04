onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /timer_test/RST_I
add wave -noupdate /timer_test/CLK_I
add wave -noupdate /timer_test/STB_I
add wave -noupdate -radix unsigned /timer_test/ADR_I
add wave -noupdate /timer_test/WE_I
add wave -noupdate -radix unsigned /timer_test/DAT_I
add wave -noupdate /timer_test/INT_O
add wave -noupdate -radix unsigned -childformat {{/timer_test/DAT_O(15) -radix unsigned} {/timer_test/DAT_O(14) -radix unsigned} {/timer_test/DAT_O(13) -radix unsigned} {/timer_test/DAT_O(12) -radix unsigned} {/timer_test/DAT_O(11) -radix unsigned} {/timer_test/DAT_O(10) -radix unsigned} {/timer_test/DAT_O(9) -radix unsigned} {/timer_test/DAT_O(8) -radix unsigned} {/timer_test/DAT_O(7) -radix unsigned} {/timer_test/DAT_O(6) -radix unsigned} {/timer_test/DAT_O(5) -radix unsigned} {/timer_test/DAT_O(4) -radix unsigned} {/timer_test/DAT_O(3) -radix unsigned} {/timer_test/DAT_O(2) -radix unsigned} {/timer_test/DAT_O(1) -radix unsigned} {/timer_test/DAT_O(0) -radix unsigned}} -subitemconfig {/timer_test/DAT_O(15) {-height 15 -radix unsigned} /timer_test/DAT_O(14) {-height 15 -radix unsigned} /timer_test/DAT_O(13) {-height 15 -radix unsigned} /timer_test/DAT_O(12) {-height 15 -radix unsigned} /timer_test/DAT_O(11) {-height 15 -radix unsigned} /timer_test/DAT_O(10) {-height 15 -radix unsigned} /timer_test/DAT_O(9) {-height 15 -radix unsigned} /timer_test/DAT_O(8) {-height 15 -radix unsigned} /timer_test/DAT_O(7) {-height 15 -radix unsigned} /timer_test/DAT_O(6) {-height 15 -radix unsigned} /timer_test/DAT_O(5) {-height 15 -radix unsigned} /timer_test/DAT_O(4) {-height 15 -radix unsigned} /timer_test/DAT_O(3) {-height 15 -radix unsigned} /timer_test/DAT_O(2) {-height 15 -radix unsigned} /timer_test/DAT_O(1) {-height 15 -radix unsigned} /timer_test/DAT_O(0) {-height 15 -radix unsigned}} /timer_test/DAT_O
add wave -noupdate -divider <NULL>
add wave -noupdate /timer_test/i1/CH
add wave -noupdate -radix unsigned /timer_test/i1/TMRi(0)
add wave -noupdate /timer_test/i1/TMREN(0)
add wave -noupdate /timer_test/i1/TMRIE(0)
add wave -noupdate -radix unsigned /timer_test/i1/CNTi(0)
add wave -noupdate /timer_test/TOUT(0)
add wave -noupdate /timer_test/i1/TMRIF(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {248899 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
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
WaveRestoreZoom {0 ps} {1683277 ps}
