#!/usr/bin/env bash
#
# Simulate the MIPS processor with Icarus Verilog -- no FPGA needed.
#
#   ./sim/run.sh              run all testbenches
#   ./sim/run.sh snake        Part 1: the snake program on MIPS
#   ./sim/run.sh aluctrl      Part 1: ALU / control decode
#   ./sim/run.sh top          Part 2: whole board incl. the SWITCH input
#   ./sim/run.sh snake +vcd   also dump a .vcd for GTKWave
#
# Extra +plusargs are passed straight through, e.g.
#   ./sim/run.sh top +switch=3 +loopcnt=5 +vcd
#
set -u

# Always run from the lab_7 root: InstructionMemory.v and DataMemory.v load
# insmem_h.txt / datamem_h.txt with relative paths.
cd "$(dirname "$0")/.." || exit 1

RTL="MIPS.v ALU.v ControlUnit.v DataMemory.v InstructionMemory.v RegisterFile.v reg_half.v"
RTL="$RTL top.v clockdiv.v"
STUB="sim/dist_mem_stub.v"

if ! command -v iverilog >/dev/null 2>&1; then
  echo "error: iverilog not found. Install it with:  brew install icarus-verilog"
  exit 1
fi

# Two harmless diagnostics from the *provided* files are filtered out:
#   - "dangling input port" : reg_half.v leaves the unused DIST_MEM_GEN ports open
#   - "1364-2005 standard"  : $readmemh into a [N:0] array in the memory modules
NOISE='dangling input port|1364-2005 standard|timescale for clockdiv|inherited timescale is here'

# shellcheck disable=SC2086
build_and_run() {
  local tb=$1; shift
  echo "==================================================================="
  echo " $tb"
  echo "==================================================================="
  iverilog -g2005 -Wall -o "sim/$tb.out" -s "$tb" "sim/$tb.v" $STUB $RTL 2>&1 \
    | grep -Ev "$NOISE"
  [ -f "sim/$tb.out" ] || { echo "compile failed"; return 1; }
  vvp -n "sim/$tb.out" "$@" 2>&1 | grep -Ev "$NOISE"
  echo ""
}

status=0
case "${1:-all}" in
  snake)   shift || true; build_and_run tb_snake   "$@" || status=1 ;;
  aluctrl) shift || true; build_and_run tb_aluctrl "$@" || status=1 ;;
  top)     shift || true; build_and_run tb_top     "$@" || status=1 ;;
  all|"")  build_and_run tb_aluctrl || status=1
           build_and_run tb_snake   || status=1
           build_and_run tb_top     || status=1 ;;
  *)       echo "unknown target '$1' (use: snake | aluctrl | top | all)"; exit 1 ;;
esac

exit $status
