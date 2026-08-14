`ifndef RESET_TEST_SV
`define RESET_TEST_SV

class reset_test extends base_test;


//========================================================
// Factory Registration
//========================================================
`uvm_component_utils(reset_test)

//========================================================
// Constructor
//========================================================
function new(
    string name = "reset_test",
    uvm_component parent = null
);
    super.new(name, parent);
endfunction


//========================================================
// BUILD PHASE
//========================================================
function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    // Select RESET coverage mode
    cfg.cov_mode = RESET;

    // Explicitly update configuration database
    uvm_config_db#(bridge_config)::set(
        this,
        "*",
        "bridge_cfg",
        cfg
    );

    `uvm_info(
        "RESET_TEST",
        $sformatf(
            "Coverage mode set to %s",
            cfg.cov_mode.name()
        ),
        UVM_NONE
    );

endfunction


//========================================================
// RUN PHASE
//========================================================
task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    `uvm_info(
        "RESET_TEST",
        "================================================",
        UVM_NONE
    );

    `uvm_info(
        "RESET_TEST",
        "Running Power-On Reset Test",
        UVM_NONE
    );

    `uvm_info(
        "RESET_TEST",
        "Waiting for RESET_ASSERTED and RESET_RELEASED",
        UVM_NONE
    );

    //====================================================
    // Power-on reset is generated from tb_top.
    //
    // Do NOT start any AHB/APB transaction here.
    // This keeps reset_test an independent reset test.
    //
    // The extended wait gives the reset signal enough
    // simulation time to assert and subsequently release.
    //====================================================
    #200ns;

    `uvm_info(
        "RESET_TEST",
        "Reset observation window completed",
        UVM_NONE
    );

    //====================================================
    // Allow one additional clock period after reset
    // release so the DUT can settle into its idle state.
    //====================================================
    #20ns;

    `uvm_info(
        "RESET_TEST",
        "DUT settled after reset release",
        UVM_NONE
    );

    `uvm_info(
        "RESET_TEST",
        "Power-On Reset Test Completed",
        UVM_NONE
    );

    `uvm_info(
        "RESET_TEST",
        "================================================",
        UVM_NONE
    );

    phase.drop_objection(this);

endtask

endclass

`endif
