class decode_in_sequence_random extends decode_in_sequence;

    function new(string name = "decode_in_sequence_random");
        super.new(name);
    endfunction

    virtual task body();
        Request = new("Request");
        `uvm_info("SEQUENCE", "send transaction request to driver",UVM_MEDIUM)
        start_item(Request);

        if(!Request.randomize()) `uvm_fatal("decode_in_sequence", "driver sequence randomization failed")
            `uvm_info("SEQUENCE", {"Sending transaction to Driver: ",Request.convert2string()},UVM_MEDIUM);
        finish_item(Request);

        get_response(Response);
        // //`uvm_info("SEQUENCE", {"Received transaction from Driver: ",Response.convert2string()},UVM_MEDIUM)
        // $display("\n\n"); // to separate transactions
    endtask

endclass