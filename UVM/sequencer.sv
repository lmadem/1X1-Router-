//sequencer goal is to receive transactions from sequence and send it to driver through TLM ports(seq_item_port)
//typedef uvm_sequencer #(packet) sequencer;
//   OR

//sequencer by extending from uvm_sequencer and typed to packet.
class sequencer extends uvm_sequencer #(packet); 
  //Register sequencer into factory
  `uvm_component_utils(sequencer);
  
  //custom constructor
  function new (string name = "sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
