//new_packet4 extends from original packet, used for new_test4.sv
class new_packet4 extends packet;
  //constraints to generate scenario specific stimulus
  
  constraint valid {
    //Constraint sa to be assigned to a single source port
    sa == 4;
    //Constraint da to be assigned to a single destination port
    da == 4;
    //Constraint payload size to be in the range 101 to 200
    payload.size inside {[101:200]};
  }

endclass
