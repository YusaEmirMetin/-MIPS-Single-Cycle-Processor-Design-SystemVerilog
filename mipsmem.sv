{\rtf1\ansi\ansicpg1254\cocoartf2820
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 //------------------------------------------------\
// Instruction Memory (imem)\
//------------------------------------------------\
module imem(input logic [5:0] a, // Address\
            output logic [31:0] rd); // Read Data\
\
  logic [31:0] RAM[63:0];\
\
  initial begin\
    $readmemh("hexfile.dat", RAM); // Load instructions from file\
  end\
\
  assign rd = RAM[a]; // Fetch instruction\
endmodule\
\
//------------------------------------------------\
// Data Memory (dmem)\
//------------------------------------------------\
module dmem(input logic clk, we, // Write Enable\
            input logic [31:0] a, wd, // Address, Write Data\
            output logic [31:0] rd); // Read Data\
\
  logic [31:0] RAM[63:0];\
\
  assign rd = RAM[a[31:2]]; // Word-aligned address\
\
  always_ff @(posedge clk) begin\
    if (we) begin\
      RAM[a[31:2]] <= wd; // Write operation\
    end\
  end\
endmodule}