{\rtf1\ansi\ansicpg1254\cocoartf2820
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 module testbench();\
\
  logic clk;\
  logic reset;\
  logic [31:0] writedata, dataadr;\
  logic memwrite;\
\
  \
  int correctdata = 5;          \
  int expected_address = 32'h54; \
  logic success_flag = 0;      \
\
  \
  top dut (\
      .clk(clk),\
      .reset(reset),\
      .writedata(writedata),\
      .dataadr(dataadr),\
      .memwrite(memwrite)\
  );\
\
  \
  always #5 clk = ~clk;\
\
  initial begin\
    \
    clk = 0;\
    reset = 1;\
    #15 reset = 0; \
\
    // Monit\'f6r: Belle\uc0\u287 e yazma i\u351 lemini izler\
    $monitor("Time: %0dns | MemWrite: %b | Address: %h | WriteData: %h",\
             $time, memwrite, dataadr, writedata);\
\
   \
    #400;\
\
    if (success_flag) begin\
      $display("=============================");\
      $display("Simulation succeeded: ");\
      $display("Data Address: %d, Data written: %d", expected_address, correctdata);\
      $display("=============================");\
    end else begin\
      $display("=============================");\
      $display("Simulation failed: MemWrite signal was not active.");\
      $display("=============================");\
    end\
    $stop; \
  end\
\
  always @(posedge clk) begin\
    if (memwrite && (dataadr == expected_address) && (writedata == correctdata)) begin\
      success_flag = 1; \
    end\
  end\
\
endmodule\
}