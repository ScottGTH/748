class decode_in_configuration extends uvm_object;
    `uvm_object_utils(decode_in_configuration)

    virtual decode_in_monitor_bfm monitor_bfm;
    virtual decode_in_driver_bfm driver_bfm;

    uvm_active_passive_enum  UVMState;    ///state  //enabled
    bit enCoverage = 1;   ///enable coverage
    bit transaction_viewing = 1;

    function new(string name="decode_in_configuration");
        super.new(name);
    endfunction

    virtual task wait_for_reset();
        monitor_bfm.wait_for_reset();
    endtask

    virtual task wait_for_num_clocks(int clocks);
        monitor_bfm.wait_for_num_clocks(clocks);
    endtask

    virtual function void initialize(uvm_active_passive_enum activity,string agent_path,string interface_name);
        // super.initialize(activity, agent_path, interface_name);

        UVMState = activity;

        uvm_config_db #(decode_in_configuration)::set(null, agent_path, "decode_in_configuration", this);

        uvm_config_db #(decode_in_configuration)::set(null, agent_path, interface_name, this);

    endfunction

    virtual function string convert2string();
        return {super.convert2string(), $sformatf("Status: %s, enCoverage: %s, Transaction Viewing: %s", UVMState ? "Active" : "Passive", enCoverage ? "Enabled" : "Disabled", transaction_viewing ? "Enabled" : "Disabled")};
    endfunction

endclass