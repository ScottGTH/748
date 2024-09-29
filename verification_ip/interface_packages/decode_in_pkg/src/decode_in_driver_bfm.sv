import decode_in_pkg::*;

interface decode_in_driver_bfm(decode_in_if bus);

    logic clock;
    logic reset;
    logic [15:0] instr_dout;
    logic [15:0] idOut;
    logic [15:0] npc_in;
    logic [15:0] npcOut;
    logic [2:0] srOut;
    logic en_decode;
    logic enOut;

    assign bus.instr_dout = idOut;
    assign bus.npc_in = npcOut;
    assign bus.Sr = srOut;
    assign bus.en_decode = enOut;

    assign clock = bus.clock;
    assign reset = bus.reset;

    assign npc_in = bus.npc_in;
    assign en_decode = bus.en_decode;
    
    task iniAndResp( input bit [15:0] instr_dout,
                                    input bit [15:0] npc_in,
                                    input bit [2:0]  Sr, 
                                    input bit        en_decode );
        @(posedge bus.clock);
        //wait for pos clk
        idOut = instr_dout;
        npcOut = npc_in;
        srOut = Sr;
        // bus.en_decode = en_decode;
    endtask

    task clear();
        enOut =0;
        idOut =0;
        npcOut=16'h3000;
    endtask
    
    task driveEnable();
        enOut = 1'b1;
    endtask

    task driveDisable();
        enOut = 1'b0;
    endtask
endinterface