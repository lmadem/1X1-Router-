class iMonitor;
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
  task run();
    bit [7:0] inp_q[$];
    $display("[iMon] run started at time=%0t ",$time); 
    forever
      begin //Monitor runs forever
        //Start of Packet into DUT :Wait on inp_valid to become high
        @(posedge vif.mcb.inp_valid);
        $display("[iMon] Started collecting packet %0d at time=%0t ",no_of_pkts_recvd,$time); 
        //Capture complete packet driven into DUT
        while(1) 
          begin
            if(vif.mcb.inp_valid == 0)
              begin
                pkt = new;
                pkt.unpack(inp_q);
                pkt.inp_stream = inp_q;
                //Send collected to scoreboard
                mbx.put(pkt);
                no_of_pkts_recvd++;
                $display("[iMon] Sent packet %0d to scoreboard at time=%0t ",no_of_pkts_recvd,$time);
                //pkt.print();
                
                //Wait until scoreboard and coverage components gets a copy of transactions and then Delete entries in the mailbox .
                begin
                  packet temp;
                  #0 while(mbx.num >= 1)
                    void'(mbx.try_get(temp));
                end
                //delete local inp_q.
                inp_q.delete();
                break;
              end//end_of_if
            inp_q.push_back(vif.mcb.dut_inp);
            @(vif.mcb);
          end//end_of_while
      end//end_of_forever
    $display("[iMon] run ended at time=%0t ",$time);//monitor will never end 
  endtask
  
  //report method to print how many packets collected by iMonitor
  function void report();
    $display("[iMon] Report: total_packets_collected = %0d ", no_of_pkts_recvd); 
  endfunction

endclass

