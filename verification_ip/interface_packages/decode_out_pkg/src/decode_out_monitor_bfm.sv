
import decode_out_pkg::*;

interface decode_out_monitor_bfm(decode_out_if bus);

  decode_out_monitor proxy;

  task do_monitor(output bit [15:0] instrDoutBfm, output bit [15:0] npcInBfm, 
                  output bit [5:0]  E_control_i, bit [1:0]  W_control_i,
                  output bit Mem_control_i);
      
      instrDoutBfm = bus.instr_dout;
      npcInBfm = bus.npc_in;
      E_control_i = bus.E_control_i;
      W_control_i = bus.W_control_i;
      Mem_control_i = bus.Mem_control_i;
  endtask

    // task do_wait_for_posedge();                                                          
    //     @(posedge bus.clock) ;                                                                             
    // endtask 

  initial begin
      while(bus.reset == 1'b1);
      repeat(7) @(posedge bus.clock);
      forever begin
          bit [15:0] instrDoutBfm;
          bit [15:0] npcInBfm;
          bit [5:0]  E_control_i;
          bit [1:0]  W_control_i;
          bit        Mem_control_i;
          @(posedge bus.clock);
          do_monitor(npcInBfm, instrDoutBfm, E_control_i, W_control_i, Mem_control_i);
          proxy.notify_transaction(npcInBfm, instrDoutBfm, E_control_i, W_control_i, Mem_control_i);
      end
      @(posedge bus.clock);
  end

endinterface
