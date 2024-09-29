interface decode_in_if#()(

    input tri [15:0] instr_dout,
    input tri [15:0] npc_in,
    input tri [2:0]  Sr,
    input tri        en_decode,
    input tri        clock,
    input tri        reset
);

endinterface