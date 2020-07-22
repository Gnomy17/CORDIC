module testbench3;



reg [15:0] x , y , z;
wire [15:0] res1;
wire [15:0] res2; 
reg mode;
reg reset = 1;
reg start = 0; 
reg clk = 1'b0;
   
initial
begin
      forever
        #4 clk = !clk;
end


cordic c1( mode, x, y, z, clk, reset, res1, res2);

initial
begin
	reset = 0;
	#4;
	reset = 1;
	start = 1;
end


 
initial begin
	mode <= 1;
    #4
	x <= 16'b0001_1010_0110_0000; //26.375  //pass //pass
	y <= 16'b0000_1110_0000_0000; //14    
	z <= 16'b0000_0010_0000_0000; //2

	#4
	
	
	x <= 16'b0001_1010_0110_0000; //26.375  //fail //pass
	y <= 16'b0000_1110_0000_0000; //14    
	z <= 16'b1111_0010_0000_0000; //-114
	
	#4
	
	x <= 16'b1111_1001_1001_0100; //-121.578125  // fail //fail
	y <= 16'b0001_1110_1100_0001; //30.75390625
	z <= 16'b0000_0101_1101_1111; //5.87109375
	 
	#4;
	
	x <= 16'b1111_1001_1001_0100; //-121.578125  //fail //fail
	y <= 16'b0001_1110_1100_0001;//30.75390625  
	z <= 16'b1111_0101_1101_1111; //-117.87109375
	 
	#4;
	
	x <= 16'b1101_1010_0010_1101; //-90.17578125  //fail //fail
	y <= 16'b1101_1000_0010_0000; //-88.125		
	z <= 16'b0001_0000_0000_1000; //16.03125
	
	#4
	
	x <= 16'b1101_1010_0010_1101; //-90.17578125 //fail //fail
	y <= 16'b1101_1000_0010_0000; //-88.125      
	z <= 16'b1101_0010_0100_1000; //-82.28125
	
	#4
	
	x <=  16'b0010_0010_1101_0000; //34.8125   //fail  // fail ( meh )
	y <=  16'b1111_0000_0000_0000; //-112      
	z <=  16'b1000_0000_1111_1111; //-0.99609375
	 
	#4

	x <=  16'b0010_0010_1101_0000; //34.8125   //fail // fail ( meh ) 
	y <=  16'b1111_0000_0000_0000; //-112 	   
	z <=  16'b0111_0000_1111_1111; //112.99609375
	
end  




initial 
$monitor($time, " res1 = %b res2 = %b",  res1 , res2);


endmodule
