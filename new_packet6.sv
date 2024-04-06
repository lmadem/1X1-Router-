//new_packet6 extends from original packet, used for new_test6.sv
class new_packet6 extends packet;
  //constraints to generate scenario specific stimulus
  
  constraint valid_payload {
    //Constraint payload size should be of full size
    payload.size == 1990;
  }

endclass
