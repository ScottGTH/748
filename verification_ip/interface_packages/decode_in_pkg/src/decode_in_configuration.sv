class decode_in_configuration extends uvm_object;
    `uvm_object_utils(decode_in_configuration)

    virtual decode_in_monitor_bfm monitor_bfm;
    virtual decode_in_driver_bfm driver_bfm;

    bit UVMState = 1;    ///state  //enabled
    bit enCoverage = 1;   ///enable coverage
    bit transaction_viewing = 1;

    // // configuration variables
    // uvm_active_passive_enum state;
    // bit enable_coverage;
    // bit enable_transaction_viewing;

    function new(string name="decode_in_configuration");
        super.new(name);
    endfunction

    virtual function string convert2string();
        return {super.convert2string(), $sformatf("Status: %s, enCoverage: %s, Transaction Viewing: %s", UVMState ? "Active" : "Passive", enCoverage ? "UVMState" : "Disabled", transaction_viewing ? "Enabled" : "Disabled")};
    endfunction

    // // Agent configuration retrieves BFM handles using uvm_config_db
    // function void startup(input uvm_active_passive_enum mode, input en_cover, input bit en_view);
    // if(!uvm_config_db#(virtual decode_in_monitor_bfm)::get(null, "*", "decode_in_monitor_bfm", monitor_bfm)) begin
    //     `uvm_fatal(get_full_name(),{"virtual interface must be set for:","decode_in_monitor_bfm"})
    // end
    // if(!uvm_config_db#(virtual decode_in_driver_bfm)::get(null, "*", "decode_in_driver_bfm", driver_bfm)) begin
    //     `uvm_fatal(get_full_name(),{"virtual interface must be set for:","decode_in_driver_bfm"})
    // end
    // state = mode;
    // enable_coverage = en_cover;
    // enable_transaction_viewing = en_view;
    // endfunction

endclass