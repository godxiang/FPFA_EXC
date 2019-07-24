library verilog;
use verilog.vl_types.all;
entity usb_controller is
    generic(
        FXS_REST        : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        FXS_IDLE        : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        FXS_READ        : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        FXS_RDLY        : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        FXS_RSOP        : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        FXS_WRIT        : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        FXS_WSOP        : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        FX3_ON          : vl_logic := Hi0;
        FX3_OFF         : vl_logic := Hi1
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        fx3_flaga       : in     vl_logic;
        fx3_flagb       : in     vl_logic;
        fx3_flagc       : in     vl_logic;
        fx3_flagd       : in     vl_logic;
        fx3_slcs_n      : out    vl_logic;
        fx3_slwr_n      : out    vl_logic;
        fx3_slrd_n      : out    vl_logic;
        fx3_sloe_n      : out    vl_logic;
        fx3_pktend_n    : out    vl_logic;
        fx3_a           : out    vl_logic_vector(1 downto 0);
        fx3_db          : inout  vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FXS_REST : constant is 1;
    attribute mti_svvh_generic_type of FXS_IDLE : constant is 1;
    attribute mti_svvh_generic_type of FXS_READ : constant is 1;
    attribute mti_svvh_generic_type of FXS_RDLY : constant is 1;
    attribute mti_svvh_generic_type of FXS_RSOP : constant is 1;
    attribute mti_svvh_generic_type of FXS_WRIT : constant is 1;
    attribute mti_svvh_generic_type of FXS_WSOP : constant is 1;
    attribute mti_svvh_generic_type of FX3_ON : constant is 1;
    attribute mti_svvh_generic_type of FX3_OFF : constant is 1;
end usb_controller;
