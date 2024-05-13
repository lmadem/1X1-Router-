//package with name router_env_pkg
package router_env_pkg;

//control variable pkt_type_t(used in packet ,sequences and driver)
//typedef enum {IDLE, RESET, STIMULUS, CSR_WRITE, CSR_READ} pkt_type_t;

//Import the UVM base class library
import uvm_pkg::*;
`include "uvm_macros.svh"

//Include transaction class
`include "packet.sv"
`include "packet_invalid_da.sv"
`include "packet_invalid_len.sv"

//Include sequences
`include "sa1_da1_sequence.sv"

`include "sa_da_sequence.sv"

`include "sa2_sequence.sv"

`include "da3_sequence.sv"

`include "equal_size_sequence.sv"

`include "full_size_sequence.sv"

`include "mixed_size_sequence.sv"

//Include run-phase sequences
`include "reset_sequence.sv"
`include "config_sequence.sv"
`include "shutdown_sequence.sv"
`include "crc_shutdown_seq.sv"
`include "invalid_DA_sequence.sv"
`include "invalid_len_sequence.sv"
`include "Invalid_shutdown_seq.sv"


//callbacks
`include "callbacks_crc.sv"

//Include all components
`include "sequencer.sv"     
`include "driver.sv"  
`include "iMonitor.sv"  
`include "master_agent.sv"
`include "oMonitor.sv"  
`include "slave_agent.sv"
`include "coverage.sv"
`include "scoreboard.sv"
`include "environment.sv"

endpackage 
