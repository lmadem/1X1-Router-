class driver;
  //virtual interface, mailbox and packet class handles
  virtual router_if.tb_mod_port vif;
  mailbox_inst mbx;
  packet pkt;
  
  //variable no_of_pkts_recvd to keep track of packets received from generator
  bit [31:0] no_of_pkts_recvd;
  bit [31:0] csr_rdata;
  
  //custom constructor with mailbox and virtual interface handles as arguments
  function new(input mailbox_inst mbx_arg, input virtual router_if.tb_mod_port vif_arg);
    this.mbx = mbx_arg;
    this.vif = vif_arg;
  endfunction
  
  //methods run,drive,drive_reset,drive_stimulus, configure_dut_csr and read_dut_csr as extern methods
  extern task run();
  extern task drive(packet pkt);
  extern task drive_reset(packet pkt);
  extern task drive_stimulus(packet pkt);
  extern task configure_dut_csr(packet pkt);
  extern task read_dut_csr(packet pkt);
endclass
    
    
//run method to start the driver operations
task driver::run();
  $display("[Driver] run started at time=%0t",$time); 
  while(1) 
    begin //driver runs forever 
      //Wait for packet from generator and pullout once packet available in mailbox
      mbx.get(pkt);
      no_of_pkts_recvd++;
      $display("[Driver] Received  %0s packet %0d from generator at time=%0t", pkt.kind.name(), no_of_pkts_recvd, $time); 
      //Process the Received transaction
      drive(pkt);
      $display("[Driver] Done with %0s packet %0d from generator at time=%0t", pkt.kind.name(), no_of_pkts_recvd, $time); 
    end//end_of_while
endtask

//Section D.6: Define drive method with packet as argument
task driver::drive(packet pkt);
  //Check the transaction type and call the appropriate method
  case(pkt.kind)
    RESET : drive_reset(pkt);
    STIMULUS : drive_stimulus(pkt);
    CSR_WRITE : configure_dut_csr(pkt);
    CSR_READ : read_dut_csr(pkt);
    default : $display("[Driver] Unknown packet received");
  endcase

endtask

//drive_reset method with packet as argument
task driver::drive_reset(packet pkt);
  $display("[Driver] Driving Reset transaction into DUT at time=%t", $time);
  vif.reset <= 1'b1;
  repeat(pkt.reset_cycles) @(vif.cb);
  vif.reset <= 1'b0;
  $display("[Driver] Driving Reset transaction completed at time=%t", $time);
endtask


//drive_stimulus method with packet as argument
task driver::drive_stimulus(packet pkt);
  wait(vif.cb.busy==0);
  @(vif.cb);
  $display("[Driver] Driving of packet %0d (size=%0d) sa%0d->da%0d started at time=%0t", no_of_pkts_recvd, pkt.len, pkt.inp_stream[0], pkt.inp_stream[1], $time);
  vif.cb.inp_valid <= 1'b1;
  foreach(pkt.inp_stream[i])
    begin
      vif.cb.dut_inp <= pkt.inp_stream[i];
      @(vif.cb);
    end
  $display("[Driver] Driving of packet %0d (size=%0d) sa%0d->da%0d ended at time=%0t \n", no_of_pkts_recvd, pkt.len, pkt.inp_stream[0], pkt.inp_stream[1], $time);
  //@(vif.cb); //uncomment this to get a verification issue
  vif.cb.inp_valid <= 1'b0;
  vif.cb.dut_inp <= 'z;
  repeat(5) @(vif.cb);
endtask

//configure_dut_csr method with packet as argument
task driver::configure_dut_csr(packet pkt);
  $display("[Driver] Configuring DUT Control registers Started at time=%0t",$time);
  @(vif.cb);
  vif.cb.wr <= 1;
  //Drive pkt.addr onto dut's addr pin
  vif.cb.addr  <= pkt.addr; 
  //Drive pkt.data onto dut's data pin
  vif.cb.wdata <= pkt.data;
  @(vif.cb);
  vif.cb.wr <= 0;
  $display("[Driver] Configuring DUT Control registers Ended at time=%0t",$time);
endtask

//read_dut_csr method with packet as argument
task driver::read_dut_csr(packet pkt);
  $display("[Driver] Reading DUT Status registers Started at time=%0t", $time);
  @(vif.cb);
  vif.cb.rd <= 1;
  //Drive pkt.addr onto dut's addr pin
  vif.cb.addr <= pkt.addr;
  repeat(2) @(vif.cb);
  //Receive dut's rdata onto csr_rdata
  csr_rdata = vif.cb.rdata;
  vif.cb.rd <= 0;
  $display("[Driver] Reading DUT Status registers Ended at time=%0t", $time);
endtask

