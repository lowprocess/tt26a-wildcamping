module ovf (input logic a, input logic b, input logic r, input logic s, output logic v, output logic c);

    always_comb begin
		if (s) begin
			c = ((a & ~b) | (a & r)) | (~b & r);
			v = ((~a & b) & ~r) | ((a & ~b) & r);
		end else begin
			c = ((a & b) | (a & ~r)) | (b & ~r);
			v = ((a & b) & ~r) | ((~a & ~b) & r);
		end
	end

endmodule
