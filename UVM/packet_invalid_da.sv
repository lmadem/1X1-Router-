//packet_invalid_da extends from original packet, used for test_invalid_da
class packet_invalid_da extends packet;
  `uvm_object_utils(packet_invalid_da)
  //constraints to generate scenario specific stimulus
  
  constraint valid_da {
    //constraints on da to be in the range of 5 to 8
    da inside {[5:8]};

  }
  
  //custom constructor
  function new(string name = "packet_invalid_da");
    super.new();
  endfunction

endclass
