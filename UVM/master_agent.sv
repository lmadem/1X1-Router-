//master agent goal is to instantiate, construct, and connect components: driver, sequencer and input monitor
//Connect TLM and analysis ports of its child components
//Agents are per interface basis (Example : AXI agent, USB agent, PCIE agent)

//master_agent by extending from uvm_agent.
class master_agent extends uvm_agent;
  //master_agent into factory
  `uvm_component_utils(master_agent);
  
  //Instantiate driver component
  driver drvr;
  
  //Instantiate iMonitor(input monitor) component
  iMonitor iMon;
  
  //Instantiate sequencer component
  sequencer seqr;
  
  //analysis pass through port for connecting iMonitor to scoreboard
  uvm_analysis_port #(packet) pass_through_ap_port;
  
  //custom constructor
  function new (string name = "m_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  //build_phase to construct object for drvr,seqr,iMon and analysis port
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //Construct object for pass through analysis port
    pass_through_ap_port = new("pass_through_ap_port", this);
    
    //Construct seqr and drvr objects only when is_active is set to UVM_ACTIVE
    if(is_active == UVM_ACTIVE)
      begin
        //Construct object for sequencer component
        seqr = sequencer::type_id::create("seqr", this);
        
        //Construct object for driver component
        drvr = driver::type_id::create("drvr", this);
      end
    
    //Construct object for iMonitor component
    iMon = iMonitor::type_id::create("iMon", this);
  endfunction
  
  
  //connect_phase to connect TLM and analysis ports
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Check if agent is a ACTIVE or PASSIVE
    if(is_active == UVM_ACTIVE)
      begin
        //Connect driver's TLM port to sequencer's TLM export
        drvr.seq_item_port.connect(seqr.seq_item_export);
        
        //Connect iMonitor analysis  port to agent's pass through port
        iMon.analysis_port.connect(this.pass_through_ap_port);
      end
  endfunction

endclass


