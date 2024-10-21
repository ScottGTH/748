class decode_env_configuration extends uvm_object;
    `uvm_object_utils(decode_env_configuration)

    decode_in_configuration decodeInConfig;
    decode_out_configuration decodeOutConfig;


    function new(string name = "decode_env_configuration");
        super.new(name);
        decodeInConfig = decode_in_configuration::type_id::create("decodeInConfig");
        decodeOutConfig = decode_out_configuration::type_id::create("decodeOutConfig");
        
    endfunction

    virtual function void initialize(string envPath,
                                    string infName[],
                                    uvm_active_passive_enum infActivity[]);
        decodeInConfig.initialize(infActivity[0], envPath, infName[0]);
        decodeOutConfig.initialize(infActivity[1], envPath, infName[1]);

        // uvm_config_db #(decode_env_configuration)::set(null, envPath, UVMF_AGENT_CONFIG, this);
        // uvm_config_db #(decode_env_configuration)::set(null, envPath, UVMF_AGENT_CONFIG, this);
    endfunction

endclass