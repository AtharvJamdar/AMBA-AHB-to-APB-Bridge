package ahb_apb_pkg;

    typedef struct packed {
        logic        hwrite;
        logic [31:0] haddr;
        logic [31:0] hwdata;
        logic [2:0]  hsize;
        logic [1:0]  htrans;
    } ahb_packet_t;

    parameter int FIFO_WIDTH = $bits(ahb_packet_t); // 70 bits

endpackage : ahb_apb_pkg
