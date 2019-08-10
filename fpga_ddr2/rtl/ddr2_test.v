
//****************************************************************
// -DDR2 test module 
//****************************************************************


module ddr2_test (
	input 				clk,
	input 				rst_n,
   
	output reg        wr_en,            //SDRAM 写使能
	output reg [31:0] wr_data,          //SDRAM 写入的数据
	output reg        rd_en,            //SDRAM 读使能
	input      [31:0] rd_data,          //SDRAM 读出的数据
 
	input             ddr2_init_done,  //SDRAM 初始化完成标志
	output reg        error_flag        //SDRAM 读写测试错误标志

	);


reg        init_done_d0;                //寄存SDRAM初始化完成信号
reg        init_done_d1;                //寄存SDRAM初始化完成信号
reg [10:0] wr_cnt;                      //写操作计数器
reg [10:0] rd_cnt;                      //读操作计数器
reg        rd_valid;                    //读数据有效标志

	
//*****************************************************
//**                    main code
//***************************************************** 


reg [10:0] delay_cnt;

//同步ddr2初始化完成信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        init_done_d0 <= 1'b0;
        init_done_d1 <= 1'b0;
    end
    else begin
        init_done_d0 <= ddr2_init_done;
        init_done_d1 <= init_done_d0;
    end
end   	


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		delay_cnt <= 11'd0;
    end
    else begin
		if (init_done_d1) begin	
			if (delay_cnt < 11'd1024)
				delay_cnt <= delay_cnt +1'b1;
		end
		else 
			delay_cnt <= delay_cnt;
    end
end  


//ddr2初始化完成之后,写操作计数器开始计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        wr_cnt <= 11'd0;  
    else if((delay_cnt == 11'd1024) && (wr_cnt <= 11'd1024))
        wr_cnt <= wr_cnt + 1'b1;
    else
        wr_cnt <= wr_cnt;
end    

//ddr2写端口FIFO的写使能、写数据(1~1024)
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin      
        wr_en   <= 1'b0;
        wr_data <= 32'd0;
    end
    else if(wr_cnt >= 11'd1 && (wr_cnt <= 11'd1024)) begin
            wr_en   <= 1'b1;            //写使能拉高
            wr_data <= wr_cnt;          //写入数据1~1024
        end    
    else begin
            wr_en   <= 1'b0;
            wr_data <= 32'd0;
        end                
end        

//写入数据完成后,开始读操作    
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rd_en <= 1'b0;
    else if(wr_cnt > 11'd1024 )         //写数据完成
        rd_en <= 1'b1;                  //读使能拉高
end

//对读操作计数     
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rd_cnt <= 11'd0;
    else if(rd_en) begin
        if(rd_cnt < 11'd1024) begin
  				if (rd_cnt == 11'd64 && rd_valid == 1'b0)
					rd_cnt <= 11'd1;
			   else 
					rd_cnt <= rd_cnt + 1'b1;							
		  end
        else
            rd_cnt <= 11'd1;
    end
end

//第一次读取的数据无效,后续读操作所读取的数据才有效
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        rd_valid <= 1'b0;
    else if(rd_cnt == 11'd64)         //等待第一次读操作结束
        rd_valid <= 1'b1;               //后续读取的数据有效
    else
        rd_valid <= rd_valid;
end            

//读数据有效时,若读取数据错误,给出标志信号
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        error_flag <= 1'b0; 
    else if(rd_valid && (rd_data != rd_cnt))
        error_flag <= 1'b1;             //若读取的数据错误,将错误标志位拉高 
    else
        error_flag <= error_flag;
end

	
	
endmodule	
