class decode_predictor extends uvm_subscriber #(decode_in_transaction);
    `uvm_component_utils(decode_predictor)

    uvm_analysis_port #(decode_out_transaction) decodePredAP;
    
    decode_out_transaction decodeOutTrans;
    
    bit dModel;

    // decode_env_configuration decodeEnvConfig;
    
    function new (string name = "decode_predictor", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        // super.build_phase(phase);
        decodePredAP = new("decodePredAP", this);
        
    endfunction

    virtual function void write(decode_in_transaction t);
        decodeOutTrans = new("decodeOutTrans");
        dModel = lc3_prediction_pkg::decode_model(t.instr_dout, 
                            t.npc_in, 
                            decodeOutTrans.instrDoutBfm, 
                            decodeOutTrans.npcInBfm, 
                            decodeOutTrans.E_control_i, 
                            decodeOutTrans.W_control_i, 
                            decodeOutTrans.Mem_control_i);
        
        decodePredAP.write(decodeOutTrans);

    endfunction
endclass