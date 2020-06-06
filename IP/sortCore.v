`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Akzhol Baktiyat
// 
// Create Date: 04/15/2020 12:31:11 PM
// Design Name: 
// Module Name: sortCore
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
module sortCore(
input clock,
input reset,
input start,
input [31:0] DataIn,
input writeEn,
input readEn,
output [31:0] DataOut,
output reg fifoDone
    );

reg [9:0] aAddr;
reg [31:0] aDataIn;
reg [31:0] bDataIn;
reg aWrEn;
reg bWrEn;
wire [31:0] aDataOut;
wire [31:0] bDataOut;
reg [2:0] state;
reg [9:0] size;
reg [9:0] sort_counter;
reg [9:0] counter;
reg writeDone;
reg swapped;
reg done;

    localparam  IDLE  = 'd0,
                READ = 'd1,
                WAIT = 'd2,                
                COMPARE = 'd3,
                INCREMENT = 'd4,
                STORE = 'd5,
                DONE = 'd6;
    
always @ (posedge clock)
begin  
    if(reset)
    begin
        state <= IDLE;
        done <= 0;
        aWrEn <= 0;
        bWrEn <= 0;
        aDataIn <= 0;
        bDataIn <= 0;
        size <= 0;
        sort_counter <= 0;
        aDataIn <= DataIn;
        swapped <=0; 
        fifoDone <=0; 
    end
    else 
    begin
        case(state)
            IDLE:begin
                if(start)
                begin 
                    state <= READ;
                    aWrEn <= 1;
                    aAddr <= 0;
                    done <= 0;
                    size <= 0;
                    writeDone <=0;
                    sort_counter <= 0;        
                    aDataIn <=DataIn;
                    swapped <=0; 
                    fifoDone <=0;                  
                end
            end
            READ:begin
                if(writeEn)
                begin
                    aAddr <= aAddr+1;
                    aDataIn <= DataIn;
                    size <= size + 1;
                    writeDone <=1;
                end
                else
                begin
                    if(writeDone)
                    begin 
                        state <= WAIT;
                        sort_counter <=size-1;
                        counter <=size;
                        aAddr <= 0;
                        aWrEn <= 0;
                        bWrEn <= 0;
                     end 
                     else 
                     begin
                        aDataIn <=DataIn;
                     end
                end
                
                end 
            WAIT: begin
                state<=COMPARE;
            end
            COMPARE:begin
                if(!counter)
                begin
                    state <= STORE;
                    aAddr <= 0;
                end
                else
                begin
                    if(aDataOut>bDataOut)
                    begin
                        swapped <= 1;
                        aDataIn <= bDataOut;
                        bDataIn <= aDataOut; 
                        aWrEn <= 1;
                        bWrEn <= 1;
                    end
                    state <= INCREMENT;   
                end    
            end

            INCREMENT:begin 
                aWrEn <= 0;
                bWrEn <= 0;         
                state <= WAIT;
                if (sort_counter==0)
                begin
                    aAddr <= 0;
                    sort_counter <= counter-2;
                    counter <= counter-1;
                    if(!swapped) 
                        counter <=0;
                    else
                        swapped <=0;
                end
                else begin
                    sort_counter <= sort_counter-1;                          
                    aAddr <= aAddr+1;
                end
                end 
            STORE:begin
               done<=1;
               aAddr <= aAddr+1;
               if(aAddr == size+1)
               begin
                    state <= DONE;
                    done <=0;
                    aWrEn <= 0;
                    bWrEn <= 0;
                    fifoDone <=1;
               end
            end
            DONE:begin
                if(readEn)
                begin
                    if(size) 
                    begin
                        size <=size-1;
                    end
                    else begin
                        state <=IDLE;
                    end
                end
            end
        endcase
     end   
  end

blk_mem_gen_0 bram (
  .clka(clock),    // input wire clka
  .wea(aWrEn),      // input wire [0 : 0] wea
  .addra(aAddr),  // input wire [9 : 0] addra
  .dina(aDataIn),    // input wire [31 : 0] dina
  .douta(aDataOut),  // output wire [31 : 0] douta
  .clkb(clock),    // input wire clkb
  .web(bWrEn),      // input wire [0 : 0] web
  .addrb(aAddr+1),  // input wire [9 : 0] addrb
  .dinb(bDataIn),    // input wire [31 : 0] dinb
  .doutb(bDataOut)  // output wire [31 : 0] doutb
);

fifo_generator_0 fifo (
  .clk(clock),      // input wire clk
  .srst(reset),    // input wire srst
  .din(aDataOut),      // input wire [31 : 0] din
  .wr_en(done),  // input wire wr_en
  .rd_en(readEn),  // input wire rd_en
  .dout(DataOut),    // output wire [31 : 0] dout
  .full(),    // output wire full
  .empty()  // output wire empty
);
endmodule 
