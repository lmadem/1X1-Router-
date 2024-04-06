//new_packet5 extends from original packet, used for new_test5.sv
class new_packet5 extends packet;
  //constraints to generate scenario specific stimulus
  
  constraint valid_payload {
    //Constraint payload size should be of fixed length
    payload.size == 20;
  }

endclass
