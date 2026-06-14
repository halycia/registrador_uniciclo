module ULA (
    input  [31:0] A,
    input  [31:0] B,
    input  [3:0]  ALUControl,
    output reg [31:0] Result,
    output Zero
);
    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A + B;                          // add, addi, lw, sw, jalr
            4'b0001: Result = A - B;                          // sub
            4'b0010: Result = A & B;                          // and
            4'b0011: Result = A | B;                          // or
            4'b0100: Result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // slt
            4'b0101: Result = B;                              // lui (passa imediato direto)
            4'b0110: Result = A << B[4:0];                    // sll, slli
            4'b0111: Result = A - B;                          // sub para beq (mesmo que 0001)
            default: Result = 32'b0;
        endcase
    end

    assign Zero = (Result == 32'd0);

endmodule