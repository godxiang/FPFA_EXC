library verilog;
use verilog.vl_types.all;
entity hsc is
    port(
        ext_clk         : in     vl_logic;
        ext_rst_n       : in     vl_logic;
        fx3_flaga       : in     vl_logic;
        fx3_flagb       : in     vl_logic;
        fx3_flagc       : in     vl_logic;
        fx3_flagd       : in     vl_logic;
        fx3_pclk        : out    vl_logic;
        fx3_slcs_n      : out    vl_logic;
        fx3_slwr_n      : out    vl_logic;
        fx3_slrd_n      : out    vl_logic;
        fx3_sloe_n      : out    vl_logic;
        fx3_pktend_n    : out    vl_logic;
        fx3_a           : out    vl_logic_vector(1 downto 0);
        fx3_db          : inout  vl_logic_vector(31 downto 0);
        led             : out    vl_logic
    );
end hsc;
