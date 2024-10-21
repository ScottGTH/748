class decode_out_transaction  extends uvm_sequence_item;

  `uvm_object_utils( decode_out_transaction )

  bit [15:0] instrDoutBfm;
  bit [15:0] npcInBfm;
  bit [5:0]  E_control_i;
  bit [1:0]  W_control_i;
  bit        Mem_control_i;

  time start_time, end_time;

  function new( string name = "" );
    super.new( name );
  endfunction

  virtual function string convert2string();
    return $sformatf("W_control:0x%x \nE_control:0x%x \nMem_control:0x%x \nIR:0x%x \nnpc_out:0x%x ",W_control_i,E_control_i,Mem_control_i,instrDoutBfm,npcInBfm);
  endfunction

  virtual function void do_print(uvm_printer printer);
    $display(convert2string());
  endfunction

  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    decode_out_transaction  RHS;
    if (!$cast(RHS,rhs)) return 0;
    return (super.do_compare(rhs,comparer)
            &&(this.instrDoutBfm == RHS.instrDoutBfm)
            &&(this.npcInBfm == RHS.npcInBfm)
            &&(this.E_control_i == RHS.E_control_i)
            &&(this.W_control_i == RHS.W_control_i)
            &&(this.Mem_control_i == RHS.Mem_control_i)
            );
  endfunction

  virtual function void do_copy (uvm_object rhs);
    decode_out_transaction  RHS;
    assert($cast(RHS,rhs));
    super.do_copy(rhs);
    this.instrDoutBfm = RHS.instrDoutBfm;
    this.npcInBfm = RHS.npcInBfm;
    this.E_control_i = RHS.E_control_i;
    this.W_control_i = RHS.W_control_i;
    this.Mem_control_i = RHS.Mem_control_i;
  endfunction

  virtual function void add_to_wave(int transaction_viewing_stream_h);
    int transaction_view_h;
    transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"decode_out_transaction",start_time);

    // super.add_to_wave(transaction_view_h);
    $add_attribute(transaction_view_h,instrDoutBfm,"instrDoutBfm");
    $add_attribute(transaction_view_h,npcInBfm,"npcInBfm");
    $add_attribute(transaction_view_h,E_control_i,"E_control_i");
    $add_attribute(transaction_view_h,W_control_i,"W_control_i");
    $add_attribute(transaction_view_h,Mem_control_i,"Mem_control_i");
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass

