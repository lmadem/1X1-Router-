// SA       = 1 byte
// DA       = 1 byte
// Length   = 4 bytes
// CRC      = 4 bytes
// Payload  = 1900 Bytes (MAX)

//enum (control knob) to identify transaction type
typedef enum {IDLE, RESET, STIMULUS, CSR_WRITE, CSR_READ} pkt_type_t;

//class packet by extending from uvm_sequence_item

class packet extends uvm_sequence_item;
  
  //router inputs 
  //variables to create packet format 
  rand bit [7:0] sa;
  rand bit [7:0] da;
  bit [31:0] len;
  bit [31:0] crc;
  rand bit [7:0] payload[];
  
  //dynamic array to pack the stimulus into it
  byte unsigned pack_arr[];
  
  //queue to store the complete stimulus
  bit [7:0] inp_pkt[$];
  
  //kind variable of type enum pkt_type_t
  pkt_type_t kind;
  
  //reset_cycles variable
  bit [7:0] reset_cycles;
  
  //CSR related signals
  bit [7:0] addr;
  logic [31:0] data;
  
  //valid constraints on sa to be in the range of 1 to 4
  constraint valid_sa {
    sa inside {[1:4]};
  }
  
  //valid constraints on da to be in the range of 1 to 4
  constraint valid_da {
    da inside {[1:4]};
  }
  
  //valid constraints on payload size to be in the range of 2 to 1990
  constraint valid_payload {
    payload.size() inside {[2:1990]};
    foreach(payload[i]) 
      payload[i] inside {[1:255]};
  }
 
  
  //post_randomize to caluclate crc and len and also pack stimulus into queue
  function void post_randomize();
    //please enable this line for generating directed stimuli
    randomize_with_combinations();
    len = payload.size() + 1 + 1 + 4 + 4;
    //compute crc
    crc = payload.sum();
    //pack the content to pack_arr
    uvm_default_packer.big_endian = 0;
    void'(pack_bytes(pack_arr));
    inp_pkt = pack_arr;
  endfunction
  
  //Use shorthand macros to implement required methods
  `uvm_object_utils_begin(packet)
  `uvm_field_int(sa, UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
  `uvm_field_int(da, UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
  `uvm_field_int(len, UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
  `uvm_field_int(crc, UVM_ALL_ON | UVM_NOCOMPARE | UVM_DEC)
  `uvm_field_array_int(payload, UVM_ALL_ON | UVM_NOCOMPARE)
  `uvm_field_queue_int(inp_pkt, UVM_ALL_ON | UVM_NOCOMPARE | UVM_NOPACK | UVM_NOPRINT)
  `uvm_object_utils_end
  
  //convert2string method
  virtual function string convert2string();
    return $sformatf("SA=%0d, DA=%0d, Len=%0d, Crc=%0d",sa,da,inp_pkt.size(),crc);
  endfunction
  
  //custom compare method
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    packet dut_pkt;
    bit status = 1;
    if(!$cast(dut_pkt, rhs))
      begin
        `uvm_fatal("CAST", "do_compare method casting failed")
      end
    if(this.inp_pkt.size() == dut_pkt.inp_pkt.size())
      begin
        foreach(this.inp_pkt[index])
          begin
            if(this.inp_pkt[index] != dut_pkt.inp_pkt[index])
              status = 0;
            else
              status = 1;
          end
      end
    else
      status = 0;
    return status;    
  endfunction
  
  //custom constructor
  function new(string name = "Packet");
    super.new(name);
  endfunction
  
  //This particular functions helps to acheive all combinations of sa,da within minimal packets. Using randomization technique, it requires almost 60 packets to hit 16 different {sa,da} combinations. But using this logic, 16 packets are enough to hit all possible combinations. A tiny exercise on directed stimuli generation.
  virtual function void randomize_with_combinations();
    static bit [4:0] flag1 = 1;
    static bit [4:0] flag2 = 1;
    for(bit [2:0] j=1; j<=4; j++) begin
      if(flag1 == j) begin
        sa = flag2;
        da = j;
        //$display("ChecK: Packet");
        //$display("sa : %0d, da : %0d", sa, da);
      end
    end
    
    flag1++;
    if(flag1 == 5) begin
      flag1 = 1;
      flag2++;
      if(flag2 == 5)
        flag2 = 1;
    end

  endfunction
  
 
endclass
