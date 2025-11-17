.section .init
.global main

/* set stack pointer */
lui sp, %hi(507) //16*1024
addi sp, sp, %lo(507) 

.section .COME_AND_GET_IT
li  t0, 1
li  t1, 0x10010001
sw  t0, 0(t1)
j .COME_AND_GET_IT

/* call main */
jal ra, main

/* break */
ebreak
