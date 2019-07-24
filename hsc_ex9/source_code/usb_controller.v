/////////////////////////////////////////////////////////////////////////////
//Altera ATPP������� ��о�Ƽ� Я�� ��Ȩͬѧ ��ͬ���� FPGA������ϵ��
//����Ӳ��ƽ̨�� Altera Cyclone IV FPGA 
//�����׼��ͺţ� SF-HSC (USB3.0) ��Ȩ����
//��   Ȩ  ��   ���� �������ɡ�����ǳ����תFPGA�����ߡ���Ȩͬѧ��ԭ����
//				����SF-HSC�����׼�ѧϰʹ�ã�лл֧��
//�ٷ��Ա����̣� http://myfpga.taobao.com/
//�����������أ� http://pan.baidu.com/s/1pLmZaFx
//��                ˾�� �Ϻ�������ӿƼ����޹�˾
/////////////////////////////////////////////////////////////////////////////
module usb_controller(
				input clk,		//100MHz
				input rst_n,	
					//FX3 Slave FIFO�ӿ�
				input fx3_flaga,
				input fx3_flagb,	
				input fx3_flagc,	//ctl[9]
				input fx3_flagd,	//ctl[8]
				//output fx3_pclk,		//Slave FIFOͬ��ʱ���ź�
				output reg fx3_slcs_n,		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
				output reg fx3_slwr_n,		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
				output reg fx3_slrd_n,		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
				output reg fx3_sloe_n,		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
				output reg fx3_pktend_n,	//�������ź�
				output reg[1:0] fx3_a,			//����FIFO��ַ
				inout[31:0] fx3_db		//����
			);



/////////////////////////////////////////////////////////////
//FX3 FIFOͬ��ʱ�Ӳ���
//assign fx3_pclk = clk;

/////////////////////////////////////////////////////////////
//�Ĵ����Ͳ�������

reg[9:0] num;		//���ݼĴ���
reg[3:0] delaycnt;	//������
reg[3:0] fxstate;	//״̬�Ĵ���
parameter	FXS_REST	= 4'd0;
parameter	FXS_IDLE	= 4'd1;
parameter	FXS_READ	= 4'd2;
parameter	FXS_RDLY	= 4'd3;
parameter	FXS_RSOP	= 4'd4;
parameter	FXS_WRIT	= 4'd5;
parameter	FXS_WSOP	= 4'd6;

wire[9:0] fifo_used;	//FIFO�Ѿ�ʹ�����ݸ���
reg fifo_rdreq;			//FIFO�������źţ��ߵ�ƽ��Ч

/////////////////////////////////////////////////////////////
reg fx3_dir;	//FX3��д����ָʾ�źţ�1--read, 0--write

always @(posedge clk or negedge rst_n)
	if(!rst_n) fx3_dir <= 1'b1;		//read
	else if(fxstate == FXS_RSOP) fx3_dir <= 1'b0;		//write
	else if(fxstate == FXS_WSOP) fx3_dir <= 1'b1;		//read

/////////////////////////////////////////////////////////////
//��ʱ��ȡFX3 FIFO���ݲ�����FIFO��

	//��ʱ��д����״̬��
always @(posedge clk or negedge rst_n)
	if(!rst_n) fxstate <= FXS_REST;
	else begin
		case(fxstate)
			FXS_REST: begin
				fxstate <= FXS_IDLE;
			end
			FXS_IDLE: begin
				if(fx3_dir && fx3_flaga) fxstate <= FXS_READ;	//�����ݣ���ȡ���ݸ���������8-1024
				else if(!fx3_dir && fx3_flaga) fxstate <= FXS_WRIT;	//д����
				else fxstate <= FXS_IDLE;
			end	
			FXS_READ: begin
				if(!fx3_flagb) fxstate <= FXS_RDLY;
				else fxstate <= FXS_READ;
			end	 
			FXS_RDLY: begin	//��ȡflagd���ͺ��6������ 
				if(delaycnt >= 4'd6) fxstate <= FXS_RSOP;
				else fxstate <= FXS_RDLY;				
			end
			FXS_RSOP: fxstate <= FXS_IDLE;
			FXS_WRIT: begin	
				if(fifo_used == 10'd0) fxstate <= FXS_WSOP;
				else fxstate <= FXS_WRIT;
			end	
			FXS_WSOP: begin
				if(delaycnt >= 4'd4) fxstate <= FXS_IDLE;
				else fxstate <= FXS_WSOP;
			end
			default: fxstate <= FXS_IDLE;
		endcase
	end

	//���ݼ����������ڲ�����дʱ��
always @(posedge clk or negedge rst_n)
	if(!rst_n) num <= 10'd0;
	else if(fxstate == FXS_READ) num <= num+1'b1;	//Slave FIFO������
	else if(fxstate == FXS_WRIT) num <= num+1'b1;	//Slave FIFOд����
	else num <= 10'd0;
	
	//6��clock����ʱ������
always @(posedge clk or negedge rst_n)
	if(!rst_n) delaycnt <= 4'd0;
	else if(fxstate == FXS_RDLY) delaycnt <= delaycnt+1'b1;
	else if(fxstate == FXS_WSOP) delaycnt <= delaycnt+1'b1;
	else delaycnt <= 4'd0;
	
/////////////////////////////////////////////////////////////
//FX3 Slave FIFO�����ź�ʱ�����
parameter FX3_ON	= 1'b0;
parameter FX3_OFF	= 1'b1;
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) begin
		fx3_slcs_n <= FX3_OFF;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
		fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
		fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
		fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
		fx3_pktend_n <= FX3_OFF;	//�������ź�
		fx3_a <= 2'b11;			//����FIFO��ַ
	end
	else if(fxstate == FXS_IDLE) begin
		fx3_slcs_n <= FX3_OFF;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
		fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
		fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
		fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
		fx3_pktend_n <= FX3_OFF;	//�������ź�
		if(fx3_dir) fx3_a <= 2'b11;	//������
		else fx3_a <= 2'b00;	//д����	
	end
	else if(fxstate == FXS_READ) begin	//cs = 0; addr = 2'b11;rd = 0; oe=0
		fx3_slcs_n <= FX3_ON;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
		fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
		fx3_slrd_n <= FX3_ON;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
		fx3_sloe_n <= FX3_ON;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
		fx3_pktend_n <= FX3_OFF;	//�������ź�
		fx3_a <= 2'b11;			//FIFO����ַ			
	end
	else if(fxstate == FXS_RDLY) begin
		if(delaycnt == 4'd2) begin	//rd = 1;
			fx3_slcs_n <= FX3_ON;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
			fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
			fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
			fx3_sloe_n <= FX3_ON;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
			fx3_pktend_n <= FX3_OFF;	//�������ź�
			fx3_a <= 2'b11;			//FIFO����ַ			
		end
		else if(delaycnt == 4'd6) begin
			fx3_slcs_n <= FX3_OFF;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
			fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
			fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
			fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
			fx3_pktend_n <= FX3_OFF;	//�������ź�
			fx3_a <= 2'b11;			//����FIFO��ַ
		end 
	end	
	else if(fxstate == FXS_WRIT) begin
		if(num == 10'd1) begin	//cs = 0; addr = 2'b00;wr = 0;
			fx3_slcs_n <= FX3_ON;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
			fx3_slwr_n <= FX3_ON;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
			fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
			fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
			fx3_pktend_n <= FX3_OFF;	//�������ź�
			fx3_a <= 2'b00;			//FIFO����ַ			
		end
		else if(fifo_used == 10'd1) begin	//fx3_pktend_n =0
			fx3_slcs_n <= FX3_ON;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
			fx3_slwr_n <= FX3_ON;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
			fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
			fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
			fx3_pktend_n <= FX3_ON;		//�������ź�
			fx3_a <= 2'b00;			//FIFO����ַ		
		end		
		else if(fifo_used == 10'd0) begin	//cs = 0; addr = 2'b00;
			fx3_slcs_n <= FX3_OFF;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
			fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
			fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
			fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
			fx3_pktend_n <= FX3_OFF;		//�������ź�
			fx3_a <= 2'b00;			//FIFO����ַ		
		end	
	end
	else if(fxstate == FXS_WSOP) begin
		fx3_slcs_n <= FX3_OFF;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
		fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
		fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
		fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
		fx3_pktend_n <= FX3_OFF;	//�������ź�
		fx3_a <= 2'b11;			//����FIFO��ַ	
	end
	else begin
		fx3_slcs_n <= FX3_OFF;		//Slave FIFOƬѡ�źţ��͵�ƽ��Ч
		fx3_slwr_n <= FX3_OFF;		//Slave FIFOдʹ���źţ��͵�ƽ��Ч
		fx3_slrd_n <= FX3_OFF;		//Slave FIFO��ʹ���źţ��͵�ƽ��Ч
		fx3_sloe_n <= FX3_OFF;		//Slave FIFO���ʹ���źţ��͵�ƽ��Ч
		fx3_pktend_n <= FX3_OFF;	//�������ź�
	end 

/////////////////////////////////////////////////////////////
//Slave FIFO���������ݻ���
reg[31:0] fx3_rdb;	//FX3�������ݻ���
reg fx3_rdb_en;		//FX3����������Ч��־λ���ߵ�ƽ��Ч
wire[31:0] fx3_wdb;	//FX3д���ݼĴ���
	
always @(posedge clk or negedge rst_n)
	if(!rst_n) begin
		fx3_rdb <= 16'd0;
		fx3_rdb_en <= 1'b0;
	end
	else if((fxstate == FXS_READ) && (num >= 10'd4)) begin
		fx3_rdb <= fx3_db;
		fx3_rdb_en <= 1'b1;
	end
	else if((fxstate == FXS_RDLY) && (delaycnt < 4'd5)) begin
		fx3_rdb <= fx3_db;
		fx3_rdb_en <= 1'b1;	
	end
	else begin
		fx3_rdb <= 16'd0;
		fx3_rdb_en <= 1'b0;
	end

assign fx3_db = fx3_dir ? 32'hzzzzzzzz:fx3_wdb;	//FX3�������߷������	
	
///////////////////////////////////////////////////////////// 	
//FIFO����FX3���������ݣ������д��FX3��

always @(posedge clk or negedge rst_n)
	if(!rst_n) fifo_rdreq <= 1'b0;
	else if((fxstate == FXS_WRIT) && (fifo_used > 10'd1)) fifo_rdreq <= 1'b1;
	else fifo_rdreq <= 1'b0;
	
	//FIFO����
loopback_fifo	loopback_fifo_inst (
					.aclr ( !rst_n ),
					.clock ( clk ),
					.data ( fx3_rdb ),
					.rdreq ( fifo_rdreq ),
					.wrreq ( fx3_rdb_en ),
					.q ( fx3_wdb ),
					.usedw ( fifo_used )
				);
	
//A0A1A2A3BBBBBBBBCCCCCCCCDDDDDDDDEEEEEEEEFFFFFFFF000000001111111122222222333333334444444455555555	
	

endmodule

