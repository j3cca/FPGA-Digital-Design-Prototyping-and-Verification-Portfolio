`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 12:29:43 PM
// Design Name: 
// Module Name: decoder3_8
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


module decoder3_8(
    input logic [2:0] s,
    output logic [7:0] d
    );
    
    decoder2_4 LSB_decoder(
        .s({s[1], s[0]}), //when instantiating using vector notation, bits map in descending order
        .en(~s[2]), //negate enable to output only when = 0
        .d({d[3], d[2], d[1], d[0]})
    );
    
        decoder2_4 MSB_decoder(
        .s({s[1], s[0]}),
        .en(s[2]), //enable is not negated, outputting only when = 1
        .d({d[7], d[6], d[5], d[4]})
    );
    
endmodule
