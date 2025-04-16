{\rtf1\ansi\ansicpg1254\cocoartf2820
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 //------------------------------------------------\
// design.sv - Complete Single-Cycle MIPS Processor\
//------------------------------------------------\
\
module top(input logic clk, reset,\
           output logic [31:0] writedata, dataadr,\
           output logic memwrite);\
\
  logic [31:0] pc, instr, readdata;\
\
  mips mips_inst (\
      .clk(clk),\
      .reset(reset),\
      .pc(pc),\
      .instr(instr),\
      .memwrite(memwrite),\
      .aluout(dataadr),\
      .writedata(writedata),\
      .readdata(readdata)\
  );\
\
  imem imem_inst (\
      .a(pc[7:2]),\
      .rd(instr)\
  );\
\
  dmem dmem_inst (\
      .clk(clk),\
      .we(memwrite),\
      .a(dataadr),\
      .wd(writedata),\
      .rd(readdata)\
  );\
endmodule\
}