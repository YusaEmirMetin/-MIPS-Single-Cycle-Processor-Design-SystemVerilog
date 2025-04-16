{\rtf1\ansi\ansicpg1254\cocoartf2820
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 //------------------------------------------------\
// MIPS Processor\
//------------------------------------------------\
module mips(input logic clk, reset,\
            output logic [31:0] pc,\
            input logic [31:0] instr,\
            output logic memwrite,\
            output logic [31:0] aluout, writedata,\
            input logic [31:0] readdata);\
\
  logic memtoreg, alusrc, regdst, regwrite, jump, pcsrc, zero;\
  logic [2:0] alucontrol;\
\
  controller ctrl (\
      .op(instr[31:26]),\
      .funct(instr[5:0]),\
      .zero(zero),\
      .memtoreg(memtoreg),\
      .memwrite(memwrite),\
      .pcsrc(pcsrc),\
      .alusrc(alusrc),\
      .regdst(regdst),\
      .regwrite(regwrite),\
      .jump(jump),\
      .alucontrol(alucontrol)\
  );\
\
  datapath dp (\
      .clk(clk),\
      .reset(reset),\
      .memtoreg(memtoreg),\
      .pcsrc(pcsrc),\
      .alusrc(alusrc),\
      .regdst(regdst),\
      .regwrite(regwrite),\
      .jump(jump),\
      .alucontrol(alucontrol),\
      .zero(zero),\
      .pc(pc),\
      .instr(instr),\
      .aluout(aluout),\
      .writedata(writedata),\
      .readdata(readdata)\
  );\
endmodule\
\
//------------------------------------------------\
// Controller Module\
//------------------------------------------------\
module controller(input logic [5:0] op, funct,\
                  input logic zero,\
                  output logic memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump,\
                  output logic [2:0] alucontrol);\
\
  logic [1:0] aluop;\
\
  maindec md (\
      .op(op),\
      .memtoreg(memtoreg),\
      .memwrite(memwrite),\
      .branch(pcsrc),\
      .alusrc(alusrc),\
      .regdst(regdst),\
      .regwrite(regwrite),\
      .jump(jump),\
      .aluop(aluop)\
  );\
\
  aludec ad (\
      .funct(funct),\
      .aluop(aluop),\
      .alucontrol(alucontrol)\
  );\
\
endmodule\
\
//------------------------------------------------\
// Main Decoder\
//------------------------------------------------\
module maindec(input logic [5:0] op,\
               output logic memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump,\
               output logic [1:0] aluop);\
\
  logic [8:0] controls;\
\
  assign \{regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop\} = controls;\
\
  always_comb begin\
    case (op)\
      6'b000000: controls = 9'b110000010; // R-type\
      6'b100011: controls = 9'b101001000; // LW\
      6'b101011: controls = 9'b001010000; // SW\
      6'b000100: controls = 9'b000100001; // BEQ\
      6'b001000: controls = 9'b101000000; // ADDI\
      6'b000010: controls = 9'b000000100; // JUMP\
      default:   controls = 9'b000000000; // Default\
    endcase\
  end\
endmodule\
\
//------------------------------------------------\
// ALU Decoder\
//------------------------------------------------\
module aludec(input logic [5:0] funct,\
              input logic [1:0] aluop,\
              output logic [2:0] alucontrol);\
\
  always_comb begin\
    case (aluop)\
      2'b00: alucontrol = 3'b010; // ADD\
      2'b01: alucontrol = 3'b110; // SUB\
      2'b10: case (funct)         // R-type\
               6'b100000: alucontrol = 3'b010; // ADD\
               6'b100010: alucontrol = 3'b110; // SUB\
               6'b100100: alucontrol = 3'b000; // AND\
               6'b100101: alucontrol = 3'b001; // OR\
               6'b101010: alucontrol = 3'b111; // SLT\
               default:   alucontrol = 3'bxxx; // INVALID\
             endcase\
      default: alucontrol = 3'bxxx; // INVALID\
    endcase\
  end\
endmodule\
\
//------------------------------------------------\
// Datapath\
//------------------------------------------------\
module datapath(input logic clk, reset,\
                input logic memtoreg, pcsrc, alusrc, regdst, regwrite, jump,\
                input logic [2:0] alucontrol,\
                output logic zero,\
                output logic [31:0] pc,\
                input logic [31:0] instr,\
                output logic [31:0] aluout, writedata,\
                input logic [31:0] readdata);\
\
  logic [31:0] pcnext, pcplus4, pcbranch, srca, srcb, result, signimm, signimmsh;\
  logic [4:0] writereg;\
\
  flopr #(32) pcreg (clk, reset, pcnext, pc);\
  adder pcadd1 (pc, 32'h4, pcplus4);\
  sl2 immsh (signimm, signimmsh);\
  adder pcadd2 (pcplus4, signimmsh, pcbranch);\
  mux2 #(32) pcmux (pcplus4, pcbranch, pcsrc, pcnext);\
\
  regfile rf (clk, regwrite, instr[25:21], instr[20:16], writereg, result, srca, writedata);\
  mux2 #(5) wrmux (instr[20:16], instr[15:11], regdst, writereg);\
  signext se (instr[15:0], signimm);\
\
  mux2 #(32) srcbmux (writedata, signimm, alusrc, srcb);\
  ALU alu (srca, srcb, alucontrol, aluout, zero);\
  mux2 #(32) resmux (aluout, readdata, memtoreg, result);\
endmodule\
\
}