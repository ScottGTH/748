package example_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class my_transaction extends uvm_sequence_item;

      rand bit [15:0] data_to_driver;
           bit [15:0] data_from_driver;

      function new(string name=""); 
        super.new(name);
      endfunction

    virtual function string convert2string();
    return $sformatf("data_to_driver:0x%x data_from_driver:0x%x",data_to_driver,data_from_driver);
    endfunction

  endclass

  class my_sequence extends uvm_sequence#(.REQ(my_transaction), .RSP(my_transaction));

      my_transaction req;
      my_transaction rsp;

      function new(string name=""); 
        super.new(name);
      endfunction

      virtual task body();
      req = new("req");
      `uvm_info("SEQUENCE", "Requesting to send transaction to driver",UVM_MEDIUM)
      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("SEQ", "my_sequence::body()- randomization failed")
      `uvm_info("SEQUENCE", {"Sending:",req.convert2string()},UVM_MEDIUM)
      finish_item(req);
      get_response(rsp);
      `uvm_info("SEQUENCE", {"Received:",rsp.convert2string()},UVM_MEDIUM)
      endtask

  endclass  

  class my_driver extends uvm_driver #(.REQ(my_transaction), .RSP(my_transaction));

      my_transaction req;
      my_transaction rsp;

      function new(string name="", uvm_component parent = null); 
        super.new(name,parent);
      endfunction

     virtual task run_phase(uvm_phase phase);
     forever
        begin : forever_loop
          `uvm_info("DRIVER", "Requesting a transaction from the sequencer",UVM_MEDIUM)
          seq_item_port.get_next_item(req);
          `uvm_info("DRIVER", {"Received:",req.convert2string()},UVM_MEDIUM)
          rsp = new("rsp");
          rsp.set_id_info(req);
          rsp.data_from_driver = req.data_to_driver+1;
	        #1ns; // Consume some time to model protocol signaling
          `uvm_info("DRIVER", "Sending transaction back to sequence through sequencer",UVM_MEDIUM)
          seq_item_port.item_done(rsp);
        end 
    endtask
  endclass

  class test_base extends uvm_test;

    `uvm_component_utils( test_base );

    my_driver                       driver;
    uvm_sequencer #(my_transaction) sequencer;
    my_sequence                     sequenc;

    function new(string name="", uvm_component parent = null); 
      super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      sequencer = new("sequencer",this);
      driver  = new("driver",this);
      sequenc = new("sequenc");
    endfunction 

    virtual function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction 

    virtual task  run_phase(uvm_phase phase);
      phase.raise_objection(this, "Objection raised by test_base");
      repeat (5) sequenc.start(sequencer);
      phase.drop_objection(this, "Objection dropped by test_base");
    endtask

  endclass 
 
endpackage

module top();

  import uvm_pkg::*;
  import example_pkg::*;

  initial run_test();

endmodule // top





















