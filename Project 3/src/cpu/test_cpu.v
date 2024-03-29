`include "cpu.v"
`timescale 1ns/1ps

module test_cpu;

  reg clk;

  CPU cpu_inst (
    .CLK(clk)
  );

    initial begin
        $dumpfile("dump.vcd");
    end

  always begin
    #5 clk = ~clk;
  end

  initial begin
    integer file;
    integer i;
    reg [255:0] line;

    file = $fopen("../../testcase/cpu_test/machine_code1.txt", "r");

    if (file) begin
        for (i = 0; i < 512; i = i + 1) begin
            // $display(cpu_inst.instruction_ram.RAM[i]);
            if (!$feof(file)) begin
                $fgets(line, file);
                $sscanf(line, "%b", cpu_inst.instruction_ram.RAM[i]);
            end else begin
                cpu_inst.instruction_ram.RAM[i] = 32'b11111111111111111111111111111111; // End instruction
            end
        end
        $fclose(file);
    end else begin
        $display("Error: Cannot open machine_code1.txt");
        $finish;
    end
  end

  initial begin
    integer data_file;
    integer i;
    clk = 0;

    #1000

    data_file = $fopen("data.bin", "wb");
    
    if (data_file) begin
        for (i = 0; i < 512; i = i + 1) begin
            // $display(cpu_inst.data_memory.DATA_RAM[i]);
            $fwrite(data_file, "%b\n", cpu_inst.data_memory.DATA_RAM[i]);
        end
        $fclose(data_file);
    end else begin
        $display("Error: Cannot open data.bin");
    end  

    $finish;
  end



endmodule
