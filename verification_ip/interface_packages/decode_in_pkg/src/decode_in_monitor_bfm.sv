import decode_in_pkg::*;

interface decode_in_monitor_bfm(decode_in_if bus);

    decode_in_monitor proxy;

    tri clock_i;
    tri reset_i;

    assign clock_i = bus.clock;
    assign reset_i = bus.reset;

    event go;

    task do_monitor(output bit [15:0] instrDoutBfm, output bit [15:0] npcInBfm, 
                    output bit [2:0] srBfm, output bit enDecodeBfm);
        
        instrDoutBfm = bus.instr_dout;
        npcInBfm = bus.npc_in;
        srBfm = bus.Sr;
        enDecodeBfm = bus.en_decode;
    endtask

    task wait_for_reset(); 
        @(posedge clock_i) ;                                                                    
        do_wait_for_reset();                                                                   
    endtask       

    task do_wait_for_reset(); 
        wait ( reset_i === 0 ) ;                                                              
        @(posedge clock_i) ;                                                                             
    endtask  

    function void start_monitoring();   
        -> go;
    endfunction 

    initial begin
        @go;
        repeat(6) @(posedge bus.clock);
        forever begin
            bit [15:0] instrDoutBfm;
            bit [15:0] npcInBfm;
            bit [2:0]  srBfm;
            bit        enDecodeBfm;
            @(posedge clock_i);
            do_monitor(npcInBfm, instrDoutBfm, srBfm, enDecodeBfm);
            proxy.notify_transaction(npcInBfm, instrDoutBfm, srBfm, enDecodeBfm);
        end
    end

endinterface