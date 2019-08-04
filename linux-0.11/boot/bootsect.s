entry _start
_start:
	mov 	ah,#0x03
	xor	bh,bh
	int	0x10
	mov	cx,#18
	mov	bx,#0x0007
	mov 	bp,#msg1

	mov	ax,#0x07c0
	mov	es,ax

	mov 	ax,#0x1301
	int 	0x10

inf_loop:
	jmp	inf_loop

msg1:
	.byte	13,10
	.ascii	"Hello qianOS"	
	.byte	13,10,13,10

.org 510
boot_flag:
	.word 0xAA55

!as86 -0 -a -o bootsect.o bootsect.s
!ld85 -0 -s -o bootsect bootsect.o
!dd bs=1 if=bootsect of=Image skip=32
!cp ./Image ../Image
!../../run
