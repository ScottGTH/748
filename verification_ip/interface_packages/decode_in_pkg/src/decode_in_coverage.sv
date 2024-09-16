class decode_in_coverage extends uvm_subscriber #(.T(decode_in_transaction));
    `uvm_component_utils(decode_in_coverage)

    T trans;

    covergroup trans_coverage;
        option.per_instance = 1;
        option.auto_bin_max = 2048;

        // random transactions
        npc_in:       coverpoint trans.npc_in;
        instr_dout:   coverpoint trans.instr_dout;

        start_time:   coverpoint trans.start_time;
        end_time:     coverpoint trans.end_time;

        randAND:      coverpoint trans.randAND;
        randADD:      coverpoint trans.randADD;

        // decode inputs
        Instr:        coverpoint trans.Instr;
        Dr:           coverpoint trans.Dr;
        Sr1:          coverpoint trans.Sr1;
        Sr2:          coverpoint trans.Sr2;
        baseR:        coverpoint trans.baseR;
        Sr:           coverpoint trans.Sr;

        imm5:         coverpoint trans.imm5;
        pcOffset6:    coverpoint trans.pcOffset6;
        pcOffset9:    coverpoint trans.pcOffset9;
        nzp:          coverpoint trans.nzp;
    endgroup

    function new(string name="decode_in_coverage", uvm_component parent = null);
        super.new(name, parent);
        trans_coverage = new();
    endfunction

    virtual function void write(decode_in_transaction t);
        `uvm_info("COVERAGE", "Transaction Received", UVM_MEDIUM);
        // trans = t;
        trans = new;
        trans.npc_in = t.npc_in;
        trans.instr_dout = t.instr_dout;
        trans.Sr = t.Sr;
        trans.en_decode = t.en_decode;
        
        trans_coverage.sample();
    endfunction

    // virtual function void build_phase(uvm_phase phase);
    //     trans_coverage.set_inst_name($sformatf("trans_coverage_%s", get_full_name()));
    //     `uvm_info("INFO", "decode_in_coverage entered the build phase", UVM_LOW);
    // endfunction


endclass