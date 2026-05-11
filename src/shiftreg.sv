module shiftreg #(parameter W = 24) (
    input ser_clock,
    input ser_data_in,
    input ser_select,
    output reg [(W-1):0] p_data_o,
    output reg data_valid
);
    reg [(W-1):0] sr;

    reg [5:0] bitcnt;

    always_ff @(posedge ser_clock) begin
        if(!ser_select) begin
            sr <= { sr[(W-2):0], ser_data_in };
            bitcnt <= bitcnt + 1;
            data_valid <= 0;
        end else begin
            p_data_o <= sr;
            if(bitcnt > 23)
                data_valid <= 1;
            bitcnt <= 0;
        end
    end
endmodule

