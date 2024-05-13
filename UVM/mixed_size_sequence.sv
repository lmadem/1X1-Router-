//main sequence goal is to generate main stimulus to test the main functionality of the DUT
//mixed_size_sequence by extending from uvm_sequence and typed to packet
class mixed_size_sequence extends uvm_sequence #(packet);
  
  //Registering sequence mixed_size_sequence into factory
  `uvm_object_utils(mixed_size_sequence);
  
  //variable item_count , number of packets to generate
  int unsigned item_count;
  
  //Define the payload size bins
  bit [10:0] length_small_threshold = 50;
  bit [10:0] length_medium_threshold = 200;
  bit [10:0] length_large_threshold = 999;
  bit [10:0] length_extralarge_threshold = 1499;
  bit [10:0] jumbo_pkts_threshold = 1990;

  
  //custom constructor
  function new (string name = "mixed_size_sequence");
    super.new(name);
    //Call method to raise/drop objections automatically
    set_automatic_phase_objection(1);
  endfunction
  
  //pre_start() method to receive packet count from test
  task pre_start();
    if(!uvm_config_db#(int)::get(get_sequencer(), "", "item_count", item_count))
      begin
        `uvm_warning("pkt_count", "item count is not set in test_mixed_size");
        item_count = 25;
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
        // Randomize payload size within the overall range
        void'(req.randomize() with {payload.size() inside {[10:1990]};
                                   // Cover specific bins with minimal packets
                                   if(payload.size() <= length_small_threshold)
                                     {payload.size() == 20;} // Cover length_small bin
                                     
                                   else if(payload.size() <= length_medium_threshold) 
                                     {payload.size() == 150;}  // Cover length_medium bin
                                     
                                   else if(payload.size() <= length_large_threshold)
                                     {payload.size() == 500;}  // Cover length_large bin
                                     
                                   else if(payload.size() <= length_extralarge_threshold)
                                     {payload.size() == 1200;} // Cover length_extralarge bin
                                   else
                                     {payload.size() == 1900;}  // Cover jumbo_pkts bin
                                   });
        req.kind = STIMULUS;
        
        //Finish the transaction
        finish_item(req);
        
        count++;
        `uvm_info("SEQ",$sformatf("Master Sequence : Transaction %0d DONE ",count),UVM_MEDIUM);
      end
  endtask

endclass
