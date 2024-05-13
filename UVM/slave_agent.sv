//slave agent is to instantiate, construct, and connect child components : output monitor
//connect analysis ports of child components
//agent are per interface basis : AXI slave_agent, USB slave_agent, and PCIE slave_agent

//slave_agent by extending from uvm_agent.
class slave_agent extends uvm_agent;
  
  //Register slave_agent into factory
  `uvm_component_utils(slave_agent);
  
  //Instantiate oMonitor(output monitor) component
  oMonitor oMon;
  
  //pass through analysis port for connecting oMonitor to scoreboard
  uvm_analysis_port #(packet) pass_through_ap_port;
  
  //custom constructor
  function new (string name = "s_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //build_phase to construct object for oMon and analysis port
  function void build_phase(uvm_phase phase); 
    super.build_phase(phase);
    //Construct object for pass through analysis port
    pass_through_ap_port = new("pass_through_ap_port", this);
    
    //Construct object for oMonitor component
    oMon = oMonitor::type_id::create("oMon", this);
  endfunction
  
  
  //connect_phase to connect analysis ports
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Connect oMonitor analysis  port to agent's pass through port
    oMon.analysis_port.connect(this.pass_through_ap_port);
  endfunction

endclass
