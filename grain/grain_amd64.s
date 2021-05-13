// Code generated by command: go run asm.go -out out/grain_amd64.s -stubs out/stub_amd64.go -pkg grain. DO NOT EDIT.

// +build gc,!purego

#include "textflag.h"

// func next(s *state) uint32
TEXT ·next(SB), NOSPLIT, $0-12
	MOVQ s+0(FP), AX
	MOVQ 8336(AX), CX
	MOVQ 8344(AX), DX

	// LFSR
	MOVQ s+0(FP), BX
	MOVQ 16(BX)(CX*4), SI
	MOVQ 20(BX)(CX*4), DI
	MOVQ 24(BX)(CX*4), R8
	MOVL 28(BX)(CX*4), R9

	// v := ln ^ ln3
	MOVQ SI, R10
	XORQ R9, R10

	// <temp> = ln1 ^ ln2
	MOVQ DI, R9
	XORQ R8, R9

	// v ^= (<temp> >> 6)
	SHRQ $0x06, R9
	XORQ R9, R10

	// v ^= (ln0 >> 7)
	MOVQ SI, R9
	SHRQ $0x07, R9
	XORQ R9, R10

	// v ^= (ln2 >> 17)
	MOVQ R8, R9
	SHRQ $0x11, R9
	XORQ R9, R10

	// s.lfsr[s.count] = uint32(v)
	MOVL R10, 16(BX)(DX*4)

	// NFSR
	MOVQ s+0(FP), R11
	MOVQ 4176(R11)(CX*4), R12
	MOVQ 4180(R11)(CX*4), R13
	MOVQ 4184(R11)(CX*4), R14
	MOVL 4188(R11)(CX*4), R9

	// u := ln0
	MOVQ SI, R10

	// u ^= nn0
	XORQ R12, R10

	// u ^= (nn0 >> 26)
	MOVQ R12, R15
	SHRQ $0x1a, R15
	XORQ R15, R10
	XORQ R9, R10

	// u ^= (nn1 >> 24)
	MOVQ R13, R9
	SHRQ $0x18, R9
	XORQ R9, R10

	// <temp> = (nn0 & nn2) ^ nn2
	MOVQ R13, R9
	ANDQ R12, R9
	XORQ R14, R9

	// u ^= (<temp> >> 27)
	SHRQ $0x1b, R9
	XORQ R9, R10

	// <temp> = nn0 & nn2
	MOVQ R14, R9
	ANDQ R12, R9

	// u ^= (<temp> >> 3)
	SHRQ $0x03, R9
	XORQ R9, R10

	// u ^= (nn0 >> 11) & (nn0 >> 13)
	MOVQ R12, R9
	SHRQ $0x0b, R9
	MOVQ R12, R15
	SHRQ $0x0d, R15
	ANDQ R15, R9
	XORQ R9, R10

	// u ^= (nn0 >> 17) & (nn0 >> 18)
	MOVQ R12, R9
	SHRQ $0x11, R9
	MOVQ R12, R15
	SHRQ $0x12, R15
	ANDQ R15, R9
	XORQ R9, R10

	// u ^= (nn1 >> 8) & (nn1 >> 16)
	MOVQ R13, R9
	SHRQ $0x08, R9
	MOVQ R13, R15
	SHRQ $0x10, R15
	ANDQ R15, R9
	XORQ R9, R10

	// u ^= (nn1 >> 29) & (nn2 >> 1)
	MOVQ R13, R9
	SHRQ $0x1d, R9
	MOVQ R14, R15
	SHRQ $0x01, R15
	ANDQ R15, R9
	XORQ R9, R10

	// u ^= (nn2 >> 4) & (nn2 >> 20)
	MOVQ R14, R9
	SHRQ $0x04, R9
	MOVQ R14, R15
	SHRQ $0x14, R15
	ANDQ R15, R9
	XORQ R9, R10

	// u ^= (nn2 >> 24) & (nn2 >> 28) & (nn2 >> 29) & (nn2 >> 31)
	MOVQ R14, R9
	SHRQ $0x18, R9
	MOVQ R14, R15
	SHRQ $0x1c, R15
	ANDQ R15, R9
	MOVQ R14, R15
	SHRQ $0x1d, R15
	ANDQ R15, R9
	MOVQ R14, R15
	SHRQ $0x1f, R15
	ANDQ R15, R9
	XORQ R9, R10

	// u ^= (nn0 >> 22) & (nn0 >> 24) & (nn0 >> 25)
	MOVQ R12, R9
	SHRQ $0x16, R9
	MOVQ R12, R15
	SHRQ $0x18, R15
	ANDQ R15, R9
	MOVQ R12, R15
	SHRQ $0x19, R15
	ANDQ R15, R9
	XORQ R9, R10

	// u ^= (nn2 >> 6) & (nn2 >> 14) & (nn2 >> 18)
	MOVQ R14, R9
	SHRQ $0x06, R9
	MOVQ R14, R15
	SHRQ $0x0e, R15
	ANDQ R15, R9
	MOVQ R14, R15
	SHRQ $0x12, R15
	ANDQ R15, R9
	XORQ R9, R10

	// s.nfsr[s.count] = uint32(u)
	MOVL R10, 4176(R11)(DX*4)

	// s.count++
	INCQ DX

	// s.i++
	INCQ CX
	CMPQ DX, $+1040
	JGE  start_reinit

end_reinit:
	MOVQ R12, R10
	SHRQ $0x02, R10

	// x ^= (nn0 >> 15)
	MOVQ R12, BX
	SHRQ $0x0f, BX
	XORQ BX, R10

	// x ^= (nn1 >> 4)
	MOVQ R13, BX
	SHRQ $0x04, BX
	XORQ BX, R10

	// x ^= (nn1 >> 13)
	MOVQ R13, BX
	SHRQ $0x0d, BX
	XORQ BX, R10
	XORQ R14, R10

	// x ^= (nn2 >> 9)
	MOVQ R14, BX
	SHRQ $0x09, BX
	XORQ BX, R10

	// x ^= (nn2 >> 25)
	MOVQ R14, BX
	SHRQ $0x19, BX
	XORQ BX, R10

	// x ^= (ln2 >> 29)
	MOVQ R8, BX
	SHRQ $0x1d, BX
	XORQ BX, R10

	// x ^= (nn0 >> 12) & (ln0 >> 8)
	MOVQ R12, BX
	SHRQ $0x0c, BX
	MOVQ SI, R9
	SHRQ $0x08, R9
	ANDQ R9, BX
	XORQ BX, R10

	// x ^= (ln0 >> 13) & (ln0 >> 20)
	MOVQ SI, BX
	SHRQ $0x0d, BX
	SHRQ $0x14, SI
	ANDQ SI, BX
	XORQ BX, R10

	// x ^= (nn2 >> 31) & (ln1 >> 10)
	MOVQ R14, BX
	SHRQ $0x1f, BX
	MOVQ DI, SI
	SHRQ $0x0a, SI
	ANDQ SI, BX
	XORQ BX, R10

	// x ^= (ln1 >> 28) & (ln2 >> 15)
	MOVQ DI, BX
	SHRQ $0x1c, BX
	MOVQ R8, SI
	SHRQ $0x0f, SI
	ANDQ SI, BX
	XORQ BX, R10

	// x ^= (nn0 >> 12) & (nn2 >> 31) & (ln2 >> 30)
	MOVQ R12, BX
	SHRQ $0x0c, BX
	MOVQ R14, SI
	SHRQ $0x1f, SI
	ANDQ SI, BX
	MOVQ R8, SI
	SHRQ $0x1e, SI
	ANDQ SI, BX
	XORQ BX, R10

	// Store updated s.i and s.count
	MOVQ CX, 8336(AX)
	MOVQ DX, 8344(AX)

	// Store result
	MOVL R10, ret+8(FP)
	RET

start_reinit:
	MOVQ 16(BX)(CX*4), R9
	MOVQ R9, 16(BX)
	MOVQ 24(BX)(CX*4), R9
	MOVQ R9, 24(BX)
	MOVQ 4176(R11)(CX*4), R9
	MOVQ R9, 4176(R11)
	MOVQ 4184(R11)(CX*4), R9
	MOVQ R9, 4184(R11)
	XORQ CX, CX
	MOVQ $0x00000004, DX
	JMP  end_reinit

// func accumulate(s *state, ms uint16, pt uint16)
// Requires: CMOV
TEXT ·accumulate(SB), NOSPLIT, $0-16
	MOVQ s+0(FP), AX
	MOVQ 8360(AX), CX
	MOVQ 8352(AX), DX
	MOVW pt+10(FP), BX
	MOVW ms+8(FP), SI

	// regtmp := uint32(ms) << 16
	MOVWLZX SI, R8
	SHLL    $0x10, R8

	// Registerized constants
	MOVQ $-1, R11
	MOVL $0x0000ffff, R12

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8368(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8372(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8376(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8380(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8384(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8388(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8392(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8396(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8400(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8404(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8408(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8412(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8416(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8420(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8424(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// var mask uint64
	// if pt&0x1 != 0 { mask = ^uint64(0) }
	XORQ    R9, R9
	TESTW   $0x0001, BX
	CMOVQNE R11, R9

	// s.acc ^= s.reg & mask
	MOVQ CX, R10
	ANDQ R9, R10
	XORQ R10, DX

	// s.reg >>= 1
	SHRQ $0x01, CX

	// var rem uint32
	// if pt&0x1 != 0 { rem = 0xffff }
	XORL    R9, R9
	TESTW   $0x0001, BX
	CMOVLNE R12, R9

	// acctmp ^= uint16(regtmp & rem)
	MOVL R8, R10
	ANDL R9, R10
	XORW R10, DI
	MOVL R8, R10
	ANDL R9, R10
	MOVL R10, 8428(AX)

	// regtmp >>= 1
	SHRL $0x01, R8

	// pt >>= 1
	SHRW $0x01, BX

	// s.reg |= uint64(ms) << 48
	MOVWQZX SI, R10
	SHLQ    $0x30, R10
	ORQ     R10, CX

	// s.acc ^= uint64(acctmp) << 48
	MOVWQZX DI, R10
	SHLQ    $0x30, R10
	XORQ    R10, DX

	// Store registerized fields
	MOVQ CX, 8360(AX)
	MOVQ DX, 8352(AX)
	RET
