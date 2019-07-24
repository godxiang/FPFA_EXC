library verilog;
use verilog.vl_types.all;
entity sys_ctrl is
    port(
        ext_clk         : in     vl_logic;
        ext_rst_n       : in     vl_logic;
        sys_rst_n       : out    vl_logic;
        clk_25m         : out    vl_logic;
        fx3_pclk        : out    vl_logic;
        clk_50m         : out    vl_logic;
        clk_65m         : out    vl_logic;
        clk_100m        : out    vl_logic
    );
end sys_ctrl;
