`ifndef BRIDGE_COVERAGE_SV
`define BRIDGE_COVERAGE_SV

class bridge_coverage extends uvm_subscriber #(ahb_transaction);


//========================================================
// Factory Registration
//========================================================
`uvm_component_utils(bridge_coverage)

//========================================================
// Transaction
//========================================================
ahb_transaction tr;

//========================================================
// Configuration
//========================================================
bridge_config cfg;

//========================================================
// Virtual Interface
//========================================================
virtual ahb_if vif;

//========================================================
// Reset State
//========================================================
bit reset_state;

//========================================================
// Coverage Mode
//========================================================
coverage_mode_e cov_mode;


//========================================================
// BACK-TO-BACK COVERAGE
//========================================================
covergroup back_to_back_cg;

    option.per_instance = 1;
    option.name = "back_to_back_cg";

    cp_rw : coverpoint tr.hwrite {
        bins RD = {0};
        bins WR = {1};
    }

    cp_addr : coverpoint tr.haddr[9:2] {
        bins ALL = {[0:255]};
    }

endgroup


//========================================================
// BOUNDARY ADDRESS COVERAGE
//========================================================
covergroup boundary_address_cg;

    option.per_instance = 1;
    option.name = "boundary_address_cg";

    cp_addr : coverpoint tr.haddr[9:2] {

        bins boundary[] = {
            0,
            63,
            64,
            127,
            128,
            255
        };

    }

endgroup


//========================================================
// DATA PATTERN COVERAGE
//========================================================
covergroup data_pattern_cg;

    option.per_instance = 1;
    option.name = "data_pattern_cg";

    cp_data : coverpoint tr.hwdata {

        bins ZERO = {32'h00000000};
        bins ONES = {32'hFFFFFFFF};
        bins ALT1 = {32'hAAAAAAAA};
        bins ALT2 = {32'h55555555};

    }

endgroup


//========================================================
// OVERALL / REGRESSION / RANDOM RW COVERAGE
//========================================================
covergroup bridge_cg;

    option.per_instance = 1;
    option.name = "bridge_cg";

    cp_rw : coverpoint tr.hwrite {

        bins READ  = {0};
        bins WRITE = {1};

    }

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

        ignore_bins IDLE = {2'b00};
        ignore_bins BUSY = {2'b01};

    }

    cp_hsize : coverpoint tr.hsize {

        bins BYTE = {3'b000};
        bins HALF = {3'b001};
        bins WORD = {3'b010};

        ignore_bins RESERVED = {[3'b011:3'b111]};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    cp_resp : coverpoint tr.hresp {

        bins OKAY  = {2'b00};
        bins ERROR = {2'b01};

    }

    rw_addr_cross :
        cross cp_rw, cp_addr;

    rw_size_cross :
        cross cp_rw, cp_hsize;

    rw_trans_cross :
        cross cp_rw, cp_htrans;

    rw_resp_cross :
        cross cp_rw, cp_resp;

endgroup


//========================================================
// WRITE COVERAGE
//========================================================
covergroup write_cg;

    option.per_instance = 1;
    option.name = "write_cg";

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

    }

    cp_hsize : coverpoint tr.hsize {

        bins BYTE = {3'b000};
        bins HALF = {3'b001};
        bins WORD = {3'b010};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    cp_resp : coverpoint tr.hresp {

        bins OKAY  = {2'b00};
        bins ERROR = {2'b01};

    }

    addr_trans :
        cross cp_addr, cp_htrans;

    addr_size :
        cross cp_addr, cp_hsize;

    addr_resp :
        cross cp_addr, cp_resp;

endgroup


//========================================================
// READ COVERAGE
//========================================================
covergroup read_cg;

    option.per_instance = 1;
    option.name = "read_cg";

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

    }

    cp_hsize : coverpoint tr.hsize {

        bins BYTE = {3'b000};
        bins HALF = {3'b001};
        bins WORD = {3'b010};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    cp_resp : coverpoint tr.hresp {

        bins OKAY  = {2'b00};
        bins ERROR = {2'b01};

    }

    addr_trans :
        cross cp_addr, cp_htrans;

    addr_size :
        cross cp_addr, cp_hsize;

    addr_resp :
        cross cp_addr, cp_resp;

endgroup


//========================================================
// WRITE / READ COVERAGE
//========================================================
covergroup write_read_cg;

    option.per_instance = 1;
    option.name = "write_read_cg";

    cp_rw : coverpoint tr.hwrite {

        bins WRITE = {1};
        bins READ  = {0};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    cp_resp : coverpoint tr.hresp {

        bins OKAY  = {2'b00};
        bins ERROR = {2'b01};

    }

    rw_addr :
        cross cp_rw, cp_addr;

    rw_resp :
        cross cp_rw, cp_resp;

endgroup


//========================================================
// FIFO FULL COVERAGE
//========================================================
covergroup fifo_full_cg;

    option.per_instance = 1;
    option.name = "fifo_full_cg";

    cp_write : coverpoint tr.hwrite {

        bins WRITE = {1};

    }

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

    }

    cp_hsize : coverpoint tr.hsize {

        bins BYTE = {3'b000};
        bins HALF = {3'b001};
        bins WORD = {3'b010};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    cp_resp : coverpoint tr.hresp {

        bins OKAY  = {2'b00};
        bins ERROR = {2'b01};

    }

    addr_size :
        cross cp_addr, cp_hsize;

    addr_trans :
        cross cp_addr, cp_htrans;

endgroup


//========================================================
// FIFO EMPTY COVERAGE
//========================================================
covergroup fifo_empty_cg;

    option.per_instance = 1;
    option.name = "fifo_empty_cg";

    cp_rw : coverpoint tr.hwrite {

        bins READ  = {0};
        bins WRITE = {1};

    }

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    cp_resp : coverpoint tr.hresp {

        bins OKAY  = {2'b00};
        bins ERROR = {2'b01};

    }

    rw_addr :
        cross cp_rw, cp_addr;

    rw_trans :
        cross cp_rw, cp_htrans;

endgroup


//========================================================
// WAIT STATE COVERAGE
//========================================================
covergroup wait_state_cg;

    option.per_instance = 1;
    option.name = "wait_state_cg";

    cp_rw : coverpoint tr.hwrite {

        bins READ  = {0};
        bins WRITE = {1};

    }

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

    }

    cp_hsize : coverpoint tr.hsize {

        bins BYTE = {3'b000};
        bins HALF = {3'b001};
        bins WORD = {3'b010};

    }

    rw_trans :
        cross cp_rw, cp_htrans;

endgroup


//========================================================
// CLOCK RATIO COVERAGE
//========================================================
covergroup clock_ratio_cg;

    option.per_instance = 1;
    option.name = "clock_ratio_cg";

    cp_rw : coverpoint tr.hwrite {

        bins READ  = {0};
        bins WRITE = {1};

    }

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    rw_addr :
        cross cp_rw, cp_addr;

endgroup


//========================================================
// RESET COVERAGE
//========================================================
covergroup reset_cg;

    option.per_instance = 1;
    option.name = "reset_cg";

    cp_reset : coverpoint reset_state {

        bins RESET_ASSERTED = {0};
        bins RESET_RELEASED = {1};

    }

endgroup


//========================================================
// RESET DURING TRANSFER COVERAGE
//========================================================
covergroup reset_during_transfer_cg;

    option.per_instance = 1;
    option.name = "reset_during_transfer_cg";

    cp_rw : coverpoint tr.hwrite {

        bins READ  = {0};
        bins WRITE = {1};

    }

    cp_htrans : coverpoint tr.htrans {

        bins NONSEQ = {2'b10};
        bins SEQ    = {2'b11};

    }

    cp_hsize : coverpoint tr.hsize {

        bins BYTE = {3'b000};
        bins HALF = {3'b001};
        bins WORD = {3'b010};

    }

    cp_addr : coverpoint tr.haddr[9:2] {

        bins LOW  = {[0:63]};
        bins MID  = {[64:127]};
        bins HIGH = {[128:255]};

    }

    cp_resp : coverpoint tr.hresp {

        bins OKAY  = {2'b00};
        bins ERROR = {2'b01};

    }

    rw_addr :
        cross cp_rw, cp_addr;

    rw_size :
        cross cp_rw, cp_hsize;

    rw_trans :
        cross cp_rw, cp_htrans;

endgroup


//========================================================
// CONSTRUCTOR
//========================================================
function new(
    string name = "bridge_coverage",
    uvm_component parent = null
);

    super.new(name, parent);

    // IMPORTANT:
    // Construct EVERY covergroup.

    bridge_cg                  = new();
    back_to_back_cg            = new();
    boundary_address_cg        = new();
    data_pattern_cg            = new();

    write_cg                   = new();
    read_cg                    = new();
    write_read_cg              = new();

    fifo_full_cg               = new();
    fifo_empty_cg               = new();

    wait_state_cg              = new();
    clock_ratio_cg             = new();

    reset_cg                   = new();
    reset_during_transfer_cg   = new();

    reset_state = 1'b1;

endfunction


//========================================================
// BUILD PHASE
//========================================================
function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db#(bridge_config)::get(
            this,
            "",
            "bridge_cfg",
            cfg
    )) begin

        `uvm_fatal(
            "COV",
            "Bridge Config Not Found"
        )

    end

    if (cfg == null) begin

        `uvm_fatal(
            "COV",
            "Bridge Config is NULL"
        )

    end

    cov_mode = cfg.cov_mode;
    vif      = cfg.ahb_vif;

    if (vif == null) begin

        `uvm_fatal(
            "COV",
            "AHB virtual interface is NULL"
        )

    end

    `uvm_info(
        "COV_CFG",
        $sformatf(
            "Coverage Mode = %s",
            cov_mode.name()
        ),
        UVM_NONE
    )

endfunction


//========================================================
// WRITE
// Called whenever AHB monitor sends a transaction
//========================================================
function void write(ahb_transaction t);

    if (t == null) begin

        `uvm_warning(
            "COV",
            "NULL transaction received"
        )

        return;

    end

    tr = t;

    `uvm_info(
        "COVERAGE",
        $sformatf(
            "Coverage Sample Received : ADDR=%08h WRITE=%0d HSIZE=%0d HTRANS=%02b HRESP=%02b",
            tr.haddr,
            tr.hwrite,
            tr.hsize,
            tr.htrans,
            tr.hresp
        ),
        UVM_LOW
    )


    case (cov_mode)

        REGRESSION,
        RANDOM_RW:
            bridge_cg.sample();


        BACK_TO_BACK:
            back_to_back_cg.sample();


        DATA_PATTERN:
            data_pattern_cg.sample();


        BOUNDARY_ADDRESS:
            boundary_address_cg.sample();


        SINGLE_WRITE,
        MULTIPLE_WRITE: begin

            if (tr.hwrite)
                write_cg.sample();

        end


        SINGLE_READ,
        MULTIPLE_READ: begin

            if (!tr.hwrite)
                read_cg.sample();

        end


        WRITE_READ:
            write_read_cg.sample();


        FIFO_FULL:
            fifo_full_cg.sample();


        FIFO_EMPTY:
            fifo_empty_cg.sample();


        WAIT_STATE:
            wait_state_cg.sample();


        CLOCK_RATIO:
            clock_ratio_cg.sample();


        RESET_DURING_TRANSFER:
            reset_during_transfer_cg.sample();


        RESET: begin

            // RESET coverage is sampled
            // from HRESETn in run_phase.
            // No AHB transaction required.

        end


        default:
            bridge_cg.sample();

    endcase

endfunction

//========================================================
// RESET COVERAGE SAMPLING
//========================================================
task run_phase(uvm_phase phase);

    if (vif == null) begin

        `uvm_fatal(
            "RESET_COV",
            "AHB virtual interface is NULL in run_phase"
        )

    end

    if (cov_mode == RESET) begin

        //================================================
        // STEP 1 : Capture initial reset state
        //================================================
        if (vif.HRESETn === 1'b0) begin

            reset_state = 1'b0;

            reset_cg.sample();

            `uvm_info(
                "RESET_COV",
                "RESET ASSERTED - Initial state sampled",
                UVM_NONE
            )

            //================================================
            // IMPORTANT:
            // Wait explicitly for reset release
            //================================================
            @(posedge vif.HRESETn);

            reset_state = 1'b1;

            reset_cg.sample();

            `uvm_info(
                "RESET_COV",
                "RESET RELEASED - Coverage sampled",
                UVM_NONE
            )

        end
        else if (vif.HRESETn === 1'b1) begin

            reset_state = 1'b1;

            reset_cg.sample();

            `uvm_info(
                "RESET_COV",
                "RESET RELEASED - Initial state sampled",
                UVM_NONE
            )

        end

        //================================================
        // STEP 2 : Monitor future reset cycles
        //================================================
        forever begin

            @(negedge vif.HRESETn);

            reset_state = 1'b0;

            reset_cg.sample();

            `uvm_info(
                "RESET_COV",
                "RESET ASSERTED - Coverage sampled",
                UVM_NONE
            )

            @(posedge vif.HRESETn);

            reset_state = 1'b1;

            reset_cg.sample();

            `uvm_info(
                "RESET_COV",
                "RESET RELEASED - Coverage sampled",
                UVM_NONE
            )

        end

    end

endtask


//========================================================
// GET COVERAGE
//========================================================
function real get_cov();

    case (cov_mode)

        REGRESSION,
        RANDOM_RW:
            return bridge_cg.get_coverage();


        BACK_TO_BACK:
            return back_to_back_cg.get_coverage();


        BOUNDARY_ADDRESS:
            return boundary_address_cg.get_coverage();


        DATA_PATTERN:
            return data_pattern_cg.get_coverage();


        SINGLE_WRITE,
        MULTIPLE_WRITE:
            return write_cg.get_coverage();


        SINGLE_READ,
        MULTIPLE_READ:
            return read_cg.get_coverage();


        WRITE_READ:
            return write_read_cg.get_coverage();


        FIFO_FULL:
            return fifo_full_cg.get_coverage();


        FIFO_EMPTY:
            return fifo_empty_cg.get_coverage();


        WAIT_STATE:
            return wait_state_cg.get_coverage();


        CLOCK_RATIO:
            return clock_ratio_cg.get_coverage();


        RESET_DURING_TRANSFER:
            return reset_during_transfer_cg.get_coverage();


        RESET:
            return reset_cg.get_coverage();


        default:
            return bridge_cg.get_coverage();

    endcase

endfunction


//========================================================
// REPORT PHASE
//========================================================
function void report_phase(uvm_phase phase);

    real cov;

    super.report_phase(phase);

    cov = get_cov();

    `uvm_info(
        "COVERAGE",
        "==============================================",
        UVM_NONE
    )

    case (cov_mode)

        REGRESSION:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Regression Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        RANDOM_RW:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Random RW Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        BACK_TO_BACK:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Back-to-Back Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        BOUNDARY_ADDRESS:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Boundary Address Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        DATA_PATTERN:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Data Pattern Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        SINGLE_WRITE:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Single Write Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        SINGLE_READ:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Single Read Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        MULTIPLE_WRITE:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Multiple Write Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        MULTIPLE_READ:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Multiple Read Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        WRITE_READ:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Write Read Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        FIFO_FULL:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "FIFO Full Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        FIFO_EMPTY:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "FIFO Empty Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        WAIT_STATE:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Wait State Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        CLOCK_RATIO:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Clock Ratio Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        RESET_DURING_TRANSFER:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Reset During Transfer Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        RESET:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Reset Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )


        default:
            `uvm_info(
                "COVERAGE",
                $sformatf(
                    "Coverage : %0.2f%%",
                    cov
                ),
                UVM_NONE
            )

    endcase

    `uvm_info(
        "COVERAGE",
        "==============================================",
        UVM_NONE
    )

endfunction


endclass

`endif
