//Reset sequence is to reset the DUT
//reset_sequence by extending from uvm_sequence and typed to packet
class reset_sequence extends uvm_sequence #(packet);
  //Register sequence reset_sequence into factory
  `uvm_object_utils(reset_sequence);
  
  //custom constructor
  function new(string name = "reset_sequence");
    super.new(name);
    set_automatic_phase_objection(1);
  endfunction
  
  //body method to start the actual sequence operation
  task body();
    //Construct object for req handle
    `uvm_create(req);
    
    //Start the transaction
    start_item(req);
    
    //fields of transaction to generate reset stimulus
    req.kind = RESET;
    req.reset_cycles = 3;
    
    //Finish the transaction
    finish_item(req);
    `uvm_info("RESET_SEQ", "Reset Sequence : DONE", UVM_MEDIUM);
  endtask
  
  
endclass
