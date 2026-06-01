# README - Laboratório 3: CPU RISC-V Uniciclo

## Disciplina
**CIC0099 – Organização e Arquitetura de Computadores**  
Professor: Marcus Vinicius Lamar

## Descrição do Projeto

Este projeto consiste na implementação de uma **CPU RISC-V Uniciclo** compatível com uma versão reduzida da ISA RV32I, utilizando a linguagem **Verilog HDL**, a plataforma FPGA **DE1-SoC** e o ambiente de desenvolvimento **Quartus Prime**.

O objetivo principal é desenvolver um processador uniciclo capaz de executar um conjunto reduzido de instruções da arquitetura RISC-V, além de validar seu funcionamento por meio de simulação e execução em hardware.

---

## Objetivos

- Desenvolver habilidades em Verilog HDL;
- Compreender a arquitetura de processadores uniciclo;
- Implementar componentes fundamentais de uma CPU RISC-V;
- Realizar síntese, simulação e testes em FPGA;
- Analisar requisitos funcionais, temporais e físicos do processador.

---

## Estrutura do Projeto

```text
├── BancoRegistradores.v
├── GeradorImediatos.v
├── MemoriaInstrucao.v
├── MemoriaDados.v
├── ULA.v
├── ControleULA.v
├── Controle.v
├── Processador.v
├── TopDE.v
├── fdiv.v
├── decoder7.v
├── testeRed.s
├── testeRed_text.mif
├── testeRed_data.mif
└── README.md
```

---

## ISA Implementada

O processador implementa as seguintes instruções:

### Tipo R
- add
- sub
- and
- or
- slt
- sll

### Tipo I
- addi
- lw
- jalr
- slli

### Tipo S
- sw

### Tipo B
- beq

### Tipo U
- lui

### Tipo J
- jal

Total: **14 instruções**

---

## Componentes Implementados

### Banco de Registradores

Características:

- 32 registradores de 32 bits;
- 3 portas de leitura simultâneas:
  - rs1
  - rs2
  - disp
- 1 porta de escrita.

Valores iniciais:

| Registrador | Valor |
|------------|---------|
| SP (x2) | 0x100103FC |
| GP (x3) | 0x10010000 |
| Demais | 0x00000000 |

---

### Gerador de Imediatos

Suporte para os formatos:

- I-Type
- S-Type
- B-Type
- U-Type
- J-Type

---

### Memórias

#### Memória de Instruções

- 1024 palavras
- Endereço inicial:

```text
0x00400000
```

#### Memória de Dados

- 1024 palavras
- Endereço inicial:

```text
0x10010000
```

Ambas operam com clock de 50 MHz.

---

### ULA

Operações implementadas:

- Soma
- Subtração
- AND
- OR
- SLT
- SLL
- LUI

Sinais adicionais:

- Zero Flag

---

### Unidade de Controle

Responsável por gerar os sinais de controle para:

- Banco de Registradores;
- ULA;
- Memória de Dados;
- Atualização do PC;
- Saltos e desvios.

---

### Processador Uniciclo

Fluxo de execução:

1. Busca da instrução;
2. Decodificação;
3. Leitura de registradores;
4. Geração de imediato;
5. Execução na ULA;
6. Acesso à memória;
7. Escrita do resultado.

Todas as etapas ocorrem em um único ciclo de clock.

---

## Interface FPGA

### Chaves

| Chave | Função |
|---------|---------|
| SW[3:0] | Divisor de clock |
| SW[8:4] | Seleção do registrador exibido |
| SW[9] | Controle adicional do sistema |

### Botões

| Botão | Função |
|---------|---------|
| KEY[0] | Reset |
| KEY[1] | Exibir PC |
| KEY[2] | Exibir instrução |

### Displays

Os displays de sete segmentos exibem:

- Conteúdo do registrador selecionado;
- Valor do PC;
- Instrução atual.

---

## Programa de Teste

O arquivo `testeRed.s` foi desenvolvido para validar todas as instruções implementadas.

Os testes verificam:

- Operações aritméticas;
- Operações lógicas;
- Desvios condicionais;
- Saltos;
- Acesso à memória;
- Manipulação de imediatos.

Arquivos gerados:

```text
testeRed_text.mif
testeRed_data.mif
```

---

## Simulação

Ferramentas utilizadas:

- Quartus Prime
- ModelSim (ou simulador equivalente)

Verificações realizadas:

- Funcionamento das instruções;
- Atualização correta do PC;
- Operações da ULA;
- Leitura e escrita em memória;
- Escrita no banco de registradores.

---

## Referências

- Especificação RISC-V RV32I
- Documentação da plataforma DE1-SoC
- Intel Quartus Prime
- Material da disciplina CIC0099 – Organização e Arquitetura de Computadores
