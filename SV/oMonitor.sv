class oMonitor;
  //virtual interface, mailbox and packet class handles
  virtual router_if.tb_mon vif;
  mailbox_inst mbx;
  packet pkt;
  
  //variable no_of_pkts_recvd to keep track of packets sent to scoreboard
  bit [31:0] no_of_pkts_recvd;
  
  //custom constructor with mailbox and virtual interface handles as arguments
  function new(input mailbox_inst mbx_arg, input virtual router_if.tb_mon vif_arg);
    this.mbx = mbx_arg;
    this.vif = vif_arg;
  endfunction
  
  //run method to start the monitor operations
  task run() ;
    bit [7:0] outp_q[$];
    $display("[oMon] run started at time=%0t ",$time); 
    forever 
      begin //Monitor runs forever
        //Wait on outp_valid to become high
        @(posedge vif.mcb.outp_valid);
        $display("[oMon] Started collecting packet %0d at time=%0t ",no_of_pkts_recvd,$time); 
        //Capture complete packet driven into DUT
        while(1) 
          begin
            //Collect untill outp_valid becomes 0
            if(vif.mcb.outp_valid == 0)
              begin
                pkt = new;
                pkt.unpack(outp_q);
                pkt.outp_stream=outp_q;
                //Send collected to scoreboard
                mbx.put(pkt);
                no_of_pkts_recvd++;
                $display("[oMon] Sent packet %0d to scoreboard at time=%0t ",no_of_pkts_recvd,$time);
                //pkt.print();
                //Delete local outp_q.
                outp_q.delete();
                break;
              end//end_of_if
            //Wait for posedge of clk to collect all the dut inputs
            outp_q.push_back(vif.mcb.dut_outp);
            @(vif.mcb);
          end//end_of_while
      end//end_of_forever
    $display("[oMon] run ended at time=%0t ",$time);//monitor will never end 
  endtask
  
  
  //report method to print how many packets collected by oMonitor
   function void report();
     $display("[oMon] Report: total_packets_collected = %0d ", no_of_pkts_recvd); 
  endfunction

endclass
