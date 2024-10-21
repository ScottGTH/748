class decode_out_configuration  extends uvm_object;  
  `uvm_object_utils( decode_out_configuration )

  virtual decode_out_monitor_bfm monitor_bfm;

  bit enCoverage = 1;   ///enable coverage
  bit transaction_viewing = 1;
  uvm_active_passive_enum  UVMState;

  function new( string name = "decode_out_configuration" );
    super.new( name );
  endfunction

  virtual function void initialize(uvm_active_passive_enum activity,
                                  string agent_path,
                                  string interface_name);
    // super.initialize(activity, agent_path, interface_name);
    UVMState = activity;
    uvm_config_db #(decode_out_configuration)::set(null, agent_path, "decode_out_configuration", this);
    
    uvm_config_db #(decode_out_configuration)::set(null, agent_path, interface_name, this);

  endfunction

  virtual function string convert2string ();
    return $sformatf("");
  endfunction


endclass

