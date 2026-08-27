`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 05:46:25 PM
// Design Name: 
// Module Name: greater_4bit_top
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


module greater_4bit_top(
    input logic A3_4, //A_MSB
    input logic A2_4,
    input logic A1_4,
    input logic A0_4, //A_LSB
    input logic B3_4, //B_MSB
    input logic B2_4,
    input logic B1_4,
    input logic B0_4, //B_LSB
    output logic externalLED,
    output logic onboardLED
    );
    
    logic gr_MSB_result;
    logic eq_MSB_result;
    logic gr_LSB_result;

    greater_2bit gr_MSB_comp( 
        .A1(A3_4),
        .A0(A2_4),
        .B1(B3_4),
        .B0(B2_4),
        .externalLED(gr_MSB_result),
        .onboardLED()
    );
    
    equal_2bit eq_MSB_comp( 
        .A1(A3_4),
        .A0(A2_4),
        .B1(B3_4),
        .B0(B2_4),
        .externalLED(eq_MSB_result),
        .onboardLED()
    );
    
        greater_2bit gr_LSB_comp( 
        .A1(A1_4),
        .A0(A0_4),
        .B1(B1_4),
        .B0(B0_4),
        .externalLED(gr_LSB_result),
        .onboardLED()
    );
    
    assign externalLED = (gr_MSB_result) | (eq_MSB_result & gr_LSB_result); // A > B if 2-bit MSBs are greater, or if 2-bit MSBs are equal and 2-bit LSBs are greater
    assign onboardLED = ~externalLED; // onboardLED is inverse of externalLED for visual verification of 0 state
    
endmodule
