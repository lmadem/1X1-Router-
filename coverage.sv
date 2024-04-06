//Coverage class
class coverage;
  //packet class and mailbox handle
  packet pkt;
  mailbox_inst mbx;
  string testname;
  
  real coverage_score_test7; //to keep track of coverage score for testcase7
  
  //covergroup with required coverpoints for testcase7
  covergroup fcov7 with function sample(packet pkt);
    
    //Define bins for differnet sizes of packet using len .
    coverpoint pkt.len {
      bins length_small  = {[12:50]};
      bins length_medium = {[51:200]};
      bins length_large  = {[201:999]};
      bins length_extralarge = {[1000:1499]};
      bins jumbo_pkts = {[1500:2000]};
      //bins short_length={[$:11]};
      //bins max_length={[2001:$]};
    }
    
  endgroup
  
  //custom constructor with mailbox agrument
  function new(input mailbox_inst mbx_arg, string testname);
    this.mbx = mbx_arg;
    this.testname = testname;
    if(testname == "New_Test7")
      fcov7 = new;
  endfunction
  
  
  //report method to print the final functional coverage collected.
  function void report();
    //Call get_coverage method on fcov to get the functional coverage 
    if(testname == "New_Test7") begin
      coverage_score_test7 = fcov7.get_coverage();
      $display("********* Functional Coverage **********");
      $display("** coverage_score_test7=%0f ",coverage_score_test7);
      $display("**************************************");
    end
  endfunction
  
  //run task to sample the packet collected from input monitor mailbox
  virtual task run();
    while(1) 
      begin
        @(mbx.num);
        mbx.peek(pkt);
        //Call the sample with with transaction object as argument.
        if(testname == "New_Test7") begin
          fcov7.sample(pkt);
          coverage_score_test7 = fcov7.get_coverage();
          $display("[Coverage] Port Coverage=%0f ",fcov7.get_coverage());
          if(coverage_score_test7 == 100.00) begin
            $display("Hit %f coverage", coverage_score_test7);
            $display("[%s] Passed", testname);
            $display("Killing the %s from coverage component", testname);
            $finish;
          end
        end
      end
  endtask
  
endclass
