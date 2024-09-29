class decode_in_transaction extends uvm_sequence_item;
    
    
    bit [15:0] npc_in = 16'h3000;
    logic [15:0] instr_dout;
    // rand bit [2:0]  psr;
    rand bit        en_decode;
    time start_time, end_time;

    
    ////// need chcck
    `uvm_object_utils_begin(decode_in_transaction)
        `uvm_field_int(start_time, UVM_ALL_ON)
        `uvm_field_int(end_time, UVM_ALL_ON)
        `uvm_field_int(instr_dout, UVM_ALL_ON)
        `uvm_field_int(npc_in, UVM_ALL_ON)
    `uvm_object_utils_end

    
    rand bit randAND, randADD;                ///en_decode, im

    rand Instr_t Instr;                             ///rand bit [3:0] instr;
    rand bit [2:0] Dr, Sr1, Sr2, baseR, Sr;   ///sr === psr
    // rand bit       im;
    rand bit [4:0] imm5;
    rand bit [5:0] pcOffset6;
    rand bit [8:0] pcOffset9;
    rand NZP_t nzp;                           ///rand bit[2:0] nzp;

    // constraint trans_val{
    //     npc_in >= 3000; // starts counting up at 3000
    //     psr > 3'b000;
    //     nzp > 3'b000; // valid at all 3 bits except 000
    // };

    // constraint instr_val{
    //     instr inside {ADD, AND, NOT, LD, LDR, LDI, LEA, ST, STR, STI, BR, JMP};
    // };

    function new(string name = "decode_in_transaction");
        super.new(name);
    endfunction

    virtual function string convert2string();
        // return {super.convert2string(), $sformatf("NPC input: 0x%h,  Instruction Output: 0x%h, %s", npc_in, instr_dout, Instr)};
        return $sformatf("npc_in: 0x%x, instr_dout: 0x%b, %s", npc_in, instr_dout, Instr);
    endfunction

    function void post_randomize();
        case(Instr)
            ADD:    instr_dout = randADD ? {ADD, Dr, Sr1, 3'b000, Sr2} : {ADD, Dr, Sr1, 1'b1, imm5};
            AND:    instr_dout = randAND ? {AND, Dr, Sr1, 3'b000, Sr2} : {ADD, Dr, Sr1, 1'b1, imm5};
            NOT:    instr_dout = {NOT, Dr, Sr1, 6'b111111};
            LD:     instr_dout = {LD, Dr, pcOffset9};
            LDR:    instr_dout = {LDR, Dr, baseR, pcOffset6};
            LDI:    instr_dout = {LDI, Dr, pcOffset9};
            LEA:    instr_dout = {LEA, Dr, pcOffset9};
            ST:     instr_dout = {ST, Sr, pcOffset9};
            STR:    instr_dout = {STR, Sr, baseR, pcOffset6};
            STI:    instr_dout = {STI, Sr, pcOffset9};
            BR:     instr_dout = {BR, nzp, pcOffset9};
            JMP:    instr_dout = {JMP, 3'b000, baseR, 6'b000000};
            default: `uvm_fatal("Transaction", "Invalid Instruction Type")
        endcase
    endfunction

    // Later Use
    virtual function void add_to_wave(int transaction_viewing_stream_h);
        int transaction_view_h;
        transaction_view_h = $begin_transaction(transaction_viewing_stream_h, "decode_in_transaction", start_time);
        $add_attribute(transaction_view_h, npc_in, "npc_in");
        $add_attribute(transaction_view_h, instr_dout, "instr_dout");
        $add_attribute( transaction_view_h, Sr, "Sr" );
        $add_attribute( transaction_view_h, en_decode, "en_decode" );
        $end_transaction(transaction_view_h, end_time);
        $free_transaction(transaction_view_h);
    endfunction

endclass
