//new_packet8 extends from original packet, used for new_test8.sv
class new_packet8 extends packet;
  //constraints to generate scenario specific stimulus
  
  constraint valid_da {
    da inside {[5:8]};
  }
  
  constraint valid_payload {
    //Constraint payload size should be of size 20 to 1990
    payload.size inside {[20:200]};

  }

endclass
