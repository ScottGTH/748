interface  decode_out_if 

  (
  input tri clock, 
  input tri reset,
  inout tri [1:0] W_control_i,
  inout tri  Mem_control_i,
  inout tri [5:0] E_control_i,
  inout tri [15:0] instr_dout,
  inout tri [15:0] npc_in
  );

modport monitor_port 
  (
  input clock,
  input reset,
  input W_control_i,
  input Mem_control_i,
  input E_control_i,
  input instr_dout,
  input npc_in
  );

modport initiator_port 
  (
  input clock,
  input reset,
  input W_control_i,
  input Mem_control_i,
  input E_control_i,
  input instr_dout,
  input npc_in
  );

modport responder_port 
  (
  input clock,
  input reset,  
  output W_control_i,
  output Mem_control_i,
  output E_control_i,
  output instr_dout,
  output npc_in
  );

endinterface


