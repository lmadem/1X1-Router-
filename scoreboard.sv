class scoreboard;
  //mailbox and packet class handles
  mailbox_inst mbx_in; //will be connected to input monitor
  mailbox_inst mbx_out; //will be connected to output monitor
  packet ref_pkt;
  packet got_pkt;
  
  //variable total_pkts_recvd to keep track of packets received from monitors
  bit [31:0] total_pkts_recvd;
  
  //variable to keep track of matched/mis_matched packets
  bit [31:0] m_matched, m_mismatched;
  
  //custom constructor with mailbox handles as arguments
  function new(input mailbox_inst mbx_in_arg, mailbox_inst mbx_out_arg);
    this.mbx_in = mbx_in_arg;
    this.mbx_out = mbx_out_arg;
  endfunction
  
  //run method to start the scoreboard operations
  task run;
    $display("[Scoreboard] run started at time=%0t",$time); 
    while(1) 
      begin
        //Wait for packet from Input Monitor
        mbx_in.peek(ref_pkt);
        //Wait for packet from Output Monitor
        mbx_out.get(got_pkt);
        //Increment pkt count once packet received from both the monitors 
        total_pkts_recvd++;
        $display("[Scoreboard] Packet %0d received at time=%0t",total_pkts_recvd,$time); 
        //$display(ref_pkt);
        //$display(got_pkt);
        //Compare expected packet with received packet from DUT
        if(ref_pkt.compare(got_pkt))
          begin
            m_matched++;
            $display("[Scoreboard] Packet %0d Matched ",total_pkts_recvd); 
          end
        else
          begin
            m_mismatched++;
            //Print enough information (for debug) when packet does NOT Match
            $display("[Scoreboard] ERROR :: Packet %0d Not_Matched at time=%0t",total_pkts_recvd,$time); 
            $display("[Scoreboard] *** Expected Packet to DUT****");
	        ref_pkt.print();
	        $display("[Scoreboard] *** Received Packet From DUT****");
	        got_pkt.print();
          end
      end
    $display("[Scoreboard] run ended at time=%0t",$time); 
  endtask
  
  
  //report method to print scoreboard summary
  function void report();
    $display("[Scoreboard] Report: total_packets_collected = %0d",total_pkts_recvd); 
    $display("[Scoreboard] Report: Matches=%0d Mis_Matches=%0d",m_matched, m_mismatched); 
  endfunction

endclass

