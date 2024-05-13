//main sequence goal is to generate main stimulus to test the main functionality of the DUT
//sa2_sequence by extending from uvm_sequence and typed to packet
class sa2_sequence extends uvm_sequence #(packet);
  
  //Registering sequence sa2_sequence into factory
  `uvm_object_utils(sa2_sequence);
  
  //variable item_count , number of packets to generate
  int unsigned item_count;
  
  //custom constructor
  function new (string name = "sa2_sequence");
    super.new(name);
    //Call method to raise/drop objections automatically
    set_automatic_phase_objection(1);
  endfunction
  
  //pre_start() method to receive packet count from test
  task pre_start();
    if(!uvm_config_db#(int)::get(get_sequencer(), "", "item_count", item_count))
      begin
        `uvm_warning("pkt_count", "item count is not set in test_sa2");
        item_count = 5;
      end
  endtask
  
  //body method to start the actual sequence operation
  task body();
    bit [31:0] count;
    repeat(item_count) 
      begin
        //Construct object for req handle
        `uvm_create(req)
        
        //Start the transaction
        start_item(req);
        
        //randomize the transaction
        void'(req.randomize() with {sa == 2; 
                                    da inside {[1:4]};
                                    payload.size() inside {[10:20]};
                                   });
        req.kind = STIMULUS;
        
        //Finish the transaction
        finish_item(req);
        
        count++;
        `uvm_info("SEQ",$sformatf("Master Sequence : Transaction %0d DONE ",count),UVM_MEDIUM);
      end
  endtask

endclass
