# 1X1 Router
Verification of 1X1 router in System Verilog. The main intension of this repository is to document the verification plan and test case implementation in System Verilog testbench environment.

<details>
  <summary> Defining the black box design of Router 1X1 </summary>

  #### Router 1X1 is a switch, which can transfer a series of data in form of a packet from source port to the destination port. 
  
  <li> Note :: This DUT is not synthesizable, it is only designed for verification practices. The design has control status registers. </li>

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

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/d31edb8e-35a0-49c5-b6dc-a43c88983832)

  #### Packet Format

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/7fff2584-70f0-4da7-ac12-d0b45958d596)

  <li> Minimum packet length is 12 bytes and max is 2000 bytes </li>
  <li> RTL(router) accepts 8-bits per clock </li>
  <li> inp_valid indicates start/end of packet at the source port </li>
  <li> outp_valid indicates start/end of packet at the destination port </li>
  
  #### I/O Pins

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/118731e4-df38-48f2-b8ec-253fdfda3fcf)

  #### pins to access Control Registers

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/85085177-f3a3-4f23-b4f1-3c7958c807b9)

  #### Control Registers
  
  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/c2dda49e-ffbf-4f2b-9a99-243d69e2078d)


  #### Status Registers

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/9b170ef9-f910-4590-bd70-91014c153986)


  <li> This router 1X1 is designed in system verilog. Please check out the file "router.sv" </li>
  
</details>

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for Router 1X1 

  <li> The idea is to build an environment in system verilog which can handle various testcases. The testcases has basic functionality checks, functional coverage hits, covering corner cases, erroneous cases, and error-injection checks</li>


  #### Test Plan

![image](https://github.com/lmadem/1X1-Router-/assets/93139766/697e4379-717d-4769-856a-adc093a3943d)




</details>

<details>
  <summary> Verification Results and EDA </summary>

  </details>

   <li> Built a robust verification environment in System Verilog and implemented all the testcases as per the testplan. The SV testbench verification environment consists of header class, packet class, generator class, driver class, Monitor classes, scoreboard class, environment class, base_test class, new test classes, program block, top module, interface and the design </li>

   <li> This environment will be able to drive one testcase per simulation </li>

   #### Test Plan Status
  
![image](https://github.com/lmadem/1X1-Router-/assets/93139766/9d1431c1-241d-41be-815a-700eb5ebc5d3)

<details>
  <summary> EDA Results </summary>
  
   #### Base_Test EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/5f4b171e-2e60-4081-9ce9-f9bfe7b6fcf6)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/8bfe0037-5c14-438e-9188-849ba0037f2c)

   #### New_Test1 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/30043458-c3fd-4cd9-b411-40082e73f45b)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/39887b3c-4f96-4bf2-b01b-be799cf5c5fa)

   #### New_Test2 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/50e03fff-0076-416a-869c-a4030530b2a4)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/d55b84a8-9010-463e-a07c-f14f00fea73a)

   #### New_Test3 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/4637978a-efb3-4054-800a-a9ba98bb5d4a)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/b0867691-5832-40e4-9ec2-f7e5fdcbf055)

   #### New_Test4 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/fc9a80d6-0bcd-4783-bdf4-d7e6ff565c8b)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/d2a2c247-ec2f-4bc9-8e5f-d3a3e3252bce)

   #### New_Test5 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/5d4b7b87-131c-4b14-867e-f868287dbb6f)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/eb5da57c-46e0-47c2-9bf3-1cf6e14d5be8)

   #### New_Test6 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/21685714-bab3-4376-9888-6ce4e2b0c5e6)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/3ef79023-ef33-4166-8341-a4e79024bd41)

   #### New_Test7 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/c197ef28-4689-474a-b7ef-03a7c2e5f4b4)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/b22073d1-e600-46eb-b959-982bdd6380e1)

   #### New_Test8 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/37877375-3fb6-4eea-b352-07273961def5)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/46320450-159c-4bef-810b-e464627f0822)

   #### New_Test9 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/2cbac9f7-7eac-4a61-807b-bd2790d2c3b4)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/7456aba8-0526-4b32-898f-6c0c1046e68e)

   #### New_Test10 EDA Result

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/3fa6ebc1-b06b-4fc5-9841-1a937eb1b837)

   ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/1934d149-c9bf-4c19-82e3-2fe5c4e85b44)

</details>
</details>

<details>
  <summary> EDA Playground Link and Simluation Steps </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/Tmmv
  ```

  #### Verification Standards

  <li> Constrained random stimulus, robust generator, driver, monitors, In-order scoreboard, coverage component and environment </li>

  #### Simulation Steps
  
  <details>
    <summary> SV Environment </summary>

##### Step 1 : UnComment "top.sv", "interface.sv", and "program_test.sv"(lines 3,4,5) in testbench.sv file 

##### Step 2 : To run individual tests, please look into the above attached screenshots of EDA Results

  </details>
</details>

<details>
  <summary>Challenge</summary>

#### The error-injection and erroneous cases 
<li> The simulation environment is hanging and going into a forever loop. It is because the run() task of driver, imonitor and omonitor components run forever, the output monitor block will end up in a forever loop when the stimulus is error-injected or erroneous </li>
<li> Here, the design has status registers and it became easy to test error-injection and erroneous testcases </li>
<li> But in general, the mechanism to control the simulation environment in an organized way even for error-injection and erroneous cases are bit tricky</li>
<li> The solution would be using UVM, as it has objections and timeouts </li>
<li> Reference link for the above problem : https://verificationacademy.com/forums/t/how-to-stop-a-simulation-in-a-controlled-way/35064 </li>


</details>

