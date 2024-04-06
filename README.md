# 1X1 Router
Verification of 1X1 router in System Verilog. The main intension of this repository is to document the verification plan and test case implementation in System Verilog testbench environment.

<details>
  <summary> Defining the black box design of Router 1X1 </summary>

  ### Router 1X1 is a switch, which can transfer a series of data in form of a packet from source port to the destination port. This DUT is not synthesizable, it is only designed for verification practices. The design also has control status registers.

  <li> Input Ports : clk, reset, dut_inp, inp_valid </li>

  <li> Output Ports : dut_outp, outp_valid, busy, error  </li>

  #### Input Signals Description

  <li> clk        : clock </li>
  <li> reset      : Active high, asynchronous reset </li>
  <li> dut_inp    : Data pin of 8-bits </li>
  <li> inp_valid  : active high, indicates valid data on dut_inp </li>

  #### Output Signals Description

  <li> dut_outp   : 8 bit output data </li>
  <li> outp_valid : Active high, indicates valid data on dut_outp </li>
  <li> busy       : Active high, indicates router availability </li>
  <li> error      : Active high, indicates error </li>

  #### Black Box Design

  ![image](https://github.com/lmadem/DPRAM/assets/93139766/899a5cbf-4f4a-4ff5-a67b-499e9c8d2034)

  #### Packet Format


  #### Input and Output Ports, Control and Status Registers


  <li> This router 1X1 is designed in system verilog. Please check out the file "router.sv" </li>
  
</details>

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for Router 1X1 

  <li> The idea is to build an environment in system verilog which can handle various testcases. The testcases has basic functionality checks, functional coverage hits, covering corner cases, erroneous cases, and error-injection checks</li>
  

  <details> 
    <summary> Test Plan </summary>

  ![image](https://github.com/lmadem/DPRAM/assets/93139766/513b9c91-3fff-4d29-95aa-8d11f876bfff)

  </details>
</details>

<details>
  <summary> Verification Results and EDA waveforms </summary>

  </details>

  <details> 
    <summary> SV Environment </summary>

   <li> Built a robust verification environment in System Verilog and implemented all the testcases as per the testplan. The SV testbench verification environment consists of header class, packet class, generator class, driver class, Monitor classes, scoreboard class, environment class, base_test class, test classes, program block, top module, interface and the design </li>

   <li> The SV Environment will be able to drive one testcase per simulation </li>

   ### Test Plan Status
  
   ![image](https://github.com/lmadem/DPRAM/assets/93139766/0f80f109-38c1-4b42-a3f4-b38bf9de0fb0)

   #### Base_Test EDA Waveform

   #### New_Test1 EDA Waveform

   #### New_Test2 EDA Waveform

   #### New_Test3 EDA Waveform

   #### New_Test4 EDA Waveform

   #### New_Test5 EDA Waveform

   #### New_Test6 EDA Waveform

   #### New_Test7 EDA Waveform

   #### New_Test8 EDA Waveform

   #### New_Test9 EDA Waveform

   #### New_Test10 EDA Waveform
 
  </details>
</details>

<details>
  <summary> EDA Playground Link and Simluation Steps </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/Tmmv
  ```

  #### Verification Standards

  <li> Constrained random stimulus, robust generator and driver, and In-order scoreboard </li>

  #### Simulation Steps
  
  <details>
    <summary> SV Environment </summary>

##### Step 1 : UnComment "top.sv", "interface.sv", and "test.sv"(lines 4,5,6) in testbench.sv file 

##### Step 2 : To run individual tests, please look into the above attached screenshots in SV Environment folder of Verification Results and EDA Waveforms

  </details>
</details>

<details>
  <summary>Challenge</summary>

#### Verifying all the address location of a Memory

</details>

