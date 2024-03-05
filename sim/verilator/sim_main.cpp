#include <verilated.h>
#include <verilated_fst_c.h>
#include <math.h>

#include "Vtop_tb.h"

int main(int argc, char **argv, char **env) {
  const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
  vluint64_t t = 0;

  Verilated::debug(0);
  Verilated::randReset(2);
  Verilated::traceEverOn(true);
  Verilated::commandArgs(argc, argv);
  Verilated::mkdir("logs");
  Verilated::assertOn(false);
  VerilatedCov::zero();

  Vtop_tb *tb = new Vtop_tb;

  int clk = 0;

  uint32_t tu = pow(10, contextp->timeunit() - contextp->timeprecision());

  while (!contextp->gotFinish()) {
    contextp->timeInc(CLK_PERIOD / 2 * tu);  // 1 timeprecision period passes...
    tb->clk = !tb->clk; // Toggle a fast (time/2 period) clock
    tb->eval();
  }

  tb->final();

#if VM_COVERAGE
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage.dat");
#endif

  delete tb;
  tb = NULL;
  exit(0);
}
