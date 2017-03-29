// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/15.1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2015/08/09 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module ECE423_QSYS_mm_interconnect_0_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 1,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 9 
   )
  (output [105 - 101 : 0] default_destination_id,
   output [32-1 : 0] default_wr_channel,
   output [32-1 : 0] default_rd_channel,
   output [32-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[105 - 101 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 32'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 32'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 32'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module ECE423_QSYS_mm_interconnect_0_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [119-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [119-1    : 0] src_data,
    output reg [32-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 105;
    localparam PKT_DEST_ID_L = 101;
    localparam PKT_PROTECTION_H = 109;
    localparam PKT_PROTECTION_L = 107;
    localparam ST_DATA_W = 119;
    localparam ST_CHANNEL_W = 32;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h20000000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h20100000 - 64'h20080000); 
    localparam PAD2 = log2ceil(64'h20101000 - 64'h20100800); 
    localparam PAD3 = log2ceil(64'h20101040 - 64'h20101000); 
    localparam PAD4 = log2ceil(64'h20101060 - 64'h20101040); 
    localparam PAD5 = log2ceil(64'h20101080 - 64'h20101060); 
    localparam PAD6 = log2ceil(64'h201010a0 - 64'h20101080); 
    localparam PAD7 = log2ceil(64'h201010c0 - 64'h201010a0); 
    localparam PAD8 = log2ceil(64'h201010e0 - 64'h201010c0); 
    localparam PAD9 = log2ceil(64'h20101100 - 64'h201010e0); 
    localparam PAD10 = log2ceil(64'h20101120 - 64'h20101100); 
    localparam PAD11 = log2ceil(64'h20101140 - 64'h20101120); 
    localparam PAD12 = log2ceil(64'h20101150 - 64'h20101140); 
    localparam PAD13 = log2ceil(64'h20101160 - 64'h20101150); 
    localparam PAD14 = log2ceil(64'h20101170 - 64'h20101160); 
    localparam PAD15 = log2ceil(64'h20101180 - 64'h20101170); 
    localparam PAD16 = log2ceil(64'h20101190 - 64'h20101180); 
    localparam PAD17 = log2ceil(64'h201011a0 - 64'h20101190); 
    localparam PAD18 = log2ceil(64'h201011b0 - 64'h201011a0); 
    localparam PAD19 = log2ceil(64'h201011c0 - 64'h201011b0); 
    localparam PAD20 = log2ceil(64'h201011d0 - 64'h201011c0); 
    localparam PAD21 = log2ceil(64'h201011e0 - 64'h201011d0); 
    localparam PAD22 = log2ceil(64'h201011e8 - 64'h201011e0); 
    localparam PAD23 = log2ceil(64'h201011f0 - 64'h201011e8); 
    localparam PAD24 = log2ceil(64'h201011f8 - 64'h201011f0); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h201011f8;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [32-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire write_transaction;
    assign write_transaction = sink_data[PKT_TRANS_WRITE];
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    ECE423_QSYS_mm_interconnect_0_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x20000000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 30'h0   ) begin
            src_channel = 32'b0000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x20080000 .. 0x20100000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 30'h20080000   ) begin
            src_channel = 32'b1000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
    end

    // ( 0x20100800 .. 0x20101000 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 30'h20100800   ) begin
            src_channel = 32'b0000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x20101000 .. 0x20101040 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 30'h20101000   ) begin
            src_channel = 32'b0000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
    end

    // ( 0x20101040 .. 0x20101060 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 30'h20101040   ) begin
            src_channel = 32'b0000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x20101060 .. 0x20101080 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 30'h20101060   ) begin
            src_channel = 32'b0000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
    end

    // ( 0x20101080 .. 0x201010a0 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 30'h20101080   ) begin
            src_channel = 32'b0000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x201010a0 .. 0x201010c0 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 30'h201010a0   ) begin
            src_channel = 32'b0000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
    end

    // ( 0x201010c0 .. 0x201010e0 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 30'h201010c0   ) begin
            src_channel = 32'b0000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x201010e0 .. 0x20101100 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 30'h201010e0   ) begin
            src_channel = 32'b0000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x20101100 .. 0x20101120 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 30'h20101100   ) begin
            src_channel = 32'b0000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
    end

    // ( 0x20101120 .. 0x20101140 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 30'h20101120   ) begin
            src_channel = 32'b0000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
    end

    // ( 0x20101140 .. 0x20101150 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 30'h20101140  && write_transaction  ) begin
            src_channel = 32'b0000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x20101150 .. 0x20101160 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 30'h20101150  && write_transaction  ) begin
            src_channel = 32'b0000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
    end

    // ( 0x20101160 .. 0x20101170 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 30'h20101160  && write_transaction  ) begin
            src_channel = 32'b0000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x20101170 .. 0x20101180 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 30'h20101170  && write_transaction  ) begin
            src_channel = 32'b0000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
    end

    // ( 0x20101180 .. 0x20101190 )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 30'h20101180   ) begin
            src_channel = 32'b0010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x20101190 .. 0x201011a0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 30'h20101190   ) begin
            src_channel = 32'b0001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x201011a0 .. 0x201011b0 )
    if ( {address[RG:PAD18],{PAD18{1'b0}}} == 30'h201011a0   ) begin
            src_channel = 32'b0000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x201011b0 .. 0x201011c0 )
    if ( {address[RG:PAD19],{PAD19{1'b0}}} == 30'h201011b0  && write_transaction  ) begin
            src_channel = 32'b0000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
    end

    // ( 0x201011c0 .. 0x201011d0 )
    if ( {address[RG:PAD20],{PAD20{1'b0}}} == 30'h201011c0   ) begin
            src_channel = 32'b0000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x201011d0 .. 0x201011e0 )
    if ( {address[RG:PAD21],{PAD21{1'b0}}} == 30'h201011d0   ) begin
            src_channel = 32'b0000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0x201011e0 .. 0x201011e8 )
    if ( {address[RG:PAD22],{PAD22{1'b0}}} == 30'h201011e0   ) begin
            src_channel = 32'b0100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
    end

    // ( 0x201011e8 .. 0x201011f0 )
    if ( {address[RG:PAD23],{PAD23{1'b0}}} == 30'h201011e8  && read_transaction  ) begin
            src_channel = 32'b0000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
    end

    // ( 0x201011f0 .. 0x201011f8 )
    if ( {address[RG:PAD24],{PAD24{1'b0}}} == 30'h201011f0   ) begin
            src_channel = 32'b0000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


