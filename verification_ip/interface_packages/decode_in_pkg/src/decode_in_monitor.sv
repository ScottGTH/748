class decode_in_monitor extends uvm_monitor;
    
    `uvm_component_utils(decode_in_monitor)
    
    decode_in_transaction trans;

    virtual decode_in_monitor_bfm monitor_bfm;

    uvm_analysis_port #(decode_in_transaction) analysisPort;

    uvm_analysis_port #(decode_in_transaction) monitored_ap;
    
    decode_in_configuration Confg;

    protected time time_stamp = 0;

    int transaction_viewing_stream;

    function new(string name="decode_in_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        // super.build_phase(phase);
        analysisPort = new("analysisPort", this);
        monitored_ap = new("monitored_ap", this);
        if(!uvm_config_db #(decode_in_configuration)::get(null, "*", "in_bfm", Confg)) begin
            `uvm_fatal("FATAL MSG", "Configuration is not properly set")
        end
        `uvm_info("INFO", "decode_in_monitor entered the build phase", UVM_LOW);
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

    virtual task run_phase(uvm_phase phase);
        monitor_bfm.start_monitoring();
    endtask

    virtual function void notify_transaction(
        input logic[15:0] instr_dout,
        input logic[15:0] npc_in,
        input logic[2:0]  Sr,
        input logic       en_decode
    );
        trans = new("trans");
        trans.start_time    =   time_stamp;
        trans.end_time      =   $time;
        time_stamp          =   trans.end_time;
        
        trans.instr_dout    =   instr_dout;
        trans.npc_in        =   npc_in;
        trans.Sr            =   Sr;
        trans.en_decode     =   en_decode;
        analyze(trans);
    endfunction

    virtual function void analyze(decode_in_transaction trans);
        if(Confg.transaction_viewing)
          trans.add_to_wave(transaction_viewing_stream);
        //   `uvm_info("MONITOR_PROXY", t.convert2string(), UVM_HIGH);
        analysisPort.write(trans);
        monitored_ap.write(trans);
    endfunction

endclass
