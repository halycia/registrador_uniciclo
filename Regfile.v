// Banco de Registradores 32 bits
// 3 leituras simultâneas: rs1, rs2, disp (para TopDE)
// 1 escrita síncrona: rd (na borda de subida do clk)
// Reset assíncrono: sp=0x1001_03FC, gp=0x1001_0000, demais=0
// x0 sempre vale 0 (ignorado na escrita)

module RegFile (
    input  wire        clk,
    input  wire        reset,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  disp,
    input  wire [4:0]  rd,
    input  wire [31:0] wd,
    input  wire        RegWrite,
    output wire [31:0] RD1,
    output wire [31:0] RD2,
    output wire [31:0] RDdisp
);

    reg [31:0] regs [0:31];
    integer i;

    always @(posedge clk or posedge reset)
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
            regs[2] <= 32'h1001_03FC;   // sp (x2)
            regs[3] <= 32'h1001_0000;   // gp (x3)
        end
        else begin
            if (RegWrite && rd != 5'b0)
                regs[rd] <= wd;
        end

    assign RD1    = (rs1  == 5'b0) ? 32'b0 : regs[rs1];
    assign RD2    = (rs2  == 5'b0) ? 32'b0 : regs[rs2];
    assign RDdisp = (disp == 5'b0) ? 32'b0 : regs[disp];

endmodule