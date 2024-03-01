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

  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper
  Vtop *top = new Vtop;
  VerilatedFstC *trace = new VerilatedFstC;
  top->trace(trace, 1); //99 leveles of hierarchy
  const char *trace_file_name = "wave_verilator.fst";
  trace->open(trace_file_name);

  Verilated::scopesDump();
  // svSetScope(svGetScopeFromName ("TOP.top"));
  // Vtop::publicSetBool(1);

  top->clk = 0;
  while (t < 100 && !contextp->gotFinish()) {
    t = contextp->time();

    top->clk = !top->clk;

    if (t < 5) {
      top->reset = 1;
    } else {
      top->reset = 0;
      Verilated::assertOn(true);
    }

    if (t == 11)
      top->button = 1;
    else
      top->button = 0;

    contextp->timeInc(1);
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
