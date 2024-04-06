class generator;
  //mailbox and packet class handles
  packet ref_pkt;
  mailbox_inst mbx;
  
  //pkt_count variable to tell no of packets generator has to generate
  bit [31:0] pkt_count;
  
  //custom constructor with mailbox and packet class handles as arguments
  function new(input mailbox_inst mbx_arg, input bit [31:0] count_arg);
    this.mbx = mbx_arg;
    this.pkt_count = count_arg;
    ref_pkt = new;
  endfunction
  
  //run method to implement actual functionality of generator.
  task run ();
    //pkt_id variable to keep track of how many packets generated.
    bit [31:0] pkt_id;
    //class packet handle
    packet pkt;
    //Generate First packet as Reset packet
    pkt = new;
    pkt.kind = RESET;
    pkt.reset_cycles = 3;
    //Place the Reset packet in mailbox
    mbx.put(pkt);
    $display("[Generator] Sent %0s packet %0d to driver at time=%0t", pkt.kind.name(), pkt_id, $time); 
    
    //Generate Second packet as CSR WRITE packet
    pkt = new;
    pkt.kind = CSR_WRITE;
    pkt.addr = 'h20; //csr_sa_enable register addr = 'h20
    pkt.data = 31'hf;
    //Place the CSR WRITE packet in mailbox
    mbx.put(pkt);
    $display("[Generator] Sent %0s packet %0d to driver at time=%0t", pkt.kind.name(), pkt_id, $time); 
    
    //Generate Third packet as CSR WRITE packet
    pkt = new;
    pkt.kind = CSR_WRITE;
    pkt.addr = 'h24; //csr_da_enable register addr = 'h24
    pkt.data = 31'hf;
    //Place the CSR WRITE packet in mailbox
    mbx.put(pkt);
    $display("[Generator] Sent %0s packet %0d to driver at time=%0t", pkt.kind.name(), pkt_id, $time); 
    
    //Generate NORMAL Stimulus packets
    repeat(pkt_count)
      begin
        pkt_id++;
        assert(ref_pkt.randomize());
        pkt = new;
        pkt.copy(ref_pkt);
        pkt.kind = STIMULUS;
        //Place normal stimulus packet in mailbox
        mbx.put(pkt);
        $display("[Generator] Packet %0d (size=%0d) Generated at time=%0t",pkt_id,pkt.len,$time); 
      end
    
    //Generate Status Register READ stimulus as CSR READ packet
    pkt = new;
    pkt.kind = CSR_READ;
    pkt.addr = 'h36; //csr_total_inp_pkt_count register addr = 'h36;
    //Place the CSR READ packet in mailbox
    mbx.put(pkt);
    $display("[Generator] Sent %0s packet %0d to driver at time=%0t",pkt.kind.name(),pkt_id,$time); 
    
    //Generate Status Register READ stimulus as CSR READ packet
    pkt = new;
    pkt.kind = CSR_READ;
    pkt.addr = 'h40; //csr_total_outp_pkt_count register addr = 'h40;
    //Place the CSR READ packet in mailbox
    mbx.put(pkt);
    $display("[Generator] Sent %0s packet %0d to driver at time=%0t",pkt.kind.name(),pkt_id,$time); 
  endtask

endclass
