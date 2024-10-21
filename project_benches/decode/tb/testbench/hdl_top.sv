import uvm_pkg::*;
`include "uvm_macros.svh"
import decode_in_pkg::*;
import decode_out_pkg::*;
import decode_test_pkg::*;

module hdl_top();
    logic clk;
    logic rst;

    wire [15:0] iDout;
    wire [15:0] npcIn;
    wire [2:0] sr;
    wire enDe;

    initial begin
        clk = 1'b0;
        #10;
        forever #5 clk =~clk;
    end

    initial begin
        rst = 1'b1;
        #22;
        rst = 1'b0;
    end

    decode_in_if decodeInInterface(.clock(clk), .reset(rst), .instr_dout(iDout), .npc_in(npcIn), .Sr(sr), .en_decode(enDe));
    initial uvm_config_db#(virtual decode_in_if)::set(null, "*", "decode_in_if", decodeInInterface);

    decode_in_monitor_bfm monitorBfm(decodeInInterface);
    initial uvm_config_db#(virtual decode_in_monitor_bfm)::set(null, "*", "decode_in_monitor_bfm", monitorBfm);
    
    decode_in_driver_bfm driverBfm(decodeInInterface);
    initial uvm_config_db#(virtual decode_in_driver_bfm)::set(null, "*", "decode_in_driver_bfm", driverBfm);

    decode_out_if decodeOutInterface(.clock(clk), .reset(rst), .instr_dout(instr_dout), .npc_in(npc_in), .E_control_i(E_control_i), .Mem_control_i(Mem_control_i), .W_control_i(W_control_i));
    initial uvm_config_db#(virtual decode_out_if)::set(null, "*", "decode_out_if", decodeOutInterface);
    decode_out_monitor_bfm monitorBfmOut(decodeOutInterface);
    initial uvm_config_db#(virtual decode_out_monitor_bfm)::set(null, "*", "decode_out_monitor_bfm", monitorBfmOut);

    Decode DUT(
      .clock(clk),
  	  .reset(rst),
  	  .enable_decode(decodeInInterface.en_decode),
  	  .dout(decodeInInterface.instr_dout),
  	  .npc_in(decodeInInterface.npc_in),
  	 .W_Control(decodeOutInterface.W_control_i),
  	 .Mem_Control(decodeOutInterface.Mem_control_i),
  	 .E_Control(decodeOutInterface.E_control_i),
  	 .IR(decodeOutInterface.instr_dout),
  	 .npc_out(decodeOutInterface.npc_in)
    );

endmodule