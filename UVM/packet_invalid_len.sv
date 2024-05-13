//packet_invalid_len extends from original packet, used for test_invalid_len
class packet_invalid_len extends packet;
  `uvm_object_utils(packet_invalid_len)
  //constraints to generate scenario specific stimulus
  
  constraint valid_payload {
    //constraints on len to be 1 or 2000
    payload.size == 1 || payload.size == 2000;

  }
  
  //custom constructor
  function new(string name = "packet_invalid_len");
    super.new();
  endfunction

endclass
