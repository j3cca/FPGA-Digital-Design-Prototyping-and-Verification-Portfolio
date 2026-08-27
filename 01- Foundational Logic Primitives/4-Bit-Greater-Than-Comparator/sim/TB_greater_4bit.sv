`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2026 05:51:42 PM
// Design Name: 
// Module Name: TB_greater_4bit
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


module TB_greater_4bit;

    // -- signal declarations --
    logic [3:0] A_tb;
    logic [3:0] B_tb;
    logic externalLED_tb;
    logic onboardLED_tb;
    
    // -- TB variables --
    logic expectedLED;
    int pass_count;
    int fail_count;
    
    // -- UUT instantiation --
    greater_4bit_top UUT( 
        .A3_4(A_tb[3]),
        .A2_4(A_tb[2]),
        .A1_4(A_tb[1]),
        .A0_4(A_tb[0]),
        .B3_4(B_tb[3]),
        .B2_4(B_tb[2]),
        .B1_4(B_tb[1]),
        .B0_4(B_tb[0]),
        .externalLED(externalLED_tb),
        .onboardLED(onboardLED_tb)
    );
    
    initial begin
        pass_count = 0;
        fail_count = 0;
        
        $display("-- Starting Test Bench --");
        
        //outer loop = A value changing
        for (int i = 0; i<=15; i++) begin
            A_tb = i;
            
            //inner loop = B value changing
            for (int j = 0; j<=15; j++) begin
                B_tb = j;
                
                expectedLED = A_tb > B_tb;
                
                #1; //delay to allow calculation time
                
                // -- pass condition --
                if (expectedLED == externalLED_tb) begin
                    pass_count++;
                    $display("PASS test: %4b > %4b (%1b)", A_tb, B_tb, expectedLED);
                end
                
                // -- fail condition --
                else begin
                    fail_count++;
                    $display("FAIL test: %4b !> %4b (%1b)", A_tb, B_tb, expectedLED);
                end
                
                #9; //delay before next loop
            end
        end
        
        $display("-- Test Bench Summary --");
        $display("Pass count: %0d", pass_count);
        $display("Fail count: %0d", fail_count);
        
        if (fail_count == 0) begin
            $display("All tests passed!");
        end
        
        else begin
            $display("Test failed.");
        end
        
        $finish; //finish simulation
    end
endmodule
