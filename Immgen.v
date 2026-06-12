// Gerador de Imediatos
module ImmGen (
    input  wire [31:0] Instr,
    output reg  [31:0] Imm
);

    wire [6:0] opcode;
    assign opcode = Instr[6:0];

    always @(*) begin
        case (opcode)
            // I-type: addi, slli
            7'b0010011,
            // I-type: lw
            7'b0000011,
            // I-type: jalr
            7'b1100111:
                Imm = {{20{Instr[31]}}, Instr[31:20]};

            // S-type: sw
            7'b0100011:
                Imm = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};

            // B-type: beq
            7'b1100011:
                Imm = {{19{Instr[31]}}, Instr[31], Instr[7],
                        Instr[30:25], Instr[11:8], 1'b0};

            // U-type: lui
            7'b0110111:
                Imm = {Instr[31:12], 12'b0};

            // J-type: jal
            7'b1101111:
                Imm = {{11{Instr[31]}}, Instr[31], Instr[19:12],
                        Instr[20], Instr[30:21], 1'b0};

            default:
                Imm = 32'b0;
        endcase
    end

endmodule