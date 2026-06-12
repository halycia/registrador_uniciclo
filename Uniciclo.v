module Uniciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout
	);
	
	
	initial
		begin
			PC<=32'h0040_0000;
			Instr<=32'b0;
			regout<=32'b0;
		end
		
		wire [31:0] SaidaULA, Leitura2, MemData;
		wire EscreveMem;
		
//******************************************
// Aqui vai o seu código do seu processador

wire [31:0] RD1, RD2;          // leituras rs1, rs2
wire [31:0] WD;                 // dado a escrever no banco
wire        RegWrite;           // sinal de controle (vem do Controlador)

// Banco de Registradores
RegFile RF (
    .clock    (clockCPU),
    .reset    (reset),
    // leitura
    .rs1      (Instr[19:15]),   // campo rs1 da instrução
    .rs2      (Instr[24:20]),   // campo rs2 da instrução
    .disp     (regin),          // SW[8:4] do TopDE → display
    // escrita
    .rd       (Instr[11:7]),    // campo rd da instrução
    .wd       (WD),             // resultado a escrever
    .RegWrite (RegWrite),
    // saídas
    .RD1      (RD1),
    .RD2      (RD2),
    .RDdisp   (regout)          // saída para o TopDE/displays
);

// Gerador de Imediatos
wire [31:0] Imm;

ImmGen IG (
    .Instr (Instr),
    .Imm   (Imm)
);


always @(posedge clockCPU  or posedge reset)
	if(reset)
		PC <= 32'h0040_0000;
	else
		PC <= PC + 4;

		
		
assign EscreveMem = 1'b0;
assign SaidaULA = 32'b0;


// Instanciação das memórias
ramI MemC (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .q(Instr));
ramD MemD (.address(SaidaULA[11:2]), .clock(clockMem), .data(Leitura2), .wren(EscreveMem), .q(MemData));
		

	
		
//*****************************************	
			
endmodule
