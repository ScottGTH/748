import decode_test_pkg::*;

class test_top extends uvm_test;
  `uvm_component_utils(test_top)

  decode_in_agent Agent;
  decode_in_configuration Confg;
  decode_in_sequence_random seqRand;

  decode_environment decode_env;
  decode_env_configuration decode_env_cfg;

  string environment_path = "*";
  string interface_names [] = '{"in_bfm","out_bfm"};
  uvm_active_passive_enum interface_activity[] = {UVM_ACTIVE,UVM_PASSIVE};

  bit enCoverage = 1;
  bit transaction_viewing = 1;

  virtual decode_in_if bus;

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    decode_env_cfg = decode_env_configuration::type_id::create("env_cfg", this);
    decode_env_cfg.initialize(environment_path, interface_names, interface_activity);
    decode_env = decode_environment::type_id::create("env", this);
    decode_env.set_config(decode_env_cfg);

    // seqRand = decode_in_sequence_random::type_id::create("in_seq",this);

    if(!uvm_config_db #(virtual decode_in_if)::get(null, "*", "decode_in_if", bus)) begin
      `uvm_fatal(get_full_name(),{"virtual interface must be set for:","decode_in_if"})
    end      
    // Confg = new("Agent Configuration");
    // Agent = new("Agent", this);
    // if(!uvm_config_db#(virtual decode_in_driver_bfm)::get(null, "*", "decode_in_driver_bfm", Confg.driver_bfm))
    // `uvm_fatal("test_top", "test_top config didn't get driver base functional model")
    // if(!uvm_config_db#(virtual decode_in_monitor_bfm)::get(null, "*", "decode_in_monitor_bfm", Confg.monitor_bfm))
    // `uvm_fatal("test_top", "test_top config didn't get monitor base functional model")
    
    // Confg.UVMState = UVMState;
    // Confg.enCoverage = enCoverage;
    // Confg.transaction_viewing = transaction_viewing;

    // if(!uvm_config_db#(bit)::get(null,"*", "wave", cfg.transaction_viewing))
    // `uvm_fatal("test_top","test_top config could not get wave")
    // if(!uvm_config_db#(bit)::get(null,"*", "enabled", cfg.UVMState))
    // `uvm_fatal("test_top","test_top config could not get enabled")
    // if(!uvm_config_db#(bit)::get(null,"*", "coverage", cfg.enCoverage))
    // `uvm_fatal("test_top","test_top config could not get coverage")
    
    // uvm_config_db#(decode_in_configuration)::set(null, "*", "decode_in_configuration", Confg);
    // `uvm_info(get_full_name(), {"\n\nAgent Configuration: ", Confg.convert2string()}, UVM_MEDIUM)
    
    // if(Confg.UVMState == UVM_ACTIVE) begin
      
    //   //`uvm_info("TEST TOP", "random sequence instantiated", UVM_MEDIUM)
    // end
  endfunction 

  virtual task  run_phase(uvm_phase phase);
    phase.raise_objection(this, "Objection raised by test_base");
    
    decode_env.decodeInAgt.Confg.driver_bfm.clear();
    decode_env.decodeInAgt.Confg.wait_for_reset();
    // wait (bus.reset == 1'b0);
    repeat (3) @(posedge bus.clock);
    // @(posedge bus.clock);
    seqRand = new("sequence_random");
    decode_env.decodeInAgt.Confg.driver_bfm.driveEnable();
    
    repeat (50) seqRand.start(decode_env.decodeInAgt.Sequencer);
    
    decode_env.decodeInAgt.Confg.driver_bfm.driveDisable();
    @(posedge bus.clock);
    phase.drop_objection(this, "Objection dropped by test_base");
    `uvm_info("INFO", "test_top run phase complete", UVM_LOW);
  endtask

endclass