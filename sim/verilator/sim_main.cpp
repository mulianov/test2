#include <verilated.h>
#include <verilated_fst_c.h>

#include "Vtop.h"
// #include "Vtop__Dpi.h"

int add(int a, int b) { return a + b; };


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

  Vtop *top = new Vtop;
  VerilatedFstC *trace = new VerilatedFstC;
  top->trace(trace, 1);
  const char *trace_file_name = "wave_verilator.fst";
  trace->open(trace_file_name);

  int clk = 0;

  while (t < 100 && !contextp->gotFinish()) {
    top->clk = ~top->clk;

    ++t;

    top->reset = (t < 5) ? 1 : 0;
    top->button = (t == 11) ? 1 : 0;

    top->eval();
    trace->dump(t);
  }

  trace->flush();
  trace->close();
  trace = NULL;

  top->final();

#if VM_COVERAGE
  Verilated::mkdir("logs");
  VerilatedCov::write("logs/coverage.dat");
#endif

  delete top;
  top = NULL;
  exit(0);
}
