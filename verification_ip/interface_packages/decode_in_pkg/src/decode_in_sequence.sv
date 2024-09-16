class decode_in_sequence extends uvm_sequence#(.REQUEST(decode_in_transaction), .RESPONSE(decode_in_transaction));

    decode_in_transaction Request;
    decode_in_transaction Response;

    function new(string name="decode_in_sequence"); 
        super.new(name);
    endfunction

endclass