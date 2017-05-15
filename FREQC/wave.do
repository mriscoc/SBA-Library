onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /freqc_test/C_I(0)
add wave -noupdate /freqc_test/C_I(1)
add wave -noupdate /freqc_test/C_I(2)
add wave -noupdate /freqc_test/C_I(3)
add wave -noupdate /freqc_test/i1/W
add wave -noupdate -radix unsigned -childformat {{/freqc_test/ADR_I(15) -radix unsigned} {/freqc_test/ADR_I(14) -radix unsigned} {/freqc_test/ADR_I(13) -radix unsigned} {/freqc_test/ADR_I(12) -radix unsigned} {/freqc_test/ADR_I(11) -radix unsigned} {/freqc_test/ADR_I(10) -radix unsigned} {/freqc_test/ADR_I(9) -radix unsigned} {/freqc_test/ADR_I(8) -radix unsigned} {/freqc_test/ADR_I(7) -radix unsigned} {/freqc_test/ADR_I(6) -radix unsigned} {/freqc_test/ADR_I(5) -radix unsigned} {/freqc_test/ADR_I(4) -radix unsigned} {/freqc_test/ADR_I(3) -radix unsigned} {/freqc_test/ADR_I(2) -radix unsigned} {/freqc_test/ADR_I(1) -radix unsigned} {/freqc_test/ADR_I(0) -radix unsigned}} -subitemconfig {/freqc_test/ADR_I(15) {-height 15 -radix unsigned} /freqc_test/ADR_I(14) {-height 15 -radix unsigned} /freqc_test/ADR_I(13) {-height 15 -radix unsigned} /freqc_test/ADR_I(12) {-height 15 -radix unsigned} /freqc_test/ADR_I(11) {-height 15 -radix unsigned} /freqc_test/ADR_I(10) {-height 15 -radix unsigned} /freqc_test/ADR_I(9) {-height 15 -radix unsigned} /freqc_test/ADR_I(8) {-height 15 -radix unsigned} /freqc_test/ADR_I(7) {-height 15 -radix unsigned} /freqc_test/ADR_I(6) {-height 15 -radix unsigned} /freqc_test/ADR_I(5) {-height 15 -radix unsigned} /freqc_test/ADR_I(4) {-height 15 -radix unsigned} /freqc_test/ADR_I(3) {-height 15 -radix unsigned} /freqc_test/ADR_I(2) {-height 15 -radix unsigned} /freqc_test/ADR_I(1) {-height 15 -radix unsigned} /freqc_test/ADR_I(0) {-height 15 -radix unsigned}} /freqc_test/ADR_I
add wave -noupdate -radix unsigned /freqc_test/DAT_O
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {641552063 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {2100 us}
