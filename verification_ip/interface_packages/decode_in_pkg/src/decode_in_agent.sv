class decode_in_agent extends uvm_agent;
    `uvm_component_utils(decode_in_agent)

    // uvm_analysis_port #(decode_in_transaction) analysisPort;
  
    decode_in_configuration Confg;
    decode_in_driver        Driver;
    decode_in_monitor       Monitor;
    decode_in_coverage      Coverage;
    uvm_sequencer #(decode_in_transaction) Sequencer;
  
    function new(string name = "decode_in_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
  
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db #(decode_in_configuration)::get(null, "*", "decode_in_configuration", Confg)) begin
        `uvm_fatal("decode_in_agent", "Configuration not set properlly");
      end
      
      Monitor = new("decode_in_monitor", this);
      Monitor.monitor_bfm = Confg.monitor_bfm;

      if(Confg.enCoverage) begin
        Coverage = new("decode_in_coverage", this);
      end
      
      if(Confg.UVMState) begin
        `uvm_info("AGENT", "agent configured as ACTIVE", UVM_MEDIUM);
        Driver = new("decode_in_driver", this);
        Sequencer = new("decode_in_sequencer", this);
        Driver.driver_bfm = Confg.driver_bfm;
      end
      else begin
        `uvm_info("AGENT", "agent configured as PASSIVE", UVM_MEDIUM);
      end
    endfunction
  
    virtual function void connect_phase(uvm_phase phase);
        
        Monitor.set_bfm_proxy();

        // analysisPort = Monitor.analysisPort;

        if(Confg.UVMState)   Driver.seq_item_port.connect(Sequencer.seq_item_export);
            //`uvm_info("AGENT", "driver connect successful", UVM_MEDIUM)
        
        if(Confg.enCoverage) Monitor.analysisPort.connect(Coverage.analysis_export);
    endfunction
  
  endclass