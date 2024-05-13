//config sequence goal is to configure control registers in the DUT
//config_sequence by extending from uvm_sequence and typed to packet
class config_sequence extends uvm_sequence #(packet);
  
  //Register sequence config_sequence into factory
  `uvm_object_utils(config_sequence);
  
  //custom constructor
  function new(string name = "config_sequence");
    super.new(name);
    //Call method to raise/drop objections automatically
    set_automatic_phase_objection(1);
  endfunction
  
  
  //body method to start the actual sequence operation
  task body(); 
    //construct object for req handle
    `uvm_create(req);
    
    //Start the transaction
    start_item(req);
    
    //Fill the fields of transaction to generate CSR write stimulus
    req.kind = CSR_WRITE;
    req.addr = 8'h20; //sa_port_csr
    req.data = 8'b0000_1111;
    
    //Finish the transaction
    finish_item(req);
    `uvm_info("CFG_SEQ","Configure Sequence : Transaction DONE",UVM_MEDIUM);
    
    //Construct object for req handle
    `uvm_create(req);
    
    //Start the transaction
    start_item(req);
    
    //Fill the fields of transaction to generate CSR write stimulus
    req.kind = CSR_WRITE;
    req.addr = 8'h24; //da_port_csr
    req.data = 8'b0000_1111;
    
    //Finish the transaction
    finish_item(req);
    `uvm_info("CONFIG_SEQ", "Config Sequence : DONE", UVM_MEDIUM);
  endtask
  
endclass
