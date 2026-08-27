`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 6:45:17 PM
// Design Name: 
// Module Name: decoder4_16
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module decoder4_16(
    input logic [3:0] s, //s[3:2] = enable signal to select active decoder, s[1:0] = select bits to choose output of chosen decoder
    output logic [15:0] d //output
    );
    
    //decoder for LSBs
    decoder2_4 decoder_0(
        .s(s[1:0]), //when instantiating using vector notation, bits map in descending order
        .en(~s[2] & ~s[3]), //enabled by s[3:2] = 00
        .d(d[3:0]) //LSB output
    );
    
        decoder2_4 decoder_1(
        .s(s[1:0]),
        .en(s[2] & ~s[3]), //enabled by s[3:2] = 01
        .d(d[7:4])
    );
    
    decoder2_4 decoder_2(
        .s(s[1:0]),
        .en(~s[2] & s[3]), //enabled by s[3:2] = 10
        .d(d[11:8])
    );
    
        //decoder for MSBs
        decoder2_4 decoder_3(
        .s(s[1:0]),
        .en(s[2] & s[3]), //enabled by s[3:2] = 11
        .d(d[15:12]) //MSB output
    );
    
endmodule
