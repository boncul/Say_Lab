module tamtopla (SW, KEY, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0); //module altinda tanimlamalar, atamalar
                                                                           //yapilir.
  input [17:0] SW; 						   //18 bit giris switch'i tanimlaniyor.
	input [3:0] KEY; 						   //4 bit giris KEY'i tanimlaniyor,
                                                                           //(Karttaki KEY butonu)
	output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0; 	   //6 bit çunku display'ler tanimlaniyor.
 
	wire [7:0] wireS, C; 						   //8 bit S'i ve C'yi wire ile
                                                                           //(birbirine bagli) tanimliyor.
 
	reg [7:0] A, B;
	wire [3:0] S0, S1, S2; 						   //4 bit S0, S1, S2'yi wire ile
                                                                           //(birbirine bagli) tanimliyor.
	reg [7:0] giris1, giris2; 					   //8 bit giris1 ve giris2
                                                                           //(yani girisler) tanimlaniyor.
	reg [3:0] bcd1_1, bcd1_10, bcd2_1, bcd2_10; 			   //4 bit olarak display'de görülecek
                                                                           //sekilde BCD olarak girisler tanimlaniyor
									   //(bcd1_1 giris1'in birler basamagi,
									   //bcd1_10 onlar basamagi vb.)
	reg overflow;
 
	always @(giris1) begin 						   //always ile decimal alinacak girisler
                                                                           //BCD yapiliyor, birler ve onlar
		if (giris1 < 10) begin 					   //basamaklarina ayriliyor,
			bcd1_10 = 4'h0; 				   //her bir if yapisi ile 10'ar 10'ar
                                                                           //kontrol yapiliyor, çünkü her 10
			bcd1_1 = giris1; 				   //artista bir düzeltme yapildgindan,
		end 							   //bu ayrim yaplmistir.
		else if (giris1 < 20) begin
			bcd1_10 = 4'h1;
			bcd1_1 = giris1 - 7'd10;
		end
		else if (giris1 < 30) begin
			bcd1_10 = 4'h2;
			bcd1_1 = giris1 - 7'd20;
		end
		else if (giris1 < 40) begin
			bcd1_10 = 4'h3;
			bcd1_1 = giris1 - 7'd30;
		end
		else if (giris1 < 50) begin
			bcd1_10 = 4'h4;
			bcd1_1 = giris1 - 7'd40;
		end
		else if (giris1 < 60) begin
			bcd1_10 = 4'h5;
			bcd1_1 = giris1 - 7'd50;
		end
		else if (giris1 < 70) begin
			bcd1_10 = 4'h6;
			bcd1_1 = giris1 - 7'd60;
		end
		else if (giris1 < 80) begin
			bcd1_10 = 4'h7;
			bcd1_1 = giris1 - 7'd70;
		end
		else if (giris1 < 90) begin
			bcd1_10 = 4'h8;
			bcd1_1 = giris1 - 7'd80;
		end
		else if (giris1 < 100) begin
			bcd1_10 = 4'h9;
			bcd1_1 = giris1 - 7'd90;
		end
	end
 
	always @(giris2) begin 						   //burada da giris1'e yapilan islemin
		if (giris2 < 10) begin                                     //aynisi yapilmaktadir.
			bcd2_10 = 4'h0;
			bcd2_1 = giris2;
		end
		else if (giris2 < 20) begin
			bcd2_10 = 4'h1;
			bcd2_1 = giris2 - 7'd10;
		end
		else if (giris2 < 30) begin
			bcd2_10 = 4'h2;
			bcd2_1 = giris2 - 7'd20;
		end
		else if (giris2 < 40) begin
			bcd2_10 = 4'h3;
			bcd2_1 = giris2 - 7'd30;
		end
		else if (giris2 < 50) begin
			bcd2_10 = 4'h4;
			bcd2_1 = giris2 - 7'd40;
		end
		else if (giris2 < 60) begin
			bcd2_10 = 4'h5;
			bcd2_1 = giris2 - 7'd50;
		end
		else if (giris2 < 70) begin
			bcd2_10 = 4'h6;
			bcd2_1 = giris2 - 7'd60;
		end
		else if (giris2 < 80) begin
			bcd2_10 = 4'h7;
			bcd2_1 = giris2 - 7'd70;
		end
		else if (giris2 < 90) begin
			bcd2_10 = 4'h8;
			bcd2_1 = giris2 - 7'd80;
		end
		else if (giris2 < 100) begin
			bcd2_10 = 4'h9;
			bcd2_1 = giris2 - 7'd90;
		end
	end
 
	always @ (negedge KEY[1] or negedge KEY[0]) begin 			   //burada tanimlanan KEY ile ilgili
		if (KEY[1] == 0) begin 						   //islemler gerçeklestiriliyor,
			giris1 = SW[15:8]; 					   //kart üzerinde KEY tusuna
			giris2 = SW[7:0];                                          ////baslarak islem yaptiriliyor.
			overflow = C[7] ^ C[6]; 
		end
		end
	assign S0 = (bcd1_1 + bcd2_1 > 9) ? bcd1_1 + bcd2_1 : bcd1_1 + bcd2_1; 	   //assign S0, S1, S2'nin hesabi
	assign S1 = (bcd1_1 + bcd2_1 > 9) ? 					   //için formül atamalari
	(bcd1_10 + bcd2_10 > 8) ? (bcd1_10 + bcd2_10 - 9) :                        //yapiliyor, :, ?, | kontrol 
	(bcd1_10 + bcd2_10 + 1) : (bcd1_10 + bcd2_10 > 9) ?  (bcd1_10 + bcd2_10 - 10) : //isleçleridir.
	(bcd1_10 + bcd2_10);
	assign S2 = (bcd1_1 + bcd2_1 > 9) & (bcd1_10 + bcd2_10 > 8) | (bcd1_10 + bcd2_10 > 9);
 
	bcd7seg digit1 (bcd1_10, HEX7); 					   //bu bölümde girislerin birler ve onlar basamaklari
	bcd7seg digit2 (bcd1_1, HEX6); 						   //ve S0, S1, S2 bcd7seg modülü ile display'de
	bcd7seg digit3 (bcd2_10, HEX5); 					   //gösterilecek hale getirilir.
	bcd7seg digit4 (bcd2_1, HEX4);
	bcd7seg digit5 ({3'b0,S2}, HEX3); 					   //burada S2'den önce 3'b0 yapilmasinin sebebi,
	bcd7seg digit6 (S1, HEX2); 						   //S2 (elde biti)'nin bir bit olmasindan ötürü hata
	bcd7seg digit7 (S0, HEX1); 						   //almamak için basina 0 yazilarak, 4 bit yapilmistir.
endmodule
 
module bcd7seg (bcd, display); 							   //bcd7seg modülü BCD sayilari display'e aktarir.
	/******************************************************************/
	/****      PORT TANIMLAMALARI                                  ****/
	/******************************************************************/
	input [3:0] bcd; 							   //4 bit BCD giris tanimlanir.
	output reg [0:6] display; 						   //7 bit (7 segment oldugundan) display
										   //çikisi tanimlanir.
	/******************************************************************/
	/****      UYGULAMA                                            ****/
	/******************************************************************/
	/*
	 *       0
	 *      ---
	 *     |   |
	 *    5|   |1
	 *     | 6 |
	 *      ---
	 *     |   |
	 *    4|   |2
	 *     |   |
	 *      ---
	 *       3
	 */
	always @ (bcd)
		case (bcd)
			4'h0: display = 7'b0000001; 				   //0 ve 1'ler ile hangi rakam için
			4'h1: display = 7'b1001111; 				   //7 segment display'in hangi segmentlerinin
			4'h2: display = 7'b0010010; 				   //yanacagi belirtilir.
			4'h3: display = 7'b0000110; 				   //h0'dan h9'a display'in farkli durumlari tanimlanir.
			4'h4: display = 7'b1001100;
			4'h5: display = 7'b0100100;
			4'h6: display = 7'b0100000;
			4'h7: display = 7'b0001111;
			4'h8: display = 7'b0000000;
			4'h9: display = 7'b0000100;
			default: display = 7'b1111111;
		endcase
endmodule
