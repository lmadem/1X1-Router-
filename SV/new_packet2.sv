//new_packet2 extends from original packet, used for new_test2.sv
class new_packet2 extends packet;
  //constraints to generate scenario specific stimulus
  constraint valid_sa {
    //Constraint sa should be assigned to a single source port
    sa == 2;
  }
  
  constraint valid_payload {
    //Constraint payload size to be in the range 101 to 200
    payload.size inside {[101:200]};
  }

endclass
