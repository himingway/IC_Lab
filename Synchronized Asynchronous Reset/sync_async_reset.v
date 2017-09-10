//Synchronized Asynchronous Reset
module sync_async_reset (
        input    clock,
        input    reset_n,
        input    data_a,
        input    data_b,
        output   out_a,
        output   out_b);
        
        reg     reg1, reg2;
        reg     reg3, reg4;
        assign  out_a = reg1;
        assign  out_b = reg2;
        assign  rst_n = reg4;
        always @ (posedge clock, negedge reset_n) begin
            if (!reset_n) begin
                reg3 <= 1'b0;
                reg4 <= 1'b0;
            end
            else begin
                reg3 <= 1'b1;
                reg4 <= reg3;
            end
        end
        
        always @ (posedge clock, negedge rst_n) begin
            if (!rst_n) begin
                reg1 <= 1'b0;
                reg2 <= 1'b0;
            end
            else begin
                reg1 <= data_a;
                reg2 <= data_b;
            end
        end
endmodule  // sync_async_reset