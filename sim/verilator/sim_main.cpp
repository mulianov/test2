#include <verilated.h>
#include <verilated_fst_c.h>

#include "Vtop.h"
// #include "Vtop__Dpi.h"

vluint64_t main_time = 0;

int add(int a, int b) { return a + b; };

int main(int argc, char **argv, char **env) {
  Verilated::debug(0);
  Verilated::randReset(2);
  Verilated::traceEverOn(true);
  Verilated::commandArgs(argc, argv);
  Verilated::mkdir("logs");

  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper
  Vtop *top = new Vtop;
  VerilatedFstC *trace = new VerilatedFstC;
  top->trace(trace, 99);
  const char *trace_file_name = "wave_verilator.fst";
  trace->open(trace_file_name);

  // Verilated::scopesDump();
  // svSetScope (svGetScopeFromName ("TOP.top"));
  // Vtop::publicSetBool(1);

  top->clk = 0;
  // while (!Verilated::gotFinish()) {
  while (main_time < 100) {
    ++main_time;
    top->clk = !top->clk;
    top->reset = (main_time < 5) ? 1 : 0;
    // VerilatedCov::zero();
    if (main_time == 11)
      top->button = 1;
    else
      top->button = 0;
    top->eval();
    trace->dump(10 * main_time + 5);
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
