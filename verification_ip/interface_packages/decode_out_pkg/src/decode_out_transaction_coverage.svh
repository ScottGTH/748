class decode_out_transaction_coverage  extends uvm_subscriber #(.T(decode_out_transaction ));

  `uvm_component_utils( decode_out_transaction_coverage )

  T coverage_trans;

  covergroup decode_out_transaction_cg;
    option.auto_bin_max=1024;
    option.per_instance=1;
    instrDoutBfm: coverpoint coverage_trans.instrDoutBfm;
    npcInBfm: coverpoint coverage_trans.npcInBfm;
    E_control_i: coverpoint coverage_trans.E_control_i;
    W_control_i: coverpoint coverage_trans.W_control_i;
    Mem_control_i: coverpoint coverage_trans.Mem_control_i;
  endgroup

  function new(string name="decode_out_transaction_coverage", uvm_component parent=null);
    super.new(name,parent);
    decode_out_transaction_cg=new;
  endfunction

  virtual function void write (T t);
    `uvm_info("COVERAGE", "Transaction Received", UVM_MEDIUM);
    coverage_trans = t;
    decode_out_transaction_cg.sample();
  endfunction


endclass

