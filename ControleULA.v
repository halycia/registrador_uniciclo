module ControleULA (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7_5,   // bit 30 da instrução (bit 5 do funct7)
    output reg [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0000; // lw/sw → add
            2'b01: ALUControl = 4'b0001; // beq → sub
            2'b11: ALUControl = 4'b0101; // lui → passa B direto
            2'b10: begin                 // tipo-R e tipo-I → decodifica funct3
                case (funct3)
                    3'b000: ALUControl = funct7_5 ? 4'b0001 : 4'b0000; // sub : add
                    3'b001: ALUControl = 4'b0110; // sll / slli
                    3'b010: ALUControl = 4'b0100; // slt
                    3'b110: ALUControl = 4'b0011; // or
                    3'b111: ALUControl = 4'b0010; // and
                    default: ALUControl = 4'b0000;
                endcase
            end
        endcase
    end
endmodule