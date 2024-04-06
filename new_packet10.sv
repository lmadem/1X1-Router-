//new_packet10 extends from original packet, used for new_test10.sv
class new_packet10 extends packet;
  //constraints to generate scenario specific stimulus
    
  constraint valid_payload {
    payload.size inside {[10:100]};
  }
  
  virtual function void post_randomize_extension();
    crc = crc - 10;
  endfunction

endclass
