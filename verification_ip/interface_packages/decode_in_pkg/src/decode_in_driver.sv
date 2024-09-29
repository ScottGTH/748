class decode_in_driver extends uvm_driver #(decode_in_transaction);// #(.REQUEST(decode_in_transaction), .RESPONSE(decode_in_transaction));

    virtual decode_in_driver_bfm driver_bfm;
    decode_in_transaction Request;
    decode_in_transaction Response;  

    function new(string name="decode_in_driver", uvm_component parent = null); 
        super.new(name,parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(Request);
            // `uvm_info("DRIVER", "Received a transaction from the sequencer",UVM_MEDIUM)
            Response = new("Response");
            driver_bfm.iniAndResp(Request.instr_dout, Request.npc_in, Request.Sr, Request.en_decode);
            Response.set_id_info(Request);
            // `uvm_info("DRIVER", "Sending transaction back to sequence through sequencer",UVM_MEDIUM)
            seq_item_port.item_done(Response);
        end
        `uvm_info("INFO", "driver entered the run phase", UVM_LOW);
    endtask

endclass
