typedef class driver;

//facade class named driver_callback_facade_crc
class driver_callback_facade_crc extends uvm_callback;
  
  //standard custom constructor
  function new (string name="driver_callback_facade_crc");
	super.new(name);
  endfunction

 //interface method pre_send
  virtual task pre_send(driver drv);
  endtask
   
	
 //interface method post_send
  virtual task post_send(driver drv);
  endtask
  
endclass


//Error injection callback class
class crc_err_inject_drv_cb extends driver_callback_facade_crc;
  
  //standard custom constructor
  function new (string name="crc_err_inject_drv_cb");
	super.new(name);
  endfunction

 //Implement interface method pre_send to corrupt the CRC in the pkt
  virtual task pre_send(driver drv);
    drv.req.inp_pkt[6] = 0;
    drv.req.inp_pkt[7] = 0;
    drv.req.inp_pkt[8] = 0;
    drv.req.inp_pkt[9] = 0;
  endtask
  
endclass
 
 

