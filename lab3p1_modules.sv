{\rtf1\ansi\ansicpg1254\cocoartf2820
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 //------------------------------------------------\
// lab3p1 Modules\
//------------------------------------------------\
\
module regfile(input logic clk, we3,\
               input logic [4:0] ra1, ra2, wa3,\
               input logic [31:0] wd3,\
               output logic [31:0] rd1, rd2);\
\
  logic [31:0] rf[31:0];\
\
  always_ff @(posedge clk)\
    if (we3)\
      rf[wa3] <= wd3;\
\
  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;\
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;\
endmodule\
\
module adder(input logic [31:0] a, b, output logic [31:0] y);\
  assign y = a + b;\
endmodule\
\
module sl2(input logic [31:0] a, output logic [31:0] y);\
  assign y = \{a[29:0], 2'b00\};\
endmodule\
\
module signext(input logic [15:0] a, output logic [31:0] y);\
  assign y = \{\{16\{a[15]\}\}, a\};\
endmodule\
\
module mux2 #(parameter WIDTH = 8) (input logic [WIDTH-1:0] d0, d1, input logic s, output logic [WIDTH-1:0] y);\
  assign y = s ? d1 : d0;\
endmodule\
\
module flopr #(parameter WIDTH = 8) (input logic clk, reset, input logic [WIDTH-1:0] d, output logic [WIDTH-1:0] q);\
  always_ff @(posedge clk, posedge reset)\
    if (reset) q <= 0;\
    else       q <= d;\
endmodule\
\
module ALU(input logic [31:0] a, b, input logic [2:0] alucontrol, output logic [31:0] result, output logic zero);\
  always_comb begin\
    case (alucontrol)\
      3'b000: result = a & b;        // AND\
      3'b001: result = a | b;        // OR\
      3'b010: result = a + b;        // ADD\
      3'b110: result = a - b;        // SUB\
      3'b111: result = (a < b) ? 1 : 0; // SLT\
      default: result = 0;\
    endcase\
    zero = (result == 0);\
  end\
endmodule\
}