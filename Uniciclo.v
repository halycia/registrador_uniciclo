module Uniciclo (
    input logic clockCPU, clockMem,
    input logic reset,
    output logic [31:0] PC,
    output logic [31:0] Instr,
    input  logic [4:0] regin,
    output logic [31:0] regout
);

    initial begin
        PC     <= 32'h0040_0000;
        Instr  <= 32'b0;
        regout <= 32'b0;
    end

    // ── Todas as declarações de wire ──────────────────────
    wire [31:0] SaidaULA, Leitura2, MemData;
    wire [31:0] RD1, RD2, WD, Imm, EntradaB;
    wire [31:0] PC_branch, PC_jal, PC_jalr;
    wire [3:0]  ALUControl;
    wire [1:0]  ALUOp, OrigPC;
    wire        EscreveMem, RegWrite, ALUSrc;
    wire        MemRead, Mem2Reg, Branch, Zero, PCSrc;

    // ── Memórias ─────────────────────────────────────────────────
    ramI MemC (.address(PC[11:2]), .clock(clockMem),
               .data(), .wren(1'b0), .q(Instr));

    ramD MemD (.address(SaidaULA[11:2]), .clock(clockMem),
               .data(Leitura2), .wren(EscreveMem), .q(MemData));

    // ── Banco de Registradores ───────────────────────────────────
    RegFile RF (
        .clk      (clockCPU),
        .reset    (reset),
        .rs1      (Instr[19:15]),
        .rs2      (Instr[24:20]),
        .disp     (regin),
        .rd       (Instr[11:7]),
        .wd       (WD),
        .RegWrite (RegWrite),
        .RD1      (RD1),
        .RD2      (RD2),
        .RDdisp   (regout)
    );

    // ── Gerador de Imediatos ─────────────────────────────────────
    ImmGen IG (.Instr(Instr), .Imm(Imm));

    // ── Bloco Controlador ────────────────────────────────────────
    Controle CTRL (
        .opcode   (Instr[6:0]),
        .RegWrite (RegWrite),
        .ALUSrc   (ALUSrc),
        .MemWrite (EscreveMem),
        .MemRead  (MemRead),
        .Mem2Reg  (Mem2Reg),
        .Branch   (Branch),
        .ALUOp    (ALUOp),
        .OrigPC   (OrigPC)
    );

    // ── Controlador da ULA ───────────────────────────────────────
    ControleULA CTRLULA (
        .ALUOp      (ALUOp),
        .funct3     (Instr[14:12]),
        .funct7_5   (Instr[30]),
        .ALUControl (ALUControl)
    );

    // ── ULA ──────────────────────────────────────────────────────
    assign EntradaB = ALUSrc ? Imm : RD2;

    ULA ula1 (
        .A          (RD1),
        .B          (EntradaB),
        .ALUControl (ALUControl),
        .Result     (SaidaULA),
        .Zero       (Zero)
    );

    // ── Muxes e assigns ──────────────────────────────────────────
    assign Leitura2  = RD2;
    assign WD        = Mem2Reg ? MemData : SaidaULA;
    assign PCSrc     = Branch & Zero;
    assign PC_branch = PC + Imm;
    assign PC_jal    = PC + Imm;
    assign PC_jalr   = (RD1 + Imm) & ~32'b1;

    // ── Próximo PC ───────────────────────────────────────────────
    always @(posedge clockCPU or posedge reset)
        if (reset)
            PC <= 32'h0040_0000;
        else
            case (OrigPC)
                2'b00: PC <= PCSrc ? PC_branch : PC + 4;
                2'b10: PC <= PC_jal;
                2'b11: PC <= PC_jalr;
                default: PC <= PC + 4;
            endcase

endmodule
