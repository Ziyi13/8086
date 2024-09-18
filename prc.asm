.MODEL SMALL
.STACK 100
.DATA

    REPORTMENU DB "REPORT MENU$"
    OPTION1 DB "1. VIEW TOTAL SALES REPORT$"
    OPTION2 DB "2. VIEW INVENTORY REPORT$"
    OPTION3 DB "3. RETURN MAIN MENU$"
    PROMPTMSG DB "ENTER CHOICE (1-3): $"
    REPORTCHOICE DB ?
    INAVLIDMSG DB "INVALID CHOICE, TRY AGAIN.$"
    TITLE1 DB "TOTAL SALES REPORT$"
    TITLE2 DB "INVENTORY REPORT$"
    BUFFER      DB 6 DUP (?)  ; Buffer to store the ASCII digits
    PRICE_PREFIX DB "       Price: $"
    SOLD_PREFIX DB "       Sold Quantity: $"
    STOCK_PREFIX DB "       Stock Quantity: $"

    ;Book (8)
    Whispers    DB "Whispers$"
    Echo        DB "Echo$"
    Locket      DB "Locket$"
    Willow      DB "Willow$"
    Rendezvous  DB "Rendezvous$"
    Crimson     DB "Crimson$"
    Shadows     DB "Shadows$"
    Memories    DB "Memories$"

    ; Create a table of addresses for the book names
    BookNames   DW OFFSET Whispers, OFFSET Echo, OFFSET Locket, OFFSET Willow
                DW OFFSET Rendezvous, OFFSET Crimson, OFFSET Shadows, OFFSET Memories


    ;Book Price
    WhispersP    DB 10
    EchP        DB 25
	LocketP      DB 16
	WillowP     DB 17
	RendezvousP  DB 10
	CrimsonP     DB 12
	ShadowsP     DB 13
	MemoriesP    DB 15

    Price DB 10, 25, 16, 17, 10, 12, 13, 15


	
    ;Book left quantity
    LeftQuantity DW 155, 288, 123, 262, 165, 256, 278, 132

    ;Book sold quantity
    SoldQuantity DB 5, 10, 20, 15, 30, 35, 40, 45


	
    ; Genre Strings
    Horror      DB "Horror$"
    Romance     DB "Romance$"
    Adventure   DB "Adventure$"
    NonFiction  DB "Non-fiction$"
    Education   DB "Education$"

    ; Genre Array (store the offsets of the genre strings)
    Genre DW Horror, Romance, Adventure, NonFiction, Romance, Education, Horror, Romance


    KWY DB "Koh Win Yee$"
    CJY DB "Chiam Jian Yu$"
    LZY DB "Lau Zi Lin$"
    LXY DB "Loke Xin Yee$"

    DAuthor DW KWY, KWY, CJY, CJY, LZY, LZY, LXY, LXY

    ;Payment method
    TNG DB "Touch N Go$"
    CARD DB "Card$"
    CASH DB "Cash$"

    ;Sales
    SALES DW 1000
	
	TEN DB 10
	HUN DB 100
	NL DB 0AH,0DH,"$"



.CODE
MAIN PROC

	MOV AX,@DATA
	MOV DS,AX

    ;menu loop
RPTMENU_LOOP:

    ;display menu
    CALL DISPLAYMENU

    ;get user input
    CALL GETINPUT

    ;check input
    CMP REPORTCHOICE,1
    JNE CHECK_CHOICE2
    CALL VIEWTOTALSALESREPORT
    JMP RPTMENU_LOOP  ; Ensure return to menu loop

CHECK_CHOICE2:
    CMP REPORTCHOICE,2
    JNE CHECK_CHOICE3
    CALL VIEWINVENTORYREPORT
    JMP RPTMENU_LOOP  ; Ensure return to menu loop

CHECK_CHOICE3:
    CMP REPORTCHOICE,3
    JNE INVALID_INPUT
    JMP EXITMENU

INVALID_INPUT:
    ;display invalid msg
    CALL DISPLAYINVALID
    JMP RPTMENU_LOOP


DISPLAYMENU PROC

    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H
    
 	MOV AH,09H
	LEA DX,REPORTMENU
	INT 21H
    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    ;OPTION1
    MOV AH,09H
	LEA DX,OPTION1
	INT 21H
    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    ;OPTION2
    MOV AH,09H
	LEA DX,OPTION2
	INT 21H
    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    ;OPTION3
    MOV AH,09H
	LEA DX,OPTION3
	INT 21H
    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    ;PROMPT INPUT
    MOV AH,09H
	LEA DX,PROMPTMSG
	INT 21H

    RET
    
DISPLAYMENU ENDP


GETINPUT PROC
	;INPUT
	MOV AH,01H
	INT 21H
	SUB AL,30H
	MOV REPORTCHOICE,AL

    RET
GETINPUT ENDP

DISPLAYINVALID PROC
    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H
    MOV AH,09H
	LEA DX,INAVLIDMSG
	INT 21H
    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H
    
    RET
DISPLAYINVALID ENDP


VIEWTOTALSALESREPORT PROC


    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    ; Display the title of the report
    MOV AH,09H
	LEA DX,TITLE1   
	INT 21H

    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
    INT 21H

    ; Set up loop counter for 8 books
    MOV CX, 8
    XOR SI, SI        ; Initialize loop counter for 8 books

NEXT_BOOK:
    ; Access the book name address by loading from BookNames array
    MOV BX, [BookNames + SI]  ; Load address of the book name into BX
    MOV AH, 09H
    MOV DX, BX
    INT 21H              ; Display the book name

    MOV AH,09H
	LEA DX,PRICE_PREFIX  
	INT 21H

    MOV BX, SI
    SHR BX, 1

    ; Display 2 digits of the price
	MOV AH,0H
	MOV AL, [Price + BX]
	DIV TEN
	MOV BX,AX

	MOV AH,02H
	MOV DL,BL
	ADD DL,30H
	INT 21H

	MOV AH,02H
	MOV DL,BH
	ADD DL,30H
	INT 21H

    MOV AH,09H
	LEA DX,SOLD_PREFIX  
	INT 21H

    MOV BX, SI
    SHR BX, 1

    ; Display 2 digits of the price
	MOV AH,0H
	MOV AL, [SoldQuantity + BX]
	DIV TEN
	MOV BX, AX

	MOV AH,02H
	MOV DL,BL
	ADD DL,30H
	INT 21H

	MOV AH,02H
	MOV DL,BH
	ADD DL,30H
	INT 21H


    ; Display New Line
    MOV AH, 09H
    LEA DX, NL
    INT 21H

    ; Increment SI by 2 to point to the next word (since addresses are word-sized)
    ADD SI, 2

       ; Display New Line for separation between books
    MOV AH, 09H
    LEA DX, NL
    INT 21H

   
    LOOP NEXT_BOOK

    RET
VIEWTOTALSALESREPORT ENDP







VIEWINVENTORYREPORT PROC

    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
	INT 21H

    MOV AH,09H
	LEA DX,TITLE2
	INT 21H

    ;TO DISPLAY NEW LINE
	MOV AH,09H
	LEA DX,NL
    INT 21H

    ; Set up loop counter for 8 books
    MOV CX, 8
    XOR SI, SI        ; Initialize loop counter for 8 books

NEXT_BOOK2:
    ; Access the book name address by loading from BookNames array
    MOV BX, [BookNames + SI]  ; Load address of the book name into BX
    MOV AH, 09H
    MOV DX, BX
    INT 21H              ; Display the book name


    MOV AH,09H
	LEA DX,STOCK_PREFIX  
	INT 21H

    MOV BX, SI
    SHR BX, 1

    ; Display 3 digits of the quantity
    MOV AH,0H
	MOV AX,[LeftQuantity + SI]
	DIV HUN
	MOV BX,AX

    PUSH DX     ; Save remainder
    PUSH AX     ; Save hundreds digit for later use

    MOV AX, DX
    
	MOV AH,0H
	MOV AL,BH
	DIV TEN
	MOV BX,AX

	MOV AH,02H
	MOV DL,BL
	ADD DL,30H
	INT 21H

	MOV AH,02H
	MOV DL,BH
	ADD DL,30H
	INT 21H



    ; Display New Line
    MOV AH, 09H
    LEA DX, NL
    INT 21H

    ; Increment SI by 2 to point to the next word (since addresses are word-sized)
    ADD SI, 2

       ; Display New Line for separation between books
    MOV AH, 09H
    LEA DX, NL
    INT 21H

   
    LOOP NEXT_BOOK2

    JMP RPTMENU_LOOP
VIEWINVENTORYREPORT ENDP







EXITMENU PROC
MOV AX,4C00H
	INT 21H

EXITMENU ENDP

MAIN ENDP
END MAIN