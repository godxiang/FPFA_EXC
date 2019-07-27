
##########################################################
#时钟和复位接口
set_location_assignment PIN_E15 -to ext_clk
set_location_assignment PIN_E16 -to ext_rst_n

##########################################################
#LED指示灯接口
set_location_assignment PIN_A5 -to led

##########################################################
#DDR2接口
set_location_assignment PIN_T15 -to mem_clk_n[0]
set_location_assignment PIN_N16 -to mem_dq[15]
set_location_assignment PIN_J14 -to mem_dq[14]
set_location_assignment PIN_P15 -to mem_dq[13]
set_location_assignment PIN_L13 -to mem_dq[12]
set_location_assignment PIN_L16 -to mem_dq[11]
set_location_assignment PIN_R16 -to mem_dq[10]
set_location_assignment PIN_K16 -to mem_dq[9]
set_location_assignment PIN_N15 -to mem_dq[8]
set_location_assignment PIN_N6 -to mem_dq[7]
set_location_assignment PIN_L8 -to mem_dq[6]
set_location_assignment PIN_R5 -to mem_dq[5]
set_location_assignment PIN_R7 -to mem_dq[4]
set_location_assignment PIN_M6 -to mem_dq[3]
set_location_assignment PIN_N5 -to mem_dq[2]
set_location_assignment PIN_L7 -to mem_dq[1]
set_location_assignment PIN_R6 -to mem_dq[0]
set_location_assignment PIN_K15 -to mem_dqs[1]
set_location_assignment PIN_M7 -to mem_dqs[0]
set_location_assignment PIN_N14 -to mem_dm[1]
set_location_assignment PIN_P3 -to mem_dm[0]
set_location_assignment PIN_T4 -to mem_addr[12]
set_location_assignment PIN_R4 -to mem_addr[11]
set_location_assignment PIN_T7 -to mem_addr[10]
set_location_assignment PIN_J16 -to mem_addr[9]
set_location_assignment PIN_R12 -to mem_addr[8]
set_location_assignment PIN_T5 -to mem_addr[7]
set_location_assignment PIN_P8 -to mem_addr[6]
set_location_assignment PIN_P16 -to mem_addr[5]
set_location_assignment PIN_T12 -to mem_addr[4]
set_location_assignment PIN_T6 -to mem_addr[3]
set_location_assignment PIN_N11 -to mem_addr[2]
set_location_assignment PIN_R14 -to mem_addr[1]
set_location_assignment PIN_R11 -to mem_addr[0]
set_location_assignment PIN_R13 -to mem_ba[1]
set_location_assignment PIN_P9 -to mem_ba[0]
set_location_assignment PIN_N12 -to mem_cas_n
set_location_assignment PIN_T10 -to mem_cke[0]
set_location_assignment PIN_T14 -to mem_clk[0]
set_location_assignment PIN_R10 -to mem_cs_n[0]
set_location_assignment PIN_T11 -to mem_odt[0]
set_location_assignment PIN_P14 -to mem_ras_n
set_location_assignment PIN_T13 -to mem_we_n	

set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_addr
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_ba
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_cke
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_clk
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_clk_n
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_cs_n
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_dm
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_dq
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_dqs
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_odt
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_ras_n
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_cas_n
set_instance_assignment -name IO_STANDARD "SSTL-18 CLASS I" -to mem_we_n

##########################################################
#UART接口
set_location_assignment PIN_G2 -to uart_rx
set_location_assignment PIN_G1 -to uart_tx

##########################################################
#FX3接口
set_location_assignment PIN_A14 -to fx3_db[31]
set_location_assignment PIN_A7 -to fx3_db[30]
set_location_assignment PIN_A15 -to fx3_db[29]
set_location_assignment PIN_B12 -to fx3_db[28]
set_location_assignment PIN_B13 -to fx3_db[27]
set_location_assignment PIN_A11 -to fx3_db[26]
set_location_assignment PIN_B11 -to fx3_db[25]
set_location_assignment PIN_A13 -to fx3_db[24]
set_location_assignment PIN_A6 -to fx3_db[23]
set_location_assignment PIN_B10 -to fx3_db[22]
set_location_assignment PIN_D6 -to fx3_db[21]
set_location_assignment PIN_B6 -to fx3_db[20]
set_location_assignment PIN_A10 -to fx3_db[19]
set_location_assignment PIN_E7 -to fx3_db[18]
set_location_assignment PIN_C6 -to fx3_db[17]
set_location_assignment PIN_B7 -to fx3_db[16]
set_location_assignment PIN_F13 -to fx3_db[15]
set_location_assignment PIN_D9 -to fx3_db[14]
set_location_assignment PIN_C9 -to fx3_db[13]
set_location_assignment PIN_C11 -to fx3_db[12]
set_location_assignment PIN_F9 -to fx3_db[11]
set_location_assignment PIN_D11 -to fx3_db[10]
set_location_assignment PIN_D12 -to fx3_db[9]
set_location_assignment PIN_C14 -to fx3_db[8]
set_location_assignment PIN_E11 -to fx3_db[7]
set_location_assignment PIN_D14 -to fx3_db[6]
set_location_assignment PIN_F15 -to fx3_db[5]
set_location_assignment PIN_E10 -to fx3_db[4]
set_location_assignment PIN_F14 -to fx3_db[3]
set_location_assignment PIN_F16 -to fx3_db[2]
set_location_assignment PIN_G15 -to fx3_db[1]
set_location_assignment PIN_G16 -to fx3_db[0]
set_location_assignment PIN_B14 -to fx3_pclk
set_location_assignment PIN_F8 -to fx3_slcs_n
set_location_assignment PIN_D8 -to fx3_slwr_n
set_location_assignment PIN_E8 -to fx3_sloe_n
set_location_assignment PIN_C8 -to fx3_slrd_n
set_location_assignment PIN_D15 -to fx3_flaga
set_location_assignment PIN_C15 -to fx3_flagb
set_location_assignment PIN_A12 -to fx3_flagc
set_location_assignment PIN_D16 -to fx3_flagd
set_location_assignment PIN_E9 -to fx3_pktend_n
set_location_assignment PIN_B16 -to fx3_a[1]
set_location_assignment PIN_C16 -to fx3_a[0]

##########################################################
#200万像素摄像头接口
set_location_assignment PIN_B3 -to vdb[7]
set_location_assignment PIN_D5 -to vdb[6]
set_location_assignment PIN_A3 -to vdb[5]
set_location_assignment PIN_A2 -to vdb[4]
set_location_assignment PIN_B4 -to vdb[3]
set_location_assignment PIN_A4 -to vdb[2]
set_location_assignment PIN_E6 -to vdb[1]
set_location_assignment PIN_B5 -to vdb[0]
set_location_assignment PIN_B1 -to vhref
set_location_assignment PIN_E1 -to vpclk	
set_location_assignment PIN_F1 -to vscl
set_location_assignment PIN_F2 -to vsda
set_location_assignment PIN_C2 -to vvsync
set_location_assignment PIN_C3 -to vxclk		

##########################################################
#LCD的LVDS接口
set_instance_assignment -name IO_STANDARD LVDS -to lvdsclk
set_instance_assignment -name IO_STANDARD LVDS -to lvdsdb[2]
set_instance_assignment -name IO_STANDARD LVDS -to lvdsdb[1]
set_instance_assignment -name IO_STANDARD LVDS -to lvdsdb[0]
set_location_assignment PIN_N2 -to lvdsclk
set_location_assignment PIN_N1 -to "lvdsclk(n)"
set_location_assignment PIN_L2 -to lvdsdb[2]
set_location_assignment PIN_L1 -to "lvdsdb[2](n)"
set_location_assignment PIN_K2 -to lvdsdb[1]
set_location_assignment PIN_K1 -to "lvdsdb[1](n)"
set_location_assignment PIN_J2 -to lvdsdb[0]
set_location_assignment PIN_J1 -to "lvdsdb[0](n)"

set_instance_assignment -name IO_STANDARD LVDS -to lvds_txclk
set_instance_assignment -name IO_STANDARD LVDS -to lvds_rxclk
set_instance_assignment -name IO_STANDARD LVDS -to lvds_rxdb
set_instance_assignment -name IO_STANDARD LVDS -to lvds_txdb
set_location_assignment PIN_N2 -to lvds_txclk
set_location_assignment PIN_N1 -to "lvds_txclk(n)"
set_location_assignment PIN_M2 -to lvds_rxclk
set_location_assignment PIN_M1 -to "lvds_rxclk(n)"
set_location_assignment PIN_K2 -to lvds_rxdb
set_location_assignment PIN_K1 -to "lvds_rxdb(n)"
set_location_assignment PIN_J2 -to lvds_txdb
set_location_assignment PIN_J1 -to "lvds_txdb(n)"
