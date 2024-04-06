//new_packet3 extends from original packet, used for new_test3.sv
class new_packet3 extends packet;
  //constraints to generate scenario specific stimulus
  constraint valid_da {
    //Constraint da to be assigned to a single destination port
    da == 3;
  }
  
  constraint valid_payload {
    //Constraint payload size to be in the range 101 to 200
    payload.size inside {[101:200]};
  }

endclass
