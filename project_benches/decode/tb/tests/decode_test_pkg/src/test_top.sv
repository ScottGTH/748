import decode_test_pkg::*;

class test_top extends uvm_test;
  `uvm_component_utils(test_top)

  decode_in_agent Agent;
  decode_in_configuration Confg;
  decode_in_sequence_random seqRand;

  uvm_active_passive_enum UVMState = UVM_ACTIVE;
  bit enCoverage = 1;
  bit transaction_viewing = 1;

  virtual decode_in_if bus;

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual decode_in_if)::get(null, "*", "decode_in_if", bus)) begin
      `uvm_fatal(get_full_name(),{"virtual interface must be set for:","decode_in_if"})
    end      
    Confg = new("Agent Configuration");
    Agent = new("Agent", this);
    if(!uvm_config_db#(virtual decode_in_driver_bfm)::get(null, "*", "decode_in_driver_bfm", Confg.driver_bfm))
    `uvm_fatal("test_top", "test_top config didn't get driver base functional model")
    if(!uvm_config_db#(virtual decode_in_monitor_bfm)::get(null, "*", "decode_in_monitor_bfm", Confg.monitor_bfm))
    `uvm_fatal("test_top", "test_top config didn't get monitor base functional model")
    
    Confg.UVMState = UVMState;
    Confg.enCoverage = enCoverage;
    Confg.transaction_viewing = transaction_viewing;

    // if(!uvm_config_db#(bit)::get(null,"*", "wave", cfg.transaction_viewing))
    // `uvm_fatal("test_top","test_top config could not get wave")
    // if(!uvm_config_db#(bit)::get(null,"*", "enabled", cfg.UVMState))
    // `uvm_fatal("test_top","test_top config could not get enabled")
    // if(!uvm_config_db#(bit)::get(null,"*", "coverage", cfg.enCoverage))
    // `uvm_fatal("test_top","test_top config could not get coverage")
    
    uvm_config_db#(decode_in_configuration)::set(null, "*", "decode_in_configuration", Confg);
    // `uvm_info(get_full_name(), {"\n\nAgent Configuration: ", Confg.convert2string()}, UVM_MEDIUM)
    
    // if(Confg.UVMState == UVM_ACTIVE) begin
      
    //   //`uvm_info("TEST TOP", "random sequence instantiated", UVM_MEDIUM)
    // end
  endfunction 

  virtual task  run_phase(uvm_phase phase);
    phase.raise_objection(this, "Objection raised by test_base");

    Confg.driver_bfm.clear();
    wait (bus.reset == 1'b0);
    repeat (3) @(posedge bus.clock);
    // @(posedge bus.clock);
    seqRand = new("sequence_random");
    Confg.driver_bfm.driveEnable();
    if(Confg.UVMState == UVM_ACTIVE) begin
      repeat (50) seqRand.start(Agent.Sequencer);
    end
    Confg.driver_bfm.driveDisable();
    @(posedge bus.clock);
    phase.drop_objection(this, "Objection dropped by test_base");
    `uvm_info("INFO", "test_top run phase complete", UVM_LOW);
  endtask

endclass