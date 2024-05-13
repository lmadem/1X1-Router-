//new_packet7 extends from original packet, used for new_test7.sv
class new_packet7 extends packet;
  //constraints to generate scenario specific stimulus
  
  constraint valid_payload {
    //Constraint payload size should be of size 20 to 1990
    payload.size inside {[20:1990]};

  }

endclass
