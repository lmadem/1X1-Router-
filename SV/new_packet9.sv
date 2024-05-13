//new_packet9 extends from original packet, used for new_test9.sv
class new_packet9 extends packet;
  //constraints to generate scenario specific stimulus
    
  constraint valid_payload {
    //Constraint payload size should be Invalid(pkt.len should be less than 12 or greater than 
    payload.size == 1 || payload.size == 2000;

  }

endclass
