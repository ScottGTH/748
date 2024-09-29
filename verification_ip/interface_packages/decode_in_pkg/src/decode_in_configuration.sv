class decode_in_configuration extends uvm_object;
    `uvm_object_utils(decode_in_configuration)

    virtual decode_in_monitor_bfm monitor_bfm;
    virtual decode_in_driver_bfm driver_bfm;

    uvm_active_passive_enum  UVMState;    ///state  //enabled
    bit enCoverage;   ///enable coverage
    bit transaction_viewing;

    function new(string name="decode_in_configuration");
        super.new(name);
    endfunction

    // // configuration variables
    // state  enable_coverage  enable_transaction_viewing

    virtual function string convert2string();
        return {super.convert2string(), $sformatf("Status: %s, enCoverage: %s, Transaction Viewing: %s", UVMState ? "Active" : "Passive", enCoverage ? "Enabled" : "Disabled", transaction_viewing ? "Enabled" : "Disabled")};
    endfunction

endclass