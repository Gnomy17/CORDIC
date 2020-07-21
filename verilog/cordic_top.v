module cordic 	(input op_mode,
		input [15:0] x_coordinate,
		input [15:0] y_coordinate,
		input [15:0] rotate_amount,
		input clock,
		input reset,
		output reg [15:0] x_or_phase_out,
		output reg [15:0] y_or_size_out
		);
		// Every number is in the fixed point format of {sign bit:7 integer bits:8 fractional bits}

		`define rotate 0
		`define phase_calc 1
		`define PI 16'b0_0000011_00100100
		`define PI15 15'b0000011_00100100
		`define size_adj 15'b00000001_10100101
		//op_mode is opertation mode, if zero the current input will be placed in the rotation pipeline, and if one
		//it will be placed in the phase calculation pipeline
		reg [15:0] x_in;
		reg [15:0] y_in;
		reg [15:0] z_in;
		reg mode_in;
		wire [15:0] connections_x [7:0];
		wire [15:0] connections_y [7:0];
		wire [15:0] connections_z [7:0];
		wire connections_mode [7:0];
		wire [15:0] outx;
		wire [15:0] outy;
		wire [15:0] outz;
		assign outx = connections_x[7];
		assign outy = connections_y[7];
		assign outz = connections_z[7];
		always @(posedge clock or negedge reset)
		begin
			if (~reset)
			begin
				x_in <= 0;
				y_in <= 0;
				z_in <= 0;
				x_or_phase_out <= 0;
				y_or_size_out <= 0;
			end
			else
			begin
				if(op_mode == `rotate)
				begin
					//input transfer
					if (rotate_amount[14:0] <= (`PI15 >> 1))
					begin
						z_in <= rotate_amount;
						x_in <= x_coordinate;
						y_in <= y_coordinate;
					end
					else
					begin
						if (rotate_amount[15] == 1)
						begin
							x_in <= y_coordinate;
							y_in <= {~x_coordinate[15],x_coordinate[14:0]};
							z_in <= {rotate_amount[15],rotate_amount[14:0] - (`PI15 >> 1)};
						end
						else
						begin
							
							y_in <= x_coordinate;
							x_in <= {~y_coordinate[15],y_coordinate[14:0]};
							z_in <= rotate_amount - (`PI>>1);
						end
					end
					//output transfer
					x_or_phase_out <= {outx[15], outx[14:0]/`size_adj};
					y_or_size_out <= {outy[15], outy[14:0]/`size_adj};
				end
				else
				begin
					//input transfer
					if (x_coordinate[15] == 0)
					begin
						z_in <= 0;
						x_in <= x_coordinate;
						y_in <= y_coordinate;
					end
					else
					begin
						if (y_coordinate[15] == 1)
						begin
							x_in <= y_coordinate;
							y_in <= {~x_coordinate[15],x_coordinate[14:0]};
							z_in <= (`PI >> 1);
						end
						else
						begin
							
							y_in <= x_coordinate;
							x_in <= {~y_coordinate[15],y_coordinate[14:0]};
							z_in <= 16'b1_0000011_0010010; //-PI/2
						end
					end
					//output transfer
					y_or_size_out <= {outx[15], outx[14:0]/`size_adj};
					x_or_phase_out <= outz;
				end
			end
		end
		
		cordic_stage #(0) s0 (x_in, y_in, z_in, mode_in, reset, clock,
				 connections_x[0], connections_y[0], connections_z[0], connections_mode[0]);
		genvar i;
		generate
			for (i = 1; i < 8; i = i + 1) begin : stages
				cordic_stage #(i) s0 (connections_x[i - 1],
							connections_y[i - 1],
							connections_z[i - 1],
							connections_mode[i - 1],
							reset,
							clock,
							connections_x[i], 
							connections_y[i],
							connections_z[i],
							connections_mode[i]);
			end
		endgenerate
		

				
endmodule