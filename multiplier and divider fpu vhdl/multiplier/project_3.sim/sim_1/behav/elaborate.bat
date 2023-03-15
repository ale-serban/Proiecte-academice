@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 935a8892be3e456db8d07417886d6bba -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot test_bench_divider_behav xil_defaultlib.test_bench_divider -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
