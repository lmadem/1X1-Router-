//coverage goal is to collect functional coverage

//coverage by extending from uvm_subscriber and typed to packet
class coverage extends uvm_subscriber #(packet);
  //coverage component into factory
  `uvm_component_utils(coverage);
  
  //variable coverage_score to keep track of coverage score for ports
  real coverage_score_ports;
  //variable coverage_score to keep track of coverage score for sizes
  real coverage_score_sizes;
  //variable coverage_score to keep track of coverage score for ports and sizes
  real coverage_score_full;
  
  //testname
  string test_name;
  
  //cover group for sa,da ports with sample method
  covergroup fcov_ports with function sample(packet pkt);
    //coverpoint on sa 
    coverpoint pkt.sa {
      //bins for sa1,sa2,sa3 and sa4 ports
      bins sa1 = {1};
      bins sa2 = {2};
      bins sa3 = {3};
      bins sa4 = {4};     
    }
    
    //coverpoint on da
    coverpoint pkt.da {
      //bins for da1,da2,da3 and da4 ports
      bins da1 = {1};
      bins da2 = {2};
      bins da3 = {3};
      bins da4 = {4};  
    }
    
     
    //cross to monitor sa,da combinations
    cross pkt.sa, pkt.da;
  endgroup
  
  //cover group for packet size with sample method
  covergroup fcov_size with function sample(packet pkt);
    //coverpoint on len
    
    coverpoint pkt.len {
      //bins for differnet sizes of packet using len
      bins length_small  = {[12:50]};
      bins length_medium = {[51:200]};
      bins length_large  = {[201:999]};
      bins length_extralarge = {[1000:1499]};
      bins jumbo_pkts = {[1500:2000]};
      //bins short_length = {[$:11]};
      //bins max_length = {[2001:$]};
    }
  endgroup
  
  //cover group for sa,da ports, packet size with sample method
  covergroup fcov_full with function sample(packet pkt);
    //coverpoint on sa 
    coverpoint pkt.sa {
      //bins for sa1,sa2,sa3 and sa4 ports
      bins sa1 = {1};
      bins sa2 = {2};
      bins sa3 = {3};
      bins sa4 = {4};     
    }

    //coverpoint on da
    coverpoint pkt.da {
      //bins for da1,da2,da3 and da4 ports
      bins da1 = {1};
      bins da2 = {2};
      bins da3 = {3};
      bins da4 = {4};  
    }
   
   //coverpoint on len
   
   coverpoint pkt.len {
     //bins for differnet sizes of packet using len
     bins length_small  = {[12:50]};
     bins length_medium = {[51:200]};
     bins length_large  = {[201:999]};
     bins length_extralarge = {[1000:1499]};
     bins jumbo_pkts = {[1500:2000]};
     //bins short_length = {[$:11]};
     //bins max_length = {[2001:$]};
   }
     
   //cross to monitor sa,da combinations
   cross pkt.sa, pkt.da;
    
   //cross to monitor sa with different packet lengths as combinations
   cross pkt.sa, pkt.len;

   
   //cross to monitor da with different packet lengths as combinations
   cross pkt.da, pkt.len;
    
  endgroup
    
   
  //custom constructor
  function new (string name = "m_agent", uvm_component parent);
    super.new(name, parent);
    //use uvm_config_db::get to extract test_name from test
    uvm_config_db#(string)::get(this, "", "test_name", test_name);
    //$display("ChecK : [%s]", test_name);
    //Construct objects for embeded cover groups based on test_name 
    if(test_name == "test_sa_da")
      fcov_ports = new;
    else if(test_name == "test_mixed_size")
      fcov_size = new;
    else
      fcov_full = new;
    
  endfunction
  
  
    
  //Implement custom write method to receive transaction from Monitor
  //Implement write method as uvm_subscriber has uvm_analysis_imp implementation port
  virtual function void write(T rhs);
    packet pkt;
    if(!$cast(pkt, rhs.clone)) 
      begin
        `uvm_fatal("COV", "Transaction object received is NULL in coverage component");
      end
    
    //Call the sample with with transaction object as argument
    if(test_name == "test_sa_da") begin
      fcov_ports.sample(pkt);
      //Call get_coverage method on fcov_ports to get the current functional coverage number
      coverage_score_ports = fcov_ports.get_coverage();
      `uvm_info("COV", $sformatf("Coverage=%0f", coverage_score_ports), UVM_NONE);
    end
    else if(test_name == "test_mixed_size") begin
      fcov_size.sample(pkt);
      //Call get_coverage method on fcov_size to get the current functional coverage number
      coverage_score_sizes = fcov_size.get_coverage();
      `uvm_info("COV", $sformatf("Coverage=%0f", coverage_score_sizes), UVM_NONE);
    end
    else begin
      fcov_full.sample(pkt);
      //Call get_coverage method on fcov_full to get the current functional coverage number
      coverage_score_full = fcov_full.get_coverage();
      `uvm_info("COV", $sformatf("Coverage=%0f", coverage_score_full), UVM_NONE);
    end
  endfunction
    
  //Implement extract_phase to send coverage number to environment
  virtual function void extract_phase(uvm_phase phase);
    //use uvm_config_db::set to send coverage number to environment
    uvm_config_db#(real)::set(null, "uvm_test_top.env", "cov_score_ports", coverage_score_ports);
    //use uvm_config_db::set to send coverage number to environment
    uvm_config_db#(real)::set(null, "uvm_test_top.env", "cov_score_size", coverage_score_sizes);
    //use uvm_config_db::set to send coverage number to environment
    uvm_config_db#(real)::set(null, "uvm_test_top.env", "cov_score_full", coverage_score_full);
  endfunction
    
endclass

