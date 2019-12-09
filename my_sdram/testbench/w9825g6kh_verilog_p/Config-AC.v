/***********************************************************************************************
|*Disclaimer :
|This model software code and all related notes or documentation (collectively "Software") is 
|provided "AS IS" without warranty of any kind. You bear the risk of using it. 
|Winbond Electronics Corp.("WINBOND") hereunder DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, 
|INCLUDING BUT NOT LIMITED TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
|OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. WINBOND DOES NOT WARRANT THAT THE 
|OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. FURTHERMORE, WINBOND DOES NOT MAKE 
|ANY WARRANTIES REGARDING THE USE OR THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS 
|CORRECTNESS, ACCURACY, RELIABILITY, OR OTHERWISE. IN NO EVENT SHALL WINBOND, ITS SUBSIDIARY 
|COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL, 
|OR SPECIAL DAMAGES (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, 
|BUSINESS INTERRUPTION, OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE THE
|SOFTWARE, EVEN IF WINBOND HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
| 
|*Copyright :
|Copyright C 2012 Winbond Electronics Corp. All rights reserved.би
***********************************************************************************************/


parameter  addr_bits =         13		;	     // Address Input
parameter  data_bits =         16		;     	// DQ I/Os
parameter  col_bits  =            9	;		      
parameter  mem_sizes =      4194304	;	      




`ifdef T5CL2
// Timing Parameters 
parameter   tCK 		= 7.5	  	;	// Clock Cycle Time
parameter   tRC 		= 55			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	= 40			;// Active to Precharge Command Period
parameter   tRCD	= 15			;// Active to Read/Write Command Delay Time
parameter   tCCD	= tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		= 15			;// Precharge to Active Command Period
parameter   tRRD	= 2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	= 2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2	  		;// Clock High-Level Width
parameter   tCL 		= 2	  		;// Clock Low-Level Width
parameter   tAC 		= 6			;// Access Time from CLK
parameter   tOH 	    = 3			;// Output Data Hold Time
parameter   tHZ    	    =    6		;	// Output Data High Impedance Time Max
parameter   tLZ 		= 0			;// Output Data Low Impedance Time
parameter   tSB_min	= 0			;// Power Down Mode Entry Time Min
parameter   tSB_max	= 5			;// Power Down Mode Entry Time Max
parameter   tDS 		= 1.5	  ;		// Data-in Setup Time
parameter   tDH 	= 1.0  	;	// Data-in Hold Time
parameter   tAS 		= 1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		= 10	  ;		// Addr, Bs Hold Time
parameter   tCKS	= 1.5	  ;		// CKE Setup Time
parameter   tCKH	= 1.0	  ;		// CKE Hold  Time
parameter   tCMS	= 1.5	  ;		// Command Setup Time
parameter   tCMH	= 1.0		;	// Command Hold  Time
parameter   tREF	= 64000000;	// Refresh Time
parameter   tRSC  	= 2;		// 2 
parameter   tWRa	= tWR	  ;	// Auto precharge mode
parameter   tWRm	= tWR	  ;	// Manual precharge mode
parameter   tXSR	= 70		  ;	// Exit self refresh to ACTIVE command
parameter   CL    	= 2			;// CAS Latency
`endif

`ifdef T5CL3
// Timing Parameters 
parameter   tCK 		=5.0	  ;		// Clock Cycle Time
parameter   tRC 		= 55			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	= 40			;// Active to Precharge Command Period
parameter   tRCD	= 15			;// Active to Read/Write Command Delay Time
parameter   tCCD	= tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		= 15			;// Precharge to Active Command Period
parameter   tRRD	= 2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	= 2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2	  		;// Clock High-Level Width
parameter   tCL 		= 2	  		;// Clock Low-Level Width
parameter   tAC 		= 4.5			;// Access Time from CLK
parameter   tOH 	    = 3			;// Output Data Hold Time
parameter   tHZ    	    =    4.5		;	// Output Data High Impedance Time Max
parameter   tLZ 		= 0			;// Output Data Low Impedance Time
parameter   tSB_min	= 0			;// Power Down Mode Entry Time Min
parameter   tSB_max	= 5			;// Power Down Mode Entry Time Max
parameter   tDS 		= 1.5	  ;		// Data-in Setup Time
parameter   tDH 	= 1.0  	;	// Data-in Hold Time
parameter   tAS 		= 1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		= 10	  ;		// Addr, Bs Hold Time
parameter   tCKS	= 1.5	  ;		// CKE Setup Time
parameter   tCKH	= 1.0	  ;		// CKE Hold  Time
parameter   tCMS	= 1.5	  ;		// Command Setup Time
parameter   tCMH	= 1.0		;	// Command Hold  Time
parameter   tREF	= 64000000;	// Refresh Time
parameter   tRSC  	= 2;		// 2 
parameter   tWRa	= tWR	  ;	// Auto precharge mode
parameter   tWRm	= tWR	  ;	// Manual precharge mode
parameter   tXSR	= 70		  ;	// Exit self refresh to ACTIVE command
parameter   CL   = 	3		;	// CAS Latency
`endif



`ifdef T6CL2
// Timing Parameters 
parameter   tCK 		= 7.5	  	;	// Clock Cycle Time
parameter   tRC 		= 60			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	= 42			;// Active to Precharge Command Period
parameter   tRCD	= 15			;// Active to Read/Write Command Delay Time
parameter   tCCD	= tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		= 15			;// Precharge to Active Command Period
parameter   tRRD	= 2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	= 2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2	  		;// Clock High-Level Width
parameter   tCL 		= 2	  		;// Clock Low-Level Width
parameter   tAC 		= 6			;// Access Time from CLK
parameter   tOH 	= 3			;// Output Data Hold Time
parameter   tHZ    	= 6		;	// Output Data High Impedance Time Max
parameter   tLZ 		= 0			;// Output Data Low Impedance Time
parameter   tSB_min	= 0			;// Power Down Mode Entry Time Min
parameter   tSB_max	= 6			;// Power Down Mode Entry Time Max
parameter   tDS 		= 1.5	  ;		// Data-in Setup Time
parameter   tDH 	= 0.8  	;	// Data-in Hold Time
parameter   tAS 		= 1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		= 0.8	  ;		// Addr, Bs Hold Time
parameter   tCKS	= 1.5	  ;		// CKE Setup Time
parameter   tCKH	= 0.8	  ;		// CKE Hold  Time
parameter   tCMS	= 1.5	  ;		// Command Setup Time
parameter   tCMH	= 0.8		;	// Command Hold  Time
parameter   tREF	= 64000000;	// Refresh Time
parameter   tRSC  	= 2	;		// 2
parameter   tWRa	= tWR	  ;	// Auto precharge mode
parameter   tWRm	= tWR	  ;	// Manual precharge mode
parameter   tXSR	= 72		  ;	// Exit self refresh to ACTIVE command
parameter   CL    	= 2			;// CAS Latency
`endif

`ifdef T6CL3
// Timing Parameters 
parameter   tCK 		=6.0	  ;		// Clock Cycle Time
parameter   tRC 		= 60			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	= 42			;// Active to Precharge Command Period
parameter   tRCD	= 15			;// Active to Read/Write Command Delay Time
parameter   tCCD	= tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		= 15			;// Precharge to Active Command Period
parameter   tRRD	= 2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	= 2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2	  		;// Clock High-Level Width
parameter   tCL 		= 2	  		;// Clock Low-Level Width
parameter   tAC 		= 5			;// Access Time from CLK
parameter   tOH 	= 3			;// Output Data Hold Time
parameter   tHZ    	= 5		;	// Output Data High Impedance Time Max
parameter   tLZ 		= 0			;// Output Data Low Impedance Time
parameter   tSB_min	= 0			;// Power Down Mode Entry Time Min
parameter   tSB_max	= 6			;// Power Down Mode Entry Time Max
parameter   tDS 		= 1.5	  ;		// Data-in Setup Time
parameter   tDH 	= 0.8  	;	// Data-in Hold Time
parameter   tAS 		= 1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		= 0.8	  ;		// Addr, Bs Hold Time
parameter   tCKS	= 1.5	  ;		// CKE Setup Time
parameter   tCKH	= 0.8	  ;		// CKE Hold  Time
parameter   tCMS	= 1.5	  ;		// Command Setup Time
parameter   tCMH	= 0.8		;	// Command Hold  Time
parameter   tREF	= 64000000;	// Refresh Time
parameter   tRSC  	= 2	;		// 2
parameter   tWRa	= tWR	  ;	// Auto precharge mode
parameter   tWRm	= tWR	  ;	// Manual precharge mode
parameter   tXSR	= 72		  ;	// Exit self refresh to ACTIVE command
parameter   CL   = 	3		;	// CAS Latency
`endif



`ifdef T6ICL2
// Timing Parameters 
parameter   tCK 		= 7.5	  	;	// Clock Cycle Time
parameter   tRC 		= 60			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	= 42			;// Active to Precharge Command Period
parameter   tRCD	= 18			;// Active to Read/Write Command Delay Time
parameter   tCCD	= tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		= 18			;// Precharge to Active Command Period
parameter   tRRD	= 2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	= 2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2	  		;// Clock High-Level Width
parameter   tCL 		= 2	  		;// Clock Low-Level Width
parameter   tAC 		= 6			;// Access Time from CLK
parameter   tOH 	= 3			;// Output Data Hold Time
parameter   tHZ    	= 6		;	// Output Data High Impedance Time Max
parameter   tLZ 		= 0			;// Output Data Low Impedance Time
parameter   tSB_min	= 0			;// Power Down Mode Entry Time Min
parameter   tSB_max	= 7			;// Power Down Mode Entry Time Max
parameter   tDS 		= 1.5	  ;		// Data-in Setup Time
parameter   tDH 	= 0.8  	;	// Data-in Hold Time
parameter   tAS 		= 1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		= 0.8	  ;		// Addr, Bs Hold Time
parameter   tCKS	= 1.5	  ;		// CKE Setup Time
parameter   tCKH	= 0.8	  ;		// CKE Hold  Time
parameter   tCMS	= 1.5	  ;		// Command Setup Time
parameter   tCMH	= 0.8		;	// Command Hold  Time
parameter   tREF	= 64000000;	// Refresh Time
parameter   tRSC  	= 2	;		// 2 
parameter   tWRa	= tWR	  ;	// Auto precharge mode
parameter   tWRm	= tWR	  ;	// Manual precharge mode
parameter   tXSR	= 72		  ;	// Exit self refresh to ACTIVE command
parameter   CL    	= 2			;// CAS Latency
`endif

`ifdef T6ICL3
// Timing Parameters 
parameter   tCK 		=6.0	  ;		// Clock Cycle Time
parameter   tRC 		= 60			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	= 42			;// Active to Precharge Command Period
parameter   tRCD	= 18			;// Active to Read/Write Command Delay Time
parameter   tCCD	= tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		= 18			;// Precharge to Active Command Period
parameter   tRRD	= 2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	= 2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2	  		;// Clock High-Level Width
parameter   tCL 		= 2	  		;// Clock Low-Level Width
parameter   tAC 		= 5			;// Access Time from CLK
parameter   tOH 	= 3			;// Output Data Hold Time
parameter   tHZ    	= 5		;	// Output Data High Impedance Time Max
parameter   tLZ 		= 0			;// Output Data Low Impedance Time
parameter   tSB_min	= 0			;// Power Down Mode Entry Time Min
parameter   tSB_max	= 7			;// Power Down Mode Entry Time Max
parameter   tDS 		= 1.5	  ;		// Data-in Setup Time
parameter   tDH 	= 0.8  	;	// Data-in Hold Time
parameter   tAS 		= 1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		= 0.8	  ;		// Addr, Bs Hold Time
parameter   tCKS	= 1.5	  ;		// CKE Setup Time
parameter   tCKH	= 0.8	  ;		// CKE Hold  Time
parameter   tCMS	= 1.5	  ;		// Command Setup Time
parameter   tCMH	= 0.8		;	// Command Hold  Time
parameter   tREF	= 64000000;	// Refresh Time
parameter   tRSC  	= 2	;		// 2 
parameter   tWRa	= tWR	  ;	// Auto precharge mode
parameter   tWRm	= tWR	  ;	// Manual precharge mode
parameter   tXSR	= 72		  ;	// Exit self refresh to ACTIVE command
parameter   CL   = 	3		;	// CAS Latency
`endif


`ifdef T75CL2
// Timing Parameters
parameter   tCK 		=10	  	;	// Clock Cycle Time
parameter   tRC 		=65			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	=45			;// Active to Precharge Command Period
parameter   tRCD	=20			;// Active to Read/Write Command Delay Time
parameter   tCCD	=tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		=20			;// Precharge to Active Command Period
parameter   tRRD	=2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	=2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2.5	  	;	// Clock High-Level Width
parameter   tCL 		= 2.5	  	;	// Clock Low-Level Width
parameter   tAC 		 = 6		;	// Access Time from CLK
parameter   tOH 	=3			;// Output Data Hold Time
parameter   tHZ    	=6			;// Output Data High Impedance Time Max
parameter   tLZ 		=0			;// Output Data Low Impedance Time
parameter   tSB_min	=0			;// Power Down Mode Entry Time Min
parameter   tSB_max	=7.5			;// Power Down Mode Entry Time Max
parameter   tDS 		=1.5	  ;		// Data-in Setup Time
parameter   tDH 	=1.0  	;	// Data-in Hold Time
parameter   tAS 		=1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		=1.0	  ;		// Addr, Bs Hold Time
parameter   tCKS	=1.5	  ;		// CKE Setup Time
parameter   tCKH	=1.0	  ;		// CKE Hold  Time
parameter   tCMS	=1.5	  ;		// Command Setup Time
parameter   tCMH	=1.0		;	// Command Hold  Time
parameter   tREF	=64000000	;// Refresh Time
parameter   tRSC  	=2		;	// 2
parameter   tWRa	=tWR	  	;// Auto precharge mode
parameter   tWRm	=tWR	  	;// Manual precharge mode
parameter   tXSR	=75		  	;// Exit self refresh to ACTIVE command
parameter   CL    	=2			;// CAS Latency
`endif

`ifdef T75CL3
// Timing Parameters 
parameter   tCK 		=7.5	  	;	// Clock Cycle Time
parameter   tRC 		=65			;// Ref/Act to Ref/Act Command Period
parameter   tRAS	=45			;// Active to Precharge Command Period
parameter   tRCD	=20			;// Active to Read/Write Command Delay Time
parameter   tCCD	=tCK		;// Read/Write to Read/Write ( With different Bank) Command Period
parameter   tRP 		=20			;// Precharge to Active Command Period
parameter   tRRD	=2*tCK			;// Active to Active ( With different Bank) 
parameter   tWR 	=2*tCK	;	// Write Recovery Time
parameter   tCH 	= 2.5	  	;	// Clock High-Level Width
parameter   tCL 		= 2.5	  	;	// Clock Low-Level Width
parameter   tAC 		 = 5.4		;	// Access Time from CLK
parameter   tOH 	=3			;// Output Data Hold Time
parameter   tHZ    	=5.4			;// Output Data High Impedance Time Max
parameter   tLZ 		=0			;// Output Data Low Impedance Time
parameter   tSB_min	=0			;// Power Down Mode Entry Time Min
parameter   tSB_max	=7.5			;// Power Down Mode Entry Time Max
parameter   tDS 		=1.5	  ;		// Data-in Setup Time
parameter   tDH 	=1.0  	;	// Data-in Hold Time
parameter   tAS 		=1.5	  ;		// Addr, Bs Setup Time
parameter   tAH 		=1.0	  ;		// Addr, Bs Hold Time
parameter   tCKS	=1.5	  ;		// CKE Setup Time
parameter   tCKH	=1.0	  ;		// CKE Hold  Time
parameter   tCMS	=1.5	  ;		// Command Setup Time
parameter   tCMH	=1.0		;	// Command Hold  Time
parameter   tREF	=64000000	;// Refresh Time
parameter   tRSC  	=2		;	// 2
parameter   tWRa	=tWR	  	;// Auto precharge mode
parameter   tWRm	=tWR	  	;// Manual precharge mode
parameter   tXSR	=75		  	;// Exit self refresh to ACTIVE command
parameter   CL    	=3			;// CAS Latency
`endif






// cmds Operation
parameter   ACT  	=0;
parameter   NOP  	=1;
parameter   READ 	=2;
parameter   WRITE	=3;
parameter   PRECH	=4;
parameter   A_REF	=5;
parameter   BST  	=6;
parameter   MRS  	=7;

parameter BLE1    =3'b000; 
parameter BLE2    =3'b001;
parameter BLE4    =3'b010;
parameter BLE8    =3'b011;
parameter FULL_P  =3'b111;
 
parameter SEQUEN  =0<<3; 
parameter INTERLE =1<<3; 

parameter BRBW =  0<<9; 
parameter BRSW =  1<<9; 



// for Debug message
parameter Debug =  1;