module Controle (
    input  [6:0] opcode,
    output reg       RegWrite,
    output reg       ALUSrc,    // 0=rs2, 1=imediato
    output reg       MemWrite,
    output reg       MemRead,
    output reg       Mem2Reg,   // 0=ULA, 1=memória
    output reg       Branch,
    output reg [1:0] ALUOp,
    output reg [1:0] OrigPC     // 00=PC+4, 01=branch, 10=jal(PC + imm), 11=jalr(rs1 + imm)
);
    always @(*) begin
        // valores default (segurança)
        RegWrite = 0; ALUSrc = 0; MemWrite = 0;
        MemRead  = 0; Mem2Reg = 0; Branch = 0;
        ALUOp    = 2'b00; OrigPC = 2'b00;

        case (opcode)
            7'b0110011: begin // tipo-R: add, sub, and, or, slt, sll
                RegWrite = 1; ALUSrc = 0; ALUOp = 2'b10;
            end
            7'b0010011: begin // tipo-I ALU: addi, slli
                RegWrite = 1; ALUSrc = 1; ALUOp = 2'b10;
            end
            7'b0000011: begin // lw
                RegWrite = 1; ALUSrc = 1; MemRead = 1;
                Mem2Reg  = 1; ALUOp = 2'b00;
            end
            7'b0100011: begin // sw
                ALUSrc = 1; MemWrite = 1; ALUOp = 2'b00;
            end
            7'b1100011: begin // beq
                Branch = 1; ALUOp = 2'b01;
            end
            7'b1101111: begin // jal
                RegWrite = 1; OrigPC = 2'b10;
            end
            7'b1100111: begin // jalr
                RegWrite = 1; ALUSrc = 1;
                ALUOp = 2'b00; OrigPC = 2'b11;
            end
            7'b0110111: begin // lui
                RegWrite = 1; ALUSrc = 1; ALUOp = 2'b11;
            end
            default: begin
                RegWrite = 0; ALUSrc = 0; MemWrite = 0;
                MemRead  = 0; Mem2Reg = 0; Branch = 0;
                ALUOp    = 2'b00; OrigPC = 2'b00;
            end
        endcase
    end
endmodule