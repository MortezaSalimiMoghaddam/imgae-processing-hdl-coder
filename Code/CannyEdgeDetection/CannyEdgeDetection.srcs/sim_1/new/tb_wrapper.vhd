library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity canny_tb is
end entity;

architecture test of canny_tb is
    -- Clock and reset
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    
    -- Image memory-mapped interface
    signal wr_en  : std_logic := '0';
    signal wr_addr : std_logic_vector(17 downto 0) := (others => '0');
    signal wr_data : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_en  : std_logic := '0';
    signal rd_addr : std_logic_vector(17 downto 0) := (others => '0');
    signal rd_data : std_logic_vector(31 downto 0);

    -- File handling
    file input_file  : text open read_mode  is "D:\SBU\1\VHDL\Project\Code\MATLAB\input.txt";
    file output_file : text open write_mode is "D:\SBU\1\VHDL\Project\Code\MATLAB\output.txt";


begin
    -- Instantiate DUT (Device Under Test)
    DUT: entity work.wrapper
    port map (
        clk => clk,
        rst => rst,
            mmap_wr_en   => wr_en,
            mmap_wr_addr => wr_addr,
            mmap_wr_data => wr_data,

            mmap_rd_en   => rd_en,
            mmap_rd_addr => rd_addr,
            mmap_rd_data => rd_data
    );

    -- Clock process
    clk_process: process
    begin
        while now < 40000 ns loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus: process
    variable input_line  : line;
    variable output_line : line;
    variable addr_val, data_val : integer;
    begin
        -- Reset sequence
        rst <= '1';
        wait for 40 ns;
        rst <= '0';
        wait for 40 ns;

        -- Writing Image Data
        while not endfile(input_file) loop
            readline(input_file, input_line);
            read(input_line, addr_val);
            read(input_line, data_val);
            
            wr_en <= '1';
            wr_addr <= std_logic_vector(to_unsigned(addr_val, 18));
            wr_data <= std_logic_vector(to_unsigned(data_val, 32));
            wait for 20 ns;
            wr_en <= '0';
        end loop;
        
        wait for 100 ns; -- Wait for processing to complete

        -- Reading Processed Data
        for i in 0 to 1023 loop
            rd_en <= '1';
            rd_addr <= std_logic_vector(to_unsigned(i, 18));
            wait for 20 ns;
            rd_en <= '0';

            -- Write output to file
            write(output_line, i);
            write(output_line, string'(" "));
            write(output_line, to_integer(unsigned(rd_data)));
            writeline(output_file, output_line);
        end loop;

        report "Simulation completed" severity note;
        wait;
    end process;
end architecture;
