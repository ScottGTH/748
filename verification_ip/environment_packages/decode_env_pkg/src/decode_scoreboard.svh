class decode_scoreboard extends uvm_component;
    
    `uvm_component_utils(decode_scoreboard)

    `uvm_analysis_imp_decl(_expected_ae)
    uvm_analysis_imp_expected_ae #(decode_out_transaction, decode_scoreboard) exp;
    
    `uvm_analysis_imp_decl(_actual_ae)
    uvm_analysis_imp_actual_ae #(decode_out_transaction, decode_scoreboard) act;
    
    int matchCount = 0;
    int misMatchCount = 0;
    
    decode_out_transaction expReaultQue[$];
    decode_out_transaction expReaultTemp;

    
    int transCount = 0;
    int compareCount = 0;
    // int index;
    bit activity = 0;

    bit wait_to_scbd_empty = 1;

    bit end_of_test_empty_check = 1'b1;
	bit end_of_test_activity_check = 1'b1;
    bit wait_for_scoreboard_empty = 1'b1;

    event receiveEntry;

    function new(string name = "decode_scoreboard", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    // virtual function string compare_message(string header, decode_out_transaction expected, decode_out_transaction actual);
	// 	return {header, "\nEXPECTED: ", expected.convert2string(), "\nACTUAL: ", actual.convert2string()};
	// endfunction

    virtual function void write_expected_ae(decode_out_transaction trans);
        expReaultQue.push_back(trans);
        transCount++;
    endfunction

    virtual function void write_actual_ae(decode_out_transaction trans);
        // activity = 1;
        ->receiveEntry;

        if( expReaultQue.size() == 0 ) begin
            `uvm_error($sformatf("SCOREBOARD_ERROR.%s", this.get_full_name()), "NO PREDICTED ENTRY TO COMPARE")
            return;			
		end

        expReaultTemp = new();
        expReaultTemp = expReaultQue.pop_front();

        if(trans.compare(expReaultTemp)) begin
			matchCount++;
			`uvm_info("COMPARISON","transaction MATCHED: Correct Predictioin",UVM_MEDIUM);
		end else begin
			misMatchCount++;
			`uvm_error("COMPARISON","transaction MIS-MATCHED: Uncorrect Prediction");
		end

        compareCount++;

    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        exp = new("exp", this);
        act = new("act", this);

        // expReaultTemp = new();
    	// expReaultQue.push_back(expReaultTemp);
    endfunction

    virtual function void check_phase(uvm_phase phase);
		super.check_phase(phase);
        
        if( end_of_test_empty_check && ( expReaultQue.size() != 0 ) )
			`uvm_error("EMPTY_CHECK","transactions queue not empty at the end");
			
		if( end_of_test_activity_check && ( transCount == 0 ) )
			`uvm_error("ACTIVITY_CHECK","no transactions fed into the transactions queue");
	endfunction

    virtual task wait_for_scoreboard_drain();
		
		if(expReaultQue.size() == 0) begin
            return;
        end
        else begin
            @receiveEntry;
        end
		
	endtask
	
	virtual function void phase_ready_to_end (uvm_phase phase);
		if(phase.get_name() != "run") 
			return;
		
		if(wait_to_scbd_empty) begin
			phase.raise_objection(this, "Awaiting scoreboard being empty");
			fork
				begin
					wait_for_scoreboard_drain();
					phase.drop_objection(this, "finish waiting for scoreboard being empty");
				end
			join_none
            // wait_for_scoreboard_drain();
            // phase.drop_objection(this, "finish waiting for scoreboard being empty");
		end
		
	endfunction

    virtual function void report_phase (uvm_phase phase);
        super.report_phase(phase);
		uvm_report_info ("SCOREBOARD", $sformatf ("Expected Transactions Received Number: %d",transCount), UVM_NONE);
		uvm_report_info ("SCOREBOARD", $sformatf ("Matched Comparisons: %d",matchCount), UVM_NONE);
		uvm_report_info ("SCOREBOARD", $sformatf ("Unsmatched Comparisons: %d",misMatchCount), UVM_NONE);
        uvm_report_info ("SCOREBOARD", $sformatf ("Comparisons Count: %d",compareCount), UVM_NONE);
    endfunction

endclass