`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class base_test extends uvm_test;

//========================================================
// Factory Registration
//========================================================
`uvm_component_utils(base_test)

//========================================================
// Environment
//========================================================
bridge_env env;

//========================================================
// Configuration
//========================================================
bridge_config cfg;


//========================================================
// Constructor
//========================================================
function new(
    string name = "base_test",
    uvm_component parent = null
);

    super.new(name, parent);

endfunction


//========================================================
// BUILD PHASE
//========================================================
function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Get configuration created by tb_top
    if (!uvm_config_db#(bridge_config)::get(
            this,
            "",
            "bridge_cfg",
            cfg
    )) begin

        `uvm_fatal(
            "BASE_TEST",
            "bridge_cfg not found in config DB"
        )

    end

    if (cfg == null) begin

        `uvm_fatal(
            "BASE_TEST",
            "bridge_cfg is NULL"
        )

    end

    // Create environment
    env = bridge_env::type_id::create(
        "env",
        this
    );

    `uvm_info(
        "BASE_TEST",
        $sformatf(
            "Configuration received. Initial coverage mode = %s",
            cfg.cov_mode.name()
        ),
        UVM_NONE
    )

endfunction


//========================================================
// END OF ELABORATION
//========================================================
function void end_of_elaboration_phase(
    uvm_phase phase
);

    super.end_of_elaboration_phase(phase);

    uvm_top.print_topology();

endfunction


//========================================================
// RUN PHASE
//========================================================
task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    #10ns;

    phase.drop_objection(this);

endtask


endclass

`endif
