`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 07:15:56 PM
// Design Name: 
// Module Name: TB_decoder4_16
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


module TB_decoder4_16;

    // -- signal declarations --
    logic [3:0] s_tb;
    logic [15:0] d_tb;
    
    // -- TB variables --
    logic [15:0] expected_D;
    int pass_count;
    int fail_count;
    
    // -- UUT instantiation --
    decoder4_16 UUT( 
        .s(s_tb),
        .d(d_tb)
    );
    
    initial begin
        pass_count = 0;
        fail_count = 0;
        
        $display("-- Starting Test Bench --");
        
        //outer loop = sets enable to select the active decoder 
        for (int i = 0; i <= 3; i++) begin
            s_tb[3:2] = i;    
            
            //inner loop = sets the select bit to choose the output of the decoder
            for (int j = 0; j <= 3; j++) begin
                s_tb[1:0] = j; 
                
                expected_D = 16'b0000_0000_0000_0001 << s_tb; //since enable is handled by s[3:2], no need for conditionals in shift operator
            
                #1; //delay to allow calculation time
            
                // -- pass condition --
                if (expected_D == d_tb) begin
                    pass_count++;
                    $display("PASS test: %2b outputs %16b (en = %2b)", s_tb[1:0], d_tb, s_tb[3:2]);
                end
                
                // -- fail condition --
                else begin
                    fail_count++;
                    $display("FAIL test: %2b incorrectly outputs %16b (en = %2b) (expected = %16b)", s_tb[1:0], d_tb, s_tb[3:2], expected_D);
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
