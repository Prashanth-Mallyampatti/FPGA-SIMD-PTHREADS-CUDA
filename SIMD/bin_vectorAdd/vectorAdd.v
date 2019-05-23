// (C) 1992-2014 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
    

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module vectorAdd_basic_block_0
	(
		input 		clock,
		input 		resetn,
		input 		start,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		output 		valid_out,
		input 		stall_in,
		output [31:0] 		lvb_input_global_id_0,
		input [31:0] 		workgroup_size
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in;
 reg merge_node_valid_out_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = (|(merge_node_stall_in & merge_node_valid_out_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in))
			begin
				merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg [31:0] lvb_input_global_id_0_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = merge_node_valid_out_NO_SHIFT_REG;
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out_NO_SHIFT_REG));
assign merge_node_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_input_global_id_0 = lvb_input_global_id_0_reg_NO_SHIFT_REG;
assign valid_out = branch_node_valid_out_NO_SHIFT_REG;
assign combined_branch_stall_in_signal = stall_in;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
		lvb_input_global_id_0_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_input_global_id_0_reg_NO_SHIFT_REG <= local_lvm_input_global_id_0_NO_SHIFT_REG;
		end
		else
		begin
			if (~(combined_branch_stall_in_signal))
			begin
				branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module vectorAdd_basic_block_1
	(
		input 		clock,
		input 		resetn,
		input [63:0] 		input_x,
		input [63:0] 		input_y,
		input [63:0] 		input_z,
		input [31:0] 		input_global_size_0,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
		input 		start,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		output 		local_bb1_ld__active,
		input 		clock2x,
		input [255:0] 		avm_local_bb1_ld__u0_readdata,
		input 		avm_local_bb1_ld__u0_readdatavalid,
		input 		avm_local_bb1_ld__u0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_address,
		output 		avm_local_bb1_ld__u0_read,
		output 		avm_local_bb1_ld__u0_write,
		input 		avm_local_bb1_ld__u0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_burstcount,
		output 		local_bb1_ld__u0_active,
		input [255:0] 		avm_local_bb1_st_c0_exe1_readdata,
		input 		avm_local_bb1_st_c0_exe1_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_address,
		output 		avm_local_bb1_st_c0_exe1_read,
		output 		avm_local_bb1_st_c0_exe1_write,
		input 		avm_local_bb1_st_c0_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_burstcount,
		output 		local_bb1_st_c0_exe1_active
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in;
 reg merge_node_valid_out_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = (|(merge_node_stall_in & merge_node_valid_out_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in))
			begin
				merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_idxprom_stall_local;
wire [63:0] local_bb1_idxprom;

assign local_bb1_idxprom[32] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[33] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[34] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[35] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[36] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[37] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[38] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[39] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[40] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[41] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[42] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[43] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[44] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[45] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[46] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[47] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[48] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[49] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[50] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[51] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[52] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[53] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[54] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[55] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[56] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[57] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[58] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[59] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[60] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[61] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[62] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[63] = local_lvm_input_global_id_0_NO_SHIFT_REG[31];
assign local_bb1_idxprom[31:0] = local_lvm_input_global_id_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx_stall_local;
wire [63:0] local_bb1_arrayidx;

assign local_bb1_arrayidx = (input_x + (local_bb1_idxprom << 6'h2));

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx2_stall_local;
wire [63:0] local_bb1_arrayidx2;

assign local_bb1_arrayidx2 = (input_y + (local_bb1_idxprom << 6'h2));

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx_valid_out;
wire local_bb1_arrayidx_stall_in;
 reg local_bb1_arrayidx_consumed_0_NO_SHIFT_REG;
wire local_bb1_arrayidx2_valid_out;
wire local_bb1_arrayidx2_stall_in;
 reg local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG;
wire local_bb1_arrayidx4_valid_out;
wire local_bb1_arrayidx4_stall_in;
 reg local_bb1_arrayidx4_consumed_0_NO_SHIFT_REG;
wire local_bb1_arrayidx4_inputs_ready;
wire local_bb1_arrayidx4_stall_local;
wire [63:0] local_bb1_arrayidx4;

assign local_bb1_arrayidx4_inputs_ready = merge_node_valid_out_NO_SHIFT_REG;
assign local_bb1_arrayidx4 = (input_z + (local_bb1_idxprom << 6'h2));
assign local_bb1_arrayidx4_stall_local = ((local_bb1_arrayidx_stall_in & ~(local_bb1_arrayidx_consumed_0_NO_SHIFT_REG)) | (local_bb1_arrayidx2_stall_in & ~(local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG)) | (local_bb1_arrayidx4_stall_in & ~(local_bb1_arrayidx4_consumed_0_NO_SHIFT_REG)));
assign local_bb1_arrayidx_valid_out = (local_bb1_arrayidx4_inputs_ready & ~(local_bb1_arrayidx_consumed_0_NO_SHIFT_REG));
assign local_bb1_arrayidx2_valid_out = (local_bb1_arrayidx4_inputs_ready & ~(local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG));
assign local_bb1_arrayidx4_valid_out = (local_bb1_arrayidx4_inputs_ready & ~(local_bb1_arrayidx4_consumed_0_NO_SHIFT_REG));
assign merge_node_stall_in = (|local_bb1_arrayidx4_stall_local);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_arrayidx_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_arrayidx4_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_arrayidx_consumed_0_NO_SHIFT_REG <= (local_bb1_arrayidx4_inputs_ready & (local_bb1_arrayidx_consumed_0_NO_SHIFT_REG | ~(local_bb1_arrayidx_stall_in)) & local_bb1_arrayidx4_stall_local);
		local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG <= (local_bb1_arrayidx4_inputs_ready & (local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG | ~(local_bb1_arrayidx2_stall_in)) & local_bb1_arrayidx4_stall_local);
		local_bb1_arrayidx4_consumed_0_NO_SHIFT_REG <= (local_bb1_arrayidx4_inputs_ready & (local_bb1_arrayidx4_consumed_0_NO_SHIFT_REG | ~(local_bb1_arrayidx4_stall_in)) & local_bb1_arrayidx4_stall_local);
	end
end


// This section implements a staging register.
// 
wire rstag_1to1_bb1_arrayidx_valid_out;
wire rstag_1to1_bb1_arrayidx_stall_in;
wire rstag_1to1_bb1_arrayidx_inputs_ready;
wire rstag_1to1_bb1_arrayidx_stall_local;
 reg rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG;
wire rstag_1to1_bb1_arrayidx_combined_valid;
 reg [63:0] rstag_1to1_bb1_arrayidx_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_1to1_bb1_arrayidx;

assign rstag_1to1_bb1_arrayidx_inputs_ready = local_bb1_arrayidx_valid_out;
assign rstag_1to1_bb1_arrayidx = (rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG ? rstag_1to1_bb1_arrayidx_staging_reg_NO_SHIFT_REG : local_bb1_arrayidx);
assign rstag_1to1_bb1_arrayidx_combined_valid = (rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG | rstag_1to1_bb1_arrayidx_inputs_ready);
assign rstag_1to1_bb1_arrayidx_valid_out = rstag_1to1_bb1_arrayidx_combined_valid;
assign rstag_1to1_bb1_arrayidx_stall_local = rstag_1to1_bb1_arrayidx_stall_in;
assign local_bb1_arrayidx_stall_in = (|rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_1to1_bb1_arrayidx_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_1to1_bb1_arrayidx_stall_local)
		begin
			if (~(rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG))
			begin
				rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG <= rstag_1to1_bb1_arrayidx_inputs_ready;
			end
		end
		else
		begin
			rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_1to1_bb1_arrayidx_staging_valid_NO_SHIFT_REG))
		begin
			rstag_1to1_bb1_arrayidx_staging_reg_NO_SHIFT_REG <= local_bb1_arrayidx;
		end
	end
end


// This section implements a staging register.
// 
wire rstag_1to1_bb1_arrayidx2_valid_out;
wire rstag_1to1_bb1_arrayidx2_stall_in;
wire rstag_1to1_bb1_arrayidx2_inputs_ready;
wire rstag_1to1_bb1_arrayidx2_stall_local;
 reg rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG;
wire rstag_1to1_bb1_arrayidx2_combined_valid;
 reg [63:0] rstag_1to1_bb1_arrayidx2_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_1to1_bb1_arrayidx2;

assign rstag_1to1_bb1_arrayidx2_inputs_ready = local_bb1_arrayidx2_valid_out;
assign rstag_1to1_bb1_arrayidx2 = (rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG ? rstag_1to1_bb1_arrayidx2_staging_reg_NO_SHIFT_REG : local_bb1_arrayidx2);
assign rstag_1to1_bb1_arrayidx2_combined_valid = (rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG | rstag_1to1_bb1_arrayidx2_inputs_ready);
assign rstag_1to1_bb1_arrayidx2_valid_out = rstag_1to1_bb1_arrayidx2_combined_valid;
assign rstag_1to1_bb1_arrayidx2_stall_local = rstag_1to1_bb1_arrayidx2_stall_in;
assign local_bb1_arrayidx2_stall_in = (|rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_1to1_bb1_arrayidx2_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_1to1_bb1_arrayidx2_stall_local)
		begin
			if (~(rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG))
			begin
				rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG <= rstag_1to1_bb1_arrayidx2_inputs_ready;
			end
		end
		else
		begin
			rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_1to1_bb1_arrayidx2_staging_valid_NO_SHIFT_REG))
		begin
			rstag_1to1_bb1_arrayidx2_staging_reg_NO_SHIFT_REG <= local_bb1_arrayidx2;
		end
	end
end


// Register node:
//  * latency = 13
//  * capacity = 13
 logic rnode_1to14_bb1_arrayidx4_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to14_bb1_arrayidx4_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_1to14_bb1_arrayidx4_0_NO_SHIFT_REG;
 logic rnode_1to14_bb1_arrayidx4_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_1to14_bb1_arrayidx4_0_reg_14_NO_SHIFT_REG;
 logic rnode_1to14_bb1_arrayidx4_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_1to14_bb1_arrayidx4_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_1to14_bb1_arrayidx4_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_1to14_bb1_arrayidx4_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to14_bb1_arrayidx4_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to14_bb1_arrayidx4_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_1to14_bb1_arrayidx4_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_1to14_bb1_arrayidx4_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(local_bb1_arrayidx4),
	.data_out(rnode_1to14_bb1_arrayidx4_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_1to14_bb1_arrayidx4_0_reg_14_fifo.DEPTH = 14;
defparam rnode_1to14_bb1_arrayidx4_0_reg_14_fifo.DATA_WIDTH = 64;
defparam rnode_1to14_bb1_arrayidx4_0_reg_14_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to14_bb1_arrayidx4_0_reg_14_fifo.IMPL = "ram";

assign rnode_1to14_bb1_arrayidx4_0_reg_14_inputs_ready_NO_SHIFT_REG = local_bb1_arrayidx4_valid_out;
assign local_bb1_arrayidx4_stall_in = rnode_1to14_bb1_arrayidx4_0_stall_out_reg_14_NO_SHIFT_REG;
assign rnode_1to14_bb1_arrayidx4_0_NO_SHIFT_REG = rnode_1to14_bb1_arrayidx4_0_reg_14_NO_SHIFT_REG;
assign rnode_1to14_bb1_arrayidx4_0_stall_in_reg_14_NO_SHIFT_REG = rnode_1to14_bb1_arrayidx4_0_stall_in_NO_SHIFT_REG;
assign rnode_1to14_bb1_arrayidx4_0_valid_out_NO_SHIFT_REG = rnode_1to14_bb1_arrayidx4_0_valid_out_reg_14_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb1_ld__inputs_ready;
 reg local_bb1_ld__valid_out_NO_SHIFT_REG;
wire local_bb1_ld__stall_in;
wire local_bb1_ld__output_regs_ready;
wire local_bb1_ld__fu_stall_out;
wire local_bb1_ld__fu_valid_out;
wire [31:0] local_bb1_ld__lsu_dataout;
 reg [31:0] local_bb1_ld__NO_SHIFT_REG;
wire local_bb1_ld__causedstall;

lsu_top lsu_local_bb1_ld_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rstag_1to1_bb1_arrayidx),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb1_ld__fu_stall_out),
	.i_valid(local_bb1_ld__inputs_ready),
	.i_address(rstag_1to1_bb1_arrayidx),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld__output_regs_ready)),
	.o_valid(local_bb1_ld__fu_valid_out),
	.o_readdata(local_bb1_ld__lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__active),
	.avm_address(avm_local_bb1_ld__address),
	.avm_read(avm_local_bb1_ld__read),
	.avm_readdata(avm_local_bb1_ld__readdata),
	.avm_write(avm_local_bb1_ld__write),
	.avm_writeack(avm_local_bb1_ld__writeack),
	.avm_burstcount(avm_local_bb1_ld__burstcount),
	.avm_writedata(avm_local_bb1_ld__writedata),
	.avm_byteenable(avm_local_bb1_ld__byteenable),
	.avm_waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld_.AWIDTH = 30;
defparam lsu_local_bb1_ld_.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld_.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_ld_.READ = 1;
defparam lsu_local_bb1_ld_.ATOMIC = 0;
defparam lsu_local_bb1_ld_.WIDTH = 32;
defparam lsu_local_bb1_ld_.MWIDTH = 256;
defparam lsu_local_bb1_ld_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld_.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb1_ld_.MEMORY_SIDE_MEM_LATENCY = 89;
defparam lsu_local_bb1_ld_.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld_.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld_.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld_.USECACHING = 0;
defparam lsu_local_bb1_ld_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld_.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld_.ADDRSPACE = 1;
defparam lsu_local_bb1_ld_.STYLE = "STREAMING";

assign local_bb1_ld__inputs_ready = rstag_1to1_bb1_arrayidx_valid_out;
assign local_bb1_ld__output_regs_ready = (&(~(local_bb1_ld__valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__stall_in)));
assign rstag_1to1_bb1_arrayidx_stall_in = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign local_bb1_ld__causedstall = (local_bb1_ld__inputs_ready && (local_bb1_ld__fu_stall_out && !(~(local_bb1_ld__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld__NO_SHIFT_REG <= 'x;
		local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__output_regs_ready)
		begin
			local_bb1_ld__NO_SHIFT_REG <= local_bb1_ld__lsu_dataout;
			local_bb1_ld__valid_out_NO_SHIFT_REG <= local_bb1_ld__fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__stall_in))
			begin
				local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_ld__u0_inputs_ready;
 reg local_bb1_ld__u0_valid_out_NO_SHIFT_REG;
wire local_bb1_ld__u0_stall_in;
wire local_bb1_ld__u0_output_regs_ready;
wire local_bb1_ld__u0_fu_stall_out;
wire local_bb1_ld__u0_fu_valid_out;
wire [31:0] local_bb1_ld__u0_lsu_dataout;
 reg [31:0] local_bb1_ld__u0_NO_SHIFT_REG;
wire local_bb1_ld__u0_causedstall;

lsu_top lsu_local_bb1_ld__u0 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rstag_1to1_bb1_arrayidx2),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb1_ld__u0_fu_stall_out),
	.i_valid(local_bb1_ld__u0_inputs_ready),
	.i_address(rstag_1to1_bb1_arrayidx2),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld__u0_output_regs_ready)),
	.o_valid(local_bb1_ld__u0_fu_valid_out),
	.o_readdata(local_bb1_ld__u0_lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__u0_active),
	.avm_address(avm_local_bb1_ld__u0_address),
	.avm_read(avm_local_bb1_ld__u0_read),
	.avm_readdata(avm_local_bb1_ld__u0_readdata),
	.avm_write(avm_local_bb1_ld__u0_write),
	.avm_writeack(avm_local_bb1_ld__u0_writeack),
	.avm_burstcount(avm_local_bb1_ld__u0_burstcount),
	.avm_writedata(avm_local_bb1_ld__u0_writedata),
	.avm_byteenable(avm_local_bb1_ld__u0_byteenable),
	.avm_waitrequest(avm_local_bb1_ld__u0_waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__u0_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld__u0.AWIDTH = 30;
defparam lsu_local_bb1_ld__u0.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld__u0.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld__u0.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld__u0.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_ld__u0.READ = 1;
defparam lsu_local_bb1_ld__u0.ATOMIC = 0;
defparam lsu_local_bb1_ld__u0.WIDTH = 32;
defparam lsu_local_bb1_ld__u0.MWIDTH = 256;
defparam lsu_local_bb1_ld__u0.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld__u0.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld__u0.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb1_ld__u0.MEMORY_SIDE_MEM_LATENCY = 89;
defparam lsu_local_bb1_ld__u0.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld__u0.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld__u0.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld__u0.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld__u0.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld__u0.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld__u0.USECACHING = 0;
defparam lsu_local_bb1_ld__u0.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld__u0.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld__u0.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld__u0.ADDRSPACE = 1;
defparam lsu_local_bb1_ld__u0.STYLE = "STREAMING";

assign local_bb1_ld__u0_inputs_ready = rstag_1to1_bb1_arrayidx2_valid_out;
assign local_bb1_ld__u0_output_regs_ready = (&(~(local_bb1_ld__u0_valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__u0_stall_in)));
assign rstag_1to1_bb1_arrayidx2_stall_in = (local_bb1_ld__u0_fu_stall_out | ~(local_bb1_ld__u0_inputs_ready));
assign local_bb1_ld__u0_causedstall = (local_bb1_ld__u0_inputs_ready && (local_bb1_ld__u0_fu_stall_out && !(~(local_bb1_ld__u0_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld__u0_NO_SHIFT_REG <= 'x;
		local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__u0_output_regs_ready)
		begin
			local_bb1_ld__u0_NO_SHIFT_REG <= local_bb1_ld__u0_lsu_dataout;
			local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= local_bb1_ld__u0_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__u0_stall_in))
			begin
				local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb1_arrayidx4_0_valid_out_NO_SHIFT_REG;
 logic rnode_14to15_bb1_arrayidx4_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_14to15_bb1_arrayidx4_0_NO_SHIFT_REG;
 logic rnode_14to15_bb1_arrayidx4_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_14to15_bb1_arrayidx4_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1_arrayidx4_0_valid_out_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1_arrayidx4_0_stall_in_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb1_arrayidx4_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb1_arrayidx4_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb1_arrayidx4_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb1_arrayidx4_0_stall_in_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb1_arrayidx4_0_valid_out_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb1_arrayidx4_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(rnode_1to14_bb1_arrayidx4_0_NO_SHIFT_REG),
	.data_out(rnode_14to15_bb1_arrayidx4_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb1_arrayidx4_0_reg_15_fifo.DEPTH = 2;
defparam rnode_14to15_bb1_arrayidx4_0_reg_15_fifo.DATA_WIDTH = 64;
defparam rnode_14to15_bb1_arrayidx4_0_reg_15_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_14to15_bb1_arrayidx4_0_reg_15_fifo.IMPL = "ll_reg";

assign rnode_14to15_bb1_arrayidx4_0_reg_15_inputs_ready_NO_SHIFT_REG = rnode_1to14_bb1_arrayidx4_0_valid_out_NO_SHIFT_REG;
assign rnode_1to14_bb1_arrayidx4_0_stall_in_NO_SHIFT_REG = rnode_14to15_bb1_arrayidx4_0_stall_out_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb1_arrayidx4_0_NO_SHIFT_REG = rnode_14to15_bb1_arrayidx4_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb1_arrayidx4_0_stall_in_reg_15_NO_SHIFT_REG = rnode_14to15_bb1_arrayidx4_0_stall_in_NO_SHIFT_REG;
assign rnode_14to15_bb1_arrayidx4_0_valid_out_NO_SHIFT_REG = rnode_14to15_bb1_arrayidx4_0_valid_out_reg_15_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_3to3_bb1_ld__valid_out;
wire rstag_3to3_bb1_ld__stall_in;
wire rstag_3to3_bb1_ld__inputs_ready;
wire rstag_3to3_bb1_ld__stall_local;
 reg rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG;
wire rstag_3to3_bb1_ld__combined_valid;
 reg [31:0] rstag_3to3_bb1_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_3to3_bb1_ld_;

assign rstag_3to3_bb1_ld__inputs_ready = local_bb1_ld__valid_out_NO_SHIFT_REG;
assign rstag_3to3_bb1_ld_ = (rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG ? rstag_3to3_bb1_ld__staging_reg_NO_SHIFT_REG : local_bb1_ld__NO_SHIFT_REG);
assign rstag_3to3_bb1_ld__combined_valid = (rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG | rstag_3to3_bb1_ld__inputs_ready);
assign rstag_3to3_bb1_ld__valid_out = rstag_3to3_bb1_ld__combined_valid;
assign rstag_3to3_bb1_ld__stall_local = rstag_3to3_bb1_ld__stall_in;
assign local_bb1_ld__stall_in = (|rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_3to3_bb1_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_3to3_bb1_ld__stall_local)
		begin
			if (~(rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG <= rstag_3to3_bb1_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_3to3_bb1_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_3to3_bb1_ld__staging_reg_NO_SHIFT_REG <= local_bb1_ld__NO_SHIFT_REG;
		end
	end
end


// This section implements a staging register.
// 
wire rstag_3to3_bb1_ld__u0_valid_out;
wire rstag_3to3_bb1_ld__u0_stall_in;
wire rstag_3to3_bb1_ld__u0_inputs_ready;
wire rstag_3to3_bb1_ld__u0_stall_local;
 reg rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG;
wire rstag_3to3_bb1_ld__u0_combined_valid;
 reg [31:0] rstag_3to3_bb1_ld__u0_staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_3to3_bb1_ld__u0;

assign rstag_3to3_bb1_ld__u0_inputs_ready = local_bb1_ld__u0_valid_out_NO_SHIFT_REG;
assign rstag_3to3_bb1_ld__u0 = (rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG ? rstag_3to3_bb1_ld__u0_staging_reg_NO_SHIFT_REG : local_bb1_ld__u0_NO_SHIFT_REG);
assign rstag_3to3_bb1_ld__u0_combined_valid = (rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG | rstag_3to3_bb1_ld__u0_inputs_ready);
assign rstag_3to3_bb1_ld__u0_valid_out = rstag_3to3_bb1_ld__u0_combined_valid;
assign rstag_3to3_bb1_ld__u0_stall_local = rstag_3to3_bb1_ld__u0_stall_in;
assign local_bb1_ld__u0_stall_in = (|rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_3to3_bb1_ld__u0_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_3to3_bb1_ld__u0_stall_local)
		begin
			if (~(rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG))
			begin
				rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= rstag_3to3_bb1_ld__u0_inputs_ready;
			end
		end
		else
		begin
			rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_3to3_bb1_ld__u0_staging_valid_NO_SHIFT_REG))
		begin
			rstag_3to3_bb1_ld__u0_staging_reg_NO_SHIFT_REG <= local_bb1_ld__u0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni1_stall_local;
wire [95:0] local_bb1_c0_eni1;

assign local_bb1_c0_eni1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb1_c0_eni1[63:32] = rstag_3to3_bb1_ld_;
assign local_bb1_c0_eni1[95:64] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni2_valid_out;
wire local_bb1_c0_eni2_stall_in;
wire local_bb1_c0_eni2_inputs_ready;
wire local_bb1_c0_eni2_stall_local;
wire [95:0] local_bb1_c0_eni2;

assign local_bb1_c0_eni2_inputs_ready = (rstag_3to3_bb1_ld__valid_out & rstag_3to3_bb1_ld__u0_valid_out);
assign local_bb1_c0_eni2[63:0] = local_bb1_c0_eni1[63:0];
assign local_bb1_c0_eni2[95:64] = rstag_3to3_bb1_ld__u0;
assign local_bb1_c0_eni2_valid_out = local_bb1_c0_eni2_inputs_ready;
assign local_bb1_c0_eni2_stall_local = local_bb1_c0_eni2_stall_in;
assign rstag_3to3_bb1_ld__stall_in = (local_bb1_c0_eni2_stall_local | ~(local_bb1_c0_eni2_inputs_ready));
assign rstag_3to3_bb1_ld__u0_stall_in = (local_bb1_c0_eni2_stall_local | ~(local_bb1_c0_eni2_inputs_ready));

// This section implements a registered operation.
// 
wire local_bb1_c0_enter_c0_eni2_inputs_ready;
 reg local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni2_stall_in_0;
 reg local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni2_stall_in_1;
wire local_bb1_c0_enter_c0_eni2_output_regs_ready;
 reg [95:0] local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni2_input_accepted;
wire local_bb1_c0_exit_c0_exi1_entry_stall;
wire local_bb1_c0_exit_c0_exi1_output_regs_ready;
wire [7:0] local_bb1_c0_exit_c0_exi1_valid_bits;
wire local_bb1_c0_exit_c0_exi1_phases;
wire local_bb1_c0_enter_c0_eni2_inc_pipelined_thread;
wire local_bb1_c0_enter_c0_eni2_dec_pipelined_thread;
wire local_bb1_c0_enter_c0_eni2_causedstall;

assign local_bb1_c0_enter_c0_eni2_inputs_ready = local_bb1_c0_eni2_valid_out;
assign local_bb1_c0_enter_c0_eni2_output_regs_ready = 1'b1;
assign local_bb1_c0_enter_c0_eni2_input_accepted = (local_bb1_c0_enter_c0_eni2_inputs_ready && !(local_bb1_c0_exit_c0_exi1_entry_stall));
assign local_bb1_c0_enter_c0_eni2_inc_pipelined_thread = 1'b1;
assign local_bb1_c0_enter_c0_eni2_dec_pipelined_thread = ~(1'b0);
assign local_bb1_c0_eni2_stall_in = ((~(local_bb1_c0_enter_c0_eni2_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) | ~(1'b1));
assign local_bb1_c0_enter_c0_eni2_causedstall = (1'b1 && ((~(local_bb1_c0_enter_c0_eni2_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG <= 'x;
		local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_enter_c0_eni2_output_regs_ready)
		begin
			local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG <= local_bb1_c0_eni2;
			local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_c0_enter_c0_eni2_stall_in_0))
			begin
				local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni2_stall_in_1))
			begin
				local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene1_stall_local;
wire [31:0] local_bb1_c0_ene1;

assign local_bb1_c0_ene1 = local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG[63:32];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene2_stall_local;
wire [31:0] local_bb1_c0_ene2;

assign local_bb1_c0_ene2 = local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG[95:64];

// This section implements an unregistered operation.
// 
wire local_bb1_var__stall_local;
wire [31:0] local_bb1_var_;

assign local_bb1_var_ = local_bb1_c0_ene1;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u1_stall_local;
wire [31:0] local_bb1_var__u1;

assign local_bb1_var__u1 = local_bb1_c0_ene2;

// This section implements an unregistered operation.
// 
wire local_bb1_and2_i_stall_local;
wire [31:0] local_bb1_and2_i;

assign local_bb1_and2_i = (local_bb1_var_ >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_and12_i_stall_local;
wire [31:0] local_bb1_and12_i;

assign local_bb1_and12_i = (local_bb1_var_ & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and_i_stall_local;
wire [31:0] local_bb1_and_i;

assign local_bb1_and_i = (local_bb1_var__u1 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_and10_i_stall_local;
wire [31:0] local_bb1_and10_i;

assign local_bb1_and10_i = (local_bb1_var__u1 & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_shr3_i_stall_local;
wire [31:0] local_bb1_shr3_i;

assign local_bb1_shr3_i = (local_bb1_and2_i & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb1_shr_i_stall_local;
wire [31:0] local_bb1_shr_i;

assign local_bb1_shr_i = (local_bb1_and_i & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp13_i_stall_local;
wire local_bb1_cmp13_i;

assign local_bb1_cmp13_i = (local_bb1_and10_i > local_bb1_and12_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp_i_stall_local;
wire local_bb1_cmp_i;

assign local_bb1_cmp_i = (local_bb1_shr_i > local_bb1_shr3_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp8_i_stall_local;
wire local_bb1_cmp8_i;

assign local_bb1_cmp8_i = (local_bb1_shr_i == local_bb1_shr3_i);

// This section implements an unregistered operation.
// 
wire local_bb1___i_stall_local;
wire local_bb1___i;

assign local_bb1___i = (local_bb1_cmp8_i & local_bb1_cmp13_i);

// This section implements an unregistered operation.
// 
wire local_bb1__21_i_stall_local;
wire local_bb1__21_i;

assign local_bb1__21_i = (local_bb1_cmp_i | local_bb1___i);

// This section implements an unregistered operation.
// 
wire local_bb1__22_i_stall_local;
wire [31:0] local_bb1__22_i;

assign local_bb1__22_i = (local_bb1__21_i ? local_bb1_var_ : local_bb1_var__u1);

// This section implements an unregistered operation.
// 
wire local_bb1__22_i_valid_out;
wire local_bb1__22_i_stall_in;
 reg local_bb1__22_i_consumed_0_NO_SHIFT_REG;
wire local_bb1__23_i_valid_out;
wire local_bb1__23_i_stall_in;
 reg local_bb1__23_i_consumed_0_NO_SHIFT_REG;
wire local_bb1__23_i_inputs_ready;
wire local_bb1__23_i_stall_local;
wire [31:0] local_bb1__23_i;

assign local_bb1__23_i_inputs_ready = (local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG & local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG);
assign local_bb1__23_i = (local_bb1__21_i ? local_bb1_var__u1 : local_bb1_var_);
assign local_bb1__22_i_valid_out = 1'b1;
assign local_bb1__23_i_valid_out = 1'b1;
assign local_bb1_c0_enter_c0_eni2_stall_in_0 = 1'b0;
assign local_bb1_c0_enter_c0_eni2_stall_in_1 = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1__22_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1__23_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1__22_i_consumed_0_NO_SHIFT_REG <= (local_bb1__23_i_inputs_ready & (local_bb1__22_i_consumed_0_NO_SHIFT_REG | ~(local_bb1__22_i_stall_in)) & local_bb1__23_i_stall_local);
		local_bb1__23_i_consumed_0_NO_SHIFT_REG <= (local_bb1__23_i_inputs_ready & (local_bb1__23_i_consumed_0_NO_SHIFT_REG | ~(local_bb1__23_i_stall_in)) & local_bb1__23_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb1__22_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_4to5_bb1__22_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb1__22_i_0_NO_SHIFT_REG;
 logic rnode_4to5_bb1__22_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_4to5_bb1__22_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb1__22_i_1_NO_SHIFT_REG;
 logic rnode_4to5_bb1__22_i_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb1__22_i_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1__22_i_0_valid_out_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1__22_i_0_stall_in_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1__22_i_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb1__22_i_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb1__22_i_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb1__22_i_0_stall_in_0_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb1__22_i_0_valid_out_0_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb1__22_i_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1__22_i),
	.data_out(rnode_4to5_bb1__22_i_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb1__22_i_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb1__22_i_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_4to5_bb1__22_i_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb1__22_i_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb1__22_i_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__22_i_stall_in = 1'b0;
assign rnode_4to5_bb1__22_i_0_stall_in_0_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1__22_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb1__22_i_0_NO_SHIFT_REG = rnode_4to5_bb1__22_i_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb1__22_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb1__22_i_1_NO_SHIFT_REG = rnode_4to5_bb1__22_i_0_reg_5_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb1__23_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_4to5_bb1__23_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb1__23_i_0_NO_SHIFT_REG;
 logic rnode_4to5_bb1__23_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_4to5_bb1__23_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb1__23_i_1_NO_SHIFT_REG;
 logic rnode_4to5_bb1__23_i_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb1__23_i_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1__23_i_0_valid_out_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1__23_i_0_stall_in_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb1__23_i_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb1__23_i_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb1__23_i_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb1__23_i_0_stall_in_0_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb1__23_i_0_valid_out_0_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb1__23_i_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb1__23_i),
	.data_out(rnode_4to5_bb1__23_i_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb1__23_i_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb1__23_i_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_4to5_bb1__23_i_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb1__23_i_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb1__23_i_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__23_i_stall_in = 1'b0;
assign rnode_4to5_bb1__23_i_0_stall_in_0_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1__23_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb1__23_i_0_NO_SHIFT_REG = rnode_4to5_bb1__23_i_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb1__23_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb1__23_i_1_NO_SHIFT_REG = rnode_4to5_bb1__23_i_0_reg_5_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_shr18_i_stall_local;
wire [31:0] local_bb1_shr18_i;

assign local_bb1_shr18_i = (rnode_4to5_bb1__22_i_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1__22_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1__22_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1__22_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1__22_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1__22_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1__22_i_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1__22_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1__22_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1__22_i_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1__22_i_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1__22_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1__22_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1__22_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1__22_i_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1__22_i_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1__22_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(rnode_4to5_bb1__22_i_1_NO_SHIFT_REG),
	.data_out(rnode_5to6_bb1__22_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1__22_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1__22_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1__22_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1__22_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1__22_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb1__22_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1__22_i_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1__22_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1__22_i_0_NO_SHIFT_REG = rnode_5to6_bb1__22_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1__22_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1__22_i_1_NO_SHIFT_REG = rnode_5to6_bb1__22_i_0_reg_6_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_shr16_i_stall_local;
wire [31:0] local_bb1_shr16_i;

assign local_bb1_shr16_i = (rnode_4to5_bb1__23_i_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1__23_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1__23_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1__23_i_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1__23_i_2_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1__23_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1__23_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1__23_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1__23_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1__23_i_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1__23_i_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1__23_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(rnode_4to5_bb1__23_i_1_NO_SHIFT_REG),
	.data_out(rnode_5to6_bb1__23_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1__23_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1__23_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1__23_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1__23_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1__23_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb1__23_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1__23_i_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1__23_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1__23_i_0_NO_SHIFT_REG = rnode_5to6_bb1__23_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1__23_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1__23_i_1_NO_SHIFT_REG = rnode_5to6_bb1__23_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1__23_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1__23_i_2_NO_SHIFT_REG = rnode_5to6_bb1__23_i_0_reg_6_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_and19_i_stall_local;
wire [31:0] local_bb1_and19_i;

assign local_bb1_and19_i = (local_bb1_shr18_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and21_i_stall_local;
wire [31:0] local_bb1_and21_i;

assign local_bb1_and21_i = (rnode_5to6_bb1__22_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_sub_i_stall_local;
wire [31:0] local_bb1_sub_i;

assign local_bb1_sub_i = (local_bb1_shr16_i - local_bb1_shr18_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and20_i_stall_local;
wire [31:0] local_bb1_and20_i;

assign local_bb1_and20_i = (rnode_5to6_bb1__23_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and35_i_valid_out;
wire local_bb1_and35_i_stall_in;
wire local_bb1_and35_i_inputs_ready;
wire local_bb1_and35_i_stall_local;
wire [31:0] local_bb1_and35_i;

assign local_bb1_and35_i_inputs_ready = rnode_5to6_bb1__23_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb1_and35_i = (rnode_5to6_bb1__23_i_1_NO_SHIFT_REG & 32'h80000000);
assign local_bb1_and35_i_valid_out = 1'b1;
assign rnode_5to6_bb1__23_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_xor_i_stall_local;
wire [31:0] local_bb1_xor_i;

assign local_bb1_xor_i = (rnode_5to6_bb1__23_i_2_NO_SHIFT_REG ^ rnode_5to6_bb1__22_i_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot23_i_stall_local;
wire local_bb1_lnot23_i;

assign local_bb1_lnot23_i = (local_bb1_and19_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp27_i_stall_local;
wire local_bb1_cmp27_i;

assign local_bb1_cmp27_i = (local_bb1_and19_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot33_not_i_stall_local;
wire local_bb1_lnot33_not_i;

assign local_bb1_lnot33_not_i = (local_bb1_and21_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_or64_i_stall_local;
wire [31:0] local_bb1_or64_i;

assign local_bb1_or64_i = (local_bb1_and21_i << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_and68_i_stall_local;
wire [31:0] local_bb1_and68_i;

assign local_bb1_and68_i = (local_bb1_sub_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot30_i_stall_local;
wire local_bb1_lnot30_i;

assign local_bb1_lnot30_i = (local_bb1_and20_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_or_i_stall_local;
wire [31:0] local_bb1_or_i;

assign local_bb1_or_i = (local_bb1_and20_i << 32'h3);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_and35_i_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_and35_i_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_and35_i_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_and35_i_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_and35_i_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_and35_i_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_and35_i_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_and35_i_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_and35_i_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_and35_i_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_and35_i_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1_and35_i),
	.data_out(rnode_6to7_bb1_and35_i_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_and35_i_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_and35_i_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_and35_i_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_and35_i_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_and35_i_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and35_i_stall_in = 1'b0;
assign rnode_6to7_bb1_and35_i_0_NO_SHIFT_REG = rnode_6to7_bb1_and35_i_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_and35_i_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_cmp37_i_stall_local;
wire local_bb1_cmp37_i;

assign local_bb1_cmp37_i = ($signed(local_bb1_xor_i) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb1_xor_lobit_i_stall_local;
wire [31:0] local_bb1_xor_lobit_i;

assign local_bb1_xor_lobit_i = ($signed(local_bb1_xor_i) >>> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_and36_lobit_i_stall_local;
wire [31:0] local_bb1_and36_lobit_i;

assign local_bb1_and36_lobit_i = (local_bb1_xor_i >> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_shl65_i_stall_local;
wire [31:0] local_bb1_shl65_i;

assign local_bb1_shl65_i = (local_bb1_or64_i | 32'h4000000);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp69_i_stall_local;
wire local_bb1_cmp69_i;

assign local_bb1_cmp69_i = (local_bb1_and68_i > 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot30_not_i_stall_local;
wire local_bb1_lnot30_not_i;

assign local_bb1_lnot30_not_i = (local_bb1_lnot30_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_shl_i_stall_local;
wire [31:0] local_bb1_shl_i;

assign local_bb1_shl_i = (local_bb1_or_i | 32'h4000000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and35_i_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and35_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and35_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and35_i_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and35_i_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and35_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_and35_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_and35_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_and35_i_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_and35_i_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_and35_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_6to7_bb1_and35_i_0_NO_SHIFT_REG),
	.data_out(rnode_7to8_bb1_and35_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_and35_i_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_and35_i_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_and35_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_and35_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_and35_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and35_i_0_NO_SHIFT_REG = rnode_7to8_bb1_and35_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_and35_i_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_align_0_i_stall_local;
wire [31:0] local_bb1_align_0_i;

assign local_bb1_align_0_i = (local_bb1_cmp69_i ? 32'h1F : local_bb1_and68_i);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_and35_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and35_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_and35_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and35_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and35_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and35_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_and35_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_and35_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_and35_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_and35_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_and35_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(rnode_7to8_bb1_and35_i_0_NO_SHIFT_REG),
	.data_out(rnode_8to9_bb1_and35_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_and35_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_and35_i_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb1_and35_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_and35_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_and35_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_and35_i_0_NO_SHIFT_REG = rnode_8to9_bb1_and35_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_and35_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_and93_i_stall_local;
wire [31:0] local_bb1_and93_i;

assign local_bb1_and93_i = (local_bb1_align_0_i & 32'h1C);

// This section implements an unregistered operation.
// 
wire local_bb1_and95_i_stall_local;
wire [31:0] local_bb1_and95_i;

assign local_bb1_and95_i = (local_bb1_align_0_i & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_and115_i_stall_local;
wire [31:0] local_bb1_and115_i;

assign local_bb1_and115_i = (local_bb1_align_0_i & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_and130_i_stall_local;
wire [31:0] local_bb1_and130_i;

assign local_bb1_and130_i = (local_bb1_align_0_i & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_shr16_i_valid_out_1;
wire local_bb1_shr16_i_stall_in_1;
 reg local_bb1_shr16_i_consumed_1_NO_SHIFT_REG;
wire local_bb1_lnot23_i_valid_out;
wire local_bb1_lnot23_i_stall_in;
 reg local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp27_i_valid_out;
wire local_bb1_cmp27_i_stall_in;
 reg local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and93_i_valid_out;
wire local_bb1_and93_i_stall_in;
 reg local_bb1_and93_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and95_i_valid_out;
wire local_bb1_and95_i_stall_in;
 reg local_bb1_and95_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and115_i_valid_out;
wire local_bb1_and115_i_stall_in;
 reg local_bb1_and115_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and130_i_valid_out;
wire local_bb1_and130_i_stall_in;
 reg local_bb1_and130_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and149_i_valid_out;
wire local_bb1_and149_i_stall_in;
 reg local_bb1_and149_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and149_i_inputs_ready;
wire local_bb1_and149_i_stall_local;
wire [31:0] local_bb1_and149_i;

assign local_bb1_and149_i_inputs_ready = (rnode_4to5_bb1__22_i_0_valid_out_0_NO_SHIFT_REG & rnode_4to5_bb1__23_i_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_and149_i = (local_bb1_align_0_i & 32'h3);
assign local_bb1_shr16_i_valid_out_1 = 1'b1;
assign local_bb1_lnot23_i_valid_out = 1'b1;
assign local_bb1_cmp27_i_valid_out = 1'b1;
assign local_bb1_and93_i_valid_out = 1'b1;
assign local_bb1_and95_i_valid_out = 1'b1;
assign local_bb1_and115_i_valid_out = 1'b1;
assign local_bb1_and130_i_valid_out = 1'b1;
assign local_bb1_and149_i_valid_out = 1'b1;
assign rnode_4to5_bb1__22_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb1__23_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_shr16_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_and93_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_and95_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_and115_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_and130_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_and149_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_shr16_i_consumed_1_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_shr16_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_shr16_i_stall_in_1)) & local_bb1_and149_i_stall_local);
		local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_lnot23_i_stall_in)) & local_bb1_and149_i_stall_local);
		local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp27_i_stall_in)) & local_bb1_and149_i_stall_local);
		local_bb1_and93_i_consumed_0_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_and93_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_and93_i_stall_in)) & local_bb1_and149_i_stall_local);
		local_bb1_and95_i_consumed_0_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_and95_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_and95_i_stall_in)) & local_bb1_and149_i_stall_local);
		local_bb1_and115_i_consumed_0_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_and115_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_and115_i_stall_in)) & local_bb1_and149_i_stall_local);
		local_bb1_and130_i_consumed_0_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_and130_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_and130_i_stall_in)) & local_bb1_and149_i_stall_local);
		local_bb1_and149_i_consumed_0_NO_SHIFT_REG <= (local_bb1_and149_i_inputs_ready & (local_bb1_and149_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_and149_i_stall_in)) & local_bb1_and149_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_shr16_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_shr16_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_shr16_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_shr16_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1_shr16_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_shr16_i_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1_shr16_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_shr16_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_shr16_i_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_shr16_i_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_shr16_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_shr16_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_shr16_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_shr16_i_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_shr16_i_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_shr16_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_shr16_i),
	.data_out(rnode_5to6_bb1_shr16_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_shr16_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_shr16_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1_shr16_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_shr16_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_shr16_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr16_i_stall_in_1 = 1'b0;
assign rnode_5to6_bb1_shr16_i_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_shr16_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_shr16_i_0_NO_SHIFT_REG = rnode_5to6_bb1_shr16_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_shr16_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_shr16_i_1_NO_SHIFT_REG = rnode_5to6_bb1_shr16_i_0_reg_6_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_lnot23_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to6_bb1_lnot23_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_5to6_bb1_lnot23_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_lnot23_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic rnode_5to6_bb1_lnot23_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_lnot23_i_0_valid_out_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_lnot23_i_0_stall_in_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_lnot23_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_lnot23_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_lnot23_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_lnot23_i_0_stall_in_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_lnot23_i_0_valid_out_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_lnot23_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_lnot23_i),
	.data_out(rnode_5to6_bb1_lnot23_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_lnot23_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_lnot23_i_0_reg_6_fifo.DATA_WIDTH = 1;
defparam rnode_5to6_bb1_lnot23_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_lnot23_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_lnot23_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_lnot23_i_stall_in = 1'b0;
assign rnode_5to6_bb1_lnot23_i_0_NO_SHIFT_REG = rnode_5to6_bb1_lnot23_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_lnot23_i_0_stall_in_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_lnot23_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_cmp27_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_2_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_cmp27_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_cmp27_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_cmp27_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_cmp27_i_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_cmp27_i_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_cmp27_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_cmp27_i),
	.data_out(rnode_5to6_bb1_cmp27_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_cmp27_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_cmp27_i_0_reg_6_fifo.DATA_WIDTH = 1;
defparam rnode_5to6_bb1_cmp27_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_cmp27_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_cmp27_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp27_i_stall_in = 1'b0;
assign rnode_5to6_bb1_cmp27_i_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_cmp27_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_cmp27_i_0_NO_SHIFT_REG = rnode_5to6_bb1_cmp27_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_cmp27_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_cmp27_i_1_NO_SHIFT_REG = rnode_5to6_bb1_cmp27_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_cmp27_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_cmp27_i_2_NO_SHIFT_REG = rnode_5to6_bb1_cmp27_i_0_reg_6_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_and93_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and93_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and93_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and93_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and93_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and93_i_0_valid_out_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and93_i_0_stall_in_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and93_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_and93_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_and93_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_and93_i_0_stall_in_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_and93_i_0_valid_out_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_and93_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_and93_i),
	.data_out(rnode_5to6_bb1_and93_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_and93_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_and93_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1_and93_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_and93_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_and93_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and93_i_stall_in = 1'b0;
assign rnode_5to6_bb1_and93_i_0_NO_SHIFT_REG = rnode_5to6_bb1_and93_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_and93_i_0_stall_in_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and93_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_and95_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and95_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and95_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and95_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and95_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and95_i_0_valid_out_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and95_i_0_stall_in_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and95_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_and95_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_and95_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_and95_i_0_stall_in_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_and95_i_0_valid_out_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_and95_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_and95_i),
	.data_out(rnode_5to6_bb1_and95_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_and95_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_and95_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1_and95_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_and95_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_and95_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and95_i_stall_in = 1'b0;
assign rnode_5to6_bb1_and95_i_0_NO_SHIFT_REG = rnode_5to6_bb1_and95_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_and95_i_0_stall_in_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and95_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_and115_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and115_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and115_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and115_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and115_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and115_i_0_valid_out_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and115_i_0_stall_in_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and115_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_and115_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_and115_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_and115_i_0_stall_in_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_and115_i_0_valid_out_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_and115_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_and115_i),
	.data_out(rnode_5to6_bb1_and115_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_and115_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_and115_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1_and115_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_and115_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_and115_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and115_i_stall_in = 1'b0;
assign rnode_5to6_bb1_and115_i_0_NO_SHIFT_REG = rnode_5to6_bb1_and115_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_and115_i_0_stall_in_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and115_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_and130_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and130_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and130_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and130_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and130_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and130_i_0_valid_out_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and130_i_0_stall_in_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and130_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_and130_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_and130_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_and130_i_0_stall_in_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_and130_i_0_valid_out_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_and130_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_and130_i),
	.data_out(rnode_5to6_bb1_and130_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_and130_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_and130_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1_and130_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_and130_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_and130_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and130_i_stall_in = 1'b0;
assign rnode_5to6_bb1_and130_i_0_NO_SHIFT_REG = rnode_5to6_bb1_and130_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_and130_i_0_stall_in_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and130_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb1_and149_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and149_i_0_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and149_i_1_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and149_i_2_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb1_and149_i_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb1_and149_i_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb1_and149_i_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb1_and149_i_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb1_and149_i_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb1_and149_i_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb1_and149_i_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb1_and149_i),
	.data_out(rnode_5to6_bb1_and149_i_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb1_and149_i_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb1_and149_i_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb1_and149_i_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb1_and149_i_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb1_and149_i_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and149_i_stall_in = 1'b0;
assign rnode_5to6_bb1_and149_i_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and149_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_and149_i_0_NO_SHIFT_REG = rnode_5to6_bb1_and149_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_and149_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_and149_i_1_NO_SHIFT_REG = rnode_5to6_bb1_and149_i_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb1_and149_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_and149_i_2_NO_SHIFT_REG = rnode_5to6_bb1_and149_i_0_reg_6_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_and17_i_stall_local;
wire [31:0] local_bb1_and17_i;

assign local_bb1_and17_i = (rnode_5to6_bb1_shr16_i_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_6to8_bb1_shr16_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to8_bb1_shr16_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb1_shr16_i_0_NO_SHIFT_REG;
 logic rnode_6to8_bb1_shr16_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb1_shr16_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_shr16_i_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_shr16_i_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_shr16_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_6to8_bb1_shr16_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to8_bb1_shr16_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to8_bb1_shr16_i_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_6to8_bb1_shr16_i_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_6to8_bb1_shr16_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_5to6_bb1_shr16_i_1_NO_SHIFT_REG),
	.data_out(rnode_6to8_bb1_shr16_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_6to8_bb1_shr16_i_0_reg_8_fifo.DEPTH = 2;
defparam rnode_6to8_bb1_shr16_i_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_6to8_bb1_shr16_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to8_bb1_shr16_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_6to8_bb1_shr16_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb1_shr16_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_shr16_i_0_NO_SHIFT_REG = rnode_6to8_bb1_shr16_i_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb1_shr16_i_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_shr16_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1__28_i_stall_local;
wire [31:0] local_bb1__28_i;

assign local_bb1__28_i = (rnode_5to6_bb1_lnot23_i_0_NO_SHIFT_REG ? 32'h0 : local_bb1_shl65_i);

// This section implements an unregistered operation.
// 
wire local_bb1_brmerge_not_i_stall_local;
wire local_bb1_brmerge_not_i;

assign local_bb1_brmerge_not_i = (rnode_5to6_bb1_cmp27_i_0_NO_SHIFT_REG & local_bb1_lnot33_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp96_i_stall_local;
wire local_bb1_cmp96_i;

assign local_bb1_cmp96_i = (rnode_5to6_bb1_and95_i_0_NO_SHIFT_REG == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp116_i_stall_local;
wire local_bb1_cmp116_i;

assign local_bb1_cmp116_i = (rnode_5to6_bb1_and115_i_0_NO_SHIFT_REG == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp131_not_i_stall_local;
wire local_bb1_cmp131_not_i;

assign local_bb1_cmp131_not_i = (rnode_5to6_bb1_and130_i_0_NO_SHIFT_REG != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_Pivot20_i_stall_local;
wire local_bb1_Pivot20_i;

assign local_bb1_Pivot20_i = (rnode_5to6_bb1_and149_i_1_NO_SHIFT_REG < 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_SwitchLeaf_i_stall_local;
wire local_bb1_SwitchLeaf_i;

assign local_bb1_SwitchLeaf_i = (rnode_5to6_bb1_and149_i_2_NO_SHIFT_REG == 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_i_stall_local;
wire local_bb1_lnot_i;

assign local_bb1_lnot_i = (local_bb1_and17_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp25_i_stall_local;
wire local_bb1_cmp25_i;

assign local_bb1_cmp25_i = (local_bb1_and17_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and72_i_stall_local;
wire [31:0] local_bb1_and72_i;

assign local_bb1_and72_i = (local_bb1__28_i >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_and75_i_stall_local;
wire [31:0] local_bb1_and75_i;

assign local_bb1_and75_i = (local_bb1__28_i & 32'hF0);

// This section implements an unregistered operation.
// 
wire local_bb1_and78_i_stall_local;
wire [31:0] local_bb1_and78_i;

assign local_bb1_and78_i = (local_bb1__28_i & 32'hF00);

// This section implements an unregistered operation.
// 
wire local_bb1_shr94_i_stall_local;
wire [31:0] local_bb1_shr94_i;

assign local_bb1_shr94_i = (local_bb1__28_i >> rnode_5to6_bb1_and93_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_and90_i_stall_local;
wire [31:0] local_bb1_and90_i;

assign local_bb1_and90_i = (local_bb1__28_i & 32'h7000000);

// This section implements an unregistered operation.
// 
wire local_bb1_and87_i_stall_local;
wire [31:0] local_bb1_and87_i;

assign local_bb1_and87_i = (local_bb1__28_i & 32'hF00000);

// This section implements an unregistered operation.
// 
wire local_bb1_and84_i_stall_local;
wire [31:0] local_bb1_and84_i;

assign local_bb1_and84_i = (local_bb1__28_i & 32'hF0000);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u2_stall_local;
wire [31:0] local_bb1_var__u2;

assign local_bb1_var__u2 = (local_bb1__28_i & 32'hFFF8);

// This section implements an unregistered operation.
// 
wire local_bb1_brmerge_not_not_i_stall_local;
wire local_bb1_brmerge_not_not_i;

assign local_bb1_brmerge_not_not_i = (local_bb1_brmerge_not_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1__27_i_stall_local;
wire [31:0] local_bb1__27_i;

assign local_bb1__27_i = (local_bb1_lnot_i ? 32'h0 : local_bb1_shl_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp25_not_i_stall_local;
wire local_bb1_cmp25_not_i;

assign local_bb1_cmp25_not_i = (local_bb1_cmp25_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_or_cond_not_i_stall_local;
wire local_bb1_or_cond_not_i;

assign local_bb1_or_cond_not_i = (local_bb1_cmp25_i & local_bb1_lnot30_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u3_stall_local;
wire local_bb1_var__u3;

assign local_bb1_var__u3 = (local_bb1_cmp25_i | rnode_5to6_bb1_cmp27_i_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_and72_tr_i_stall_local;
wire [7:0] local_bb1_and72_tr_i;

assign local_bb1_and72_tr_i = local_bb1_and72_i[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_cmp76_i_stall_local;
wire local_bb1_cmp76_i;

assign local_bb1_cmp76_i = (local_bb1_and75_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp79_i_stall_local;
wire local_bb1_cmp79_i;

assign local_bb1_cmp79_i = (local_bb1_and78_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_and142_i_stall_local;
wire [31:0] local_bb1_and142_i;

assign local_bb1_and142_i = (local_bb1_shr94_i >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_shr150_i_stall_local;
wire [31:0] local_bb1_shr150_i;

assign local_bb1_shr150_i = (local_bb1_shr94_i >> rnode_5to6_bb1_and149_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u4_stall_local;
wire [31:0] local_bb1_var__u4;

assign local_bb1_var__u4 = (local_bb1_shr94_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_and146_i_stall_local;
wire [31:0] local_bb1_and146_i;

assign local_bb1_and146_i = (local_bb1_shr94_i >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp91_i_stall_local;
wire local_bb1_cmp91_i;

assign local_bb1_cmp91_i = (local_bb1_and90_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp88_i_stall_local;
wire local_bb1_cmp88_i;

assign local_bb1_cmp88_i = (local_bb1_and87_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp85_i_stall_local;
wire local_bb1_cmp85_i;

assign local_bb1_cmp85_i = (local_bb1_and84_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u5_stall_local;
wire local_bb1_var__u5;

assign local_bb1_var__u5 = (local_bb1_var__u2 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_7_i_stall_local;
wire local_bb1_reduction_7_i;

assign local_bb1_reduction_7_i = (local_bb1_cmp25_i & local_bb1_brmerge_not_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_add_i_stall_local;
wire [31:0] local_bb1_add_i;

assign local_bb1_add_i = (local_bb1__27_i | local_bb1_and36_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or_cond_i_stall_local;
wire local_bb1_or_cond_i;

assign local_bb1_or_cond_i = (local_bb1_lnot30_i | local_bb1_cmp25_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1__24_i_stall_local;
wire local_bb1__24_i;

assign local_bb1__24_i = (local_bb1_or_cond_not_i | local_bb1_brmerge_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_frombool74_i_stall_local;
wire [7:0] local_bb1_frombool74_i;

assign local_bb1_frombool74_i = (local_bb1_and72_tr_i & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u6_stall_local;
wire [31:0] local_bb1_var__u6;

assign local_bb1_var__u6 = (local_bb1_and146_i | local_bb1_shr94_i);

// This section implements an unregistered operation.
// 
wire local_bb1__31_v_i_stall_local;
wire local_bb1__31_v_i;

assign local_bb1__31_v_i = (local_bb1_cmp96_i ? local_bb1_cmp79_i : local_bb1_cmp91_i);

// This section implements an unregistered operation.
// 
wire local_bb1__30_v_i_stall_local;
wire local_bb1__30_v_i;

assign local_bb1__30_v_i = (local_bb1_cmp96_i ? local_bb1_cmp76_i : local_bb1_cmp88_i);

// This section implements an unregistered operation.
// 
wire local_bb1_frombool109_i_stall_local;
wire [7:0] local_bb1_frombool109_i;

assign local_bb1_frombool109_i[7:1] = 7'h0;
assign local_bb1_frombool109_i[0] = local_bb1_cmp85_i;

// This section implements an unregistered operation.
// 
wire local_bb1_or107_i_stall_local;
wire [31:0] local_bb1_or107_i;

assign local_bb1_or107_i[31:1] = 31'h0;
assign local_bb1_or107_i[0] = local_bb1_var__u5;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_8_i_stall_local;
wire local_bb1_reduction_8_i;

assign local_bb1_reduction_8_i = (rnode_5to6_bb1_cmp27_i_1_NO_SHIFT_REG & local_bb1_or_cond_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or1596_i_stall_local;
wire [31:0] local_bb1_or1596_i;

assign local_bb1_or1596_i = (local_bb1_var__u6 | local_bb1_and142_i);

// This section implements an unregistered operation.
// 
wire local_bb1__31_i_stall_local;
wire [7:0] local_bb1__31_i;

assign local_bb1__31_i[7:1] = 7'h0;
assign local_bb1__31_i[0] = local_bb1__31_v_i;

// This section implements an unregistered operation.
// 
wire local_bb1__30_i_stall_local;
wire [7:0] local_bb1__30_i;

assign local_bb1__30_i[7:1] = 7'h0;
assign local_bb1__30_i[0] = local_bb1__30_v_i;

// This section implements an unregistered operation.
// 
wire local_bb1__29_i_stall_local;
wire [7:0] local_bb1__29_i;

assign local_bb1__29_i = (local_bb1_cmp96_i ? local_bb1_frombool74_i : local_bb1_frombool109_i);

// This section implements an unregistered operation.
// 
wire local_bb1__32_i_stall_local;
wire [31:0] local_bb1__32_i;

assign local_bb1__32_i = (local_bb1_cmp96_i ? 32'h0 : local_bb1_or107_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_9_i_stall_local;
wire local_bb1_reduction_9_i;

assign local_bb1_reduction_9_i = (local_bb1_reduction_7_i & local_bb1_reduction_8_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or162_i_stall_local;
wire [31:0] local_bb1_or162_i;

assign local_bb1_or162_i = (local_bb1_or1596_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_or1237_i_stall_local;
wire [7:0] local_bb1_or1237_i;

assign local_bb1_or1237_i = (local_bb1__30_i | local_bb1__29_i);

// This section implements an unregistered operation.
// 
wire local_bb1__33_i_stall_local;
wire [7:0] local_bb1__33_i;

assign local_bb1__33_i = (local_bb1_cmp116_i ? local_bb1__29_i : local_bb1__31_i);

// This section implements an unregistered operation.
// 
wire local_bb1__26_i_stall_local;
wire local_bb1__26_i;

assign local_bb1__26_i = (local_bb1_reduction_9_i ? local_bb1_cmp37_i : local_bb1__24_i);

// This section implements an unregistered operation.
// 
wire local_bb1__37_v_i_stall_local;
wire [31:0] local_bb1__37_v_i;

assign local_bb1__37_v_i = (local_bb1_Pivot20_i ? 32'h0 : local_bb1_or162_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or123_i_stall_local;
wire [31:0] local_bb1_or123_i;

assign local_bb1_or123_i[31:8] = 24'h0;
assign local_bb1_or123_i[7:0] = local_bb1_or1237_i;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u7_stall_local;
wire [7:0] local_bb1_var__u7;

assign local_bb1_var__u7 = (local_bb1__33_i & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1__39_v_i_stall_local;
wire [31:0] local_bb1__39_v_i;

assign local_bb1__39_v_i = (local_bb1_SwitchLeaf_i ? local_bb1_var__u4 : local_bb1__37_v_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or124_i_stall_local;
wire [31:0] local_bb1_or124_i;

assign local_bb1_or124_i = (local_bb1_cmp116_i ? 32'h0 : local_bb1_or123_i);

// This section implements an unregistered operation.
// 
wire local_bb1_conv135_i_stall_local;
wire [31:0] local_bb1_conv135_i;

assign local_bb1_conv135_i[31:8] = 24'h0;
assign local_bb1_conv135_i[7:0] = local_bb1_var__u7;

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_3_i_stall_local;
wire [31:0] local_bb1_reduction_3_i;

assign local_bb1_reduction_3_i = (local_bb1__32_i | local_bb1_or124_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or136_i_stall_local;
wire [31:0] local_bb1_or136_i;

assign local_bb1_or136_i = (local_bb1_cmp131_not_i ? local_bb1_conv135_i : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_5_i_stall_local;
wire [31:0] local_bb1_reduction_5_i;

assign local_bb1_reduction_5_i = (local_bb1_shr150_i | local_bb1_reduction_3_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_4_i_stall_local;
wire [31:0] local_bb1_reduction_4_i;

assign local_bb1_reduction_4_i = (local_bb1_or136_i | local_bb1__39_v_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_6_i_stall_local;
wire [31:0] local_bb1_reduction_6_i;

assign local_bb1_reduction_6_i = (local_bb1_reduction_4_i | local_bb1_reduction_5_i);

// This section implements an unregistered operation.
// 
wire local_bb1_xor188_i_stall_local;
wire [31:0] local_bb1_xor188_i;

assign local_bb1_xor188_i = (local_bb1_reduction_6_i ^ local_bb1_xor_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp37_i_valid_out_1;
wire local_bb1_cmp37_i_stall_in_1;
 reg local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG;
wire local_bb1__26_i_valid_out;
wire local_bb1__26_i_stall_in;
 reg local_bb1__26_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_add192_i_valid_out;
wire local_bb1_add192_i_stall_in;
 reg local_bb1_add192_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and17_i_valid_out_2;
wire local_bb1_and17_i_stall_in_2;
 reg local_bb1_and17_i_consumed_2_NO_SHIFT_REG;
wire local_bb1_var__u3_valid_out;
wire local_bb1_var__u3_stall_in;
 reg local_bb1_var__u3_consumed_0_NO_SHIFT_REG;
wire local_bb1_add192_i_inputs_ready;
wire local_bb1_add192_i_stall_local;
wire [31:0] local_bb1_add192_i;

assign local_bb1_add192_i_inputs_ready = (rnode_5to6_bb1__22_i_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb1_cmp27_i_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb1_lnot23_i_0_valid_out_NO_SHIFT_REG & rnode_5to6_bb1_and93_i_0_valid_out_NO_SHIFT_REG & rnode_5to6_bb1__22_i_0_valid_out_1_NO_SHIFT_REG & rnode_5to6_bb1__23_i_0_valid_out_2_NO_SHIFT_REG & rnode_5to6_bb1__23_i_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb1_cmp27_i_0_valid_out_1_NO_SHIFT_REG & rnode_5to6_bb1_shr16_i_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb1_cmp27_i_0_valid_out_2_NO_SHIFT_REG & rnode_5to6_bb1_and149_i_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb1_and95_i_0_valid_out_NO_SHIFT_REG & rnode_5to6_bb1_and149_i_0_valid_out_2_NO_SHIFT_REG & rnode_5to6_bb1_and115_i_0_valid_out_NO_SHIFT_REG & rnode_5to6_bb1_and130_i_0_valid_out_NO_SHIFT_REG & rnode_5to6_bb1_and149_i_0_valid_out_1_NO_SHIFT_REG);
assign local_bb1_add192_i = (local_bb1_add_i + local_bb1_xor188_i);
assign local_bb1_cmp37_i_valid_out_1 = 1'b1;
assign local_bb1__26_i_valid_out = 1'b1;
assign local_bb1_add192_i_valid_out = 1'b1;
assign local_bb1_and17_i_valid_out_2 = 1'b1;
assign local_bb1_var__u3_valid_out = 1'b1;
assign rnode_5to6_bb1__22_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_cmp27_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_lnot23_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and93_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1__22_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1__23_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1__23_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_cmp27_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_shr16_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_cmp27_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and149_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and95_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and149_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and115_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and130_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb1_and149_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1__26_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_add192_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_and17_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__u3_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_cmp37_i_stall_in_1)) & local_bb1_add192_i_stall_local);
		local_bb1__26_i_consumed_0_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1__26_i_consumed_0_NO_SHIFT_REG | ~(local_bb1__26_i_stall_in)) & local_bb1_add192_i_stall_local);
		local_bb1_add192_i_consumed_0_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_add192_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_add192_i_stall_in)) & local_bb1_add192_i_stall_local);
		local_bb1_and17_i_consumed_2_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_and17_i_consumed_2_NO_SHIFT_REG | ~(local_bb1_and17_i_stall_in_2)) & local_bb1_add192_i_stall_local);
		local_bb1_var__u3_consumed_0_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_var__u3_consumed_0_NO_SHIFT_REG | ~(local_bb1_var__u3_stall_in)) & local_bb1_add192_i_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_6to8_bb1_cmp37_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_1_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_2_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_valid_out_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_stall_in_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_cmp37_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_6to8_bb1_cmp37_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to8_bb1_cmp37_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to8_bb1_cmp37_i_0_stall_in_0_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_6to8_bb1_cmp37_i_0_valid_out_0_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_6to8_bb1_cmp37_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb1_cmp37_i),
	.data_out(rnode_6to8_bb1_cmp37_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_6to8_bb1_cmp37_i_0_reg_8_fifo.DEPTH = 2;
defparam rnode_6to8_bb1_cmp37_i_0_reg_8_fifo.DATA_WIDTH = 1;
defparam rnode_6to8_bb1_cmp37_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to8_bb1_cmp37_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_6to8_bb1_cmp37_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp37_i_stall_in_1 = 1'b0;
assign rnode_6to8_bb1_cmp37_i_0_stall_in_0_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_cmp37_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_6to8_bb1_cmp37_i_0_NO_SHIFT_REG = rnode_6to8_bb1_cmp37_i_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb1_cmp37_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_6to8_bb1_cmp37_i_1_NO_SHIFT_REG = rnode_6to8_bb1_cmp37_i_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb1_cmp37_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_6to8_bb1_cmp37_i_2_NO_SHIFT_REG = rnode_6to8_bb1_cmp37_i_0_reg_8_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1__26_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1__26_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_6to7_bb1__26_i_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1__26_i_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to7_bb1__26_i_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1__26_i_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1__26_i_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1__26_i_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1__26_i_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1__26_i_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1__26_i_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1__26_i_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1__26_i_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1__26_i),
	.data_out(rnode_6to7_bb1__26_i_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1__26_i_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1__26_i_0_reg_7_fifo.DATA_WIDTH = 1;
defparam rnode_6to7_bb1__26_i_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1__26_i_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1__26_i_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__26_i_stall_in = 1'b0;
assign rnode_6to7_bb1__26_i_0_NO_SHIFT_REG = rnode_6to7_bb1__26_i_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1__26_i_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1__26_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_add192_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_add192_i_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_add192_i_1_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_add192_i_2_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_add192_i_3_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb1_add192_i_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_valid_out_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_stall_in_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_add192_i_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_add192_i_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_add192_i_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_add192_i_0_stall_in_0_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_add192_i_0_valid_out_0_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_add192_i_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1_add192_i),
	.data_out(rnode_6to7_bb1_add192_i_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_add192_i_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_add192_i_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb1_add192_i_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_add192_i_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_add192_i_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_add192_i_stall_in = 1'b0;
assign rnode_6to7_bb1_add192_i_0_stall_in_0_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_add192_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_add192_i_0_NO_SHIFT_REG = rnode_6to7_bb1_add192_i_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_add192_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_add192_i_1_NO_SHIFT_REG = rnode_6to7_bb1_add192_i_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_add192_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_add192_i_2_NO_SHIFT_REG = rnode_6to7_bb1_add192_i_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_add192_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_add192_i_3_NO_SHIFT_REG = rnode_6to7_bb1_add192_i_0_reg_7_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_6to8_bb1_and17_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to8_bb1_and17_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb1_and17_i_0_NO_SHIFT_REG;
 logic rnode_6to8_bb1_and17_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb1_and17_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_and17_i_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_and17_i_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb1_and17_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_6to8_bb1_and17_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to8_bb1_and17_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to8_bb1_and17_i_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_6to8_bb1_and17_i_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_6to8_bb1_and17_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb1_and17_i),
	.data_out(rnode_6to8_bb1_and17_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_6to8_bb1_and17_i_0_reg_8_fifo.DEPTH = 2;
defparam rnode_6to8_bb1_and17_i_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_6to8_bb1_and17_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to8_bb1_and17_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_6to8_bb1_and17_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and17_i_stall_in_2 = 1'b0;
assign rnode_6to8_bb1_and17_i_0_NO_SHIFT_REG = rnode_6to8_bb1_and17_i_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb1_and17_i_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_and17_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb1_var__u3_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb1_var__u3_0_stall_in_NO_SHIFT_REG;
 logic rnode_6to7_bb1_var__u3_0_NO_SHIFT_REG;
 logic rnode_6to7_bb1_var__u3_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to7_bb1_var__u3_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_var__u3_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_var__u3_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb1_var__u3_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb1_var__u3_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb1_var__u3_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb1_var__u3_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb1_var__u3_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb1_var__u3_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb1_var__u3),
	.data_out(rnode_6to7_bb1_var__u3_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb1_var__u3_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb1_var__u3_0_reg_7_fifo.DATA_WIDTH = 1;
defparam rnode_6to7_bb1_var__u3_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb1_var__u3_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb1_var__u3_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_var__u3_stall_in = 1'b0;
assign rnode_6to7_bb1_var__u3_0_NO_SHIFT_REG = rnode_6to7_bb1_var__u3_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb1_var__u3_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb1_var__u3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_not_cmp37_i_stall_local;
wire local_bb1_not_cmp37_i;

assign local_bb1_not_cmp37_i = (rnode_6to8_bb1_cmp37_i_1_NO_SHIFT_REG ^ 1'b1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1__26_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1__26_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_7to8_bb1__26_i_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1__26_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic rnode_7to8_bb1__26_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1__26_i_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1__26_i_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1__26_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1__26_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1__26_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1__26_i_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1__26_i_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1__26_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_6to7_bb1__26_i_0_NO_SHIFT_REG),
	.data_out(rnode_7to8_bb1__26_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1__26_i_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1__26_i_0_reg_8_fifo.DATA_WIDTH = 1;
defparam rnode_7to8_bb1__26_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1__26_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1__26_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1__26_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1__26_i_0_NO_SHIFT_REG = rnode_7to8_bb1__26_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1__26_i_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1__26_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_and193_i_valid_out;
wire local_bb1_and193_i_stall_in;
wire local_bb1_and193_i_inputs_ready;
wire local_bb1_and193_i_stall_local;
wire [31:0] local_bb1_and193_i;

assign local_bb1_and193_i_inputs_ready = rnode_6to7_bb1_add192_i_0_valid_out_0_NO_SHIFT_REG;
assign local_bb1_and193_i = (rnode_6to7_bb1_add192_i_0_NO_SHIFT_REG & 32'hFFFFFFF);
assign local_bb1_and193_i_valid_out = 1'b1;
assign rnode_6to7_bb1_add192_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_and195_i_valid_out;
wire local_bb1_and195_i_stall_in;
wire local_bb1_and195_i_inputs_ready;
wire local_bb1_and195_i_stall_local;
wire [31:0] local_bb1_and195_i;

assign local_bb1_and195_i_inputs_ready = rnode_6to7_bb1_add192_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb1_and195_i = (rnode_6to7_bb1_add192_i_1_NO_SHIFT_REG >> 32'h1B);
assign local_bb1_and195_i_valid_out = 1'b1;
assign rnode_6to7_bb1_add192_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_and198_i_valid_out;
wire local_bb1_and198_i_stall_in;
wire local_bb1_and198_i_inputs_ready;
wire local_bb1_and198_i_stall_local;
wire [31:0] local_bb1_and198_i;

assign local_bb1_and198_i_inputs_ready = rnode_6to7_bb1_add192_i_0_valid_out_2_NO_SHIFT_REG;
assign local_bb1_and198_i = (rnode_6to7_bb1_add192_i_2_NO_SHIFT_REG & 32'h1);
assign local_bb1_and198_i_valid_out = 1'b1;
assign rnode_6to7_bb1_add192_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_and201_i_stall_local;
wire [31:0] local_bb1_and201_i;

assign local_bb1_and201_i = (rnode_6to7_bb1_add192_i_3_NO_SHIFT_REG & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_var__u3_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_var__u3_0_stall_in_NO_SHIFT_REG;
 logic rnode_7to8_bb1_var__u3_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_var__u3_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic rnode_7to8_bb1_var__u3_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_var__u3_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_var__u3_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_var__u3_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_var__u3_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_var__u3_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_var__u3_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_var__u3_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_var__u3_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_6to7_bb1_var__u3_0_NO_SHIFT_REG),
	.data_out(rnode_7to8_bb1_var__u3_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_var__u3_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_var__u3_0_reg_8_fifo.DATA_WIDTH = 1;
defparam rnode_7to8_bb1_var__u3_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_var__u3_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_var__u3_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb1_var__u3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_var__u3_0_NO_SHIFT_REG = rnode_7to8_bb1_var__u3_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_var__u3_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_var__u3_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1__26_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_1_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_2_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_valid_out_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_stall_in_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1__26_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1__26_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1__26_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1__26_i_0_stall_in_0_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1__26_i_0_valid_out_0_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1__26_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(rnode_7to8_bb1__26_i_0_NO_SHIFT_REG),
	.data_out(rnode_8to9_bb1__26_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1__26_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1__26_i_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb1__26_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1__26_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1__26_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1__26_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1__26_i_0_stall_in_0_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1__26_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb1__26_i_0_NO_SHIFT_REG = rnode_8to9_bb1__26_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1__26_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb1__26_i_1_NO_SHIFT_REG = rnode_8to9_bb1__26_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1__26_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb1__26_i_2_NO_SHIFT_REG = rnode_8to9_bb1__26_i_0_reg_9_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_and193_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and193_i_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and193_i_1_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and193_i_2_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and193_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_valid_out_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_stall_in_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and193_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_and193_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_and193_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_and193_i_0_stall_in_0_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_and193_i_0_valid_out_0_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_and193_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb1_and193_i),
	.data_out(rnode_7to8_bb1_and193_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_and193_i_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_and193_i_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_and193_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_and193_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_and193_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and193_i_stall_in = 1'b0;
assign rnode_7to8_bb1_and193_i_0_stall_in_0_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and193_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1_and193_i_0_NO_SHIFT_REG = rnode_7to8_bb1_and193_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_and193_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1_and193_i_1_NO_SHIFT_REG = rnode_7to8_bb1_and193_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_and193_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1_and193_i_2_NO_SHIFT_REG = rnode_7to8_bb1_and193_i_0_reg_8_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_and195_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and195_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and195_i_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and195_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and195_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and195_i_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and195_i_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and195_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_and195_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_and195_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_and195_i_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_and195_i_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_and195_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb1_and195_i),
	.data_out(rnode_7to8_bb1_and195_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_and195_i_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_and195_i_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_and195_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_and195_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_and195_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and195_i_stall_in = 1'b0;
assign rnode_7to8_bb1_and195_i_0_NO_SHIFT_REG = rnode_7to8_bb1_and195_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_and195_i_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and195_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1_and198_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and198_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and198_i_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and198_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1_and198_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and198_i_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and198_i_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1_and198_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1_and198_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1_and198_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1_and198_i_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1_and198_i_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1_and198_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb1_and198_i),
	.data_out(rnode_7to8_bb1_and198_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1_and198_i_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1_and198_i_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1_and198_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1_and198_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1_and198_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and198_i_stall_in = 1'b0;
assign rnode_7to8_bb1_and198_i_0_NO_SHIFT_REG = rnode_7to8_bb1_and198_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1_and198_i_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and198_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shr_i_i_stall_local;
wire [31:0] local_bb1_shr_i_i;

assign local_bb1_shr_i_i = (local_bb1_and201_i >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_var__u3_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_var__u3_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb1_var__u3_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_var__u3_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb1_var__u3_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_var__u3_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_var__u3_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_var__u3_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_var__u3_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_var__u3_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_var__u3_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_var__u3_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_var__u3_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(rnode_7to8_bb1_var__u3_0_NO_SHIFT_REG),
	.data_out(rnode_8to9_bb1_var__u3_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_var__u3_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_var__u3_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb1_var__u3_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_var__u3_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_var__u3_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1_var__u3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_var__u3_0_NO_SHIFT_REG = rnode_8to9_bb1_var__u3_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_var__u3_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_var__u3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_cond292_i_stall_local;
wire [31:0] local_bb1_cond292_i;

assign local_bb1_cond292_i = (rnode_8to9_bb1__26_i_1_NO_SHIFT_REG ? 32'h400000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u8_stall_local;
wire [31:0] local_bb1_var__u8;

assign local_bb1_var__u8[31:1] = 31'h0;
assign local_bb1_var__u8[0] = rnode_8to9_bb1__26_i_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_shr216_i_stall_local;
wire [31:0] local_bb1_shr216_i;

assign local_bb1_shr216_i = (rnode_7to8_bb1_and193_i_1_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1__pre_i_stall_local;
wire [31:0] local_bb1__pre_i;

assign local_bb1__pre_i = (rnode_7to8_bb1_and195_i_0_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_or_i_i_stall_local;
wire [31:0] local_bb1_or_i_i;

assign local_bb1_or_i_i = (local_bb1_shr_i_i | local_bb1_and201_i);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_ext_i_stall_local;
wire [31:0] local_bb1_lnot_ext_i;

assign local_bb1_lnot_ext_i = (local_bb1_var__u8 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_or219_i_stall_local;
wire [31:0] local_bb1_or219_i;

assign local_bb1_or219_i = (local_bb1_shr216_i | rnode_7to8_bb1_and198_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_tobool213_i_stall_local;
wire local_bb1_tobool213_i;

assign local_bb1_tobool213_i = (local_bb1__pre_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_shr1_i_i_stall_local;
wire [31:0] local_bb1_shr1_i_i;

assign local_bb1_shr1_i_i = (local_bb1_or_i_i >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb1__40_demorgan_i_stall_local;
wire local_bb1__40_demorgan_i;

assign local_bb1__40_demorgan_i = (rnode_6to8_bb1_cmp37_i_0_NO_SHIFT_REG | local_bb1_tobool213_i);

// This section implements an unregistered operation.
// 
wire local_bb1__42_i_stall_local;
wire local_bb1__42_i;

assign local_bb1__42_i = (local_bb1_tobool213_i & local_bb1_not_cmp37_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or2_i_i_stall_local;
wire [31:0] local_bb1_or2_i_i;

assign local_bb1_or2_i_i = (local_bb1_shr1_i_i | local_bb1_or_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1__43_i_stall_local;
wire [31:0] local_bb1__43_i;

assign local_bb1__43_i = (local_bb1__42_i ? 32'h0 : local_bb1__pre_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shr3_i_i_stall_local;
wire [31:0] local_bb1_shr3_i_i;

assign local_bb1_shr3_i_i = (local_bb1_or2_i_i >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_or4_i_i_stall_local;
wire [31:0] local_bb1_or4_i_i;

assign local_bb1_or4_i_i = (local_bb1_shr3_i_i | local_bb1_or2_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shr5_i_i_stall_local;
wire [31:0] local_bb1_shr5_i_i;

assign local_bb1_shr5_i_i = (local_bb1_or4_i_i >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_or6_i_i_stall_local;
wire [31:0] local_bb1_or6_i_i;

assign local_bb1_or6_i_i = (local_bb1_shr5_i_i | local_bb1_or4_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shr7_i_i_stall_local;
wire [31:0] local_bb1_shr7_i_i;

assign local_bb1_shr7_i_i = (local_bb1_or6_i_i >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_or6_masked_i_i_stall_local;
wire [31:0] local_bb1_or6_masked_i_i;

assign local_bb1_or6_masked_i_i = (local_bb1_or6_i_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_neg_i_i_stall_local;
wire [31:0] local_bb1_neg_i_i;

assign local_bb1_neg_i_i = (local_bb1_or6_masked_i_i | local_bb1_shr7_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and_i_i_stall_local;
wire [31:0] local_bb1_and_i_i;

assign local_bb1_and_i_i = (local_bb1_neg_i_i ^ 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1__and_i_i_valid_out;
wire local_bb1__and_i_i_stall_in;
wire local_bb1__and_i_i_inputs_ready;
wire local_bb1__and_i_i_stall_local;
wire [31:0] local_bb1__and_i_i;

thirtysix_six_comp local_bb1__and_i_i_popcnt_instance (
	.data(local_bb1_and_i_i),
	.sum(local_bb1__and_i_i)
);


assign local_bb1__and_i_i_inputs_ready = rnode_6to7_bb1_add192_i_0_valid_out_3_NO_SHIFT_REG;
assign local_bb1__and_i_i_valid_out = 1'b1;
assign rnode_6to7_bb1_add192_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb1__and_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1__and_i_i_0_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1__and_i_i_1_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1__and_i_i_2_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb1__and_i_i_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_valid_out_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_stall_in_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb1__and_i_i_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb1__and_i_i_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb1__and_i_i_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb1__and_i_i_0_stall_in_0_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb1__and_i_i_0_valid_out_0_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb1__and_i_i_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb1__and_i_i),
	.data_out(rnode_7to8_bb1__and_i_i_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb1__and_i_i_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb1__and_i_i_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb1__and_i_i_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb1__and_i_i_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb1__and_i_i_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__and_i_i_stall_in = 1'b0;
assign rnode_7to8_bb1__and_i_i_0_stall_in_0_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1__and_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1__and_i_i_0_NO_SHIFT_REG = rnode_7to8_bb1__and_i_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1__and_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1__and_i_i_1_NO_SHIFT_REG = rnode_7to8_bb1__and_i_i_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb1__and_i_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb1__and_i_i_2_NO_SHIFT_REG = rnode_7to8_bb1__and_i_i_0_reg_8_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_and9_i_i_stall_local;
wire [31:0] local_bb1_and9_i_i;

assign local_bb1_and9_i_i = (rnode_7to8_bb1__and_i_i_0_NO_SHIFT_REG & 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_and203_i_stall_local;
wire [31:0] local_bb1_and203_i;

assign local_bb1_and203_i = (rnode_7to8_bb1__and_i_i_1_NO_SHIFT_REG & 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb1_and206_i_stall_local;
wire [31:0] local_bb1_and206_i;

assign local_bb1_and206_i = (rnode_7to8_bb1__and_i_i_2_NO_SHIFT_REG & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb1_sub239_i_stall_local;
wire [31:0] local_bb1_sub239_i;

assign local_bb1_sub239_i = (32'h0 - local_bb1_and9_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shl204_i_stall_local;
wire [31:0] local_bb1_shl204_i;

assign local_bb1_shl204_i = (rnode_7to8_bb1_and193_i_0_NO_SHIFT_REG << local_bb1_and203_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cond244_i_stall_local;
wire [31:0] local_bb1_cond244_i;

assign local_bb1_cond244_i = (rnode_6to8_bb1_cmp37_i_2_NO_SHIFT_REG ? local_bb1_sub239_i : local_bb1__43_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and205_i_stall_local;
wire [31:0] local_bb1_and205_i;

assign local_bb1_and205_i = (local_bb1_shl204_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_add245_i_stall_local;
wire [31:0] local_bb1_add245_i;

assign local_bb1_add245_i = (local_bb1_cond244_i + rnode_6to8_bb1_and17_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_fold_i_stall_local;
wire [31:0] local_bb1_fold_i;

assign local_bb1_fold_i = (local_bb1_cond244_i + rnode_6to8_bb1_shr16_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_shl207_i_stall_local;
wire [31:0] local_bb1_shl207_i;

assign local_bb1_shl207_i = (local_bb1_and205_i << local_bb1_and206_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and247_i_stall_local;
wire [31:0] local_bb1_and247_i;

assign local_bb1_and247_i = (local_bb1_add245_i & 32'h100);

// This section implements an unregistered operation.
// 
wire local_bb1_and250_i_stall_local;
wire [31:0] local_bb1_and250_i;

assign local_bb1_and250_i = (local_bb1_fold_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and269_i_stall_local;
wire [31:0] local_bb1_and269_i;

assign local_bb1_and269_i = (local_bb1_fold_i << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb1_and208_i_stall_local;
wire [31:0] local_bb1_and208_i;

assign local_bb1_and208_i = (local_bb1_shl207_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_notlhs_i_stall_local;
wire local_bb1_notlhs_i;

assign local_bb1_notlhs_i = (local_bb1_and247_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_notrhs_i_stall_local;
wire local_bb1_notrhs_i;

assign local_bb1_notrhs_i = (local_bb1_and250_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1__44_i_stall_local;
wire [31:0] local_bb1__44_i;

assign local_bb1__44_i = (local_bb1__40_demorgan_i ? local_bb1_and208_i : local_bb1_or219_i);

// This section implements an unregistered operation.
// 
wire local_bb1_not__46_i_stall_local;
wire local_bb1_not__46_i;

assign local_bb1_not__46_i = (local_bb1_notrhs_i | local_bb1_notlhs_i);

// This section implements an unregistered operation.
// 
wire local_bb1__45_i_stall_local;
wire [31:0] local_bb1__45_i;

assign local_bb1__45_i = (local_bb1__42_i ? rnode_7to8_bb1_and193_i_2_NO_SHIFT_REG : local_bb1__44_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and225_i_stall_local;
wire [31:0] local_bb1_and225_i;

assign local_bb1_and225_i = (local_bb1__45_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and270_i_stall_local;
wire [31:0] local_bb1_and270_i;

assign local_bb1_and270_i = (local_bb1__45_i & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb1_shr271_i_stall_local;
wire [31:0] local_bb1_shr271_i;

assign local_bb1_shr271_i = (local_bb1__45_i >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp226_i_stall_local;
wire local_bb1_cmp226_i;

assign local_bb1_cmp226_i = (local_bb1_and225_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp296_i_stall_local;
wire local_bb1_cmp296_i;

assign local_bb1_cmp296_i = (local_bb1_and270_i > 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_and269_i_valid_out;
wire local_bb1_and269_i_stall_in;
 reg local_bb1_and269_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_add245_i_valid_out_1;
wire local_bb1_add245_i_stall_in_1;
 reg local_bb1_add245_i_consumed_1_NO_SHIFT_REG;
wire local_bb1_not__46_i_valid_out;
wire local_bb1_not__46_i_stall_in;
 reg local_bb1_not__46_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_not_cmp37_i_valid_out_1;
wire local_bb1_not_cmp37_i_stall_in_1;
 reg local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG;
wire local_bb1_shr271_i_valid_out;
wire local_bb1_shr271_i_stall_in;
 reg local_bb1_shr271_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp226_i_valid_out;
wire local_bb1_cmp226_i_stall_in;
 reg local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp296_i_valid_out;
wire local_bb1_cmp296_i_stall_in;
 reg local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp299_i_valid_out;
wire local_bb1_cmp299_i_stall_in;
 reg local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp299_i_inputs_ready;
wire local_bb1_cmp299_i_stall_local;
wire local_bb1_cmp299_i;

assign local_bb1_cmp299_i_inputs_ready = (rnode_6to8_bb1_shr16_i_0_valid_out_NO_SHIFT_REG & rnode_6to8_bb1_cmp37_i_0_valid_out_2_NO_SHIFT_REG & rnode_6to8_bb1_and17_i_0_valid_out_NO_SHIFT_REG & rnode_6to8_bb1_cmp37_i_0_valid_out_0_NO_SHIFT_REG & rnode_7to8_bb1_and193_i_0_valid_out_2_NO_SHIFT_REG & rnode_6to8_bb1_cmp37_i_0_valid_out_1_NO_SHIFT_REG & rnode_7to8_bb1_and195_i_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_and193_i_0_valid_out_1_NO_SHIFT_REG & rnode_7to8_bb1_and198_i_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb1_and193_i_0_valid_out_0_NO_SHIFT_REG & rnode_7to8_bb1__and_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_7to8_bb1__and_i_i_0_valid_out_2_NO_SHIFT_REG & rnode_7to8_bb1__and_i_i_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_cmp299_i = (local_bb1_and270_i == 32'h4);
assign local_bb1_and269_i_valid_out = 1'b1;
assign local_bb1_add245_i_valid_out_1 = 1'b1;
assign local_bb1_not__46_i_valid_out = 1'b1;
assign local_bb1_not_cmp37_i_valid_out_1 = 1'b1;
assign local_bb1_shr271_i_valid_out = 1'b1;
assign local_bb1_cmp226_i_valid_out = 1'b1;
assign local_bb1_cmp296_i_valid_out = 1'b1;
assign local_bb1_cmp299_i_valid_out = 1'b1;
assign rnode_6to8_bb1_shr16_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_cmp37_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_and17_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_cmp37_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and193_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb1_cmp37_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and195_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and193_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and198_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1_and193_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1__and_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1__and_i_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb1__and_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_and269_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_add245_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_not__46_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_shr271_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_and269_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_and269_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_and269_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_add245_i_consumed_1_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_add245_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_add245_i_stall_in_1)) & local_bb1_cmp299_i_stall_local);
		local_bb1_not__46_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_not__46_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_not__46_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_not_cmp37_i_stall_in_1)) & local_bb1_cmp299_i_stall_local);
		local_bb1_shr271_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_shr271_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_shr271_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp226_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp296_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp299_i_stall_in)) & local_bb1_cmp299_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_and269_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and269_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_and269_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and269_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_and269_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and269_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and269_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_and269_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_and269_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_and269_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_and269_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_and269_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_and269_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_and269_i),
	.data_out(rnode_8to9_bb1_and269_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_and269_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_and269_i_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb1_and269_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_and269_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_and269_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and269_i_stall_in = 1'b0;
assign rnode_8to9_bb1_and269_i_0_NO_SHIFT_REG = rnode_8to9_bb1_and269_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_and269_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_and269_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_add245_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_add245_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_add245_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_add245_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_add245_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_add245_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_add245_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_add245_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_add245_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_add245_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_add245_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_add245_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_add245_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_add245_i),
	.data_out(rnode_8to9_bb1_add245_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_add245_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_add245_i_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb1_add245_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_add245_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_add245_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_add245_i_stall_in_1 = 1'b0;
assign rnode_8to9_bb1_add245_i_0_NO_SHIFT_REG = rnode_8to9_bb1_add245_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_add245_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_add245_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_not__46_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not__46_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not__46_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not__46_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not__46_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not__46_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not__46_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not__46_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_not__46_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_not__46_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_not__46_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_not__46_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_not__46_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_not__46_i),
	.data_out(rnode_8to9_bb1_not__46_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_not__46_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_not__46_i_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb1_not__46_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_not__46_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_not__46_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_not__46_i_stall_in = 1'b0;
assign rnode_8to9_bb1_not__46_i_0_NO_SHIFT_REG = rnode_8to9_bb1_not__46_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_not__46_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_not__46_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_not_cmp37_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not_cmp37_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not_cmp37_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not_cmp37_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not_cmp37_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not_cmp37_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not_cmp37_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_not_cmp37_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_not_cmp37_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_not_cmp37_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_not_cmp37_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_not_cmp37_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_not_cmp37_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_not_cmp37_i),
	.data_out(rnode_8to9_bb1_not_cmp37_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_not_cmp37_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_not_cmp37_i_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb1_not_cmp37_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_not_cmp37_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_not_cmp37_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_not_cmp37_i_stall_in_1 = 1'b0;
assign rnode_8to9_bb1_not_cmp37_i_0_NO_SHIFT_REG = rnode_8to9_bb1_not_cmp37_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_not_cmp37_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_not_cmp37_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_shr271_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_shr271_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_shr271_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_shr271_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb1_shr271_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_shr271_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_shr271_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_shr271_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_shr271_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_shr271_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_shr271_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_shr271_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_shr271_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_shr271_i),
	.data_out(rnode_8to9_bb1_shr271_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_shr271_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_shr271_i_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb1_shr271_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_shr271_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_shr271_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr271_i_stall_in = 1'b0;
assign rnode_8to9_bb1_shr271_i_0_NO_SHIFT_REG = rnode_8to9_bb1_shr271_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_shr271_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_shr271_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_cmp226_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_1_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_valid_out_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_stall_in_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp226_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_cmp226_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_cmp226_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_cmp226_i_0_stall_in_0_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_cmp226_i_0_valid_out_0_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_cmp226_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_cmp226_i),
	.data_out(rnode_8to9_bb1_cmp226_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_cmp226_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_cmp226_i_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb1_cmp226_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_cmp226_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_cmp226_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp226_i_stall_in = 1'b0;
assign rnode_8to9_bb1_cmp226_i_0_stall_in_0_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_cmp226_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb1_cmp226_i_0_NO_SHIFT_REG = rnode_8to9_bb1_cmp226_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_cmp226_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb1_cmp226_i_1_NO_SHIFT_REG = rnode_8to9_bb1_cmp226_i_0_reg_9_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_cmp296_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp296_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp296_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp296_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp296_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp296_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp296_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp296_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_cmp296_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_cmp296_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_cmp296_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_cmp296_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_cmp296_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_cmp296_i),
	.data_out(rnode_8to9_bb1_cmp296_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_cmp296_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_cmp296_i_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb1_cmp296_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_cmp296_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_cmp296_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp296_i_stall_in = 1'b0;
assign rnode_8to9_bb1_cmp296_i_0_NO_SHIFT_REG = rnode_8to9_bb1_cmp296_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_cmp296_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_cmp296_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb1_cmp299_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp299_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp299_i_0_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp299_i_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp299_i_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp299_i_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp299_i_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb1_cmp299_i_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb1_cmp299_i_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb1_cmp299_i_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb1_cmp299_i_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb1_cmp299_i_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb1_cmp299_i_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb1_cmp299_i),
	.data_out(rnode_8to9_bb1_cmp299_i_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb1_cmp299_i_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb1_cmp299_i_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb1_cmp299_i_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb1_cmp299_i_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb1_cmp299_i_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp299_i_stall_in = 1'b0;
assign rnode_8to9_bb1_cmp299_i_0_NO_SHIFT_REG = rnode_8to9_bb1_cmp299_i_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb1_cmp299_i_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_cmp299_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shl273_i_stall_local;
wire [31:0] local_bb1_shl273_i;

assign local_bb1_shl273_i = (rnode_8to9_bb1_and269_i_0_NO_SHIFT_REG & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp258_i_stall_local;
wire local_bb1_cmp258_i;

assign local_bb1_cmp258_i = ($signed(rnode_8to9_bb1_add245_i_0_NO_SHIFT_REG) > $signed(32'hFE));

// This section implements an unregistered operation.
// 
wire local_bb1_and272_i_stall_local;
wire [31:0] local_bb1_and272_i;

assign local_bb1_and272_i = (rnode_8to9_bb1_shr271_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp226_not_i_stall_local;
wire local_bb1_cmp226_not_i;

assign local_bb1_cmp226_not_i = (rnode_8to9_bb1_cmp226_i_0_NO_SHIFT_REG ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1__47_i_stall_local;
wire local_bb1__47_i;

assign local_bb1__47_i = (rnode_8to9_bb1_cmp226_i_1_NO_SHIFT_REG | rnode_8to9_bb1_not__46_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp29649_i_stall_local;
wire [31:0] local_bb1_cmp29649_i;

assign local_bb1_cmp29649_i[31:1] = 31'h0;
assign local_bb1_cmp29649_i[0] = rnode_8to9_bb1_cmp296_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_conv300_i_stall_local;
wire [31:0] local_bb1_conv300_i;

assign local_bb1_conv300_i[31:1] = 31'h0;
assign local_bb1_conv300_i[0] = rnode_8to9_bb1_cmp299_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_or274_i_stall_local;
wire [31:0] local_bb1_or274_i;

assign local_bb1_or274_i = (local_bb1_and272_i | local_bb1_shl273_i);

// This section implements an unregistered operation.
// 
wire local_bb1_brmerge12_i_stall_local;
wire local_bb1_brmerge12_i;

assign local_bb1_brmerge12_i = (local_bb1_cmp226_not_i | rnode_8to9_bb1_not_cmp37_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot262__i_stall_local;
wire local_bb1_lnot262__i;

assign local_bb1_lnot262__i = (local_bb1_cmp258_i & local_bb1_cmp226_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u9_stall_local;
wire [31:0] local_bb1_var__u9;

assign local_bb1_var__u9[31:1] = 31'h0;
assign local_bb1_var__u9[0] = local_bb1__47_i;

// This section implements an unregistered operation.
// 
wire local_bb1_resultSign_0_i_stall_local;
wire [31:0] local_bb1_resultSign_0_i;

assign local_bb1_resultSign_0_i = (local_bb1_brmerge12_i ? rnode_8to9_bb1_and35_i_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_or2662_i_stall_local;
wire local_bb1_or2662_i;

assign local_bb1_or2662_i = (rnode_8to9_bb1_var__u3_0_NO_SHIFT_REG | local_bb1_lnot262__i);

// This section implements an unregistered operation.
// 
wire local_bb1_or275_i_stall_local;
wire [31:0] local_bb1_or275_i;

assign local_bb1_or275_i = (local_bb1_or274_i | local_bb1_resultSign_0_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or2804_i_stall_local;
wire local_bb1_or2804_i;

assign local_bb1_or2804_i = (local_bb1__47_i | local_bb1_or2662_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or2875_i_stall_local;
wire local_bb1_or2875_i;

assign local_bb1_or2875_i = (local_bb1_or2662_i | rnode_8to9_bb1__26_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u10_stall_local;
wire [31:0] local_bb1_var__u10;

assign local_bb1_var__u10[31:1] = 31'h0;
assign local_bb1_var__u10[0] = local_bb1_or2662_i;

// This section implements an unregistered operation.
// 
wire local_bb1_cond282_i_stall_local;
wire [31:0] local_bb1_cond282_i;

assign local_bb1_cond282_i = (local_bb1_or2804_i ? 32'h80000000 : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_cond289_i_stall_local;
wire [31:0] local_bb1_cond289_i;

assign local_bb1_cond289_i = (local_bb1_or2875_i ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_ext310_i_stall_local;
wire [31:0] local_bb1_lnot_ext310_i;

assign local_bb1_lnot_ext310_i = (local_bb1_var__u10 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_and293_i_stall_local;
wire [31:0] local_bb1_and293_i;

assign local_bb1_and293_i = (local_bb1_cond282_i & local_bb1_or275_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or294_i_stall_local;
wire [31:0] local_bb1_or294_i;

assign local_bb1_or294_i = (local_bb1_cond289_i | local_bb1_cond292_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_0_i_stall_local;
wire [31:0] local_bb1_reduction_0_i;

assign local_bb1_reduction_0_i = (local_bb1_lnot_ext310_i & local_bb1_lnot_ext_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and302_i_stall_local;
wire [31:0] local_bb1_and302_i;

assign local_bb1_and302_i = (local_bb1_conv300_i & local_bb1_and293_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or295_i_stall_local;
wire [31:0] local_bb1_or295_i;

assign local_bb1_or295_i = (local_bb1_or294_i | local_bb1_and293_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or295_i_valid_out;
wire local_bb1_or295_i_stall_in;
 reg local_bb1_or295_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_var__u9_valid_out;
wire local_bb1_var__u9_stall_in;
 reg local_bb1_var__u9_consumed_0_NO_SHIFT_REG;
wire local_bb1_lor_ext_i_valid_out;
wire local_bb1_lor_ext_i_stall_in;
 reg local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_reduction_0_i_valid_out;
wire local_bb1_reduction_0_i_stall_in;
 reg local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_lor_ext_i_inputs_ready;
wire local_bb1_lor_ext_i_stall_local;
wire [31:0] local_bb1_lor_ext_i;

assign local_bb1_lor_ext_i_inputs_ready = (rnode_8to9_bb1_and35_i_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_not_cmp37_i_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_and269_i_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_add245_i_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_var__u3_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1__26_i_0_valid_out_0_NO_SHIFT_REG & rnode_8to9_bb1__26_i_0_valid_out_1_NO_SHIFT_REG & rnode_8to9_bb1_cmp226_i_0_valid_out_1_NO_SHIFT_REG & rnode_8to9_bb1_not__46_i_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_shr271_i_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1__26_i_0_valid_out_2_NO_SHIFT_REG & rnode_8to9_bb1_cmp226_i_0_valid_out_0_NO_SHIFT_REG & rnode_8to9_bb1_cmp296_i_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb1_cmp299_i_0_valid_out_NO_SHIFT_REG);
assign local_bb1_lor_ext_i = (local_bb1_cmp29649_i | local_bb1_and302_i);
assign local_bb1_or295_i_valid_out = 1'b1;
assign local_bb1_var__u9_valid_out = 1'b1;
assign local_bb1_lor_ext_i_valid_out = 1'b1;
assign local_bb1_reduction_0_i_valid_out = 1'b1;
assign rnode_8to9_bb1_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_not_cmp37_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_and269_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_add245_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_var__u3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1__26_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1__26_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_cmp226_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_not__46_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_shr271_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1__26_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_cmp226_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_cmp296_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb1_cmp299_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_or295_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__u9_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_or295_i_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_or295_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_or295_i_stall_in)) & local_bb1_lor_ext_i_stall_local);
		local_bb1_var__u9_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_var__u9_consumed_0_NO_SHIFT_REG | ~(local_bb1_var__u9_stall_in)) & local_bb1_lor_ext_i_stall_local);
		local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_lor_ext_i_stall_in)) & local_bb1_lor_ext_i_stall_local);
		local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_reduction_0_i_stall_in)) & local_bb1_lor_ext_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb1_or295_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb1_or295_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_or295_i_0_NO_SHIFT_REG;
 logic rnode_9to10_bb1_or295_i_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_or295_i_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_or295_i_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_or295_i_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_or295_i_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb1_or295_i_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb1_or295_i_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb1_or295_i_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb1_or295_i_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb1_or295_i_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb1_or295_i),
	.data_out(rnode_9to10_bb1_or295_i_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb1_or295_i_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb1_or295_i_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb1_or295_i_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb1_or295_i_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb1_or295_i_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_or295_i_stall_in = 1'b0;
assign rnode_9to10_bb1_or295_i_0_NO_SHIFT_REG = rnode_9to10_bb1_or295_i_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb1_or295_i_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_or295_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb1_var__u9_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb1_var__u9_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_var__u9_0_NO_SHIFT_REG;
 logic rnode_9to10_bb1_var__u9_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_var__u9_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_var__u9_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_var__u9_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_var__u9_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb1_var__u9_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb1_var__u9_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb1_var__u9_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb1_var__u9_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb1_var__u9_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb1_var__u9),
	.data_out(rnode_9to10_bb1_var__u9_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb1_var__u9_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb1_var__u9_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb1_var__u9_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb1_var__u9_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb1_var__u9_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_var__u9_stall_in = 1'b0;
assign rnode_9to10_bb1_var__u9_0_NO_SHIFT_REG = rnode_9to10_bb1_var__u9_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb1_var__u9_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_var__u9_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb1_lor_ext_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb1_lor_ext_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_lor_ext_i_0_NO_SHIFT_REG;
 logic rnode_9to10_bb1_lor_ext_i_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_lor_ext_i_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_lor_ext_i_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_lor_ext_i_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_lor_ext_i_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb1_lor_ext_i_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb1_lor_ext_i_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb1_lor_ext_i_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb1_lor_ext_i_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb1_lor_ext_i_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb1_lor_ext_i),
	.data_out(rnode_9to10_bb1_lor_ext_i_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb1_lor_ext_i_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb1_lor_ext_i_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb1_lor_ext_i_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb1_lor_ext_i_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb1_lor_ext_i_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_lor_ext_i_stall_in = 1'b0;
assign rnode_9to10_bb1_lor_ext_i_0_NO_SHIFT_REG = rnode_9to10_bb1_lor_ext_i_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb1_lor_ext_i_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_lor_ext_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb1_reduction_0_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_0_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_reduction_0_i_0_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_0_i_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb1_reduction_0_i_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_0_i_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_0_i_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb1_reduction_0_i_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb1_reduction_0_i_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb1_reduction_0_i_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb1_reduction_0_i_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb1_reduction_0_i_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb1_reduction_0_i_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb1_reduction_0_i),
	.data_out(rnode_9to10_bb1_reduction_0_i_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb1_reduction_0_i_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb1_reduction_0_i_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb1_reduction_0_i_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb1_reduction_0_i_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb1_reduction_0_i_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_0_i_stall_in = 1'b0;
assign rnode_9to10_bb1_reduction_0_i_0_NO_SHIFT_REG = rnode_9to10_bb1_reduction_0_i_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb1_reduction_0_i_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_reduction_0_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_ext314_i_stall_local;
wire [31:0] local_bb1_lnot_ext314_i;

assign local_bb1_lnot_ext314_i = (rnode_9to10_bb1_var__u9_0_NO_SHIFT_REG ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_1_i_stall_local;
wire [31:0] local_bb1_reduction_1_i;

assign local_bb1_reduction_1_i = (local_bb1_lnot_ext314_i & rnode_9to10_bb1_lor_ext_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_2_i_stall_local;
wire [31:0] local_bb1_reduction_2_i;

assign local_bb1_reduction_2_i = (rnode_9to10_bb1_reduction_0_i_0_NO_SHIFT_REG & local_bb1_reduction_1_i);

// This section implements an unregistered operation.
// 
wire local_bb1_add320_i_stall_local;
wire [31:0] local_bb1_add320_i;

assign local_bb1_add320_i = (local_bb1_reduction_2_i + rnode_9to10_bb1_or295_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u11_stall_local;
wire [31:0] local_bb1_var__u11;

assign local_bb1_var__u11 = local_bb1_add320_i;

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi1_valid_out;
wire local_bb1_c0_exi1_stall_in;
wire local_bb1_c0_exi1_inputs_ready;
wire local_bb1_c0_exi1_stall_local;
wire [63:0] local_bb1_c0_exi1;

assign local_bb1_c0_exi1_inputs_ready = (rnode_9to10_bb1_or295_i_0_valid_out_NO_SHIFT_REG & rnode_9to10_bb1_reduction_0_i_0_valid_out_NO_SHIFT_REG & rnode_9to10_bb1_var__u9_0_valid_out_NO_SHIFT_REG & rnode_9to10_bb1_lor_ext_i_0_valid_out_NO_SHIFT_REG);
assign local_bb1_c0_exi1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb1_c0_exi1[63:32] = local_bb1_var__u11;
assign local_bb1_c0_exi1_valid_out = 1'b1;
assign rnode_9to10_bb1_or295_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_reduction_0_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_var__u9_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb1_lor_ext_i_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_c0_exit_c0_exi1_inputs_ready;
 reg local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi1_stall_in;
 reg [63:0] local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG;
wire [63:0] local_bb1_c0_exit_c0_exi1_in;
wire local_bb1_c0_exit_c0_exi1_valid;
wire local_bb1_c0_exit_c0_exi1_causedstall;

acl_stall_free_sink local_bb1_c0_exit_c0_exi1_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c0_exi1),
	.data_out(local_bb1_c0_exit_c0_exi1_in),
	.input_accepted(local_bb1_c0_enter_c0_eni2_input_accepted),
	.valid_out(local_bb1_c0_exit_c0_exi1_valid),
	.stall_in(~(local_bb1_c0_exit_c0_exi1_output_regs_ready)),
	.stall_entry(local_bb1_c0_exit_c0_exi1_entry_stall),
	.valids(local_bb1_c0_exit_c0_exi1_valid_bits),
	.IIphases(local_bb1_c0_exit_c0_exi1_phases),
	.inc_pipelined_thread(local_bb1_c0_enter_c0_eni2_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb1_c0_enter_c0_eni2_dec_pipelined_thread)
);

defparam local_bb1_c0_exit_c0_exi1_instance.DATA_WIDTH = 64;
defparam local_bb1_c0_exit_c0_exi1_instance.PIPELINE_DEPTH = 12;
defparam local_bb1_c0_exit_c0_exi1_instance.SHARINGII = 1;
defparam local_bb1_c0_exit_c0_exi1_instance.SCHEDULEII = 1;

assign local_bb1_c0_exit_c0_exi1_inputs_ready = 1'b1;
assign local_bb1_c0_exit_c0_exi1_output_regs_ready = (&(~(local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi1_stall_in)));
assign local_bb1_c0_exi1_stall_in = 1'b0;
assign local_bb1_c0_exit_c0_exi1_causedstall = (1'b1 && (1'b0 && !(~(local_bb1_c0_exit_c0_exi1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= 'x;
		local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_exit_c0_exi1_output_regs_ready)
		begin
			local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_in;
			local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_valid;
		end
		else
		begin
			if (~(local_bb1_c0_exit_c0_exi1_stall_in))
			begin
				local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_exe1_valid_out;
wire local_bb1_c0_exe1_stall_in;
wire local_bb1_c0_exe1_inputs_ready;
wire local_bb1_c0_exe1_stall_local;
wire [31:0] local_bb1_c0_exe1;

assign local_bb1_c0_exe1_inputs_ready = local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
assign local_bb1_c0_exe1 = local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG[63:32];
assign local_bb1_c0_exe1_valid_out = local_bb1_c0_exe1_inputs_ready;
assign local_bb1_c0_exe1_stall_local = local_bb1_c0_exe1_stall_in;
assign local_bb1_c0_exit_c0_exi1_stall_in = (|local_bb1_c0_exe1_stall_local);

// This section implements a registered operation.
// 
wire local_bb1_st_c0_exe1_inputs_ready;
 reg local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG;
wire local_bb1_st_c0_exe1_stall_in;
wire local_bb1_st_c0_exe1_output_regs_ready;
wire local_bb1_st_c0_exe1_fu_stall_out;
wire local_bb1_st_c0_exe1_fu_valid_out;
wire local_bb1_st_c0_exe1_causedstall;

lsu_top lsu_local_bb1_st_c0_exe1 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rnode_14to15_bb1_arrayidx4_0_NO_SHIFT_REG),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb1_st_c0_exe1_fu_stall_out),
	.i_valid(local_bb1_st_c0_exe1_inputs_ready),
	.i_address(rnode_14to15_bb1_arrayidx4_0_NO_SHIFT_REG),
	.i_writedata(local_bb1_c0_exe1),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_st_c0_exe1_output_regs_ready)),
	.o_valid(local_bb1_st_c0_exe1_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_st_c0_exe1_active),
	.avm_address(avm_local_bb1_st_c0_exe1_address),
	.avm_read(avm_local_bb1_st_c0_exe1_read),
	.avm_readdata(avm_local_bb1_st_c0_exe1_readdata),
	.avm_write(avm_local_bb1_st_c0_exe1_write),
	.avm_writeack(avm_local_bb1_st_c0_exe1_writeack),
	.avm_burstcount(avm_local_bb1_st_c0_exe1_burstcount),
	.avm_writedata(avm_local_bb1_st_c0_exe1_writedata),
	.avm_byteenable(avm_local_bb1_st_c0_exe1_byteenable),
	.avm_waitrequest(avm_local_bb1_st_c0_exe1_waitrequest),
	.avm_readdatavalid(avm_local_bb1_st_c0_exe1_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_st_c0_exe1.AWIDTH = 30;
defparam lsu_local_bb1_st_c0_exe1.WIDTH_BYTES = 4;
defparam lsu_local_bb1_st_c0_exe1.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c0_exe1.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c0_exe1.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_st_c0_exe1.READ = 0;
defparam lsu_local_bb1_st_c0_exe1.ATOMIC = 0;
defparam lsu_local_bb1_st_c0_exe1.WIDTH = 32;
defparam lsu_local_bb1_st_c0_exe1.MWIDTH = 256;
defparam lsu_local_bb1_st_c0_exe1.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_st_c0_exe1.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_st_c0_exe1.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb1_st_c0_exe1.MEMORY_SIDE_MEM_LATENCY = 32;
defparam lsu_local_bb1_st_c0_exe1.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_st_c0_exe1.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_st_c0_exe1.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_st_c0_exe1.NUMBER_BANKS = 1;
defparam lsu_local_bb1_st_c0_exe1.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_st_c0_exe1.USEINPUTFIFO = 0;
defparam lsu_local_bb1_st_c0_exe1.USECACHING = 0;
defparam lsu_local_bb1_st_c0_exe1.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_st_c0_exe1.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_st_c0_exe1.HIGH_FMAX = 1;
defparam lsu_local_bb1_st_c0_exe1.ADDRSPACE = 1;
defparam lsu_local_bb1_st_c0_exe1.STYLE = "STREAMING";
defparam lsu_local_bb1_st_c0_exe1.USE_BYTE_EN = 0;

assign local_bb1_st_c0_exe1_inputs_ready = (local_bb1_c0_exe1_valid_out & rnode_14to15_bb1_arrayidx4_0_valid_out_NO_SHIFT_REG);
assign local_bb1_st_c0_exe1_output_regs_ready = (&(~(local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG) | ~(local_bb1_st_c0_exe1_stall_in)));
assign local_bb1_c0_exe1_stall_in = (local_bb1_st_c0_exe1_fu_stall_out | ~(local_bb1_st_c0_exe1_inputs_ready));
assign rnode_14to15_bb1_arrayidx4_0_stall_in_NO_SHIFT_REG = (local_bb1_st_c0_exe1_fu_stall_out | ~(local_bb1_st_c0_exe1_inputs_ready));
assign local_bb1_st_c0_exe1_causedstall = (local_bb1_st_c0_exe1_inputs_ready && (local_bb1_st_c0_exe1_fu_stall_out && !(~(local_bb1_st_c0_exe1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_st_c0_exe1_output_regs_ready)
		begin
			local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= local_bb1_st_c0_exe1_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_st_c0_exe1_stall_in))
			begin
				local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_17to17_bb1_st_c0_exe1_valid_out;
wire rstag_17to17_bb1_st_c0_exe1_stall_in;
wire rstag_17to17_bb1_st_c0_exe1_inputs_ready;
wire rstag_17to17_bb1_st_c0_exe1_stall_local;
 reg rstag_17to17_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG;
wire rstag_17to17_bb1_st_c0_exe1_combined_valid;

assign rstag_17to17_bb1_st_c0_exe1_inputs_ready = local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG;
assign rstag_17to17_bb1_st_c0_exe1_combined_valid = (rstag_17to17_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG | rstag_17to17_bb1_st_c0_exe1_inputs_ready);
assign rstag_17to17_bb1_st_c0_exe1_valid_out = rstag_17to17_bb1_st_c0_exe1_combined_valid;
assign rstag_17to17_bb1_st_c0_exe1_stall_local = rstag_17to17_bb1_st_c0_exe1_stall_in;
assign local_bb1_st_c0_exe1_stall_in = (|rstag_17to17_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_17to17_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (rstag_17to17_bb1_st_c0_exe1_stall_local)
		begin
			if (~(rstag_17to17_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG))
			begin
				rstag_17to17_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= rstag_17to17_bb1_st_c0_exe1_inputs_ready;
			end
		end
		else
		begin
			rstag_17to17_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
wire branch_var__output_regs_ready;

assign branch_var__inputs_ready = rstag_17to17_bb1_st_c0_exe1_valid_out;
assign branch_var__output_regs_ready = ~(stall_in);
assign rstag_17to17_bb1_st_c0_exe1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign valid_out = branch_var__inputs_ready;

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module vectorAdd_function
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		input_global_id_0,
		output 		stall_out,
		input 		valid_in,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		input [255:0] 		avm_local_bb1_ld__u0_readdata,
		input 		avm_local_bb1_ld__u0_readdatavalid,
		input 		avm_local_bb1_ld__u0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_address,
		output 		avm_local_bb1_ld__u0_read,
		output 		avm_local_bb1_ld__u0_write,
		input 		avm_local_bb1_ld__u0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_burstcount,
		input [255:0] 		avm_local_bb1_st_c0_exe1_readdata,
		input 		avm_local_bb1_st_c0_exe1_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_address,
		output 		avm_local_bb1_st_c0_exe1_read,
		output 		avm_local_bb1_st_c0_exe1_write,
		input 		avm_local_bb1_st_c0_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_burstcount,
		input 		start,
		input 		clock2x,
		input [63:0] 		input_x,
		input [63:0] 		input_y,
		input [63:0] 		input_z,
		input [31:0] 		input_global_size_0,
		output reg 		has_a_write_pending,
		output reg 		has_a_lsu_active
	);


wire [31:0] cur_cycle;
wire bb_0_stall_out;
wire bb_0_valid_out;
wire [31:0] bb_0_lvb_input_global_id_0;
wire bb_1_stall_out;
wire bb_1_valid_out;
wire bb_1_local_bb1_ld__active;
wire bb_1_local_bb1_ld__u0_active;
wire bb_1_local_bb1_st_c0_exe1_active;
wire writes_pending;
wire [2:0] lsus_active;

vectorAdd_sys_cycle_time system_cycle_time_module (
	.clock(clock),
	.resetn(resetn),
	.cur_cycle(cur_cycle)
);


vectorAdd_basic_block_0 vectorAdd_basic_block_0 (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.valid_in(valid_in),
	.stall_out(bb_0_stall_out),
	.input_global_id_0(input_global_id_0),
	.valid_out(bb_0_valid_out),
	.stall_in(bb_1_stall_out),
	.lvb_input_global_id_0(bb_0_lvb_input_global_id_0),
	.workgroup_size(workgroup_size)
);


vectorAdd_basic_block_1 vectorAdd_basic_block_1 (
	.clock(clock),
	.resetn(resetn),
	.input_x(input_x),
	.input_y(input_y),
	.input_z(input_z),
	.input_global_size_0(input_global_size_0),
	.valid_in(bb_0_valid_out),
	.stall_out(bb_1_stall_out),
	.input_global_id_0(bb_0_lvb_input_global_id_0),
	.valid_out(bb_1_valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size),
	.start(start),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__burstcount),
	.local_bb1_ld__active(bb_1_local_bb1_ld__active),
	.clock2x(clock2x),
	.avm_local_bb1_ld__u0_readdata(avm_local_bb1_ld__u0_readdata),
	.avm_local_bb1_ld__u0_readdatavalid(avm_local_bb1_ld__u0_readdatavalid),
	.avm_local_bb1_ld__u0_waitrequest(avm_local_bb1_ld__u0_waitrequest),
	.avm_local_bb1_ld__u0_address(avm_local_bb1_ld__u0_address),
	.avm_local_bb1_ld__u0_read(avm_local_bb1_ld__u0_read),
	.avm_local_bb1_ld__u0_write(avm_local_bb1_ld__u0_write),
	.avm_local_bb1_ld__u0_writeack(avm_local_bb1_ld__u0_writeack),
	.avm_local_bb1_ld__u0_writedata(avm_local_bb1_ld__u0_writedata),
	.avm_local_bb1_ld__u0_byteenable(avm_local_bb1_ld__u0_byteenable),
	.avm_local_bb1_ld__u0_burstcount(avm_local_bb1_ld__u0_burstcount),
	.local_bb1_ld__u0_active(bb_1_local_bb1_ld__u0_active),
	.avm_local_bb1_st_c0_exe1_readdata(avm_local_bb1_st_c0_exe1_readdata),
	.avm_local_bb1_st_c0_exe1_readdatavalid(avm_local_bb1_st_c0_exe1_readdatavalid),
	.avm_local_bb1_st_c0_exe1_waitrequest(avm_local_bb1_st_c0_exe1_waitrequest),
	.avm_local_bb1_st_c0_exe1_address(avm_local_bb1_st_c0_exe1_address),
	.avm_local_bb1_st_c0_exe1_read(avm_local_bb1_st_c0_exe1_read),
	.avm_local_bb1_st_c0_exe1_write(avm_local_bb1_st_c0_exe1_write),
	.avm_local_bb1_st_c0_exe1_writeack(avm_local_bb1_st_c0_exe1_writeack),
	.avm_local_bb1_st_c0_exe1_writedata(avm_local_bb1_st_c0_exe1_writedata),
	.avm_local_bb1_st_c0_exe1_byteenable(avm_local_bb1_st_c0_exe1_byteenable),
	.avm_local_bb1_st_c0_exe1_burstcount(avm_local_bb1_st_c0_exe1_burstcount),
	.local_bb1_st_c0_exe1_active(bb_1_local_bb1_st_c0_exe1_active)
);


assign valid_out = bb_1_valid_out;
assign stall_out = bb_0_stall_out;
assign writes_pending = bb_1_local_bb1_st_c0_exe1_active;
assign lsus_active[0] = bb_1_local_bb1_ld__active;
assign lsus_active[1] = bb_1_local_bb1_ld__u0_active;
assign lsus_active[2] = bb_1_local_bb1_st_c0_exe1_active;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		has_a_write_pending <= 1'b0;
		has_a_lsu_active <= 1'b0;
	end
	else
	begin
		has_a_write_pending <= (|writes_pending);
		has_a_lsu_active <= (|lsus_active);
	end
end

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module vectorAdd_function_wrapper
	(
		input 		clock,
		input 		resetn,
		input 		clock2x,
		input 		local_router_hang,
		input 		avs_cra_read,
		input 		avs_cra_write,
		input [3:0] 		avs_cra_address,
		input [63:0] 		avs_cra_writedata,
		input [7:0] 		avs_cra_byteenable,
		output 		avs_cra_waitrequest,
		output reg [63:0] 		avs_cra_readdata,
		output reg 		avs_cra_readdatavalid,
		output 		cra_irq,
		input [255:0] 		avm_local_bb1_ld__inst0_readdata,
		input 		avm_local_bb1_ld__inst0_readdatavalid,
		input 		avm_local_bb1_ld__inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__inst0_address,
		output 		avm_local_bb1_ld__inst0_read,
		output 		avm_local_bb1_ld__inst0_write,
		input 		avm_local_bb1_ld__inst0_writeack,
		output [255:0] 		avm_local_bb1_ld__inst0_writedata,
		output [31:0] 		avm_local_bb1_ld__inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__inst0_burstcount,
		input [255:0] 		avm_local_bb1_ld__u0_inst0_readdata,
		input 		avm_local_bb1_ld__u0_inst0_readdatavalid,
		input 		avm_local_bb1_ld__u0_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_inst0_address,
		output 		avm_local_bb1_ld__u0_inst0_read,
		output 		avm_local_bb1_ld__u0_inst0_write,
		input 		avm_local_bb1_ld__u0_inst0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_inst0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_inst0_burstcount,
		input [255:0] 		avm_local_bb1_st_c0_exe1_inst0_readdata,
		input 		avm_local_bb1_st_c0_exe1_inst0_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_inst0_address,
		output 		avm_local_bb1_st_c0_exe1_inst0_read,
		output 		avm_local_bb1_st_c0_exe1_inst0_write,
		input 		avm_local_bb1_st_c0_exe1_inst0_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_inst0_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_inst0_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_inst0_burstcount
	);

// Responsible for interfacing a kernel with the outside world. It comprises a
// slave interface to specify the kernel arguments and retain kernel status. 

// This section of the wrapper implements the slave interface.
// twoXclock_consumer uses clock2x, even if nobody inside the kernel does. Keeps interface to acl_iface consistent for all kernels.
 reg start_NO_SHIFT_REG;
 reg started_NO_SHIFT_REG;
wire finish;
 reg [31:0] status_NO_SHIFT_REG;
wire has_a_write_pending;
wire has_a_lsu_active;
 reg [191:0] kernel_arguments_NO_SHIFT_REG;
 reg twoXclock_consumer_NO_SHIFT_REG /* synthesis  preserve  noprune  */;
 reg [31:0] workgroup_size_NO_SHIFT_REG;
 reg [31:0] global_size_NO_SHIFT_REG[2:0];
 reg [31:0] num_groups_NO_SHIFT_REG[2:0];
 reg [31:0] local_size_NO_SHIFT_REG[2:0];
 reg [31:0] work_dim_NO_SHIFT_REG;
 reg [31:0] global_offset_NO_SHIFT_REG[2:0];
 reg [63:0] profile_data_NO_SHIFT_REG;
 reg [31:0] profile_ctrl_NO_SHIFT_REG;
 reg [63:0] profile_start_cycle_NO_SHIFT_REG;
 reg [63:0] profile_stop_cycle_NO_SHIFT_REG;
wire dispatched_all_groups;
wire [31:0] group_id_tmp[2:0];
wire [31:0] global_id_base_out[2:0];
wire start_out;
wire [31:0] local_id[0:0][2:0];
wire [31:0] global_id[0:0][2:0];
wire [31:0] group_id[0:0][2:0];
wire iter_valid_in;
wire iter_stall_out;
wire stall_in;
wire stall_out;
wire valid_in;
wire valid_out;

always @(posedge clock2x or negedge resetn)
begin
	if (~(resetn))
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b1;
	end
end



// Work group dispatcher is responsible for issuing work-groups to id iterator(s)
acl_work_group_dispatcher group_dispatcher (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.num_groups(num_groups_NO_SHIFT_REG),
	.local_size(local_size_NO_SHIFT_REG),
	.stall_in(iter_stall_out),
	.valid_out(iter_valid_in),
	.group_id_out(group_id_tmp),
	.global_id_base_out(global_id_base_out),
	.start_out(start_out),
	.dispatched_all_groups(dispatched_all_groups)
);

defparam group_dispatcher.NUM_COPIES = 1;
defparam group_dispatcher.RUN_FOREVER = 0;


// This section of the wrapper implements an Avalon Slave Interface used to configure a kernel invocation.
// The few words words contain the status and the workgroup size registers.
// The remaining addressable space is reserved for kernel arguments.
wire [63:0] bitenable;

assign bitenable[7:0] = (avs_cra_byteenable[0] ? 8'hFF : 8'h0);
assign bitenable[15:8] = (avs_cra_byteenable[1] ? 8'hFF : 8'h0);
assign bitenable[23:16] = (avs_cra_byteenable[2] ? 8'hFF : 8'h0);
assign bitenable[31:24] = (avs_cra_byteenable[3] ? 8'hFF : 8'h0);
assign bitenable[39:32] = (avs_cra_byteenable[4] ? 8'hFF : 8'h0);
assign bitenable[47:40] = (avs_cra_byteenable[5] ? 8'hFF : 8'h0);
assign bitenable[55:48] = (avs_cra_byteenable[6] ? 8'hFF : 8'h0);
assign bitenable[63:56] = (avs_cra_byteenable[7] ? 8'hFF : 8'h0);
assign avs_cra_waitrequest = 1'b0;
assign cra_irq = (status_NO_SHIFT_REG[1] | status_NO_SHIFT_REG[3]);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		start_NO_SHIFT_REG <= 1'b0;
		started_NO_SHIFT_REG <= 1'b0;
		kernel_arguments_NO_SHIFT_REG <= 192'h0;
		status_NO_SHIFT_REG <= 32'h30000;
		profile_ctrl_NO_SHIFT_REG <= 32'h4;
		profile_start_cycle_NO_SHIFT_REG <= 64'h0;
		profile_stop_cycle_NO_SHIFT_REG <= 64'hFFFFFFFFFFFFFFFF;
		work_dim_NO_SHIFT_REG <= 32'h0;
		workgroup_size_NO_SHIFT_REG <= 32'h0;
		global_size_NO_SHIFT_REG[0] <= 32'h0;
		global_size_NO_SHIFT_REG[1] <= 32'h0;
		global_size_NO_SHIFT_REG[2] <= 32'h0;
		num_groups_NO_SHIFT_REG[0] <= 32'h0;
		num_groups_NO_SHIFT_REG[1] <= 32'h0;
		num_groups_NO_SHIFT_REG[2] <= 32'h0;
		local_size_NO_SHIFT_REG[0] <= 32'h0;
		local_size_NO_SHIFT_REG[1] <= 32'h0;
		local_size_NO_SHIFT_REG[2] <= 32'h0;
		global_offset_NO_SHIFT_REG[0] <= 32'h0;
		global_offset_NO_SHIFT_REG[1] <= 32'h0;
		global_offset_NO_SHIFT_REG[2] <= 32'h0;
	end
	else
	begin
		if (avs_cra_write)
		begin
			case (avs_cra_address)
				4'h0:
				begin
					status_NO_SHIFT_REG[31:16] <= 16'h3;
					status_NO_SHIFT_REG[15:0] <= ((status_NO_SHIFT_REG[15:0] & ~(bitenable[15:0])) | (avs_cra_writedata[15:0] & bitenable[15:0]));
				end

				4'h1:
				begin
					profile_ctrl_NO_SHIFT_REG <= ((profile_ctrl_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h3:
				begin
					profile_start_cycle_NO_SHIFT_REG[31:0] <= ((profile_start_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_start_cycle_NO_SHIFT_REG[63:32] <= ((profile_start_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h4:
				begin
					profile_stop_cycle_NO_SHIFT_REG[31:0] <= ((profile_stop_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_stop_cycle_NO_SHIFT_REG[63:32] <= ((profile_stop_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h5:
				begin
					work_dim_NO_SHIFT_REG <= ((work_dim_NO_SHIFT_REG & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					workgroup_size_NO_SHIFT_REG <= ((workgroup_size_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h6:
				begin
					global_size_NO_SHIFT_REG[0] <= ((global_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_size_NO_SHIFT_REG[1] <= ((global_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h7:
				begin
					global_size_NO_SHIFT_REG[2] <= ((global_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[0] <= ((num_groups_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h8:
				begin
					num_groups_NO_SHIFT_REG[1] <= ((num_groups_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[2] <= ((num_groups_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h9:
				begin
					local_size_NO_SHIFT_REG[0] <= ((local_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					local_size_NO_SHIFT_REG[1] <= ((local_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hA:
				begin
					local_size_NO_SHIFT_REG[2] <= ((local_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[0] <= ((global_offset_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hB:
				begin
					global_offset_NO_SHIFT_REG[1] <= ((global_offset_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[2] <= ((global_offset_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hC:
				begin
					kernel_arguments_NO_SHIFT_REG[31:0] <= ((kernel_arguments_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[63:32] <= ((kernel_arguments_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hD:
				begin
					kernel_arguments_NO_SHIFT_REG[95:64] <= ((kernel_arguments_NO_SHIFT_REG[95:64] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[127:96] <= ((kernel_arguments_NO_SHIFT_REG[127:96] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'hE:
				begin
					kernel_arguments_NO_SHIFT_REG[159:128] <= ((kernel_arguments_NO_SHIFT_REG[159:128] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[191:160] <= ((kernel_arguments_NO_SHIFT_REG[191:160] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				default:
				begin
				end

			endcase
		end
		else
		begin
			if (status_NO_SHIFT_REG[0])
			begin
				start_NO_SHIFT_REG <= 1'b1;
			end
			if (start_NO_SHIFT_REG)
			begin
				status_NO_SHIFT_REG[0] <= 1'b0;
				started_NO_SHIFT_REG <= 1'b1;
			end
			if (started_NO_SHIFT_REG)
			begin
				start_NO_SHIFT_REG <= 1'b0;
			end
			if (finish)
			begin
				status_NO_SHIFT_REG[1] <= 1'b1;
				started_NO_SHIFT_REG <= 1'b0;
			end
		end
		status_NO_SHIFT_REG[11] <= local_router_hang;
		status_NO_SHIFT_REG[12] <= (|has_a_lsu_active);
		status_NO_SHIFT_REG[13] <= (|has_a_write_pending);
		status_NO_SHIFT_REG[14] <= (|valid_in);
		status_NO_SHIFT_REG[15] <= started_NO_SHIFT_REG;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdata <= 64'h0;
	end
	else
	begin
		case (avs_cra_address)
			4'h0:
			begin
				avs_cra_readdata[31:0] <= status_NO_SHIFT_REG;
				avs_cra_readdata[63:32] <= 32'h0;
			end

			4'h1:
			begin
				avs_cra_readdata[31:0] <= 'x;
				avs_cra_readdata[63:32] <= 32'h0;
			end

			4'h2:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			4'h3:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			4'h4:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			4'h5:
			begin
				avs_cra_readdata[31:0] <= work_dim_NO_SHIFT_REG;
				avs_cra_readdata[63:32] <= workgroup_size_NO_SHIFT_REG;
			end

			4'h6:
			begin
				avs_cra_readdata[31:0] <= global_size_NO_SHIFT_REG[0];
				avs_cra_readdata[63:32] <= global_size_NO_SHIFT_REG[1];
			end

			4'h7:
			begin
				avs_cra_readdata[31:0] <= global_size_NO_SHIFT_REG[2];
				avs_cra_readdata[63:32] <= num_groups_NO_SHIFT_REG[0];
			end

			4'h8:
			begin
				avs_cra_readdata[31:0] <= num_groups_NO_SHIFT_REG[1];
				avs_cra_readdata[63:32] <= num_groups_NO_SHIFT_REG[2];
			end

			4'h9:
			begin
				avs_cra_readdata[31:0] <= local_size_NO_SHIFT_REG[0];
				avs_cra_readdata[63:32] <= local_size_NO_SHIFT_REG[1];
			end

			4'hA:
			begin
				avs_cra_readdata[31:0] <= local_size_NO_SHIFT_REG[2];
				avs_cra_readdata[63:32] <= global_offset_NO_SHIFT_REG[0];
			end

			4'hB:
			begin
				avs_cra_readdata[31:0] <= global_offset_NO_SHIFT_REG[1];
				avs_cra_readdata[63:32] <= global_offset_NO_SHIFT_REG[2];
			end

			4'hC:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[31:0];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[63:32];
			end

			4'hD:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[95:64];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[127:96];
			end

			4'hE:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[159:128];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[191:160];
			end

			default:
			begin
				avs_cra_readdata <= status_NO_SHIFT_REG;
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdatavalid <= 1'b0;
	end
	else
	begin
		avs_cra_readdatavalid <= (avs_cra_read & ~(avs_cra_waitrequest));
	end
end


// Handshaking signals used to control data through the pipeline

// Determine when the kernel is finished.
acl_kernel_finish_detector kernel_finish_detector (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.wg_size(workgroup_size_NO_SHIFT_REG),
	.wg_dispatch_valid_out(iter_valid_in),
	.wg_dispatch_stall_in(iter_stall_out),
	.dispatched_all_groups(dispatched_all_groups),
	.kernel_copy_valid_out(valid_out),
	.kernel_copy_stall_in(stall_in),
	.pending_writes(has_a_write_pending),
	.finish(finish)
);

defparam kernel_finish_detector.NUM_COPIES = 1;
defparam kernel_finish_detector.WG_SIZE_W = 32;

assign stall_in = 1'b0;

// Creating ID iterator and kernel instance for every requested kernel copy

// ID iterator is responsible for iterating over all local ids for given work-groups
acl_id_iterator id_iter_inst0 (
	.clock(clock),
	.resetn(resetn),
	.start(start_out),
	.valid_in(iter_valid_in),
	.stall_out(iter_stall_out),
	.stall_in(stall_out),
	.valid_out(valid_in),
	.group_id_in(group_id_tmp),
	.global_id_base_in(global_id_base_out),
	.local_size(local_size_NO_SHIFT_REG),
	.global_size(global_size_NO_SHIFT_REG),
	.local_id(local_id[0]),
	.global_id(global_id[0]),
	.group_id(group_id[0])
);



// This section instantiates a kernel function block
vectorAdd_function vectorAdd_function_inst0 (
	.clock(clock),
	.resetn(resetn),
	.input_global_id_0(global_id[0][0]),
	.stall_out(stall_out),
	.valid_in(valid_in),
	.valid_out(valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size_NO_SHIFT_REG),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__inst0_readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__inst0_readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__inst0_waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__inst0_address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__inst0_read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__inst0_write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__inst0_writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__inst0_writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__inst0_byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__inst0_burstcount),
	.avm_local_bb1_ld__u0_readdata(avm_local_bb1_ld__u0_inst0_readdata),
	.avm_local_bb1_ld__u0_readdatavalid(avm_local_bb1_ld__u0_inst0_readdatavalid),
	.avm_local_bb1_ld__u0_waitrequest(avm_local_bb1_ld__u0_inst0_waitrequest),
	.avm_local_bb1_ld__u0_address(avm_local_bb1_ld__u0_inst0_address),
	.avm_local_bb1_ld__u0_read(avm_local_bb1_ld__u0_inst0_read),
	.avm_local_bb1_ld__u0_write(avm_local_bb1_ld__u0_inst0_write),
	.avm_local_bb1_ld__u0_writeack(avm_local_bb1_ld__u0_inst0_writeack),
	.avm_local_bb1_ld__u0_writedata(avm_local_bb1_ld__u0_inst0_writedata),
	.avm_local_bb1_ld__u0_byteenable(avm_local_bb1_ld__u0_inst0_byteenable),
	.avm_local_bb1_ld__u0_burstcount(avm_local_bb1_ld__u0_inst0_burstcount),
	.avm_local_bb1_st_c0_exe1_readdata(avm_local_bb1_st_c0_exe1_inst0_readdata),
	.avm_local_bb1_st_c0_exe1_readdatavalid(avm_local_bb1_st_c0_exe1_inst0_readdatavalid),
	.avm_local_bb1_st_c0_exe1_waitrequest(avm_local_bb1_st_c0_exe1_inst0_waitrequest),
	.avm_local_bb1_st_c0_exe1_address(avm_local_bb1_st_c0_exe1_inst0_address),
	.avm_local_bb1_st_c0_exe1_read(avm_local_bb1_st_c0_exe1_inst0_read),
	.avm_local_bb1_st_c0_exe1_write(avm_local_bb1_st_c0_exe1_inst0_write),
	.avm_local_bb1_st_c0_exe1_writeack(avm_local_bb1_st_c0_exe1_inst0_writeack),
	.avm_local_bb1_st_c0_exe1_writedata(avm_local_bb1_st_c0_exe1_inst0_writedata),
	.avm_local_bb1_st_c0_exe1_byteenable(avm_local_bb1_st_c0_exe1_inst0_byteenable),
	.avm_local_bb1_st_c0_exe1_burstcount(avm_local_bb1_st_c0_exe1_inst0_burstcount),
	.start(start_out),
	.clock2x(clock2x),
	.input_x(kernel_arguments_NO_SHIFT_REG[63:0]),
	.input_y(kernel_arguments_NO_SHIFT_REG[127:64]),
	.input_z(kernel_arguments_NO_SHIFT_REG[191:128]),
	.input_global_size_0(global_size_NO_SHIFT_REG[0]),
	.has_a_write_pending(has_a_write_pending),
	.has_a_lsu_active(has_a_lsu_active)
);



endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module vectorAdd_sys_cycle_time
	(
		input 		clock,
		input 		resetn,
		output [31:0] 		cur_cycle
	);


 reg [31:0] cur_count_NO_SHIFT_REG;

assign cur_cycle = cur_count_NO_SHIFT_REG;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		cur_count_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		cur_count_NO_SHIFT_REG <= (cur_count_NO_SHIFT_REG + 32'h1);
	end
end

endmodule

