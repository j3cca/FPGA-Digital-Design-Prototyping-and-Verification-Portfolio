`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2026 06:07:25 PM
// Design Name: 
// Module Name: decoder2_4
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


module decoder2_4(

    input logic [1:0] s, //selection bits
    input logic en, //enable signal
    output logic [3:0] d //output bits
    );
    
    assign d[0] = ~s[1] & ~s[0] & en;
    assign d[1] = ~s[1] & s[0] & en;
    assign d[2] = s[1] & ~s[0] & en;
    assign d[3] = s[1] & s[0] & en;
    
endmodule
