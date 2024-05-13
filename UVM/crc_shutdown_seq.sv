//crc_shutdown sequence goal is to read the status registers in the DUT : we will be reading csr_crc_dropped_count to know how many packets dropped in router due to CRC mismatch
//crc_shutdown_sequence by extending from uvm_sequence and typed to packet
class crc_shutdown_sequence extends uvm_sequence #(packet); 
  //Register sequence crc_shutdown_sequence into factory
  `uvm_object_utils(crc_shutdown_sequence);
  bit [31:0] dropped_pkt_count;
  
  //custom constructor
  function new (string name = "crc_shutdown_sequence");
	super.new(name);
    //Call method to raise/drop objections automatically
    set_automatic_phase_objection(1);
  endfunction
  
  //body method to start the actual sequence operation
  task body();
    //Construct object for req handle
    `uvm_create(req);
 
    //Start the transaction
    start_item(req);
    
    //Fill the fields of transaction to generate CSR Read stimulus
    req.kind = CSR_READ;
    req.addr = 'h28; //csr_crc_dropped_count
    //Finish the transaction
    finish_item(req);
    
    dropped_pkt_count = req.data;
    
    
    
    `uvm_info("CRC_SHTDWN_SEQ", $sformatf("Dropped_pkt_count = %0d", dropped_pkt_count), UVM_MEDIUM);

    `uvm_info("CRC_SHTDWN_SEQ", "ShutDown Sequence : DONE", UVM_MEDIUM);
  
  endtask
  
endclass
