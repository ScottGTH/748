import uvm_pkg::*;
`include "uvm_macros.svh"
import decode_in_pkg::*;
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


endmodule