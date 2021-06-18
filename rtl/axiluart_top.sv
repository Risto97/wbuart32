`include "register_interface/typedef.svh"
`include "register_interface/assign.svh"

module axiluart_top
    #(
      parameter int unsigned AXI_ADDR_WIDTH = 32,
      localparam int unsigned AXI_DATA_WIDTH = 32,
      parameter int unsigned AXI_ID_WIDTH,
      parameter int unsigned AXI_USER_WIDTH
      )
(
    input clk_i,
    input rst_ni,

    AXI_BUS.Slave axi_slave

);

    logic testmode_i;
    assign testmode_i = 0;

    logic rx, tx, cts_n, rts_n, rx_int, tx_int, rxfifo_int, tx_fifo_int;

    AXI_LITE #(.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH), .AXI_DATA_WIDTH(AXI_DATA_WIDTH)) master();


    axi_to_axi_lite_intf #(.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
                           .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
                           .AXI_ID_WIDTH(AXI_ID_WIDTH),
                           .AXI_USER_WIDTH(AXI_USER_WIDTH))
                           i_axi2_axil (
                            .clk_i(clk_i),
                            .rst_ni(rst_ni),
                            .testmode_i(testmode_i),
                            .slv(axi_slave),
                            .mst(master)
                           );

    axiluart #(.C_AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
               .C_AXI_DATA_WIDTH(AXI_DATA_WIDTH))
               i_axiluart(
                .S_AXI_ACLK(clk_i),
                .S_AXI_ARESETN(rst_ni),
                .S_AXI_AWVALID(master.aw_valid),
                .S_AXI_AWREADY(master.aw_ready),
                .S_AXI_AWADDR(master.aw_addr),
                .S_AXI_AWPROT(master.aw_prot),
                .S_AXI_WVALID(master.w_valid),
                .S_AXI_WREADY(master.w_ready),
                .S_AXI_WDATA(master.w_data),
                .S_AXI_WSTRB(master.w_strb),
                .S_AXI_BVALID(master.b_valid),
                .S_AXI_BREADY(master.b_ready),
                .S_AXI_BRESP(master.b_resp),
                .S_AXI_ARVALID(master.ar_valid),
                .S_AXI_ARREADY(master.ar_ready),
                .S_AXI_ARADDR(master.ar_addr),
                .S_AXI_ARPROT(master.ar_prot),
                .S_AXI_RVALID(master.r_valid),
                .S_AXI_RREADY(master.r_ready),
                .S_AXI_RDATA(master.r_data),
                .S_AXI_RRESP(master.r_resp),
                .i_uart_rx(rx),
                .o_uart_tx(tx),
                .i_cts_n(cts_n),
                .o_rts_n(rts_n),
                .o_uart_rx_int(rx_int),
                .o_uart_tx_int(tx_int),
                .o_ouart_rxfifo_int(rxfifo_int),
                .o_uart_txfifo_int(txfifo_int)
               );
endmodule

