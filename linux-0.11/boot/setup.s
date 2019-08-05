!
!	setup.s		(C) 1991 Linus Torvalds
!
! setup.s is responsible for getting the system data from the BIOS,
! and putting them into the appropriate places in system memory.
! both setup.s and system has been loaded by the bootblock.
!
! This code asks the bios for memory/disk/other parameters, and
! puts them in a "safe" place: 0x90000-0x901FF, ie where the
! boot-block used to be. It is then up to the protected mode
! system to read them from there before the area is overwritten
! for buffer-blocks.
!

! NOTE! These had better be the same as in bootsect.s!

INITSEG  = 0x9000	! we move boot here - out of the way
SYSSEG   = 0x1000	! system loaded at 0x10000 (65536).
SETUPSEG = 0x9020	! this is the current segment

.globl begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text

entry start
start:

!!!!===============code begins here=============!!!!
	mov 	ax,#SETUPSEG
	mov	es,ax
	mov	ah,#0x03
	xor	bh,bh
	int 	0x10

	mov	cx,#25
	mov	bx,#0x0007
	mov	bp,#msg2
	mov	ax,#0x1301
	int	0x10 

!!!!============================================!!!!
! ok, the read went well so we get current cursor position and save it for
! posterity.

	mov	ax,#INITSEG	! this is done in bootsect already, but...
	mov	ds,ax
	mov	ah,#0x03	! read cursor pos
	xor	bh,bh
	int	0x10		! save it in known place, con_init fetches
	mov	[0],dx		! it from 0x90000.
! Get memory size (extended mem, kB)

	mov	ah,#0x88
	int	0x15
	mov	[2],ax

! Get video-card data:

	mov	ah,#0x0f
	int	0x10
	mov	[4],bx		! bh = display page
	mov	[6],ax		! al = video mode, ah = window width

! check for EGA/VGA and some config parameters

	mov	ah,#0x12
	mov	bl,#0x10
	int	0x10
	mov	[8],ax
	mov	[10],bx
	mov	[12],cx

! Get hd0 data

	mov	ax,#0x0000
	mov	ds,ax
	lds	si,[4*0x41]
	mov	ax,#INITSEG
	mov	es,ax
	mov	di,#0x0080
	mov	cx,#0x10
	rep
	movsb

! Get hd1 data

	mov	ax,#0x0000
	mov	ds,ax
	lds	si,[4*0x46]
	mov	ax,#INITSEG
	mov	es,ax
	mov	di,#0x0090
	mov	cx,#0x10
	rep
	movsb
!!!!==================================!!!!
	mov	ax,#SETUPSEG
	mov 	ds,ax
	mov	es,ax

!print cursor position
	mov	ah,#0x03
	xor	bh,bh
	int	0x10
	mov 	cx,#18
	mov	bx,#0x0007
	mov	bp,#msg_cursor
	mov	ax,#0x1301
	int	0x10
	mov	ax,#INITSEG
	mov	ds,ax
	mov 	cx,#4
	mov	dx,[0]

print_digit1:
	rol	dx,#4
	mov	ax,#0xe0f
	and	al,dl
	add	al,#0x30
	cmp	al,#0x3a
	jl	outp1
	add	al,#0x07
outp1:
	int	0x10
	loop	print_digit1

!print memory size
	mov	ah,#0x03
	xor	bh,bh
	int 	0x10
	mov 	cx,#14
	mov	bx,#0x0007
	mov	bp,#msg_memory
	mov	ax,#0x1301
	int	0x10
	mov	ax,#INITSEG
	mov	ds,ax
	mov	cx,#4
	mov	dx,[2]

print_digit2:
	rol	dx,#4
	mov	ax,#0xe0f
	and	al,dl
	add 	al,#0x30
	cmp	al,#0x3a
	jl	outp2
	add	al,#0x07
outp2:
	int	0x10
	loop	print_digit2

!add KB
	mov	ah,#0x03
	xor	bh,bh
	int	0x10
	mov	cx,#2
	mov	bx,#0x0007
	mov	bp,#msg_kb
	mov	ax,#0x1301
	int	0x10

!print vga config parameter:
	mov	ah,#0x03
	xor	bh,bh
	int	0x10
	mov	cx,#15
	mov 	bx,#0x0007
	mov	bp,#msg_frameBuffer
	mov	ax,#0x1301
	int	0x10
	mov	ax,#INITSEG
	mov	ds,ax
	mov	cx,#4
	mov	dx,[10]

print_digit3:
	rol	dx,#4
	mov	ax,#0xe0f
	and	al,dl
	add	al,#0x30
	cmp	al,#0x3a
	jl	outp3
	add	al,#0x07
outp3:
	int	0x10
	loop	print_digit3

print_nl:
	mov	ax,#0xe0d
	int	0x10
	mov	al,#0xa
	int 	0x10
	
!!!!==================================!!!!

msg2:
	.byte	13,10
	.ascii	"NOW we are in SETUP"
	.byte   13,10,13,10	
msg_cursor:
	.byte	13,10
	.ascii "Cursor position:"
msg_memory:
	.byte   13,10
	.ascii "Memory size:"
msg_kb:
	.ascii "KB"
msg_frameBuffer:
	.byte	13,10
	.ascii	"Frame Buffer:"
.text
endtext:
.data
enddata:
.bss
endbss:
