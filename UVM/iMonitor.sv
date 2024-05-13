//Input Monitor goal is to collect expected/golden/reference packets(driven into DUT) and send it to scoreboard for data validity
//iMonitor by extending from uvm_monitor.
class iMonitor extends uvm_monitor;
  
  //Register iMonitor into factory
  `uvm_component_utils(iMonitor);
  
  //virtual interface
  virtual router_if.tb_mon vif;


  //variable no_of_pkts_recvd to keep track of packets received from sequencer
  bit [31:0] no_of_pkts_recvd;
  
  //analysis port for connecting iMonitor to scoreboard
  uvm_analysis_port #(packet) analysis_port;
  
  //custom constructor
  function new (string name = "iMonitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  //build_phase to construct object for analysis port
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //Construct object for analysis port
    analysis_port = new("analysis_port", this);
  endfunction
  
  //connect_phase to connect virtual interface to physical interface
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Use uvm_config_db::get to retrieve physical interface
    //Check if vif connected to physical interface or not
    if(!uvm_config_db#(virtual router_if.tb_mon)::get(get_parent(), "", "iMon_if", vif))
      begin
        `uvm_fatal("VIF_ERR", "iMonitor DUT interface not set");
      end
  endfunction
  
  //run_phase to start the iMonitor operations
  task run_phase(uvm_phase phase);
    //local queue to store the collected packet
    bit [7:0] q_inp[$];
    
    //dynamic arr to unpack (reconstructing the packet format)
    byte unsigned pack_arr[];
    
    // Current monitored transaction
    packet pkt;
    
    `uvm_info("iMon","run started",UVM_MEDIUM);

    forever 
      begin //Monitor runs forever
        //detect start of Packet by Waiting on inp_valid
        @(posedge vif.mcb.inp_valid);
        //Wait till inp_valid becomes high
        no_of_pkts_recvd++;
        `uvm_info("iMon", $sformatf("Started Collecting Packet %0d", no_of_pkts_recvd), UVM_HIGH);
        //Capture the complete packet driven into DUT
        while (1) 
          begin
            //End of packet into DUT: Collect until inp_valid becomes 0
            if(vif.mcb.inp_valid == 0)
              begin
                //Convert Pin level activity to Transaction Level
                pkt = new;
                //Unpack collected q_inp stream into pkt fields
                pack_arr = q_inp;
                void'(pkt.unpack_bytes(pack_arr));
                
                //Content of inp_pkt used by compare method in transaction class.
                pkt.inp_pkt = q_inp;
                
                //Send collected packet to scoreboard
                analysis_port.write(pkt);
                `uvm_info("iMon", $sformatf("Sent Packet %0d (sa%0d->da%0d) to scoreboard", no_of_pkts_recvd, pkt.sa, pkt.da), UVM_MEDIUM);
                //$display("ChecK : IMon");
                //$display(q_inp);
                //Delete local q_inp and pack_arr
                q_inp.delete();
                pack_arr.delete();
                
                //Break out of while loop as collection of packet completed
                break;
              end//end_of_if
            //Collect packet: push dut_inp into local q_inp
            q_inp.push_back(vif.mcb.dut_inp);
            
            //Wait for posedge of clk to collect complete packet
            @(vif.mcb);
          end//end_of_while
      end//end_of_forever
  endtask 

endclass 
