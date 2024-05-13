//Output monitor goal is to collect actual packet(output from DUT) and send it to scoreboard for data validity
//oMonitor by extending from uvm_monitor.
class oMonitor extends uvm_monitor;
  
  //Register oMonitor into factory
  `uvm_component_utils(oMonitor);
  
  //virtual interface
  virtual router_if.tb_mon vif;


  //variable no_of_pkts_recvd to keep track of packets received from sequencer
  bit [31:0] no_of_pkts_recvd;
  
  //analysis port for connecting iMonitor to scoreboard
  uvm_analysis_port #(packet) analysis_port;
  
  //custom constructor
  function new (string name = "oMonitor", uvm_component parent);
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
    if(!uvm_config_db#(virtual router_if.tb_mon)::get(get_parent(), "", "oMon_if", vif))
      begin
        `uvm_fatal("VIF_ERR", "oMonitor DUT interface not set");
      end
  endfunction
  
  //run_phase to start the iMonitor operations
  task run_phase(uvm_phase phase);
    //local queue to store the collected packet
    bit [7:0] q_out[$];
    
    //dynamic arr to unpack (reconstructing the packet format)
    byte unsigned pack_arr[];
    
    // Current monitored transaction
    packet pkt;
    
    `uvm_info("oMon","run started",UVM_MEDIUM);

    forever 
      begin //Monitor runs forever
        //detect start of Packet by Waiting on outp_valid
        @(posedge vif.mcb.outp_valid);
        //Wait till outp_valid becomes high
        no_of_pkts_recvd++;
        `uvm_info("oMon", $sformatf("Started Collecting Packet %0d", no_of_pkts_recvd), UVM_HIGH);
        //Capture the complete packet driven into DUT
        while (1) 
          begin
            //End of packet into DUT: Collect until outp_valid becomes 0
            if(vif.mcb.outp_valid == 0)
              begin
                //Convert Pin level activity to Transaction Level
                pkt = new;
                //Unpack collected q_out stream into pkt fields
                pack_arr = q_out;
                void'(pkt.unpack_bytes(pack_arr));
                
                //Content of inp_pkt used by compare method in transaction class.
                pkt.inp_pkt = q_out;
                
                //Send collected packet to scoreboard
                analysis_port.write(pkt);
                `uvm_info("oMon", $sformatf("Sent Packet %0d (sa%0d->da%0d) to scoreboard", no_of_pkts_recvd, pkt.sa, pkt.da), UVM_MEDIUM);
                //$display("ChecK : oMon");
                //$display(q_out);
                
                //Delete local q_out and pack_arr
                q_out.delete();
                pack_arr.delete();
                
                //Break out of while loop as collection of packet completed
                break;
              end//end_of_if
            //Collect packet: push dut_outp into local q_out
            q_out.push_back(vif.mcb.dut_outp);
            
            //Wait for posedge of clk to collect complete packet
            @(vif.mcb);
          end//end_of_while
      end//end_of_forever
  endtask 

endclass 
