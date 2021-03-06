/*-------DSP module----------
				NCO
				|
input->ADC->Mixer->CIC->FIR->output

*/

module mDSP
(
	input  clk,			//sample rate of ADC,NCO,Mixer,CIC
	input  clk_fir,	//the sample rate of fir is 20Mhz/200=100Khz
	input  rst_n,
	input  [9:0]  adc_data,
	input  [31:0] phi_inc_i,
	
	output signed [31:0] i_out,		//baseband i-q data
	output signed [31:0] q_out
);



wire signed [9:0]	fsin_o;		//nco sin output
wire signed [9:0]	fcos_o;		//nco cos output

wire clken;
assign clken=1'b1;

mnco u_mnco
(
	.clk		(clk),
	.reset_n (rst_n),
	.clken	(clken),
	.phi_inc_i (phi_inc_i),
	
	.fsin_o	(fsin_o),
	.fcos_o  (fcos_o)
	
);

wire signed [19:0] i_o_mixer;
wire signed [19:0] q_o_mixer;
multiply u_multiply
(
	.clk		(clk),
	.adc_data(adc_data),
	.fsin		(fsin_o),
	.fcos		(fcos_o),
	.i_o_mixer(i_o_mixer),
	.q_o_mixer(q_o_mixer)

);

wire signed [15:0]	i_o_cic;	//cic of i channel output
wire signed [15:0]	q_o_cic;	//cic of q channel output

wire in_valid;
wire out_ready;
wire [1:0] in_error;
assign in_valid=1'b1;
assign out_ready=1'b1;
assign in_error=2'd0;


mcic u_i_mcic
(
	.clk		(clk),
	.clken	(clken),
	.reset_n	(rst_n),
	.in_data (i_o_mixer),
	.in_valid(in_valid),
	.out_ready(out_ready),
	.in_error(in_error),
	.out_data (i_o_cic)
	
);

mcic u_q_mcic
(
	.clk		(clk),
	.clken	(clken),
	.reset_n	(rst_n),
	.in_data (q_o_mixer),
	.in_valid(in_valid),
	.out_ready(out_ready),
	.in_error(in_error),
	.out_data (q_o_cic)
	
);

wire ast_sink_valid;
wire [1:0] ast_sink_error;
assign ast_sink_valid=1;
assign ast_sink_error=2'd0;

mfir u_i_mfir
(
	.clk		(clk_fir),
	.reset_n (rst_n),
	.ast_sink_data(i_o_cic),
	.ast_sink_valid(ast_sink_valid),
	.ast_sink_error(ast_sink_error),
	.ast_source_data(i_out)
);

mfir u_q_mfir
(
	.clk(clk_fir),
	.reset_n(rst_n),
	.ast_sink_data(q_o_cic),
	.ast_sink_valid(ast_sink_valid),
	.ast_sink_error(ast_sink_error),
	.ast_source_data(q_out)
);





endmodule
