`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2026 02:10:39 AM
// Design Name: 
// Module Name: bit2_top
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


module equal_2bit(
    input logic A1, //MSB1
    input logic A0, //LSB1
    input logic B1, //MSB2
    input logic B0, //LSB2
    output logic externalLED,
    output logic onboardLED
    );
    
    assign externalLED = (!A1 & !A0 & !B1 & !B0)|(!A1 & A0 & !B1 & B0)|(A1 & !A0 & B1 & !B0)|(A1 & A0 & B1 & B0);
    assign onboardLED = ~externalLED;

endmodule
