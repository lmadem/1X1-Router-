// Code your design here
//sa ,da,len,crc,payload
module router_dut (clk,reset,dut_inp,inp_valid,dut_outp,outp_valid,busy,error,wr,rd,addr,wdata,rdata);
  input clk,reset;
  input [7:0] dut_inp;
  input inp_valid;
  input wr,rd;
  input [7:0] addr;
  input [31:0] wdata;
  output [31:0] rdata;
  output [7:0] dut_outp;
  output outp_valid;
  output busy;
  output error;
  reg [7:0] dut_outp;
  reg [31:0] rdata;
  reg outp_valid;
  reg busy,error;
logic [7:0] inp_pkt[$];
bit done; 
bit [31:0] len_recv; 
bit [3:0] csr_sa_enable;//addr='h20;
bit [3:0] csr_da_enable;//addr='h24;
bit [31:0] csr_crc_dropped_count;//addr='h28
bit [31:0] csr_pkt_dropped_count; //addr='h32;
bit [31:0] csr_total_inp_pkt_count;//addr='h36;
bit [31:0] csr_total_outp_pkt_count;//addr='h40;

always @(posedge clk or posedge reset) begin 

if(reset) begin
csr_crc_dropped_count<=0;
csr_pkt_dropped_count<=0;
csr_total_inp_pkt_count<=0;
csr_total_outp_pkt_count<=0;
rdata<=0;
end
else if (wr===1'b1) begin
case (addr) 
 'h20 : csr_sa_enable <= wdata;
 'h24 : csr_da_enable <= wdata;
 default: begin 
			$display("[DUT_ERROR] invalid csr write address(%0h) received at time=%0t",addr,$time);
		end
endcase
end
else if (rd===1'b1) begin
case (addr) 
 'h28 : rdata <= csr_crc_dropped_count;
 'h32 : rdata <= csr_pkt_dropped_count;
 'h36 : rdata <= csr_total_inp_pkt_count;
 'h40 : rdata <= csr_total_outp_pkt_count;
 default: begin 
			$display("[DUT_ERROR] invalid csr read address(%0h) received at time=%0t",addr,$time);
		  end
endcase
end
end//end_of_always


//sa0 da1 len2 len3 len4 len5
always@(posedge clk or posedge reset) begin 
if(reset) begin
busy<=0;
inp_pkt.delete();
done<=0;
len_recv=0;
error<=0; 
end
else begin
while(inp_valid && csr_sa_enable) begin
 inp_pkt.push_back(dut_inp);
 if($test$plusargs("dut_debug_input"))
    $display("[DUT Input] dut_inp=%0d at time=%0t",dut_inp,$time);
 @(posedge clk);
 if(inp_pkt.size() == 6) len_recv={inp_pkt[5],inp_pkt[4],inp_pkt[3],inp_pkt[2]};
 if (inp_pkt.size() == len_recv) begin
      csr_total_inp_pkt_count++;
	  if($test$plusargs("dut_debug") )
      $display("[DUT Input] Total Packet %0d collected size=%0d at time=%0t",csr_total_inp_pkt_count,inp_pkt.size(),$time);
	  
			if(is_packet_not_ok(inp_pkt)) begin
			inp_pkt.delete();
			break;//drop the packet as size is not ok
			end
	  		if(is_da_not_ok(inp_pkt[1])) begin
			inp_pkt.delete();
			break;//drop the packet as da is invalid
			end

		   if(calc_crc(inp_pkt)) begin
			  done<=1;
			  busy<=1;
			  len_recv<=0;
			  break; 
		   end//end_of_crc_if
   else begin
    csr_crc_dropped_count++;
    if($test$plusargs("dut_debug_crc")) begin
    $display("[DUT CRC] Packet %0d Dropped in DUT due to CRC Mismatch at time=%0t",csr_total_inp_pkt_count,$time);
    end
    inp_pkt.delete();
    done<=0;
    busy<=0;
    len_recv<=0;
    break;
   end
  end//end_of_if
end//end_of_while
end//end_of_main_if_else
end//end_of_always

always @(posedge clk) begin
while (done==1 && error==0) begin
@(posedge clk);
outp_valid <=1;
dut_outp <= inp_pkt.pop_front();
 if($test$plusargs("dut_debug_output"))
    $strobe("[DUT Output] dut_outp=%0d at time=%0t",dut_outp,$time);
if(inp_pkt.size() ==0) begin
      csr_total_outp_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT Output] Total Packet %0d Driving completed at time=%0t \n",csr_total_outp_pkt_count,$time);
  done<=0;
  len_recv<=0;
  busy<=0;
  @(posedge clk);
  dut_outp <= 'z;
  outp_valid <= 1'b0;
  //break;
end//end_of_if;  
end//end_of_while
end

always@(inp_valid or dut_inp) begin
if(!$isunknown(dut_inp) && busy && inp_valid) begin
    if($test$plusargs("dut_debug"))begin
     $display("[DUT Protocol ERROR] *************************************");
     $display("[DUT Protocol] Protocol violation detected at time=%0t",$time);
     $display("[DUT Protocol] inp_valid or dut_inp changed while router is busy at time=%0t",$time);
     $display("[DUT Protocol ERROR] *************************************");
    end
     error =1;
end
else error=0;
end

//sa0 da1 len2 
//len3 len4 len5
//crc6 crc7 crc8 crc9
//payload10->to->end ofpacket
function automatic bit calc_crc(const ref logic [7:0] pkt[$]);
bit [31:0] crc,new_crc;
bit [7:0] payload[$];
crc={pkt[9],pkt[8],pkt[7],pkt[6]};
for(int i=10;i < pkt.size(); i++) begin
    payload.push_back(pkt[i]);
end
new_crc=payload.sum();
payload.delete();
    if($test$plusargs("dut_debug_crc"))
       	$display("[DUT CRC] Received crc=%0d caluclated crc=%0d at time=%0t",crc,new_crc,$time);
return (crc == new_crc);
endfunction

function automatic bit is_packet_not_ok(const ref logic [7:0] pkt[$]);
if(pkt.size() < 12 || pkt.size() > 2001) begin
csr_pkt_dropped_count++; //Drop the packet as its satisfying minimum or maximux size of packet
 if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to size mismatch at time=%0t",csr_total_inp_pkt_count,$time);
	$display("[DUT_ERROR] Received packet size=%0d , Allowed range 12Bytes ->to-> 2000 Bytes ",pkt.size());
 end

done=0;
busy<=0;
len_recv<=0;
return 1;
end else return 0;
endfunction

function automatic bit is_da_not_ok(logic [7:0] da);
if(! (da inside {[1:4]})) begin
csr_pkt_dropped_count++; //Drop the packet as da port does not exists
 if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to invalid da(%0d) port received at time=%0t",csr_total_inp_pkt_count,da,$time);
	$display("[DUT_ERROR] Received packet da=%0d , Allowed da values {1,2,3,4} ",da);
 end

done=0;
busy<=0;
len_recv<=0;
return 1;
end 
else if (csr_da_enable)
	       return 0;
else begin
csr_pkt_dropped_count++; //Drop the packet as da port is not enabled
if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet Dropped in DUT due to da(%0d) port is not enabled at time=%0t",csr_total_inp_pkt_count,da,$time);
end
done=0;
busy<=0;
len_recv<=0;
return 1;
end
endfunction

endmodule

