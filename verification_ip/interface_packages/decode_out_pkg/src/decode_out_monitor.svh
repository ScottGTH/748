class decode_out_monitor  extends uvm_monitor;
  `uvm_component_utils( decode_out_monitor )

  decode_out_transaction trans;

  virtual decode_out_monitor_bfm monitor_bfm;

  uvm_analysis_port #(decode_out_transaction) analysisPort;

  // uvm_analysis_port #(decode_out_transaction) monitored_ap;
  
  decode_out_configuration Confg;

  protected time time_stamp = 0;

  int transaction_viewing_stream;

  function new( string name = "decode_out_monitor", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // super.build_phase(phase);
    analysisPort = new("analysisPort", this);
    if(!uvm_config_db #(decode_out_configuration)::get(null, "*", "out_bfm", Confg)) begin
        `uvm_fatal("FATAL MSG", "Configuration is not properly set")
    end
    `uvm_info("INFO", "decode_out_monitor entered the build phase", UVM_LOW);
  endfunction

  virtual function void start_of_simulation_phase(uvm_phase phase);
    if(Confg.transaction_viewing) begin
        transaction_viewing_stream = $create_transaction_stream({"..", get_full_name(),".","txn_stream"});
    end
    `uvm_info("INFO", "decode_in_monitor entered start of sim phase", UVM_LOW);
  endfunction

  virtual function void set_bfm_proxy();
      monitor_bfm.proxy = this;
  endfunction

// // ***************************************************************************              
//   virtual task run_phase(uvm_phase phase);                                                                                                                        
//     wait(monitor_bfm.bus.reset);
//     @(posedge monitor_bfm.bus.clock);  ->monitor_bfm.go;                                                 
//   endtask                                                                                    


  virtual function void notify_transaction( input bit [15:0] instrDoutBfm, input bit [15:0] npcInBfm, 
                                            input bit [5:0]  E_control_i,  input bit [1:0]  W_control_i,
                                            input bit Mem_control_i);
      trans = new("trans");
      trans.start_time    =   time_stamp;
      trans.end_time      =   $time;
      time_stamp          =   trans.end_time;
      
      trans.instrDoutBfm    =   instrDoutBfm;
      trans.npcInBfm        =   npcInBfm;
      trans.E_control_i     =   E_control_i;
      trans.W_control_i     =   W_control_i;
      trans.Mem_control_i   =   Mem_control_i;
      analyze(trans);
  endfunction

  virtual function void analyze(decode_out_transaction trans);
      if(Confg.transaction_viewing)
        trans.add_to_wave(transaction_viewing_stream);
      // analysisPort.write(trans);
      // monitored_ap.write(trans);
endfunction
endclass

