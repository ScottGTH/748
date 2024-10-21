class decode_out_agent  extends uvm_agent; 
  `uvm_component_utils( decode_out_agent )

  decode_out_configuration Confg;
  decode_out_monitor       Monitor;
  decode_out_transaction_coverage      Coverage;

  uvm_analysis_port #(decode_out_transaction) monitored_ap;

  function new( string name = "decode_out_agent", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(decode_out_configuration)::get(null, "*", "decode_out_configuration", Confg)) begin
      `uvm_fatal("decode_out_agent", "Configuration not set properlly");
    end

    if(!uvm_config_db#(virtual decode_out_monitor_bfm)::get(null, "*", "decode_out_monitor_bfm", Confg.monitor_bfm))
      `uvm_fatal("test_top", "test_top config didn't get monitor base functional model")
    
    Monitor = new("decode_out_monitor", this);
    Monitor.monitor_bfm = Confg.monitor_bfm;

    monitored_ap = new("monitored_ap", this);

    if(Confg.enCoverage) begin
      Coverage = new("decode_out_coverage", this);
    end
  endfunction

  virtual function void connect_phase(uvm_phase phase);
        
    Monitor.set_bfm_proxy();

    // analysisPort = Monitor.analysisPort;
    
    // if(Confg.enCoverage == UVM_ACTIVE) Monitor.analysisPort.connect(Coverage.analysis_export);
endfunction
  
endclass

