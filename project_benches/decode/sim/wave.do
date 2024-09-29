onerror {resume}
quietly WaveActivateNextPane {} 0


add wave -noupdate /hdl_top/clk
add wave -noupdate /hdl_top/rst



add wave -noupdate /hdl_top/enDe
add wave -noupdate /hdl_top/npcIn
add wave -noupdate /hdl_top/iDout



WaveRestoreCursors {{Cursor 1} {5000 ns} 0}
quietly wave cursor active 1

update
WaveRestoreZoom {0 ns} {383 ns}