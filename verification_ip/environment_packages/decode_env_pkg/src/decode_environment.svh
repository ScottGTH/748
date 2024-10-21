class decode_environment extends uvm_env;
    `uvm_component_utils(decode_environment)

    decode_in_agent decodeInAgt;
    decode_out_agent decodeOutAgt;
    decode_scoreboard decodeSCB;
    decode_predictor decodePred;

    decode_env_configuration decodeEnvConfig;

    function new(string name = "decode_environment", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void set_config(decode_env_configuration cfg);
		decodeEnvConfig = cfg;
	endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        decodeInAgt = decode_in_agent::type_id::create("decodeInAgt", this);
        decodeOutAgt = decode_out_agent::type_id::create("decodeOutAgt", this);
        decodeSCB = decode_scoreboard::type_id::create("decodeSCB", this);
        decodePred = decode_predictor::type_id::create("decodePred", this);


    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connects decode_in agent to predictor
        decodeInAgt.monitored_ap.connect(decodePred.analysis_export);
        // Connects predictor to scoreboard
        decodePred.decodePredAP.connect(decodeSCB.exp);
        // Connects decode_out agent to scoreboard
        decodeOutAgt.monitored_ap.connect(decodeSCB.act);
    endfunction

endclass
