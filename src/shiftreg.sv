module shiftreg #(parameter W = 24) (
    input ser_clock,
    input ser_data_in,
    input ser_select,
    output reg [(W-1):0] p_data_o
);
    reg [(W-1):0] sr;

    always_ff @(posedge ser_clock) begin
        if(!ser_select) 
            sr <= { sr[(W-2):0], ser_data_in };
        else
            p_data_o <= sr;
    end
endmodule

