program testbench(router_if vif);
  //Include test cases
  `include "base_test.sv"
  //`include "new_test1.sv"
  //`include "new_test2.sv"
  //`include "new_test3.sv"
  //`include "new_test4.sv"
  //`include "new_test5.sv"
  //`include "new_test6.sv"
  //`include "new_test7.sv"
  //`include "new_test8.sv"
  //`include "new_test9.sv"
  //`include "new_test10.sv"
  
  //test class handles
  base_test test;
  //new_test1 test;
  //new_test2 test;
  //new_test3 test;
  //new_test4 test;
  //new_test5 test;
  //new_test6 test;
  //new_test7 test;
  //new_test8 test;
  //new_test9 test;
  //new_test10 test;
  
  //Verification Flow
  string testname; //used to identify the testname in the environment
  
  initial 
    begin
      $display("[Program Block] Simulation Started at time=%0t",$time);
      //Construct test object and pass required interface handles

      test = new(vif.tb_mod_port, vif.tb_mon, vif.tb_mon, "Base_Test");
      //test = new(vif.tb_mod_port, vif.tb_mon, vif.tb_mon, "New_Test8");
      
      //Start the testcase
      
      test.run();
      
      $display("[Program Block] Simulation Finished at time=%0t",$time);
    
    end

endprogram

