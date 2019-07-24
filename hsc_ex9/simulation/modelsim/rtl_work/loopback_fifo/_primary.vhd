library verilog;
use verilog.vl_types.all;
entity loopback_fifo is
    port(
        clock           : in     vl_logic;
        data            : in     vl_logic_vector(31 downto 0);
        rdreq           : in     vl_logic;
        wrreq           : in     vl_logic;
        q               : out    vl_logic_vector(31 downto 0);
        usedw           : out    vl_logic_vector(9 downto 0)
    );
end loopback_fifo;
