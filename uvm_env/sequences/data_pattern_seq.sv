`ifndef DATA_PATTERN_SEQ_SV
`define DATA_PATTERN_SEQ_SV

class data_pattern_seq extends base_sequence;
    `uvm_object_utils(data_pattern_seq)

    function new(string name="data_pattern_seq");
        super.new(name);
    endfunction

    virtual task body();
        bit [31:0] patterns[5];
        bit [31:0] addr;
        super.body();

        patterns[0]=32'h00000000;
        patterns[1]=32'hFFFFFFFF;
        patterns[2]=32'hAAAAAAAA;
        patterns[3]=32'h55555555;
        patterns[4]=32'h12345678;

        for (int i=0;i<5;i++) begin
            addr = 32'h00000020 + i*4;

            req = ahb_transaction::type_id::create($sformatf("pat_wr_%0d",i));
            start_item(req);
            if (!req.randomize() with {
                hwrite == 1'b1;
                htrans == ((i==0)?2'b10:2'b11);
                hsize  == 3'b010;
                haddr  == local::addr;
                hwdata == local::patterns[i];
            })
                `uvm_fatal(get_type_name(),"Pattern write randomization failed")
            finish_item(req);

            req = ahb_transaction::type_id::create($sformatf("pat_rd_%0d",i));
            start_item(req);
            if (!req.randomize() with {
                hwrite == 1'b0;
                htrans == 2'b10;
                hsize  == 3'b010;
                haddr  == local::addr;
            })
                `uvm_fatal(get_type_name(),"Pattern read randomization failed")
            finish_item(req);
        end
    endtask
endclass

`endif
