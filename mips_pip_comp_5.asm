#对5个数排序+全部中断
j Main
j Interrupt
j Exception

Main:
addi $ra $0 20
jr $ra #退出内核态
add $ra $0 $0
#Timer禁止中断，TCON=000
addi $t0 $0 0
lui $t1 16384
addi $t1 $t1 8 
sw $t0 0($t1)
#此处写入待排序数据，待排序的数据从DataMemory的0位置开始写
addi $t0 $0 7397
sw $t0 0($0)
addi $t0 $0 16898
sw $t0 4($0)
addi $t0 $0 30845
sw $t0 8($0)
addi $t0 $0 26507
sw $t0 12($0)
addi $t0 $0 5907
sw $t0 16($0)
#记录CLKCount的输出于$v1
lui $t1 16384
addi $t1 $t1 20
lw $v1 0($t1)

#选择排序，需要手动改$s0, $s1
addi $s0 $0 5 #$s0存待排序数据的个数
#数据从DataMemory的0地址开始存储
addi $s1 $0 16 #$s1存待排序数据的截止地址（含最后一个），截止地址等于4*个数-4
addi $s2 $s1 4 #$s2存待排序数据的上限地址（不含最后一个），上限地址等于4*个数
add $t0 $0 $0 #$t0存左侧数据指针
i_loop:
slt $t4 $t0 $s1 #$t4工具人
beq $t4 $0 i_end
addi $t1 $t0 4 #$t1存右侧数据指针
j_loop:
slt $t4 $t1 $s2
beq $t4 $0 j_end
lw $t2 0($t0) #$t2存左侧数据
lw $t3 0($t1) #$t3存右侧数据
slt $t4 $t2 $t3
bne $t4 $0 swap_end
sw $t2 0($t1) #交换
sw $t3 0($t0)
swap_end:
addi $t1 $t1 4
j j_loop
j_end:
addi $t0 $t0 4
j i_loop
i_end:

#此时已排完序
#记录CLKCount的输出于$v0
lui $t1 16384
addi $t1 $t1 20
lw $v0 0($t1)
#排序总指令数保存在$v0中
sub $v0 $v0 $v1
#将数码管查找表加载进DataMemory，存在0x00000710及之后
addi $t0 $0 192 #$t0存数据
addi $t1 $0 1808 #$t1存地址
sw $t0 0($t1) #0
addi $t0 $0 249
sw $t0 4($t1) #1
addi $t0 $0 164
sw $t0 8($t1) #2
addi $t0 $0 176
sw $t0 12($t1) #3
addi $t0 $0 153
sw $t0 16($t1) #4
addi $t0 $0 146
sw $t0 20($t1) #5
addi $t0 $0 130
sw $t0 24($t1) #6
addi $t0 $0 248
sw $t0 28($t1) #7
addi $t0 $0 128
sw $t0 32($t1) #8
addi $t0 $0 144
sw $t0 36($t1) #9
addi $t0 $0 136
sw $t0 40($t1) #a
addi $t0 $0 131
sw $t0 44($t1) #b
addi $t0 $0 198
sw $t0 48($t1) #c
addi $t0 $0 161
sw $t0 52($t1) #d
addi $t0 $0 134
sw $t0 56($t1) #e
addi $t0 $0 142
sw $t0 60($t1) #f

#将排好的数据显示在$a0中
addi $t0 $0 0 #$t0存待显示的数的编号
show:
beq $t0 $s2 Timer_start
lw $a0 0($t0)
addi $t0 $t0 4
j show

Timer_start:
#Timer加载TH, TL
lui $t0 65535
sra $t0 $t0 16
addi $t0 $t0 -100
lui $t1 16384
sw $t0 0($t1) #存入TH，只中断100个周期
lui $t0 65535
sra $t0 $t0 16
sw $t0 4($t1) #存入TL=0xffffffff
#Timer开始计数，TCON=011
addi $t0 $0 3
lui $t1 16384
addi $t1 $t1 8
sw $t0 0($t1) #TCON=011
#$k1写入0
addi $k1 $0 0
#进入Main死循环
Main_loop:
beq $0 $0 Main_loop

Interrupt: #此处写入中断处理
#Timer禁止中断，允许计数，TCON=001
addi $t0 $0 1 #$t0存数据相关，$t1存指令相关
lui $t1 16384
addi $t1 $t1 8
sw $t0 0($t1) #TCON=001
#点亮数码管
addi $t2 $0 0 #$t2工具人
beq $k1 $t2 AN0 #点亮第0个数码管
addi $t2 $t2 1
beq $k1 $t2 AN1 #点亮第1个数码管
addi $t2 $t2 1
beq $k1 $t2 AN2 #点亮第2个数码管
addi $t2 $t2 1
beq $k1 $t2 AN3 #点亮第3个数码管
AN0:
addi $t0 $0 14
sll $t0 $t0 8
addi $t3 $0 15 #$t3是取数字时用到的与运算
j AN_end
AN1:
addi $t0 $0 13
sll $t0 $t0 8
addi $t3 $0 240
j AN_end
AN2:
addi $t0 $0 11
sll $t0 $t0 8
addi $t3 $0 3840
j AN_end
AN3:
addi $t0 $0 7
sll $t0 $t0 8
addi $t3 $0 3840
sll $t3 $t3 4
j AN_end
AN_end:
and $t4 $v0 $t3 #$t4存待显示的数字
num_loop:
beq $t2 $0 num_end
srl $t4 $t4 4
subi $t2 $t2 1
j num_loop
num_end:
sll $t1 $t4 2 #$t1存地址相关
addi $t1 $t1 1808 #该数字编码在DataMemory中的存储地址
lw $t2 0($t1)
add $t0 $t0 $t2 #最终输入给数码管的12bit有效数字
lui $t1 16384
addi $t1 $t1 16
sw $t0 0($t1) #写入数码管
addi $k1 $k1 1 #$k1+1
#Timer允许中断，TCON=011
addi $t0 $0 3
lui $t1 16384
addi $t1 $t1 8
sw $t0 0($t1) #TCON=011
#$k1=4后重新回到0
addi $t2 $0 4
bne $k1 $t2 Interrupt_end
addi $k1 $0 0
Interrupt_end:
jr $26

Exception: #此处写入异常处理
#异常处理就是死循环
beq $0 $0 Exception
jr $26
