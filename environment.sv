`include "header.h"
`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "iMonitor.sv"
`include "oMonitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class environment;
  //components class handles
  generator gen;
  driver drv;
  iMonitor iMon;
  oMonitor oMon;
  scoreboard scb;
  coverage cov;
  
  //Stimulus packet count
  bit [31:0] no_of_pkts;//assigned in testcase
  bit env_disable_report; //used to turn off the report function in env from testclass
  bit env_disable_EOT; //used to turn off the simulation wait in env from testclass
  string testname; //used to identify the testname in the environment
  
  bit cov_status; //used for coverage component
  //mailbox class handles
  //Below will be connected to generator and driver(Generator->Driver)
  mailbox_inst gen_drv_mbox;
  //Below will be connected to input monitor and mon_in in scoreborad (iMonitor->scoreboard)
  mailbox_inst imon_scb_mbox;
  
  //Below will be connected to output monitor and mon_out in scoreborad (oMonitor->scoreboard)
  mailbox_inst omon_scb_mbox;
  
  //virtual interface handles required for Driver,iMonitor and oMonitor
  virtual router_if.tb_mod_port vif;
  virtual router_if.tb_mon vif_mon_in;
  virtual router_if.tb_mon vif_mon_out;
  
  //custom constructor with virtual interface handles as arguments and pkt count
  function new(input virtual router_if.tb_mod_port vif_arg,
               input virtual router_if.tb_mon  vif_mon_in_arg,
               input virtual router_if.tb_mon  vif_mon_out_arg,
               input string testname,
               input bit [31:0] no_of_pkts
              );
    this.vif = vif_arg;
    this.vif_mon_in = vif_mon_in_arg;
    this.vif_mon_out = vif_mon_out_arg;
    this.testname = testname;
    this.no_of_pkts = no_of_pkts;
  endfunction
  
  //Build Verification components and connect them
  function void build();
    $display("[Environment] build started at time=%0t",$time); 
    //Construct objects for mailbox handles.
    gen_drv_mbox = new(1);
    imon_scb_mbox = new;
    omon_scb_mbox = new;
    
    //Construct all components and connect them
    
    gen = new(gen_drv_mbox, no_of_pkts);
    drv = new(gen_drv_mbox, vif);
    iMon = new(imon_scb_mbox, vif_mon_in);
    oMon = new(omon_scb_mbox, vif_mon_out);
    scb = new(imon_scb_mbox, omon_scb_mbox);
    
    //coverage component and mailbox connection
    cov = new(imon_scb_mbox, testname);
    $display("[Environment] build ended at time=%0t",$time); 
  endfunction
  
  
  //run method to start all components.
  task run ;
    $display("[Environment] run started at time=%0t",$time); 
    //Start all the components of environment
    fork
      gen.run();
      drv.run();
      iMon.run();
      oMon.run();
      scb.run();
      if(cov_status)
        cov.run();
    join_any
    
    
    //Wait until scoreboard receives all packets from iMonitor and oMonitor
    if(!env_disable_EOT && this.testname == "Base_Test")
      wait(scb.total_pkts_recvd == no_of_pkts);  //Base_Test Termination
    else if(!env_disable_EOT && this.testname == "New_Test1")
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test1 Termination
    else if(!env_disable_EOT && this.testname == "New_Test2")
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test2 Termination
    else if(!env_disable_EOT && this.testname == "New_Test3")
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test3 Termination
    else if(!env_disable_EOT && this.testname == "New_Test4")
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test4 Termination
    else if(!env_disable_EOT && this.testname == "New_Test5")
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test5 Termination
    else if(!env_disable_EOT && this.testname == "New_Test6")
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test6 Termination
    else if(!env_disable_EOT && this.testname == "New_Test7")
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test7 Termination
    else if(!env_disable_EOT && this.testname == "New_Test8") //will be disabled by test8
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test8 Termination
    else if(!env_disable_EOT && this.testname == "New_Test9") //will be disabled by test9
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test9 Termination
    else if(!env_disable_EOT && this.testname == "New_Test10") //will be disabled by test10
      wait(scb.total_pkts_recvd == no_of_pkts);  //New_Test10 Termination

    
    //repeat(5) @(vif.cb);//drain time
    
    if(!env_disable_report && this.testname == "Base_Test")
      report();
    else if(!env_disable_report && this.testname == "New_Test1")
      report();
    else if(!env_disable_report && this.testname == "New_Test2")
      report();
    else if(!env_disable_report && this.testname == "New_Test3")
      report();
    else if(!env_disable_report && this.testname == "New_Test4")
      report();
    else if(!env_disable_report && this.testname == "New_Test5")
      report();
    else if(!env_disable_report && this.testname == "New_Test6")
      report();
    else if(!env_disable_report && this.testname == "New_Test7")
      report();
    else if(!env_disable_report && this.testname == "New_Test8") //will be disabled by test8
      report();
    else if(!env_disable_report && this.testname == "New_Test9") //will be disabled by test9
      report();
    else if(!env_disable_report && this.testname == "New_Test10") //will be disabled by test10
      report();
    
    $display("[Environment] run ended at time=%0t",$time); 
endtask
  
  //Define report method to print results.
  function void report();
    $display("\n[Environment] ****** Report Started ********** "); 
    //Call report method of iMon,oMon and scoreboard
    iMon.report();
    oMon.report();
    scb.report();
    if(cov_status)
      cov.report();
    
    $display("\n*******************************"); 
    //Check the results and print test Passed or Failed
    if(this.testname == "Base_Test")
      begin
        if(scb.m_mismatched == 0 && (no_of_pkts == scb.total_pkts_recvd))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
          end
      end
    else if(this.testname == "New_Test1")
      begin
        if(scb.m_mismatched == 0 && (no_of_pkts == scb.total_pkts_recvd))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
          end
      end 
    else if(this.testname == "New_Test2")
      begin
        if(scb.m_mismatched == 0 && (no_of_pkts == scb.total_pkts_recvd))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
          end
      end 
    else if(this.testname == "New_Test3")
      begin
        if(scb.m_mismatched == 0 && (no_of_pkts == scb.total_pkts_recvd))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
          end
      end 
    else if(this.testname == "New_Test4")
      begin
        if(scb.m_mismatched == 0 && (no_of_pkts == scb.total_pkts_recvd))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
          end
      end
    else if(this.testname == "New_Test5")
      begin
        if(scb.m_mismatched == 0 && (no_of_pkts == scb.total_pkts_recvd))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
          end
      end 
    else if(this.testname == "New_Test6")
      begin
        if(scb.m_mismatched == 0 && (no_of_pkts == scb.total_pkts_recvd))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
          end
      end 
    else if(this.testname == "New_Test7")
      begin
        if(scb.m_mismatched == 0 && (cov.coverage_score_test7 == 100.00))
          begin
            $display("%s :: TEST PASSED", testname);
          end
        else
          begin
            $display("%s::TEST FAILED",testname);
            $display("Matches = %d, Mis_Matches = %d", scb.m_matched, scb.m_mismatched);
            $display("Coverage Score : %f", cov.coverage_score_test7);
          end
      end 
    $display("*************************\n "); 
    $display("[Environment] ******** Report ended******** \n"); 
  endfunction

endclass

