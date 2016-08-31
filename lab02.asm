TITLE	lab02
; Programmer:	Marcus Ross
; Due:		28 Feb,  2014
; Description:	This program prompts the user for 4 integers then subtracts them from a hardcoded number. It displays a report that shows the date of the run as well as the result of the aforementioned operation.

	.MODEL SMALL
	.386
	.STACK 64
;==========================
	.DATA
num	EQU	1986
result	DW	?
prmptMsg	DB	'Enter an integer: $'
head	DB	205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 13, 10, 'Number Subtractor', 13, 10, 36	; before the title is a long double line--this used to be two different arrays, but that was pointless
slash	DB	'/$'
text	DB	13, 10, 10, 'The resulting value is $' ; this also used to be two arrays
;==========================
	.CODE
	EXTRN	GetDec : NEAR, PutDec : NEAR

Main	PROC	NEAR
	mov	ax, @data	; init data
	mov	ds, ax		; segment register

	call 	Prompts		; prompt user for 3 integers
	call 	SumInput		; add numbers from user
	call 	Subtract		; subtract sum from constant
	call 	Report		; display report

	mov	ax, 4c00h	; return code 0
	int	21h

Main	ENDP
;==========================
Prompts	PROC	NEAR
	mov	dx, OFFSET prmptMsg	; display prompt
	mov	ah, 9
	int	21h
	call	GetDec			; get input
	mov	bx, ax			; put input in bx
	mov	ah, 9			; display prompt
	int	21h
	call	GetDec			; get input
	mov	cx, ax			; put input in cx
	mov	ah, 9			; display prompt
	int	21h
	call	GetDec			; get input
	mov	dx, ax			; put input in dx
	push	dx			; save value
	mov	dx, OFFSET prmptMsg	; display prompt
	mov	ah, 9
	int	21h
	pop	dx
	call	GetDec			; get input, and leave in ax
	ret
	ENDP
;==========================
SumInput	PROC	NEAR
	add	bx, ax	; add rest of inputs to the input in bx, and leave in bx
	add	bx, cx
	add	bx, dx
	ret
	ENDP
;==========================
Subtract	PROC	NEAR
	mov	ax, num		; prep num for subtraction
	sub	ax, bx		; subtract sum of inputs
	mov	result, ax	; store result in result
	ret
	ENDP
;==========================
Report	PROC	NEAR
	mov	dx, OFFSET head
	mov	ah, 9		; display heading
	int	21h
	mov	ah, 2ah		; get date
	int	21h
	mov	al, dh		; prepare month for display
	cbw			; zero ah so it's not displayed by PutDec
	call	PutDec		; display month
	mov	al, dl		; prepare day for display, but don't display yet
	mov	dx, OFFSET slash	; display slash
	mov	ah, 9
	int	21h
	cbw			; reckon this's more efficient than "sub ah,ah" or "xor ah,ah"?
	call	PutDec		; display day
	mov	dx, OFFSET slash	; display slash
	mov	ah, 9
	int	21h
	mov	ax, cx		; cx = year
	call	PutDec		; display year
	mov	dx, OFFSET text	; display slash
	mov	ah, 9
	int	21h
	mov	ax, result	; prep result for display
	call	PutDec
	ret
	ENDP
;==========================
	END	Main