import decode_in_pkg::*;

interface decode_in_monitor_bfm(decode_in_if bus);

    decode_in_monitor proxy;

    task do_monitor(output bit [15:0] instrDoutBfm, output bit [15:0] npcInBfm, 
                    output bit [2:0] srBfm, output bit enDecodeBfm);
        
        instrDoutBfm = bus.instr_dout;
        npcInBfm = bus.npc_in;
        srBfm = bus.Sr;
        enDecodeBfm = bus.en_decode;
    endtask

    initial begin
        while(bus.reset == 1'b1);
        repeat(7) @(posedge bus.clock);
        forever begin
            bit [15:0] instrDoutBfm;
            bit [15:0] npcInBfm;
            bit [2:0]  srBfm;
            bit        enDecodeBfm;
            @(posedge bus.clock);
            do_monitor(npcInBfm, instrDoutBfm, srBfm, enDecodeBfm);
            proxy.notify_transaction(npcInBfm, instrDoutBfm, srBfm, enDecodeBfm);
        end
    end

endinterface