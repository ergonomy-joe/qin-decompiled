{$C-,K-}
PROGRAM QINPROG;

{ !!!IMPORTANT!!! this file must be edited 
with codepage 437 or 850}

{$I GRAPH.P}

CONST
	MAX_SCENARS = 26;
	MAX_EVENTS = 12;

	DRV_A_STR = 'A:';
	DRV_B_STR = 'B:';
	PATH_SPRITES = 'A:SPRITES.SPR';
	PATH_DEROULE = 'A:DEROULE.TAB';
	PATH_CHIFFRES = 'A:CHIFFRES.TAB';

TYPE
	tRegs = RECORD
		AX,BX,CX,DX,BP,SI,DI,DS,ES,Flags:INTEGER;
	END;
	tString_0C = STRING[12];
	tString_14 = STRING[20];
	tString_2A = STRING[42];
	tString_FF = STRING[255];
	tImage{size:$1A01} = ARRAY[0..$1a00] OF BYTE;
	tEvents{size:$27} = RECORD
		{+00}f_verb_obj:ARRAY[1..10] OF BYTE;
		{+0a}f_mask1,f_res1,f_flags1:ARRAY[1..4] OF BYTE;
		{+16}f_mask2,f_res2,f_flags2:ARRAY[1..2] OF BYTE;
		{+1c}f_schedule:ARRAY[1..6] OF BYTE;
		f_22,f_23,f_24,f_25,f_26:BYTE;
	END;
	tType_64 = ARRAY[1..100] OF BYTE;
	tScenar{size:$400} = ARRAY[1..$400] OF BYTE;
	tToken{size:$C} = RECORD
		word:STRING[10];
		code:byte;
	END;

VAR
	{D_0262}Music_data:ARRAY[1..8000] OF INTEGER;
	D_40E2:TEXT[$80];
	{D_41AE}QinBin_1:ARRAY[1..320] OF tToken;
	{D_50AE}QinBin_2:ARRAY[1..293] OF tToken;
	{D_5E6A}Scene_tok1:ARRAY[1..20] OF tToken;
	{D_5F5A}Scene_tok2:ARRAY[1..5] OF tToken;
	{D_5F96}QinBin_345:ARRAY[1..3,1..68] OF STRING[$5f];
	D_AC16:BYTE;
	{D_AC17}Scenar_tmp:tScenar;
	{D_B017}Scenars:ARRAY[1..MAX_SCENARS] OF ^tScenar;
	D_B07F:FILE OF tScenar;
	D_B0CB:BOOLEAN;
__B0CC:BYTE;
	D_B0CD:BOOLEAN;
	{D_B0CE}EvtTriggered:BOOLEAN;
	{D_B0CF}Special_A:BOOLEAN;
	{D_B0D0}Special_B:BOOLEAN;
	{D_B0D1}InputIsEx:BOOLEAN;
	{D_B0D2}TimerFlag:BOOLEAN;
__B0D3:BYTE;
	{D_B0D4}X86Regs:tRegs;
	{D_B0E8,D_B0EA,D_B0EC}Int1,Int2,Int3:INTEGER;
	{D_B0EE,D_B0EF}T_Hours,T_Minutes:BYTE;
	{D_B0F0}EvtNum:BYTE;
	{D_B0F1}SequenceNum:BYTE;
__B0F2:BYTE;
	{D_B0F3}T_Days:INTEGER;
	{D_B0F5}DirecStr:STRING[4];
	D_B0FA:BYTE;
	{D_B0FB}NumEvts:BYTE;
	{D_B0FC}SceneDir:BYTE;
	{D_B0FD}Events:ARRAY[1..MAX_EVENTS] OF tEvents;
	D_B2D1:ARRAY[0..MAX_EVENTS] OF STRING[$7d];
	{D_B937}VerbObject:ARRAY[1..2] OF BYTE;
	{D_B939}Game_Flags_1:ARRAY[1..4] OF BYTE;
	{D_B93D}Game_Flags_2:ARRAY[1..2] OF BYTE;
	{D_B93F}NumScenar:BYTE;
	{D_B940}UserString:tString_2A;
	D_B96B:tString_2A;
	D_B996,D_B997:CHAR;
	{D_B998}Kbd_char:BYTE;
	{D_B999,D_B9A5,D_B9B1,D_B9BD}
	EvtActiOk,EvtCnd2Ok,EvtCnd1Ok,EvtTimeOk:ARRAY[1..MAX_EVENTS] OF BOOLEAN;
	{D_B9C9}HasMap:ARRAY[1..5] OF BYTE;
	{D_B9CE}NumMaps:BYTE;
	{D_B9CF}DIR_data:tType_64;
	D_BA33:FILE OF tType_64;
	D_BA7F:TEXT[$1000];
	{D_CACB}Img_data:tImage;
	D_E4CC:FILE OF BYTE;
	{D_E518}Sprites_data:ARRAY[0..$86f] OF BYTE;
	D_ED88:ARRAY[0..1,0..$8f] OF BYTE;
	{D_EEA8,D_EEAA}Sprite_XShr2,Sprite_Y:ARRAY[0..1] OF BYTE;
	{D_EEAC}Scanlines:ARRAY[0..199] OF INTEGER;
	{D_F03C}DFileName:tString_0C;
	{D_F049}Digit_data:ARRAY[0..$ef] OF BYTE;
	{D_F139}Scroll_data:ARRAY[0..$107] OF BYTE;
	{D_F241}ScrBackup1:ARRAY[0..2000] OF BYTE;
	{D_FA12}ScrBackup2:ARRAY[0..800] OF BYTE;
	D_FD33:ARRAY[1..6] OF BYTE;
	D_FD39,D_FD3A:BYTE;
	{D_FD3B}NotEnoughMoney:BOOLEAN;
	D_FD3C:BYTE;
	{D_FD3D}Money:BYTE;
	D_FD3E:STRING[30];
	D_FD5D:BOOLEAN;
	{D_FD5E}NumDrives:INTEGER;
	{D_FD60}PrinterNotReady:BOOLEAN;
	{D_FD61}FileError:BOOLEAN;
	{D_FD62}DriveStr:STRING[2];
	{D_FD65}IsPirated:BOOLEAN;

PROCEDURE {C_417E}VPoke(_x_shr_2,_y,_val8:BYTE);
BEGIN
	MEM[$b800:_x_shr_2 + Scanlines[_y]] := _val8;
END;

FUNCTION {C_41B3}VPeek(_x_shr_2,_y:BYTE):BYTE;
BEGIN
	VPeek := MEM[$b800:_x_shr_2 + Scanlines[_y]];
END;

PROCEDURE {C_41E9}VHFill(_x0_shr_2,_y,_len,_val8:BYTE);
VAR
	_b:BYTE;
BEGIN
	FOR _b := 0 TO _len - 1
	DO VPoke(_x0_shr_2 + _b, _y, _val8);
END;

PROCEDURE {C_423C}VVFill(_x_shr_2,_y0,_len,_val8:BYTE);
VAR
	_b:BYTE;
BEGIN
	FOR _b := 0 TO _len - 1
	DO VPoke(_x_shr_2, _y0 + _b, _val8);
END;

PROCEDURE {C_428F}ComputeScanlines;
VAR
	_b:BYTE;
BEGIN
	FOR _b := 0 TO 199
	DO Scanlines[_b] := (_b MOD 2) * $2000 + (_b DIV 2) * $50;
END;

PROCEDURE {C_42F0}Load_imageFile(_filename:tString_14);
VAR
	_file:FILE OF tImage;
BEGIN
	FileError := FALSE;
	ASSIGN(_file, _filename);
	{$I-}RESET(_file);{$I+}
	IF IORESULT = 0
	THEN BEGIN
		READ(_file, Img_data);
		CLOSE(_file);
	END ELSE BEGIN
		FileError := TRUE;
	END;
END;

PROCEDURE {C_4351}Load_Sprites;
VAR
	_i:INTEGER;
BEGIN
	FileError := FALSE;
	ASSIGN(D_E4CC, PATH_SPRITES);
	{$I-}RESET(D_E4CC);{$I+}
	IF IORESULT = 0
	THEN BEGIN
		FOR _i := 0 TO $86f
		DO READ(D_E4CC, Sprites_data[_i]);
		CLOSE(D_E4CC);
	END ELSE BEGIN
		FileError := TRUE;
	END;
END;

PROCEDURE {C_43DD}Load_Scroll;
VAR
	_i:INTEGER;
BEGIN
	FileError := FALSE;
	ASSIGN(D_E4CC, PATH_DEROULE);
	{$I-}RESET(D_E4CC);{$I+}
	IF IORESULT = 0
	THEN BEGIN
		FOR _i := 0 TO $107
		DO READ(D_E4CC, Scroll_data[_i]);
		CLOSE(D_E4CC);
	END ELSE BEGIN
		FileError := TRUE;
	END;
END;

PROCEDURE C_4469(_spr_index:BYTE);
CONST
	C_4470:ARRAY[0..1] OF BYTE = ($CC,$33);
VAR
	_b_y,_b_x,BP_05,_unused_:BYTE;
BEGIN
	IF
		Img_data[11 + 3 * _spr_index] +
		Img_data[12 + 3 * _spr_index] +
		Img_data[13 + 3 * _spr_index] <> 0
	THEN BEGIN
		FOR BP_05 := 0 TO 1
		DO FOR _b_y := 0 TO 23
		DO BEGIN
			FOR _b_x := 0 TO 5
			DO VPoke(
				Sprite_XShr2[_spr_index] + _b_x, Sprite_Y[_spr_index] + _b_y,
				VPeek(Sprite_XShr2[_spr_index] + _b_x, Sprite_Y[_spr_index] + _b_y) AND 
				C_4470[(_b_y + BP_05) MOD 2] OR
				D_ED88[_spr_index][_b_y * 6 + _b_x] AND
				C_4470[(_b_y + 1 + BP_05) MOD 2]
			);
			IF (_b_y MOD 2) = 1
			THEN Palette(Img_data[7]);
		END;
	END;
END;

PROCEDURE {C_4627}Image_refresh(_x_shr_2,_y:INTEGER);
CONST
	C_462E:ARRAY[0..1] OF BYTE = ($04,$11);
	C_4630:ARRAY[0..1] OF BYTE = ($44,$11);
VAR
	_height,_width,_by_1,_by_2,_tag:BYTE;
	_index:INTEGER;

	PROCEDURE {__C_4632}__DrawObject(_spr_index:BYTE);
	CONST
		C_463E:ARRAY[0..7] OF BYTE = ($80,$40,$20,$10,$08,$04,$02,$01);
	VAR
		BBP_05,BBP_06,BBP_07,BBP_08,BBP_09:BYTE;
		_sprx_shr_2,_spry,_spr_num:BYTE;
	BEGIN
		_sprx_shr_2 := Img_data[11 + 3 * _spr_index];
		_spry := Img_data[12 + 3 * _spr_index];
		_spr_num := Img_data[13 + 3 * _spr_index];
		BBP_05 := Game_Flags_2[1 + _spr_num DIV 8] AND C_463E[_spr_num MOD 8];
		IF (_sprx_shr_2 + _spry + _spr_num <> 0) AND (BBP_05 = 0)
		THEN BEGIN
			_sprx_shr_2 := _sprx_shr_2 + _x_shr_2;
			_spry := _spry + _y;
			Sprite_XShr2[_spr_index] := _sprx_shr_2;
			Sprite_Y[_spr_index] := _spry;
			FOR BBP_05 := 0 TO 23
			DO FOR BBP_06 := 0 TO 5
			DO BEGIN
				BBP_07 := Sprites_data[BBP_05 * 6 + BBP_06 + _spr_num * $90];
				BBP_08 := 0;
				IF (BBP_07 AND $c0) <> $80
				THEN BBP_08 := $c0
				ELSE BBP_07 := BBP_07 AND $3f;
				IF (BBP_07 AND $30) <> $20
				THEN BBP_08 := BBP_08 + $30
				ELSE BBP_07 := BBP_07 AND $cf;
				IF (BBP_07 AND $0c) <> $08
				THEN BBP_08 := BBP_08 + $0c
				ELSE BBP_07 := BBP_07 AND $f3;
				IF (BBP_07 AND $03) <> $02
				THEN BBP_08 := BBP_08 + $03
				ELSE BBP_07 := BBP_07 AND $fc;
				BBP_08 := BBP_08 XOR $ff;
				BBP_09 := VPeek(_sprx_shr_2 + BBP_06, _spry + BBP_05);
				D_ED88[_spr_index][BBP_05 * 6 + BBP_06] := BBP_09;
				VPoke(_sprx_shr_2 + BBP_06, _spry + BBP_05, (BBP_09 AND BBP_08) OR BBP_07);
			END;
		END;
	END;

	PROCEDURE {__C_48FA}__drawALine(__y,__mask_1,__mask_2,__mask_3:BYTE);
	BEGIN
		VPoke(_x_shr_2 - 1, __y, VPeek(_x_shr_2 - 1, __y) AND $f0 OR __mask_1);
		VHFill(_x_shr_2, __y, _width, __mask_3);
		VPoke(_x_shr_2 + _width, __y, VPeek(_x_shr_2 + _width, __y) AND $0F OR __mask_2);
	END;

	PROCEDURE {__C_49B0}__drawAColumn(__x_shr_2,__mask_and,__mask_or:BYTE);
	VAR
		BBP_05:BYTE;
	BEGIN
		FOR BBP_05 := 0 TO _height + 1
		DO VPoke(__x_shr_2, _y - 1 + BBP_05, VPeek(__x_shr_2, _y - 1 + BBP_05) AND __mask_and OR __mask_or);
	END;

BEGIN
	IF _x_shr_2 < 0
	THEN _x_shr_2 := Img_data[3] + 1;
	IF _y < 0
	THEN _y := 199 - Img_data[4] + 2;
	_height := Img_data[6];
	_width := Img_data[5];
	_tag := Img_data[17];
	_index := 18;
	IF Img_data[2] = 0
	THEN BEGIN {HORIZONTAL IMAGE}
		__drawALine(_y - 2, 5, $50, $55);
		__drawALine(_y - 1, 4, $10, 0);
		FOR _by_1 := _y TO _y + _height - 1
		DO BEGIN
			VPoke(_x_shr_2 - 1, _by_1, VPeek(_x_shr_2 - 1, _by_1) AND $f0 OR $04);
			_by_2 := _x_shr_2;
			REPEAT
				IF Img_data[_index] = _tag
				THEN BEGIN
					VHFill(_by_2, _by_1, Img_data[_index + 2], Img_data[_index + 1]);
					_by_2 := _by_2 + Img_data[_index + 2];
					_index := _index + 3;
				END ELSE BEGIN
					VPoke(_by_2, _by_1, Img_data[_index]);
					_index := _index + 1;
					_by_2 := _by_2 + 1;
				END;
			UNTIL _by_2 >= _x_shr_2 + _width;
			IF _by_1 < _y + 2
			THEN VPoke(_x_shr_2 + _width, _by_1, VPeek(_x_shr_2 + _width, _by_1) AND $05 OR $10);
			IF _by_1 = _y + 2
			THEN BEGIN
				VPoke(_x_shr_2 + _width, _by_1, $15);
				VPoke(_x_shr_2 + _width + 1,  _by_1, VPeek(_x_shr_2 + _width + 1, _by_1) AND $0f OR $50);
			END;
			IF _by_1 = _y + 3
			THEN BEGIN
				VPoke(_x_shr_2 + _width, _by_1, 0);
				VPoke(_x_shr_2 + _width + 1,  _by_1, VPeek(_x_shr_2 + _width + 1, _by_1) AND $0f OR $10);
			END;
			IF _by_1 > _y + 3
			THEN BEGIN
				VPoke(_x_shr_2 + _width, _by_1, C_462E[_by_1 MOD 2]);
				VPoke(_x_shr_2 + _width + 1, _by_1, VPeek(_x_shr_2 + _width + 1, _by_1) AND $0f OR $10);
			END;
		END;
		__drawALine(_y + _height, 4, $10, 0);
		VPoke(_x_shr_2 + _width, _y + _height, C_462E[(_by_1 + 1) MOD 2]);
		VPoke(_x_shr_2 + _width + 1, _by_1 + 1, VPeek(_x_shr_2 + _width + 1, _by_1 + 1) AND $0f OR $10);
		VPoke(_x_shr_2 - 1, _y + _height + 1, VPeek(_x_shr_2 - 1, _y + _height + 1) AND $f0 OR $05);
		VPoke(_x_shr_2, _y + _height + 1, $54);
		_x_shr_2 := _x_shr_2 + 1;
		__drawALine(_y + _height + 1, 4, $10, C_4630[_by_1 MOD 2]);
		FOR _by_2 := 0 TO 1
		DO __drawALine(_y + _height + 2 + _by_2, 4, $10, C_4630[(_by_1 + _by_2 + 1) MOD 2]);
		__drawALine(_y + _height + 4, 4, $10, 0);
		__drawALine(_y + _height + 5, 5, $50, $55);
	END ELSE BEGIN {VERTICAL IMAGE}
		VPoke(_x_shr_2 - 1, _y - 2, VPeek(_x_shr_2 - 1, _y - 2) AND $f0 OR $05);
		__drawAColumn(_x_shr_2 - 1, $f0, $04);
		VPoke(_x_shr_2 - 1, _y + _height + 1, VPeek(_x_shr_2 - 1, _y + _height + 1) AND $f0 OR $05);
		FOR _by_1 := _x_shr_2 TO _x_shr_2 + _width - 1
		DO BEGIN
			VPoke(_by_1, _y - 2, $55);
			VPoke(_by_1, _y - 1, 0);
			_by_2 := _y;
			REPEAT
				IF Img_data[_index] = _tag
				THEN BEGIN
					VVFill(_by_1, _by_2, Img_data[_index + 2], Img_data[_index + 1]);
					_by_2 := _by_2 + Img_data[_index + 2];
					_index := _index + 3;
				END ELSE BEGIN
					VPoke(_by_1, _by_2, Img_data[_index]);
					_index := _index + 1;
					_by_2 := _by_2 + 1;
				END;
			UNTIL _by_2 >= _y + _height;
			VPoke(_by_1, _y + _height, 0);
			IF _by_1 = _x_shr_2
			THEN BEGIN
				VPoke(_by_1, _y + _height + 1, $54);
				FOR _by_2 := _y + _height + 2 TO _y + _height + 4
				DO VPoke(_by_1, _by_2, VPeek(_by_1, _by_2) AND $f0 OR $04);
				VPoke(_by_1, _by_2 + 1, VPeek(_by_1, _by_2 + 1) AND $f0 OR $05);
			END;
			IF _by_1 > _x_shr_2
			THEN BEGIN
				FOR _by_2 := 0 TO 2
				DO VPoke(_by_1, _y + _height + 1 + _by_2, C_4630[(_height + _by_2) MOD 2]);
				VPoke(_by_1, _y + _height + 4, 0);
				VPoke(_by_1, _y + _height + 5, $55);
			END;
		END;
		VPoke(_by_1 + 1, _y - 2, VPeek(_by_1 + 1, _y - 2) AND $0f OR $50);
		FOR _by_2 := 0 TO 2
		DO VPoke(_by_1 + 1, _y - 1 + _by_2, VPeek(_by_1 + 1, _y - 1 + _by_2) AND $0f OR $10);
		VPoke(_by_1 + 1, _y + 2, $15);
		VPoke(_by_1 + 2, _y + 2, VPeek(_by_1 + 2, _y + 2) AND $0f OR $50);
		VPoke(_by_1 + 1, _y + 3, 0);
		VPoke(_by_1 + 2, _y + 3, VPeek(_by_1 + 2, _y + 3) AND $0f OR $10);
		FOR _by_2 := 0 TO _height - 4
		DO BEGIN
			VPoke(_by_1 + 1, _y + 4 + _by_2, C_462E[(_by_2 + 1) MOD 2]);
			VPoke(_by_1 + 2, _y + 4 + _by_2, VPeek(_by_1 + 2, _y + 4 + _by_2) AND $0f OR $10);
		END;
		FOR _by_2 := _y + _height + 1 TO _y + _height + 3
		DO BEGIN
			VPoke(_by_1 + 1, _by_2, VPeek(_by_1, _by_2));
			VPoke(_by_1 + 2, _by_2, VPeek(_by_1 + 2, _by_2) AND $0f OR $10);
		END;
		VPoke(_by_1 + 1, _by_2 + 1, 0);
		VPoke(_by_1 + 2, _by_2 + 1, VPeek(_by_1 + 2, _by_2 + 1) AND $0f OR $10);
		VPoke(_by_1 + 1, _by_2 + 2, $55);
		VPoke(_by_1 + 2, _by_2 + 2, VPeek(_by_1 + 2, _by_2 + 2) AND $0f OR $50);
	END;
	FOR _by_1 := 0 TO 1
	DO __DrawObject(_by_1);
END;

PROCEDURE {C_5522}Load_Digits;
VAR
	_i:INTEGER;
BEGIN
	ASSIGN(D_E4CC, PATH_CHIFFRES);
	{$I-}RESET(D_E4CC);{$I+}
	IF IORESULT = 0
	THEN FOR _i := 0 TO $EF
	DO READ(D_E4CC, Digit_data[_i]);
	CLOSE(D_E4CC);
END;

PROCEDURE {C_55A0}Draw_Inventory;
CONST
	C_55A7:ARRAY[0..7] OF BYTE = ($80,$40,$20,$10,$08,$04,$02,$01);
VAR
	_has_object,_obj_id,BP_05,BP_06,BP_07:BYTE;

	PROCEDURE __Put_4_pixels(_x_shr_2,_y,_4pix:BYTE);
	VAR
		_mask:BYTE;
	BEGIN
		_mask := 0;
		IF (_4pix AND $C0) <> $80
		THEN _mask := $c0
		ELSE _4pix := _4pix AND $3F;
		IF (_4pix AND $30) <> $20
		THEN _mask := _mask + $30
		ELSE _4pix := _4pix AND $cF;
		IF (_4pix AND $0c) <> $08
		THEN _mask := _mask + $0c
		ELSE _4pix := _4pix AND $f3;
		IF (_4pix AND $03) <> $02
		THEN _mask := _mask + $03
		ELSE _4pix := _4pix AND $fc;
		_mask := _mask XOR $ff;
		VPoke(_x_shr_2, _y, VPeek(_x_shr_2, _y) AND _mask OR _4pix);
	END;

	PROCEDURE __C_56A7(_y:BYTE);
	BEGIN
		FOR BP_06 := 0 TO 6
		DO __Put_4_pixels(14 + BP_06, _y, Scroll_data[BP_05 * 12 + BP_06]);
		FOR BP_06 := 0 TO 39
		DO VPoke(21 + BP_06, _y, VPeek(20 + BP_06, _y));
		FOR BP_06 := 0 TO 4
		DO __Put_4_pixels(61 + BP_06, _y, Scroll_data[7 + BP_05 * 12 + BP_06]);
	END;

	{[uncalled]}
	PROCEDURE __C_57E8(_x0_shr_2,_y0,_obj_id:BYTE);
	VAR
		BBP_05,BBP_06:BYTE;
	BEGIN
		FOR BBP_05 := 0 TO 23
		DO FOR BBP_06 := 0 TO 5
		DO __Put_4_pixels(_x0_shr_2 + BBP_06, _y0 + BBP_05, Sprites_data[$90 * _obj_id + BBP_05 * 6 + BBP_06]);
	END;

BEGIN
	FOR BP_05 := 0 TO 15
	DO __C_56A7(23 + BP_05);

	FOR BP_05 := 0 TO 99
	DO BEGIN
		__Put_4_pixels(17, 39 + BP_05, Scroll_data[$c0 + 2 * (BP_05 MOD $20)]);
		FOR BP_06 := 0 TO 41
		DO VPoke(18 + BP_06, 39 + BP_05, $55);
		__Put_4_pixels(60, 39 + BP_05, Scroll_data[$c1 + 2 * (BP_05 MOD $20)]);

		IF (BP_05 MOD $20) IN [5..28]
		THEN BEGIN
			FOR BP_06 := 0 TO 4
			DO BEGIN
				_obj_id := (BP_05 DIV $20) * 5 + BP_06;
				_has_object := Game_Flags_2[1 + _obj_id DIV 8] AND C_55A7[_obj_id MOD 8];
				IF _has_object <> 0
				THEN FOR BP_07 := 0 TO 5
				DO __Put_4_pixels(20 + 8 * BP_06 + BP_07, 39 + BP_05, Sprites_data[_obj_id * $90 + (BP_05 MOD $20 - 5) * 6 + BP_07]);
			END;
		END;
	END;

	FOR BP_05 := 15 DOWNTO 0
	DO __C_56A7(152 - BP_05);
END;

PROCEDURE {C_5ADA}Sprite_setDigit(_offset:INTEGER; _digit:BYTE);
VAR
	BP_03,BP_04:BYTE;
BEGIN
	_digit := _digit MOD 10;
	FOR BP_03 := 0 TO 11
	DO FOR BP_04 := 0 TO 1
	DO Sprites_data[_offset + BP_04 + BP_03 * 6] := Digit_data[_digit * 24 + BP_03 * 2 + BP_04];
END;

PROCEDURE {C_5B82}RefreshMapNum(_num:BYTE);
BEGIN
	Sprite_setDigit($824, _num);
END;

PROCEDURE {C_5B9F}RefreshMoney(_money:BYTE);
BEGIN
	Sprite_setDigit($1ef, _money MOD 10);
	Sprite_setDigit($1ed, (_money MOD 100) DIV 10);
END;

PROCEDURE {C_5BDD}DirtyExit;
BEGIN
	TEXTMODE(80);
	FOR Int1 := 0 TO 32000
	DO MEM[0:Int1] := 0;
END;

PROCEDURE {C_5C20}Pirate_phase2;
BEGIN
	IF IsPirated = TRUE
	THEN BEGIN
		IF T_Days > 10
		THEN BEGIN
			GOTOXY(16,12); WRITE('PIRATE !');
		END;
		IF T_Days > 25
		THEN DirtyExit;
	END;
END;

{$I C_5C70.P}

PROCEDURE {C_5DD5}Pirate_phase1;
BEGIN
	IsPirated := NOT C_5C70;
END;


PROCEDURE C_5DEC;
BEGIN
	{-- copy int 23h handler to int 24h handler --}
	MEM[0:$90] := MEM[0:$8c];
	MEM[0:$91] := MEM[0:$8d];
	MEM[0:$92] := MEM[0:$8e];
	MEM[0:$93] := MEM[0:$8f];
	{-- compute drives # --}
	Int1 := MEM[$40:$10];
	NumDrives := ((Int1 AND $c0) DIV $40) + 1;
END;

PROCEDURE {C_5E95}Scenar1_load;
BEGIN
	NumScenar := 1;
	DriveStr := DRV_A_STR;

	ASSIGN(D_B07F, DriveStr + 'SCENAR1.QIN');
	RESET(D_B07F);
	FOR Int1 := 1 TO MAX_SCENARS
	DO BEGIN
		SEEK(D_B07F, Int1);
		READ(D_B07F, Scenars[Int1]^);
	END;
	CLOSE(D_B07F);
	
	ASSIGN(D_BA33, DriveStr + 'DISK.DIR');
	RESET(D_BA33);
	SEEK(D_BA33, 0);
	READ(D_BA33, DIR_data);
	CLOSE(D_BA33);
END;

PROCEDURE {C_5F8D}Scenar2_load;
BEGIN
	ASSIGN(D_B07F, DriveStr + 'SCENAR2.QIN');
	RESET(D_B07F);
	FOR Int1 := 1 TO MAX_SCENARS
	DO BEGIN
		SEEK(D_B07F, Int1 - 1);
		READ(D_B07F, Scenars[Int1]^);
	END;
	CLOSE(D_B07F);

	ASSIGN(D_BA33, DriveStr + 'DISK.DI1');
	RESET(D_BA33);
	SEEK(D_BA33, 0);
	READ(D_BA33, DIR_data);
	CLOSE(D_BA33);
END;

PROCEDURE {C_6072}Load_Scenar3;
BEGIN
	ASSIGN(D_B07F, DriveStr + 'SCENAR3.QIN');
	RESET(D_B07F);
	FOR Int1 := 1 TO 19
	DO BEGIN
		SEEK(D_B07F, Int1 - 1);
		READ(D_B07F, Scenars[Int1]^);
	END;
	CLOSE(D_B07F);

	ASSIGN(D_BA33, DriveStr + 'DISK.DI3');
	RESET(D_BA33);
	SEEK(D_BA33, 1);
	READ(D_BA33, DIR_data);
	CLOSE(D_BA33);
END;

PROCEDURE {C_6157}CheckPrinter;
VAR
	BP_03:BYTE;
BEGIN
	X86Regs.AX := $200;
	X86Regs.DX := 0;
	INTR($17,X86Regs);
	BP_03 := HI(X86Regs.AX);
	PrinterNotReady := (BP_03 AND $10) <> $10;
	IF PrinterNotReady = FALSE
	THEN PrinterNotReady := (BP_03 AND $20) = $20;
	IF PrinterNotReady = FALSE
	THEN PrinterNotReady := (BP_03 AND 8) = 8;
	IF PrinterNotReady = FALSE
	THEN PrinterNotReady := BP_03 = $70;
END;

PROCEDURE {C_61FC}PrinterWrite(_str:tString_FF);
VAR
	_b:BYTE;
	_ch:CHAR;
BEGIN
	PrinterNotReady := FALSE;
	CheckPrinter;
	IF PrinterNotReady
	THEN EXIT;

	FOR _b := 1 TO LENGTH(_str)
	DO BEGIN
		_ch := _str[_b];
		CASE _ch OF
			'‚': _ch := 'e';
			'Š': _ch := 'e';
			'…': _ch := 'a';
			'‡': _ch := 'c';
			'ˆ': _ch := 'e';
			'“': _ch := 'o';
		END;
		X86Regs.AX := ORD(_ch);
		X86Regs.DX := 0;
		INTR($17,X86Regs);
	END;
	X86Regs.DX := 0;
	X86Regs.AX := 10;
	INTR($17,X86Regs);
	X86Regs.AX := 13;
	X86Regs.DX := 0;
	INTR($17,X86Regs);
END;

PROCEDURE {C_630C}FillRect(_x1,_y1,_x2,_y2,_color:INTEGER);
BEGIN
	GraphWindow(_x1,_y1,_x2,_y2);
	FillScreen(_color);
	GraphWindow(0,0,639,199);
END;

PROCEDURE C_6349(_str:tString_FF);
BEGIN
	FillRect(0,176,320,200,0);

	GOTOXY(1,23); WRITE(COPY(_str, 1, 40));
	PrinterWrite(COPY(_str, 1, 40));

	GOTOXY(1,24); WRITE(COPY(_str, 41, 40));
	PrinterWrite(COPY(_str, 41, 40));

	GOTOXY(1,25); WRITE(COPY(_str, 81, 40));
	PrinterWrite(COPY(_str, 81, 40));
END;

PROCEDURE {C_6430}ConfirmFloppy;
VAR
	_ch:CHAR;
	_F1_ok,_floppyOk:BOOLEAN;
BEGIN
	_F1_ok := FALSE;
	_floppyOk := FALSE;
	GOTOXY(1,24); WRITE('APPUYEZ SUR [F1] SI DISQUE(S) EN PLACE');
	WHILE (_F1_ok = FALSE) OR (_floppyOk = FALSE)
	DO BEGIN
		READ(KBD,_ch);
		IF _ch = #27
		THEN BEGIN
			READ(KBD,_ch);
			IF _ch = #$3B
			THEN BEGIN
				{$I-}
				_F1_ok := TRUE;
				IF NumScenar = 1
				THEN BEGIN
					ASSIGN(D_B07F, DriveStr + 'SCENAR1.QIN');
					RESET(D_B07F);
					CLOSE(D_B07F);
					_floppyOk := IORESULT = 0;
				END;
				IF NumScenar > 1
				THEN BEGIN
					ASSIGN(D_B07F, DriveStr + 'SCENAR2.QIN');
					RESET(D_B07F);
					CLOSE(D_B07F);
					_floppyOk := IORESULT = 0;
				END;
				{$I+}
			END;
		END;
	END;
END;

PROCEDURE {C_658F}RequestFloppy(_floppy_num:BYTE);
VAR
	_tmp:BYTE;
BEGIN
	CASE _floppy_num OF
		1: BEGIN
			IF NumDrives = 1
			THEN BEGIN
				C_6349('METTRE DISQUE 1 DANS LECTEUR A ');
				DriveStr := DRV_A_STR;
				_tmp := NumScenar;
				NumScenar := 1;
				ConfirmFloppy;
				NumScenar := _tmp;
			END;
			IF NumDrives > 1
			THEN BEGIN
				C_6349('DISQUE 1 LECTEUR A   DISQUE 2 LECTEUR B');
				DriveStr := DRV_A_STR;
				_tmp := NumScenar;
				NumScenar := 1;
				ConfirmFloppy;
				NumScenar := _tmp;
			END;
		END;
		2: BEGIN
			IF NumDrives = 1
			THEN BEGIN
				C_6349('METTRE DISQUE 2 DANS LECTEUR A');
				DriveStr := DRV_A_STR;
				_tmp := NumScenar;
				NumScenar := 2;
				ConfirmFloppy;
				NumScenar := _tmp;
			END;
			IF NumDrives = 2
			THEN BEGIN
				C_6349('METTRE DISQUE 2 DANS LECTEUR B');
				DriveStr := DRV_B_STR;
				_tmp := NumScenar;
				NumScenar := 2;
				ConfirmFloppy;
				NumScenar := _tmp;
			END;
		END;
	END;
END;

PROCEDURE {C_673A}Game_save;
VAR
	_i:INTEGER;
	_ch:CHAR;
BEGIN
	IF NumScenar = 3
	THEN BEGIN
		C_6349('D‚sol‚, mais vous ne poss‚dez plus ce   pouvoir!');
		EXIT;
	END;
	C_6349('Voulez vous vraiment sauver cette partie(O/N) ? ');
	_ch := ' ';
	WHILE (_ch <> 'O') AND (_ch <> 'o') AND (_ch <> 'N') AND (_ch <> 'n')
	DO READ(KBD,_ch);
	IF _ch IN ['n','N']
	THEN BEGIN
		C_6349('D' + #39 + 'accord, je n' + #39 + 'ai rien entendu');
		EXIT;
	END;
	IF NumScenar > 1
	THEN RequestFloppy(1);

	ASSIGN(D_BA7F,'ANCIEN.QIN');
	REWRITE(D_BA7F);

	FOR _i := 1 TO 4
	DO WRITELN(D_BA7F, CHR(Game_Flags_1[_i]));
	FOR _i := 1 TO 2
	DO WRITELN(D_BA7F, CHR(Game_Flags_2[_i]));
	FOR _i := 1 TO 2
	DO WRITELN(D_BA7F, CHR(VerbObject[_i]));

	WRITELN(D_BA7F,CHR(T_Hours));
	WRITELN(D_BA7F,CHR(HI(T_Days)));
	WRITELN(D_BA7F,CHR(LO(T_Days)));
	WRITELN(D_BA7F,CHR(NumScenar));
	WRITELN(D_BA7F,CHR(SequenceNum));
	WRITELN(D_BA7F,CHR(NumMaps));

	FOR _i := 1 TO 5
	DO WRITELN(D_BA7F,CHR(HasMap[_i]));
	WRITELN(D_BA7F,CHR(Money));

	CLOSE(D_BA7F);

	IF NumScenar > 1
	THEN RequestFloppy(2);
END;

PROCEDURE {C_6A9B}MusicPlay;
VAR
	_note,_duration,_index:INTEGER;
	_ch:CHAR;
BEGIN
	_index := 1;
	_note := 1;
	_duration := 1;
	_ch := ' ';
	WHILE (_note + _duration <> 0) AND (_ch <> #27)
	DO BEGIN
		_note := Music_data[_index];
		_index := _index + 1;
		_duration := Music_data[_index];
		_index := _index + 1;
		IF KEYPRESSED
		THEN READ(KBD,_ch);
		IF _ch = #27
		THEN NOSOUND;
		IF _note = 0
		THEN NOSOUND;
		SOUND(_note);
		DELAY(_duration * 4);
	END;
	NOSOUND;
END;

PROCEDURE {C_6B66}MusicLoadPlay;
VAR
	_n_str,_d_str:STRING[2];
	_note,_duration:INTEGER;
	_str:STRING[15];
	_index:INTEGER;
BEGIN
	_index := 1;
	_note := 1;
	_duration := 1;
	ASSIGN(D_BA7F,'qin.mus');
	RESET(D_BA7F);
	WHILE _note + _duration <> 0
	DO BEGIN
		READ(D_BA7F,_n_str);
		READLN(D_BA7F,_d_str);
		_note := ORD(_n_str[1]) + ORD(_n_str[2]) * $100;
		_duration := ORD(_d_str[1]) + ORD(_d_str[2]) * $100;
		Music_data[_index] := _note;
		_index := _index + 1;
		Music_data[_index] := _duration;
		_index := _index + 1;
	END;
	CLOSE(D_BA7F);

	_str := 'ESC fin musique';
	FOR _index := 1 TO 15
	DO BEGIN
		GOTOXY(1,5 + _index); WRITE(_str[_index]);
	END;

	MusicPlay;
END;

PROCEDURE C_6CAA;
BEGIN
	GetPic(ScrBackup1,0,24,280,44);
	GetPic(ScrBackup2,0,145,280,152);
END;

PROCEDURE {C_6CE8}Compass_draw;
VAR
	_i:INTEGER;
BEGIN
	ColorTable(0,1,2,3);
	FOR _i := 1 TO 6
	DO PutPic(ScrBackup1, 0, 24 + _i * 20);
	PutPic(ScrBackup2, 0, 152);
	GOTOXY(38,5); WRITE(DirecStr[1]);
	GOTOXY(38,7); WRITE(DirecStr[2]);
	GOTOXY(39,6); WRITE(DirecStr[3]);
	GOTOXY(37,6); WRITE(DirecStr[4]);
	PrinterWrite('DIRECTIONS :' + DirecStr[1] + DirecStr[2] + DirecStr[3] + DirecStr[4]);
END;

PROCEDURE {C_6E12}RefreshTimer;
BEGIN
	X86Regs.AX := $2c00;
	INTR($21,X86Regs);
	T_Hours := HI(X86Regs.CX);
	T_Minutes := LO(X86Regs.CX);

	GOTOXY(1,1);
	IF T_Hours < 10
	THEN WRITE(0,T_Hours)
	ELSE WRITE(T_Hours:2);

	GOTOXY(4,1);
	IF T_Minutes < 10
	THEN WRITE(0,T_Minutes:1)
	ELSE WRITE(T_Minutes:2);

	GOTOXY(3,1);
	IF TimerFlag
	THEN WRITE(':')
	ELSE WRITE(' ');
	TimerFlag := NOT TimerFlag;
END;

PROCEDURE {C_6F17}Kbd_clrBuffer;
BEGIN
	X86Regs.AX := $c00;
	INTR($21,X86Regs);
END;

PROCEDURE {C_6F37}Kbd_get;
VAR
	_tmp_char:BYTE;
	_counter:INTEGER;
BEGIN
	_tmp_char := 0;
	_counter := 0;
	Kbd_clrBuffer;
	InputIsEx := FALSE;
	REPEAT
		X86Regs.AX := $100;
		INTR($16,X86Regs);
		IF (X86Regs.Flags AND $40) = 0
		THEN BEGIN
			InputIsEx := FALSE;
			IF NOT (LO(X86Regs.AX) = 0)
			THEN BEGIN
				_tmp_char := LO(X86Regs.AX);
			END ELSE BEGIN
				InputIsEx := TRUE;
				_tmp_char := HI(X86Regs.AX);
				Kbd_clrBuffer;
			END;
		END;
		IF _tmp_char = 0
		THEN _counter := _counter + 1;
		IF _counter = 3000
		THEN BEGIN
			RefreshTimer;
			_counter := 0;
		END;
	UNTIL _tmp_char <> 0;
	Kbd_char := _tmp_char;
END;

PROCEDURE {C_6FF5}Image_load(_img_id:BYTE);
VAR
	_unused_:STRING[13];
	_scenar_str:STRING[3];
	_img_str:STRING[3];
BEGIN
	_scenar_str := '   ';
	_img_str := '   ';
	STR(NumScenar,_scenar_str);
	STR(_img_id,_img_str);

	IF (_img_id  >= 90) AND (NumScenar = 3)
	THEN _scenar_str := '2';

	DFileName := DriveStr + 'Q' + _img_str + '.' + 'D' + _scenar_str;
	Load_imageFile(DFileName);

	IF _img_id IN [93,94]
	THEN Palette(2)
	ELSE Palette(Img_data[7]);
END;

PROCEDURE C_7102;
BEGIN
	CASE D_B997 OF
		#$F7: D_B997 := '“';
		#$F8: D_B997 := '€';
		#$F9: D_B997 := '‚';
		#$FC: D_B997 := '†';
		#$FD: D_B997 := 'Š';
		#$FE: D_B997 := 'ˆ';
	END;
END;

PROCEDURE {C_7178}Scene_new(_scene_num:BYTE);
VAR
	BP_03:BYTE;
	BP_04:CHAR;
	_day_str,_hour_str:STRING[6];
BEGIN
	IF (_scene_num < 1) OR (_scene_num > 100)
	THEN EXIT;

	IF _scene_num <> 1
	THEN FOR Int1 := 1 TO 6
	DO D_FD33[Int1] := 0;

	DirecStr := ' ';
	FOR Int1 := 1 TO 4
	DO DirecStr[Int1] := CHR(Scenars[_scene_num]^[Int1]);

	D_B0FA := Scenars[_scene_num]^[6];
	NumEvts := Scenars[_scene_num]^[7];
	SceneDir := Scenars[_scene_num]^[$200];

	FOR Int1 := 1 TO NumEvts
	DO WITH Events[Int1]
	DO BEGIN
		FOR Int3 := 1 TO 10
		DO f_verb_obj[Int3] := Scenars[_scene_num]^[7 + Int3 + (Int1 - 1) * $27];
		FOR Int3 := 1 TO 6
		DO f_schedule[Int3] := Scenars[_scene_num]^[$11 + Int3 + (Int1 - 1) * $27];
		FOR Int3 := 1 TO 4
		DO f_mask1[Int3] := Scenars[_scene_num]^[$17 + Int3 + (Int1 - 1) * $27];
		FOR Int3 := 1 TO 4
		DO f_res1[Int3] := Scenars[_scene_num]^[$1b + Int3 + (Int1 - 1) * $27];
		FOR Int3 := 1 TO 4
		DO f_flags1[Int3] := Scenars[_scene_num]^[$1f + Int3 + (Int1 - 1) * $27];
		FOR Int3 := 1 TO 2
		DO f_mask2[Int3] := Scenars[_scene_num]^[$23 + Int3 + (Int1 - 1) * $27];
		FOR Int3 := 1 TO 2
		DO f_res2[Int3] := Scenars[_scene_num]^[$25 + Int3 + (Int1 - 1) * $27];
		FOR Int3 := 1 TO 2
		DO f_flags2[Int3] := Scenars[_scene_num]^[$27 + Int3 + (Int1 - 1) * $27];
		f_22 := Scenars[_scene_num]^[$2a + (Int1 - 1) * $27];
		f_23 := Scenars[_scene_num]^[$2b + (Int1 - 1) * $27];
		f_24 := Scenars[_scene_num]^[$2c + (Int1 - 1) * $27];
		f_25 := Scenars[_scene_num]^[$2d + (Int1 - 1) * $27];
		f_26 := Scenars[_scene_num]^[$2e + (Int1 - 1) * $27];
	END;

	Int3 := 0;
	FOR Int1 := 0 TO NumEvts
	DO BEGIN
		D_B2D1[Int1] := '';
		BP_04 := '.';
		WHILE BP_04 <> '*'
		DO BEGIN
			BP_04 := CHR(Scenars[_scene_num]^[$201 + Int3]);
			Int3 := Int3 + 1;
			CASE BP_04 OF
				#$f7: BP_04 := '“';
				#$f8: BP_04 := '€';
				#$f9: BP_04 := '‚';
				#$fc: BP_04 := '†';
				#$fd: BP_04 := 'Š';
				#$fe: BP_04 := 'ˆ';
			END;
			IF BP_04 <> '*'
			THEN D_B2D1[Int1] := D_B2D1[Int1] + BP_04;
		END;
	END;

	Compass_draw;

	FillRect(48,0,272,15,0);
	ColorTable(1,0,0,0);
	GOTOXY(7,1); WRITE(COPY(D_B2D1[0], 1, 28));
	GOTOXY(7,2); WRITE(COPY(D_B2D1[0], 29, 28));

	PrinterWrite('SCENE :' + COPY(D_B2D1[0], 1, 28) + COPY(D_B2D1[0], 29, 28));
	STR(T_Days, _day_str);
	STR(T_Hours, _hour_str);
	PrinterWrite('TEMPS :' + _day_str + ' Jrs  ' + _hour_str + ' Hrs');

	FillRect(48,0,272,15,-1);
END;

PROCEDURE {C_7929}Draw_DES(BP04:tString_0C);
BEGIN
	ASSIGN(D_BA7F, BP04 + '.DES');
	RESET(D_BA7F);
	FOR Int1 := 0 TO $1fff
	DO BEGIN
		READ(D_BA7F, D_B996);
		MEM[$B800:Int1] := ORD(D_B996);
		READ(D_BA7F, D_B996);
		MEM[$B800:$2000 + Int1] := ORD(D_B996);
	END;
	CLOSE(D_BA7F);
END;

PROCEDURE {C_79DD}Decode_Qin1_Bin;
VAR
	_key:STRING[14];
BEGIN
	_key := 'JACK FIRST';
	FOR Int2 := 1 TO LENGTH(QinBin_1[Int1].word)
	DO BEGIN
		Int3 := ORD(QinBin_1[Int1].word[Int2]) XOR (ORD(_key[Int2]) - $41);
		IF Int3 <> 13
		THEN QinBin_1[Int1].word[Int2] := CHR(Int3);
	END;
END;

PROCEDURE {C_7A80}Decode_Qin2_Bin;
VAR
	_key:STRING[14];
BEGIN
	_key := 'JACK FIRST';
	FOR Int2 := 1 TO LENGTH(QinBin_2[Int1].word)
	DO BEGIN
		Int3 := ORD(QinBin_2[Int1].word[Int2]) XOR (ORD(_key[Int2]) - $41);
		IF Int3 <> 13
		THEN QinBin_2[Int1].word[Int2] := CHR(Int3);
	END;
END;

PROCEDURE {C_7B23}Load_Qin1_Bin;
BEGIN
	ASSIGN(D_40E2, 'QIN1.BIN');
	RESET(D_40E2);
	FOR Int1 := 1 TO 320
	DO BEGIN
		READLN(D_40E2, QinBin_1[Int1].word);
		READLN(D_40E2, D_B996);
		QinBin_1[Int1].code := ORD(D_B996);
		Decode_Qin1_Bin;
		IF QinBin_1[Int1].word = 'BAMBO'
		THEN QinBin_1[Int1].code := 29;
	END;
	CLOSE(D_40E2);
END;

PROCEDURE {C_7BFC}Load_Qin2_Bin;
BEGIN
	ASSIGN(D_40E2, 'QIN2.BIN');
	RESET(D_40E2);
	FOR Int1 := 1 TO 293
	DO BEGIN
		READLN(D_40E2, QinBin_2[Int1].word);
		READLN(D_40E2, D_B996);
		QinBin_2[Int1].code := ORD(D_B996);
		Decode_Qin2_Bin;


	END;
	CLOSE(D_40E2);
END;

PROCEDURE C_7CA3(_operation,_param:BYTE);
VAR
	_minutes:INTEGER;
	BP_09,BP_0E:STRING[4];
BEGIN
	BP_0E := '0000';

	IF T_Hours = 24
	THEN T_Hours := 0;
	_minutes := T_Hours * 60 + T_Minutes;
	CASE _operation OF
		2: _minutes := _minutes + _param * 60;
		3: _minutes := _minutes + _param;
		1: T_Days := T_Days + _param;

		6: BEGIN
			NumMaps := NumMaps + 1;
			HasMap[_param] := 1;
			IF NumMaps > 5
			THEN NumMaps := 5;
		END;
		7: BEGIN
			NumMaps := NumMaps - 1;
			HasMap[_param] := 0;
			IF NumMaps < 0
			THEN NumMaps := 0;
		END;
	END;

	IF _operation IN [6,7]
	THEN BEGIN
		RefreshMapNum(NumMaps);
		IF HasMap[1] = 1
		THEN Game_Flags_1[4] := Game_Flags_1[4] OR 4;
	END;

	IF _operation IN [1,2,3]
	THEN BEGIN
		T_Days := T_Days + _minutes DIV 1440;
		T_Hours := (_minutes DIV 60) MOD 24;
		T_Minutes := _minutes MOD 60;
		X86Regs.CX := T_Hours * $100 + T_Minutes;
		X86Regs.AX := $2d00;
		INTR($21,X86Regs);

		RefreshTimer;

		BP_09 := BP_0E;
		STR(T_Days, BP_09);
		INSERT(BP_09, BP_0E, 5 - LENGTH(BP_09));
		GOTOXY(1,2); WRITE(BP_0E:4,'j',' ');
		ColorTable(3,0,0,0);
		FillRect(0,8,47,15,-1);
	END;
END;

PROCEDURE {C_7F11}Game_load;
VAR
	_i:INTEGER;
	_ch:CHAR;
BEGIN
	FOR _i := 1 TO 6
	DO D_FD33[_i] := 0;
	NumScenar := 1;
	RequestFloppy(1);
	ASSIGN(D_BA7F, DriveStr + 'ANCIEN.QIN');
	RESET(D_BA7F);
	FOR _i := 1 TO 4
	DO BEGIN
		READLN(D_BA7F, _ch);
		Game_Flags_1[_i] := ORD(_ch);
	END;
	FOR _i := 1 TO 2
	DO BEGIN
		READLN(D_BA7F, _ch);
		Game_Flags_2[_i] := ORD(_ch);
	END;
	FOR _i := 1 TO 2
	DO BEGIN
		READLN(D_BA7F, _ch);
		VerbObject[_i] := ORD(_ch);
	END;
	READLN(D_BA7F, _ch);
	T_Hours := ORD(_ch);
	READLN(D_BA7F, _ch);
	T_Days := ORD(_ch) * $100;
	READLN(D_BA7F, _ch);
	T_Days := T_Days + ORD(_ch);
	READLN(D_BA7F, _ch);
	NumScenar := ORD(_ch);
	READLN(D_BA7F, _ch);
	SequenceNum := ORD(_ch);
	READLN(D_BA7F, _ch);
	NumMaps := ORD(_ch);
	FOR _i := 1 TO 5
	DO BEGIN
		READLN(D_BA7F, _ch);
		HasMap[_i] := ORD(_ch);
	END;
	RefreshMapNum(NumMaps);
	READLN(D_BA7F, _ch);
	Money := ORD(_ch);
	RefreshMoney(Money);
	CLOSE(D_BA7F);
	C_7CA3(1,0);
	IF NumScenar > 1
	THEN RequestFloppy(2);
	IF NumScenar = 2
	THEN Scenar2_load;
	IF NumScenar = 1
	THEN Scenar1_load;
END;

PROCEDURE {C_81BC}Game_reset;
VAR
	_unused_:BYTE;
	_ch:CHAR;
	_i:INTEGER;
BEGIN
	FOR _i := 1 TO MAX_EVENTS
	DO BEGIN
		EvtTimeOk[_i] := FALSE;
		EvtActiOk[_i] := FALSE;
		EvtCnd2Ok[_i] := FALSE;
		EvtCnd1Ok[_i] := FALSE;
	END;
	FOR _i := 1 TO 4
	DO Game_Flags_1[_i] := 0;
	Game_Flags_2[1] := 0;
	Game_Flags_2[2] := 0;

	NumMaps := 0;
	Money := 99;
	RefreshMapNum(NumMaps);
	RefreshMoney(Money);
	Image_load(93);
	Image_refresh(-1,-1);
	D_B0FA := 100;
	C_6349('VOULEZ VOUS REPRENDRE UNE ANCIENNE      PARTIE (O/N) ');
	_ch := ' ';
	WHILE (_ch <> 'O') AND (_ch <> 'o') AND (_ch <> 'N') AND (_ch <> 'n')
	DO READ(KBD, _ch);
	IF _ch IN ['O','o']
	THEN BEGIN
		Game_load;
		Image_load(SequenceNum);
		FillRect(0,176,320,200,0);
		Scene_new(DIR_data[SequenceNum]);
		Compass_draw;
		Image_refresh(-1,-1);
		D_FD3C := 1;
		D_FD33[1] := SequenceNum;
		NotEnoughMoney := FALSE;
		Special_A := FALSE;
		Special_B := FALSE;
	END ELSE BEGIN
		C_7CA3(2,0);
		T_Days := 0;
		NumScenar := 1;
		RequestFloppy(1);
		Scenar1_load;
		Image_load(1);
		SequenceNum := 1;
		D_B0FA := 100;
		Scene_new(1);
		Image_refresh(-1,-1);
		D_FD3C := 1;
		D_FD33[1] := 1;
		Money := 99;
		NotEnoughMoney := FALSE;
		FillRect(0,176,320,200,0);
		Special_A := FALSE;
		Special_B := FALSE;
	END;
END;

PROCEDURE {C_842C}Game_init;
VAR
	BPFF32:TEXT[$80];
BEGIN
	D_AC16 := 1;
	NumScenar := 1;
	DriveStr := DRV_A_STR;

	ASSIGN(D_B07F, DriveStr + 'SCENAR1.QIN');
	RESET(D_B07F);
	FOR Int1 := 1 TO MAX_SCENARS
	DO BEGIN
		SEEK(D_B07F, Int1);
		READ(D_B07F, Scenar_tmp);
		NEW(Scenars[Int1]);
		Scenars[Int1]^ := Scenar_tmp;
	END;
	CLOSE(D_B07F);

	ASSIGN(D_BA33, DriveStr + 'DISK.DIR');
	RESET(D_BA33);
	SEEK(D_BA33, 0);
	READ(D_BA33, DIR_data);
	CLOSE(D_BA33);

	GraphColorMode;
	Palette(0);
	Draw_DES('ECRAN1');

	ASSIGN(BPFF32, 'QIN3.BIN');
	RESET(BPFF32);
	Int2 := 1;
	QinBin_345[1][1] := '';
	FOR Int3 := 1 TO $800
	DO BEGIN
		READ(BPFF32, D_B997);
		D_B997 := CHR(ORD(D_B997) XOR (Int3 MOD 6));
		C_7102;
		IF D_B997 = '*'
		THEN BEGIN
			Int2 := Int2 + 1;
			QinBin_345[1][Int2] := '';
		END;
		IF D_B997 <> '*'
		THEN QinBin_345[1][Int2] := QinBin_345[1][Int2] + D_B997;
	END;
	CLOSE(BPFF32);

	ASSIGN(BPFF32, 'QIN4.BIN');
	RESET(BPFF32);
	Int2 := 1;
	QinBin_345[2][1] := '';
	FOR Int3 := 1 TO $800
	DO BEGIN
		READ(BPFF32, D_B997);
		D_B997 := CHR(ORD(D_B997) XOR (Int3 MOD 6));
		C_7102;
		IF D_B997 = '*'
		THEN BEGIN
			Int2 := Int2 + 1;
			QinBin_345[2][Int2] := '';
		END;
		IF D_B997 <> '*'
		THEN QinBin_345[2][Int2] := QinBin_345[2][Int2] + D_B997;
	END;
	CLOSE(BPFF32);

	ASSIGN(BPFF32, 'QIN5.BIN');
	RESET(BPFF32);
	Int2 := 1;
	QinBin_345[3][1] := '';
	FOR Int3 := 1 TO $800
	DO BEGIN
		READ(BPFF32, D_B997);
		D_B997 := CHR(ORD(D_B997) XOR (Int3 MOD 6));
		C_7102;
		IF D_B997 = '*'
		THEN BEGIN
			Int2 := Int2 + 1;
			QinBin_345[3][Int2] := '';
		END;
		IF D_B997 <> '*'
		THEN QinBin_345[3][Int2] := QinBin_345[3][Int2] + D_B997;
	END;
	CLOSE(BPFF32);

	Load_Qin1_Bin;
	Int2 := 1;
	FOR Int1 := 1 TO 320
	DO IF POS('-', QinBin_1[Int1].word) > 0
	THEN BEGIN
		Scene_tok1[Int2].word := QinBin_1[Int1].word;
		Scene_tok1[Int2].code := QinBin_1[Int1].code;
		Int2 := Int2 + 1;
	END;

	Load_Qin2_Bin;
	Int2 := 1;
	FOR Int1 := 1 TO 289
	DO IF POS('-', QinBin_2[Int1].word) > 0
	THEN BEGIN
		Scene_tok2[Int2].word := QinBin_2[Int1].word;
		Scene_tok2[Int2].code := QinBin_2[Int1].code;
		Int2 := Int2 + 1;
	END;

	MusicLoadPlay;
	ComputeScanlines;
	Load_Sprites;
	Load_Digits;
	Load_Scroll;

	Draw_DES('ECRAN2');
	FillRect(0,160,328,176,0);
	C_6CAA;
	C_7CA3(1,0);
	Game_reset;
END;

PROCEDURE {C_89D6}Game_pause;
VAR
	BP_03:CHAR;
BEGIN
	Kbd_clrBuffer;
	PORT[$3d4] := 1; PORT[$3d5] := 0;
	GOTOXY(1,1); WRITE('PAUSE');
	WHILE BP_03 <> #27
	DO READ(KBD,BP_03);
	PORT[$3d4] := 1; PORT[$3d5] := 40;
END;

{disable ctrl+brk?}
PROCEDURE C_8A46;
BEGIN
	X86Regs.AX := $3301;
	X86Regs.DX := 0;
	INTR($21,X86Regs);
END;

PROCEDURE {C_8A6C}TryToPay;
BEGIN
	NotEnoughMoney := FALSE;

	IF Events[EvtNum].f_25 IN [4,5]
	THEN IF (Game_Flags_2[1] AND $10) = 0
	THEN BEGIN
		NotEnoughMoney := TRUE;
		C_6349('Vous n' + CHR(39) + 'avez pas d' + CHR(39) + 'argent.');
		EXIT;
	END;

	IF Events[EvtNum].f_25 = 5
	THEN BEGIN
		IF Money < Events[EvtNum].f_26
		THEN BEGIN
			NotEnoughMoney := TRUE;
			C_6349('Vous n' + CHR(39) + 'avez plus assez d' + CHR(39) + 'argent.');
			EXIT;
		END;
		Money := Money - Events[EvtNum].f_26;
	END;

	IF Events[EvtNum].f_25 = 4
	THEN BEGIN
		Money := Money + Events[EvtNum].f_26;
		IF Money > 99
		THEN Money := 99;
	END;

	RefreshMoney(Money);
END;

PROCEDURE C_8C09;
BEGIN
	Kbd_char := 0;
	REPEAT
		Kbd_get;
		IF InputIsEx = FALSE
		THEN InputIsEx := Kbd_char IN [1..31,139..255];
	UNTIL Kbd_char <> 0;
	Kbd_clrBuffer;
END;

PROCEDURE {C_8C60}UserInput(_dummy_x,_dummy_y,_str_length,_str_width:BYTE);
VAR
	_b:BYTE;
	_txt_color:BYTE;
	_insert:BOOLEAN;
BEGIN
	Pirate_phase2;
	_insert := FALSE;
	_txt_color := 2;
	Draw(0,167,8,167,_txt_color);
	Draw(8,167,16,167,0);
	GOTOXY(1,21);
	UserString := '';
	Kbd_char := 0;
	FOR _b := 1 TO _str_length
	DO UserString := UserString + ' ';
	_b := 0;
	WHILE Kbd_char <> 13
	DO BEGIN
		InputIsEx := FALSE;
		C_8C09;
		CASE Kbd_char OF
			27: IF InputIsEx
			THEN Game_pause;
			$4d: BEGIN
				IF (_b = 0) AND InputIsEx
				THEN BEGIN
					CASE SceneDir OF
						$f1: UserString := 'EST !   ';
						$f0: UserString := 'OUEST ! ';
						$f2: UserString := 'NORD !  ';
						$f3: UserString := 'SUD !   ';
					END;
					GOTOXY(1,21);
					Kbd_char := 13;
				END;
				IF InputIsEx
				THEN IF _b < _str_length
				THEN _b := _b + 1;
			END;
			$4b: BEGIN
				IF (_b = 0) AND InputIsEx
				THEN BEGIN
					CASE SceneDir OF
						$f1: UserString := 'OUEST ! ';
						$f0: UserString := 'EST !   ';
						$f2: UserString := 'SUD !   ';
						$f3: UserString := 'NORD !  ';
					END;
					GOTOXY(1,21);
					Kbd_char := 13;
				END;
				IF InputIsEx
				THEN IF _b > 0
				THEN _b := _b - 1;
			END;
			$50: BEGIN
				IF (_b = 0) AND InputIsEx
				THEN BEGIN
					CASE SceneDir OF
						$f1: UserString := 'SUD !   ';
						$f0: UserString := 'NORD !  ';
						$f2: UserString := 'EST !   ';
						$f3: UserString := 'OUEST ! ';
					END;
					GOTOXY(1,21);
					Kbd_char := 13;
				END;
			END;
			$48: BEGIN
				IF (_b = 0) AND InputIsEx
				THEN BEGIN
					CASE SceneDir OF
						$f1: UserString := 'NORD !  ';
						$f0: UserString := 'SUD !   ';
						$f2: UserString := 'OUEST ! ';
						$f3: UserString := 'EST !   ';
					END;
					GOTOXY(1,21);
					Kbd_char := 13;
				END;
			END;

			$52: IF InputIsEx
			THEN BEGIN
				_insert := NOT _insert;
				IF _insert = TRUE
				THEN _txt_color := 3
				ELSE _txt_color := 2;
			END;
			8{BACKSPACE}: IF _b > 0
			THEN BEGIN
				DELETE(UserString, _b, 1);
				UserString := UserString + ' ';
				_b := _b - 1;
			END;
			7{DELETE?}: BEGIN
				DELETE(UserString, _b + 1, 1);
				UserString := UserString + ' ';
			END;
		END;

		IF (InputIsEx = FALSE) AND (_b < _str_length)
		THEN BEGIN
			_b := _b + 1;
			IF _insert
			THEN BEGIN
				INSERT(' ', UserString, _b);
				DELETE(UserString, _str_length, 1);
			END;
			UserString[_b] := UPCASE(Kbd_char);
		END;

		IF _insert OR (Kbd_char IN [8,7,$52]) OR InputIsEx
		THEN BEGIN
			GOTOXY(1,21); WRITE(UserString);
		END ELSE BEGIN
			GOTOXY(_b,21); WRITE(UserString[_b]);
		END;

		Draw((_b MOD _str_width - 1) * 8, 167, (_b MOD _str_width)     * 8, 167, 0);
		Draw((_b MOD _str_width)     * 8, 167, (_b MOD _str_width + 1) * 8, 167, _txt_color);
		Draw((_b MOD _str_width + 1) * 8, 167, (_b MOD _str_width + 2) * 8, 167, 0);
		GOTOXY(_b MOD _str_width + 1, 21);
	END;
	FillRect(0,160,328,176,0);
	GOTOXY(1,22); WRITE(UserString);
	PrinterWrite('VOUS : ' + UserString);
	UserString := UserString + ' ';
END;

PROCEDURE {C_9391}IntroAndInit;
BEGIN
	Special_A := FALSE;
	Special_B := FALSE;
	TEXTCOLOR(3);
	D_B0FA := 0;
	UserString := '';

	C_8A46;

	T_Days := 0;

	FOR Int1 := 1 TO MAX_EVENTS
	DO BEGIN
		EvtTimeOk[Int1] := FALSE;
		EvtActiOk[Int1] := FALSE;
		EvtCnd2Ok[Int1] := FALSE;
		EvtCnd1Ok[Int1] := FALSE;
	END;
	FOR Int1 := 1 TO 4
	DO Game_Flags_1[Int1] := 0;
	Game_Flags_2[1] := 0;
	Game_Flags_2[2] := 0;

	D_FD3A := 0;
	D_FD39 := RANDOM(5) + 3;

	Game_init;
END;

PROCEDURE {C_9466}Parse_Word_1;
VAR
	BP_03,BP_04,BP_05,BP_06:BYTE;
BEGIN
	VerbObject[1] := 0;
	D_B0CD := FALSE;
	FOR Int2 := 1 TO 5
	DO BEGIN
		Int3 := POS('-', Scene_tok2[Int2].word);
		BP_03 := POS(COPY(Scene_tok2[Int2].word, 1, Int3 - 1), UserString);
		BP_04 := POS(COPY(Scene_tok2[Int2].word, Int3 + 1, LENGTH(Scene_tok2[Int2].word) - Int3), UserString);
		IF (UserString[BP_03 - 1] = ' ') AND (UserString[BP_04 - 1] = ' ')
		THEN BEGIN
			D_B0CD := TRUE;
			VerbObject[1] := Scene_tok2[Int2].code;

			BP_05 := BP_03;
			REPEAT
				BP_05 := BP_05 + 1;
			UNTIL UserString[BP_05] = ' ';
			DELETE(UserString, BP_03, BP_05);

			BP_05 := BP_04;
			REPEAT
				BP_05 := BP_05 + 1;
			UNTIL UserString[BP_05] = ' ';
			DELETE(UserString, BP_04, BP_05);

			Int3 := POS(' ', COPY(D_B96B, BP_03, LENGTH(D_B96B))) + BP_03 - 2;
			TEXTCOLOR(2);
			GOTOXY(BP_03 - 1, 22);
			FOR BP_06 := BP_03 TO Int3
			DO WRITE(D_B96B[BP_06]);
			TEXTCOLOR(3);

			Int3 := POS(' ', COPY(D_B96B, BP_04, LENGTH(D_B96B))) + BP_04 - 2;
			TEXTCOLOR(2);
			GOTOXY(BP_04 - 1, 22);
			FOR BP_06 := BP_04 TO Int3
			DO WRITE(D_B96B[BP_06]);
			TEXTCOLOR(3);

			EXIT;
		END;
	END;
END;

PROCEDURE {C_9701}Parse_Word_2;
VAR
	BP_03,BP_04,BP_05,BP_06:BYTE;
BEGIN
	VerbObject[2] := 0;
	D_B0CD := FALSE;
	FOR Int2 := 1 TO 20
	DO BEGIN
		Int3 := POS('-', Scene_tok1[Int2].word);
		BP_03 := POS(COPY(Scene_tok1[Int2].word, 1, Int3 - 1), UserString);
		BP_04 := POS(COPY(Scene_tok1[Int2].word, Int3 + 1, LENGTH(Scene_tok1[Int2].word) - Int3), UserString);
		IF (UserString[BP_03 - 1] = ' ') AND (UserString[BP_04 - 1] = ' ')
		THEN BEGIN
			D_B0CD := TRUE;
			VerbObject[2] := Scene_tok1[Int2].code;

			BP_05 := BP_03;
			REPEAT
				BP_05 := BP_05 + 1;
			UNTIL UserString[BP_05] = ' ';
			DELETE(UserString, BP_03, BP_05);

			BP_05 := BP_04;
			REPEAT
				BP_05 := BP_05 + 1;
			UNTIL UserString[BP_05] = ' ';
			DELETE(UserString, BP_04, BP_05);

			Int3 := POS(' ', COPY(D_B96B, BP_03, LENGTH(D_B96B))) + BP_03 - 2;
			TEXTCOLOR(2);
			GOTOXY(BP_03 - 1, 22);
			FOR BP_06 := BP_03 TO Int3
			DO WRITE(D_B96B[BP_06]);
			TEXTCOLOR(3);

			Int3 := POS(' ', COPY(D_B96B, BP_04, LENGTH(D_B96B))) + BP_04 - 2;
			TEXTCOLOR(2);
			GOTOXY(BP_04 - 1, 22);
			FOR BP_06 := BP_04 TO Int3
			DO WRITE(D_B96B[BP_06]);
			TEXTCOLOR(3);

			EXIT;
		END;
	END;
END;

PROCEDURE C_999C;
VAR
	BP_03:BYTE;
	BP_04:BOOLEAN;
	BP_06,BP_08,BP_0A:INTEGER;
	BP_0C:INTEGER;
	BP_2B:STRING[30];
	BP_2C:BYTE;
BEGIN
	D_B0CD := FALSE;
	IF VerbObject[1] > 0
	THEN EXIT;
	BP_04 := TRUE;
	BP_0C := 0;
	WHILE BP_04
	DO BEGIN
		BP_08 := 1;
		BP_0A := 293;
		BP_2B := D_FD3E;
		WHILE NOT D_B0CD
		DO BEGIN
			BP_06 := (BP_08 + BP_0A) DIV 2;
			IF BP_06 = BP_0C
			THEN BP_08 := BP_0A;
			BP_0C := BP_06;
			IF POS(QinBin_2[BP_06].word, BP_2B) = 1
			THEN BEGIN
				VerbObject[1] := QinBin_2[BP_06].code;
				D_B0CD := TRUE;
				EXIT;
			END;
			IF BP_08 < BP_0A
			THEN BEGIN
				IF BP_2B > QinBin_2[BP_06].word
				THEN BP_08 := BP_06;
				IF BP_2B < QinBin_2[BP_06].word
				THEN BP_0A := BP_06;
			END ELSE BEGIN
				EXIT;
			END;
		END;
	END;
END;

PROCEDURE C_9ACB;
VAR
	BP_03:BYTE;
	BP_04:BOOLEAN;
	BP_06,BP_08,BP_0A:INTEGER;
	BP_0C:INTEGER;
	BP_2B:STRING[30];
	BP_2C:BYTE;
BEGIN
	IF VerbObject[2] > 0
	THEN EXIT;
	D_B0CD := FALSE;
	BP_04 := TRUE;
	WHILE BP_04
	DO BEGIN
		BP_08 := 1;
		BP_0A := 322;
		BP_2B := D_FD3E;
		WHILE NOT D_B0CD
		DO BEGIN
			BP_06 := (BP_08 + BP_0A) DIV 2;
			IF BP_06 = BP_0C
			THEN BP_08 := BP_0A;
			BP_0C := BP_06;
			IF POS(QinBin_1[BP_06].word, BP_2B) = 1
			THEN BEGIN
				VerbObject[2] := QinBin_1[BP_06].code;
				D_B0CD := TRUE;
				EXIT;
			END;
			IF BP_08 < BP_0A
			THEN BEGIN
				IF BP_2B > QinBin_1[BP_06].word
				THEN BP_08 := BP_06;
				IF BP_2B < QinBin_1[BP_06].word
				THEN BP_0A := BP_06;
			END ELSE BEGIN
				EXIT;
			END;
		END;
	END;
END;

PROCEDURE C_9BF4;
VAR
	BP_03,BP_04:BYTE;
	BP_05:BYTE;
	BP_06:BYTE;
	BP_08:INTEGER;
	_tmp_str:tString_2A;
BEGIN
	UserInput(1,21,39,40);
	{-- remove minuses --}
	REPEAT
		BP_05 := POS('-', UserString);
		IF BP_05 > 0
		THEN BEGIN
			DELETE(UserString, BP_05, 1);
			INSERT(' ', UserString, BP_05);
		END;
	UNTIL BP_05 = 0;
	{-- remove apostrophes --}
	REPEAT
		BP_05 := POS(#39, UserString);
		IF BP_05 > 0
		THEN BEGIN
			DELETE(UserString, BP_05, 1);
			INSERT(' ', UserString, BP_05);
		END;
	UNTIL BP_05 = 0;

	UserString := ' ' + UserString;
	BP_06 := 0;
	D_B96B := UserString;

	VerbObject[1] := 0;
	Parse_Word_1;
	
	VerbObject[2] := 0;
	Parse_Word_2;

	_tmp_str := UserString;
	IF VerbObject[1] = $01
	THEN BEGIN
		{...}
	END ELSE BEGIN
		_tmp_str := UserString;
		BP_06 := 0;
		REPEAT
			D_B0CD := FALSE;
			BP_05 := POS(' ', UserString);
			D_FD3E := '';
			FOR Int1 := 1 TO BP_05 - 1
			DO D_FD3E := D_FD3E + UserString[Int1];
			DELETE(UserString, 1, BP_05);
			IF LENGTH(D_FD3E) > 1
			THEN BEGIN
				D_B0CD := FALSE;
				C_999C;
				IF D_B0CD
				THEN BEGIN
					BP_06 := BP_06 + 1;
					BP_03 := POS(D_FD3E, D_B96B);
					BP_04 := POS(' ', COPY(D_B96B, BP_03, LENGTH(D_B96B))) + BP_03 - 2;
					TEXTCOLOR(2);
					GOTOXY(BP_03 - 1, 22);
					FOR Int3 := BP_03 TO BP_04
					DO WRITE(D_B96B[Int3]);
					TEXTCOLOR(3);
				END;
			END;
		UNTIL (LENGTH(UserString) < 3) OR (D_B0CD = TRUE);
	END;

	UserString := _tmp_str;

	IF VerbObject[2] <> 0
	THEN BEGIN
		{...}
	END ELSE BEGIN
		D_B0CD := FALSE;
		BP_06 := 0;
		REPEAT

			BP_05 := POS(' ', UserString);
			D_FD3E := '';
			FOR Int1 := 1 TO BP_05 - 1
			DO D_FD3E := D_FD3E + UserString[Int1];
			DELETE(UserString, 1, BP_05);
			IF LENGTH(D_FD3E) > 1
			THEN BEGIN
				D_B0CD := FALSE;
				C_9ACB;
				IF D_B0CD
				THEN BEGIN
					BP_06 := BP_06 + 1;
					BP_03 := POS(D_FD3E, D_B96B);
					BP_04 := POS(' ', COPY(D_B96B, BP_03, LENGTH(D_B96B))) + BP_03 - 2;
					TEXTCOLOR(2);
					GOTOXY(BP_03 - 1, 22);
					FOR Int3 := BP_03 TO BP_04
					DO WRITE(D_B96B[Int3]);
					TEXTCOLOR(3);
				END;
			END;
		UNTIL (LENGTH(UserString) < 3) OR (D_B0CD = TRUE);
	END;
END;

PROCEDURE C_A045;
VAR
	BP_03:BYTE;
BEGIN
	D_AC16 := D_AC16 + 1;
	IF D_AC16 > 3
	THEN D_AC16 := 1;
	BP_03 := VerbObject[1];
	IF BP_03 = 0
	THEN EXIT;
	C_6349(QinBin_345[D_AC16][BP_03]);
END;

PROCEDURE C_A0B3;
VAR
	BP_03,BP_04:BYTE;
BEGIN
	IF (D_FD3C = 1) AND (D_FD33[1] <> 0)
	THEN D_FD3C := 2;
	BP_04 := 0;
	FOR BP_03 := 1 TO 6
	DO IF D_FD33[BP_03] = SequenceNum
	THEN BP_04 := 1;
	IF BP_04 = 0
	THEN BEGIN
		D_FD33[D_FD3C] := SequenceNum;
		D_FD3C := D_FD3C + 1;
	END;
END;

PROCEDURE C_A15F;
VAR
	BP_03:BYTE;
BEGIN
	NotEnoughMoney := FALSE;
	TryToPay;
	IF NotEnoughMoney = TRUE
	THEN EXIT;

	IF
		((Events[EvtNum].f_24 > 0) AND (Special_A = FALSE)) OR
		((SequenceNum = 32) AND (NumScenar = 3))
	THEN BEGIN
		SOUND(300);
		DELAY(100);
		NOSOUND;
		DELAY(2000);
		C_4469(Events[EvtNum].f_24 - 1);
		SOUND(600);
		DELAY(100);
		NOSOUND;
	END;

	IF (Events[EvtNum].f_24 > 0) AND Special_A
	THEN BEGIN
		Image_load(SequenceNum);
		Image_refresh(-1,-1);
		C_A0B3;
		IF SequenceNum * NumScenar <> 96 {32 * 3}
		THEN BEGIN
			SOUND(300);
			DELAY(100);
			NOSOUND;
			DELAY(2000);
			C_4469(Events[EvtNum].f_24 - 1);
			SOUND(600);
			DELAY(100);
			NOSOUND;
			DELAY(1000);
			Special_A := FALSE;
		END;
	END;

	FOR BP_03 := 1 TO 4
	DO Game_Flags_1[BP_03] := Game_Flags_1[BP_03] XOR Events[EvtNum].f_flags1[BP_03];
	FOR BP_03 := 1 TO 2
	DO Game_Flags_2[BP_03] := Game_Flags_2[BP_03] XOR Events[EvtNum].f_flags2[BP_03];

	C_7CA3(Events[EvtNum].f_25, Events[EvtNum].f_26);
END;

PROCEDURE C_A38A;
VAR
	BP_03:BYTE;
	BP_04:BYTE;
	_vo,_evt,_counter,BP_08:BYTE;
	BP_09:BYTE;
BEGIN
	EvtTriggered := FALSE;
	BP_03 := 0;

	IF VerbObject[1] = 0
	THEN EXIT;

	FOR _evt := 1 TO NumEvts
	DO BEGIN
		_counter := 0;
		GOTOXY(1, 5);
		FOR _vo := 1 TO 5
		DO IF (
			(
				(VerbObject[1] = Events[_evt].f_verb_obj[2 * _vo - 1]) AND
				(VerbObject[2] = Events[_evt].f_verb_obj[2 * _vo])
			) OR (
				(VerbObject[1] = Events[_evt].f_verb_obj[2 * _vo - 1]) AND
				(Events[_evt].f_verb_obj[2 * _vo] = 0)
			) OR (
				(Events[_evt].f_verb_obj[2 * _vo - 1] = 0) AND
				(VerbObject[2] = Events[_evt].f_verb_obj[2 * _vo]))
			) AND
				(Events[_evt].f_verb_obj[2 * _vo - 1] + Events[_evt].f_verb_obj[2 * _vo] > 0)
		THEN _counter := _counter + 1;
		EvtActiOk[_evt] := _counter > 0;
		IF EvtActiOk[_evt] = TRUE
		THEN BEGIN
			_counter := 0;
			FOR BP_08 := 1 TO 4
			DO IF (Game_Flags_1[BP_08] AND Events[_evt].f_mask1[BP_08]) = Events[_evt].f_res1[BP_08]
			THEN _counter := _counter + 1;
			EvtCnd1Ok[_evt] := _counter = 4;

			_counter := 0;
			FOR BP_08 := 1 TO 2
			DO IF (Game_Flags_2[BP_08] AND Events[_evt].f_mask2[BP_08]) = Events[_evt].f_res2[BP_08]
			THEN _counter := _counter + 1;
			EvtCnd2Ok[_evt] := _counter = 2;

			IF T_Hours = 24
			THEN T_Hours := 0;
			IF
				((T_Hours >= Events[_evt].f_schedule[1]) AND (T_Hours < Events[_evt].f_schedule[2])) OR
				((T_Hours >= Events[_evt].f_schedule[3]) AND (T_Hours < Events[_evt].f_schedule[4])) OR
				((T_Hours >= Events[_evt].f_schedule[5]) AND (T_Hours < Events[_evt].f_schedule[6]))
			THEN EvtTimeOk[_evt] := TRUE
			ELSE EvtTimeOk[_evt] := FALSE;

			IF EvtCnd2Ok[_evt] AND EvtCnd1Ok[_evt] AND EvtActiOk[_evt] AND EvtTimeOk[_evt]
			THEN BEGIN
				EvtTriggered := TRUE;
				EvtNum := _evt;
				EXIT;
			END;
		END;
	END;
END;

PROCEDURE C_A86B;
VAR
	BP_03:BYTE;
BEGIN
	BP_03 := RANDOM(7);
	CASE BP_03 OF
		0: C_6349('Mon ignorance est aussi ‚tendue  qu' + CHR(39) + 'une mer brumeuse.');
		1: C_6349('J' + CHR(39) + 'ai beau me creuser la tˆte, je n' + CHR(39) + 'y    suis vraiment pas.');
		2: C_6349('La profondeur de vos propos me montre   les limites de mon savoir.');
		3: C_6349('Je ne vous ai pas compris, je ne suis   qu' + CHR(39) + 'un mis‚rable sot.');
		4: C_6349('Pourriez vous adapter vos propos … mes  faibles connaissances de votre si jolie langue,honorable personne.');
		5: C_6349('Jamais je ne pourrai oublier l' + CHR(39) + 'affront  que je vous fais en ne vous comprenant  pas.');
		6: C_6349('Charm‚ par la m‚lodie de vos propos, je n' + CHR(39) +
			'en ai malheureusement pas saisi toutes les subtilit‚s.');
	END;
END;

PROCEDURE {C_AB99}Game_ending;
BEGIN
	DELAY(1000);
	FillRect(48,0,272,15,0);
	FillRect(0,160,320,200,0);
	FOR SequenceNum := 33 TO 34
	DO BEGIN
		DELAY(5000);
		Image_load(SequenceNum);
		Image_refresh(-1,-1);
	END;
	DELAY(5000);
	Image_load(35);
	Image_refresh(-1,-1);
	WHILE 1 = 1
	DO MusicPlay;
END;

PROCEDURE C_AC3E;
BEGIN
	D_FD5D := FALSE;
	CASE NumScenar OF
		1: BEGIN
			IF SequenceNum = 39
			THEN BEGIN
				SequenceNum := 40;
				Special_A := TRUE;
				D_FD5D := TRUE;
				C_6349('Les tartares vous font prisonnier.');
				EXIT;
			END;
			IF SequenceNum = 40
			THEN BEGIN
				SequenceNum := 41;
				Special_A := TRUE;
				Special_B := TRUE;
				D_FD5D := TRUE;
				C_6349('Les tartares vous mŠnent … leur chef.');
				EXIT;
			END;
			IF SequenceNum = 30
			THEN BEGIN
				Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND 2);
				RefreshMapNum(1);
			END;
			IF SequenceNum = 42
			THEN BEGIN
				Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND 2);
				RefreshMapNum(2);
			END;
			IF (SequenceNum = 44) AND (NumMaps = 2)
			THEN BEGIN
				Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND 2);
				RefreshMapNum(3);
			END;
			IF (SequenceNum = 44) AND (NumMaps <> 3)
			THEN BEGIN
				Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND 2);
				RefreshMapNum(NumMaps);
			END;
		END;
		2: BEGIN
			IF SequenceNum = 2
			THEN BEGIN
				Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND 2);
				RefreshMapNum(4);
			END;
			IF SequenceNum = 34
			THEN BEGIN
				Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND 2);
				RefreshMapNum(5);
			END;
		END;
	END;
END;

PROCEDURE C_AE39;
BEGIN
	NumScenar := 2;

	REPEAT UNTIL KEYPRESSED;
	RequestFloppy(2);
	Scenar2_load;
	Image_load(94);
	Image_refresh(-1,-1);
	C_6349('APPUYEZ SUR UNE TOUCHE...');
	REPEAT UNTIL KEYPRESSED;
	Image_load(1);
	SequenceNum := 1;
	Scene_new(DIR_data[SequenceNum]);
	Image_refresh(-1,-1);
	Game_Flags_2[1] := Game_Flags_2[1] XOR 2;
	Game_Flags_2[1] := Game_Flags_2[1] XOR 1;
	Game_Flags_1[3] := 0;
	Game_Flags_1[2] := 0;
	Game_Flags_1[1] := Game_Flags_1[1] AND $10;
	Game_Flags_1[4] := 7;
	HasMap[4] := 0;
	HasMap[5] := 0;
	NumMaps := 3;
	RefreshMapNum(NumMaps);
	Special_B := FALSE;
	Special_A := FALSE;
	D_FD33[1] := 1;
	D_FD3C := 2;
END;

PROCEDURE C_AF2C;
BEGIN
	NumScenar := 3;
	C_6349('Les dieux vous rappellent.');
	REPEAT UNTIL KEYPRESSED;
	RequestFloppy(2);
	Load_Scenar3;
	Image_load(93);
	Image_refresh(-1,-1);
	C_6349('APPUYEZ SUR UNE TOUCHE...');
	REPEAT UNTIL KEYPRESSED;
	Image_load(1);
	SequenceNum := 1;
	Scene_new(DIR_data[SequenceNum]);
	Image_refresh(-1,-1);
	Game_Flags_1[3] := 0;
	Game_Flags_1[2] := 0;
	Game_Flags_1[1] := 0;
	Game_Flags_1[4] := $1f;
	Game_Flags_2[1] := Game_Flags_2[1] XOR (Game_Flags_2[1] AND $80);
	Game_Flags_2[1] := Game_Flags_2[1] XOR (Game_Flags_2[1] AND $20);
	Game_Flags_2[1] := Game_Flags_2[1] XOR (Game_Flags_2[1] AND 2);
	Game_Flags_2[1] := Game_Flags_2[1] XOR (Game_Flags_2[1] AND 1);
	Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND $80);
	Game_Flags_2[2] := Game_Flags_2[2] XOR (Game_Flags_2[2] AND $20);
	Special_B := FALSE;
	Special_A := FALSE;
	D_FD33[1] := 1;
	D_FD3C := 2;
END;

PROCEDURE {C_B087}Scenar_events;
VAR
	BP_03:BYTE;
	_day_str,_hour_str:STRING[6];
BEGIN
	CASE NumScenar OF
		1: BEGIN
			CASE SequenceNum OF
				14: IF T_Hours IN [0..3,7..11,15..21]
				THEN BEGIN
					SequenceNum := 12;
					Special_A := TRUE;
					Special_B := TRUE;
				END;
				20: IF T_Hours IN [4..6,12..14,22..24]
				THEN BEGIN
					SequenceNum := 18;
					Special_A := TRUE;
					Special_B := TRUE;
				END;
				21: IF T_Hours IN [0..7,23..24]
				THEN BEGIN
					SequenceNum := 22;
					Special_A := TRUE;
					Special_B := TRUE;
				END;
				45: IF HasMap[1] * HasMap[2] * HasMap[3] = 1
				THEN C_AE39;
			END;
			IF SequenceNum IN [0..5,8..200]
			THEN Game_Flags_1[1] := Game_Flags_1[1] XOR (Game_Flags_1[1] AND $20);
			IF SequenceNum IN [0..14,18..200]
			THEN Game_Flags_1[2] := Game_Flags_1[2] XOR (Game_Flags_1[2] AND $20);
			IF SequenceNum IN [12,14,18,20]
			THEN BEGIN
				Game_Flags_1[1] := Game_Flags_1[1] XOR (Game_Flags_1[1] AND 1);
				Game_Flags_1[1] := Game_Flags_1[1] XOR (Game_Flags_1[1] AND 2);
			END;
			IF SequenceNum IN [0..32,37..200]
			THEN BEGIN
				Game_Flags_1[3] := Game_Flags_1[3] XOR (Game_Flags_1[3] AND 1);
				Game_Flags_1[3] := Game_Flags_1[3] XOR (Game_Flags_1[3] AND 2);
			END;
		END;
		2: BEGIN
			IF SequenceNum IN [0..3,6..200]
			THEN Game_Flags_1[1] := Game_Flags_1[1] XOR (Game_Flags_1[1] AND 4);
			IF SequenceNum IN [0..32,36..200]
			THEN Game_Flags_1[3] := Game_Flags_1[3] XOR (Game_Flags_1[3] AND $40);
			IF SequenceNum IN [0..10,14..200]
			THEN Game_Flags_1[1] := Game_Flags_1[1] XOR (Game_Flags_1[1] AND 2);
			IF SequenceNum IN [0..22,28..200]
			THEN Game_Flags_1[2] := Game_Flags_1[2] XOR (Game_Flags_1[2] AND $40);
			IF SequenceNum = 23
			THEN BEGIN
				Game_Flags_1[2] := Game_Flags_1[2] XOR (Game_Flags_1[2] AND $20);
				Game_Flags_1[2] := Game_Flags_1[2] XOR (Game_Flags_1[2] AND $10);
				Game_Flags_1[2] := Game_Flags_1[2] XOR (Game_Flags_1[2] AND 8);
			END;
			IF (NumMaps = 5) AND ((Game_Flags_2[2] AND $70) = $70)
			THEN D_FD3A := D_FD3A + 1;
			IF (NumMaps = 5) AND ((Game_Flags_2[2] AND $70) = $70) AND (D_FD3A > D_FD39)
			THEN C_AF2C;
		END;
		3: BEGIN
			IF SequenceNum  = 32
			THEN Game_ending;
			IF SequenceNum = 5
			THEN BEGIN
				DELAY(1500);
				Image_load(7);
				Compass_draw;
				Image_refresh(-1,-1);
				C_6349('Vous survolez cette glorieuse arm‚e.');
				DELAY(1500);
				SequenceNum := 7;
				FillRect(48,0,272,15,0);
				ColorTable(1,0,0,0);
				GOTOXY(7,1); WRITE('L' + #39 + 'arm‚e de terre...');
				PrinterWrite('SCENE :' + 'L' + #39 + 'arm‚e de terre...');
				STR(T_Days, _day_str);
				STR(T_Hours, _hour_str);
				PrinterWrite('TEMPS :' + _day_str + ' Jrs  ' + _hour_str + ' Hrs');
				FillRect(48,0,272,15,-1);
			END;
			IF SequenceNum = 7
			THEN BEGIN
				Image_load(6);
				Compass_draw;
				Image_refresh(-1,-1);
				DELAY(1500);
				SequenceNum := 6;
			END;
			IF SequenceNum = 6
			THEN BEGIN
				Image_load(8);
				Compass_draw;
				Image_refresh(-1,-1);
				DELAY(1500);
				SequenceNum := 8;
			END;
			IF SequenceNum = 8
			THEN BEGIN
				Image_load(9);
				Compass_draw;
				Image_refresh(-1,-1);
				DELAY(1500);
				SequenceNum := 9;
			END;
			IF SequenceNum = 9
			THEN BEGIN
				Special_A := TRUE;
				SequenceNum := 10;
				Special_B := TRUE;
				C_6349('Votre pouvoir se termine, vous reprenez contact avec le sol.');
			END;
		END;
	END;
END;

PROCEDURE {C_B6FA}Draw_map;
VAR
	_map_id:BYTE;
BEGIN
	_map_id := VerbObject[2] - $30;
	IF (SequenceNum IN [28..31]) AND (_map_id * HasMap[_map_id] = 1) AND (NumScenar = 1)
	THEN BEGIN
		C_6349('Le plan disparait!. Il vous avait bien  dit de ne pas le regarder.');
		NumMaps := NumMaps - 1;
		HasMap[1] := 0;
		RefreshMapNum(NumMaps);
		IF (Game_Flags_1[4] AND 4) = 4
		THEN Game_Flags_1[4] := Game_Flags_1[4] XOR 4;
		EXIT;
	END;
	IF HasMap[_map_id] = 1
	THEN BEGIN
		Image_load(94 + _map_id);
		Image_refresh(-1,-1);
		C_6349('Voila le plan ' + CHR(_map_id + $30) + ' !');
		Kbd_clrBuffer;
		REPEAT UNTIL KEYPRESSED;
		FOR Int2 := 1 TO D_FD3C
		DO BEGIN
			Image_load(D_FD33[Int2]);
			IF Int2 = 1
			THEN Compass_draw;
			Image_refresh(-1,-1);
		END;
	END;
	IF HasMap[_map_id] = 0
	THEN C_6349('Vous n' + #39 + 'avez pas le plan ' + CHR(_map_id + $30) + ' !');
END;

PROCEDURE {C_B8FF}WaitApologies;
LABEL C_B95B;
BEGIN
	Compass_draw;
	Image_load(101);
	Image_refresh(-1,-1);
	C_6349('Voil… ce qui attend les grossiers       personnages.');
C_B95B:
	C_9BF4;
	IF VerbObject[2] = $3c
	THEN BEGIN
		C_6349('Vous voyez, ce n' + #39 + 'est pas si difficile!.');
		Compass_draw;
		FOR Int2 := 1 TO D_FD3C
		DO BEGIN
			Image_load(D_FD33[Int2]);
			Image_refresh(-1,-1);
		END;
		EXIT;
	END;
	C_6349('Ce n' + #39 + 'est pas cela que j' + #39 + 'attends. Et     VLAN, encore un coup de fouet !');
	GOTO C_B95B;
END;

{=====----- main routine -----=====}
LABEL LoopTop;

{C_BA63}BEGIN
	C_5DEC;

	IsPirated := FALSE;
	Pirate_phase1;{to skip test, comment here!}

	UserString := '';
	IntroAndInit;
	SequenceNum := 1;
	D_FD3C := 1;
	TimerFlag := TRUE;

	WHILE 1 = 1
	DO BEGIN
{C_BA9D}LoopTop:
		Scenar_events;
		{====---- end of game ----====}
		IF
			(SequenceNum = 100) OR
			((SequenceNum = 11) AND (NumScenar = 3)) OR
			((SequenceNum = 20) AND (NumScenar = 3))
		THEN BEGIN
			Image_load(SequenceNum);
			IF NumScenar <> 2
			THEN Scene_new(DIR_data[SequenceNum]);
			Image_refresh(-1,-1);
			REPEAT UNTIL KEYPRESSED;
			C_6349('Une autre partie (O/N) ?');
			D_B997 := ' ';
			WHILE (D_B997 <> 'O') AND (D_B997 <> 'o') AND (D_B997 <> 'N') AND (D_B997 <> 'n') 
			DO READ(KBD,D_B997);
			IF D_B997 IN ['O','o']
			THEN BEGIN
				Game_reset;
				FillRect(0,176,320,200,0);
				GOTO LoopTop;
			END ELSE BEGIN
				DirtyExit;
			END;
		END;
		{====---- ----====}
		D_B0CB := FALSE;
		IF Special_A
		THEN BEGIN
			D_B0CB := TRUE;
			Image_load(SequenceNum);
			C_A0B3;
		END;
		IF Special_B
		THEN BEGIN
			Scene_new(DIR_data[SequenceNum]);
			D_FD33[1] := SequenceNum;
			D_FD3C := 1;
		END;
		IF D_B0CB
		THEN Image_refresh(-1,-1);

		C_9BF4;
		{====---- insult? ----====}
		IF VerbObject[2] = $41
		THEN BEGIN
			WaitApologies;
			GOTO LoopTop;
		END;
		{====---- save game ----====}
		IF VerbObject[1] = $0e
		THEN BEGIN
			Game_save;
			GOTO LoopTop;
		END;
		{====---- ----====}
		Special_B := FALSE;
		Special_A := FALSE;
		Game_Flags_2[2] := Game_Flags_2[2] OR 2;

		C_AC3E;
		IF D_FD5D = TRUE
		THEN GOTO LoopTop;

		C_A38A;

		FillRect(0,176,320,200,0);

		IF EvtTriggered
		THEN BEGIN
			Int1 := EvtNum;
			C_6349(D_B2D1[Int1]);
			Special_B := Events[Int1].f_23 = 1;
			Special_A := Events[Int1].f_22 > 0;
			IF Special_A
			THEN SequenceNum := Events[Int1].f_22;
			C_A15F;
			RefreshMapNum(NumMaps);
		END;

		IF EvtTriggered = FALSE
		THEN BEGIN
			{====---- map related ----====}
			IF ((VerbObject[1] = $16) OR (VerbObject[1] = $05)) AND (VerbObject[2] IN [$31..$35])
			THEN BEGIN
				Draw_map;
				GOTO LoopTop;
			END;
			IF ((VerbObject[1] = $16) OR (VerbObject[1] = $05)) AND (VerbObject[2] = $38)
			THEN BEGIN
				C_6349('Pr‚cisez le num‚ro du plan. ex:         VOIR PLAN 1.');
				GOTO LoopTop;
			END;
			{====---- ----====}
			CASE VerbObject[1] OF
				$16: IF (VerbObject[2] = $2c) AND ((Game_Flags_2[1] OR $80) = Game_Flags_2[1])
				THEN BEGIN
					C_6349('Le texte transmis de g‚n‚rations en     g‚n‚rations se trouve dans votre manuel.');
					Game_Flags_1[1] := Game_Flags_1[1] OR 8;
				END ELSE BEGIN
					C_A045;
				END;
				0: IF VerbObject[2] = 0
				THEN BEGIN
					C_A86B;
				END ELSE BEGIN
					GOTOXY(1,23); WRITE('PAS COMPRIS LE VERBE');
				END;
				$41: BEGIN
					Draw_Inventory;
					C_A045;
					REPEAT UNTIL KEYPRESSED;
					Compass_draw;
					IF D_FD3C > 1
					THEN BEGIN
						FOR Int2 := 1 TO D_FD3C - 1
						DO BEGIN
							Image_load(D_FD33[Int2]);
							Image_refresh(-1,-1);
						END;
					END ELSE BEGIN
						Image_refresh(-1,-1);
					END;
				END;
				ELSE C_A045;
			END;
		END;

	END;{end of WHILE 1 = 1}
END.
