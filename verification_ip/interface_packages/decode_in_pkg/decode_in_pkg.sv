package decode_in_pkg;
    import uvm_pkg::*;
    import para_type_pkg::*;
    `include "uvm_macros.svh"

    `include "src/decode_in_transaction.sv"
    `include "src/decode_in_sequence.sv"
    `include "src/decode_in_sequence_radom.sv"

    `include "src/decode_in_configuration.sv"
    `include "src/decode_in_monitor.sv"
    `include "src/decode_in_driver.sv"
    `include "src/decode_in_coverage.sv"
    `include "src/decode_in_agent.sv"


    // `include "src/decode_in_transaction.svh"
    // `include "src/decode_in_sequence.svh"
    // `include "src/decode_in_sequence_radom.svh"
    // `include "src/decode_in_monitor.svh"
    // `include "src/decode_in_driver.svh"
    // `include "src/decode_in_coverage.svh"
    // `include "src/decode_in_configuration.svh"
    // `include "src/decode_in_agent.svh"
    
    // NOTE: BFMs and Interface of Decode In are in the Makefile
    // DO NOT PUT THEM HERE
endpackage