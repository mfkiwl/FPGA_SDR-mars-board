library verilog;
use verilog.vl_types.all;
entity mcic is
    port(
        clk             : in     vl_logic;
        clken           : in     vl_logic;
        in_data         : in     vl_logic_vector(19 downto 0);
        in_error        : in     vl_logic_vector(1 downto 0);
        in_ready        : out    vl_logic;
        in_valid        : in     vl_logic;
        out_data        : out    vl_logic_vector(15 downto 0);
        out_error       : out    vl_logic_vector(1 downto 0);
        out_ready       : in     vl_logic;
        out_valid       : out    vl_logic;
        reset_n         : in     vl_logic
    );
end mcic;
