SETUPSEG = 0x9020

entry _start
_start:
	mov 	ax,#SETUPSEG
	mov 	es,ax
	mov	ah,0x03
	xor	bh,bh
	int	0x10
	mov	cx,#25
	mov	bx,#0x0007
	mov 	bp,#msg2
	mov 	ax,#0x1301
	int 	0x10
msg2:
	.byte	13,10
	.ascii	"Now we are in setup"	
	.byte	13,10,13,10

!cd ~/oslab/Linux-0.11
!make BootImage
!../run
