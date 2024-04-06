//new_packet1 extends from original packet used for new_test1
class new_packet1 extends packet;
  //constraints to generate scenario specific stimulus
  constraint valid_sa {
    //Constraint sa and da to be in the range 2 to 4
    sa inside {[2:4]};
  }
  
  constraint valid_da {
    da inside {[2:4]};
  }
  
  constraint valid_payload {
    //Constraint payload size to be in the range 101 to 200
    payload.size inside {[101:200]};
  }

endclass
