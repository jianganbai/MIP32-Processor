#对128个数排序+全部中断
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
addi $t0 $0 738
sw $t0 0($0)
addi $t0 $0 6012
sw $t0 4($0)
addi $t0 $0 30058
sw $t0 8($0)
addi $t0 $0 32157
sw $t0 12($0)
addi $t0 $0 24445
sw $t0 16($0)
addi $t0 $0 26916
sw $t0 20($0)
addi $t0 $0 8774
sw $t0 24($0)
addi $t0 $0 2251
sw $t0 28($0)
addi $t0 $0 8943
sw $t0 32($0)
addi $t0 $0 8478
sw $t0 36($0)
addi $t0 $0 24496
sw $t0 40($0)
addi $t0 $0 23499
sw $t0 44($0)
addi $t0 $0 22131
sw $t0 48($0)
addi $t0 $0 5702
sw $t0 52($0)
addi $t0 $0 4447
sw $t0 56($0)
addi $t0 $0 21130
sw $t0 60($0)
addi $t0 $0 4371
sw $t0 64($0)
addi $t0 $0 17164
sw $t0 68($0)
addi $t0 $0 18771
sw $t0 72($0)
addi $t0 $0 29464
sw $t0 76($0)
addi $t0 $0 19566
sw $t0 80($0)
addi $t0 $0 22312
sw $t0 84($0)
addi $t0 $0 25271
sw $t0 88($0)
addi $t0 $0 11519
sw $t0 92($0)
addi $t0 $0 30393
sw $t0 96($0)
addi $t0 $0 4490
sw $t0 100($0)
addi $t0 $0 17420
sw $t0 104($0)
addi $t0 $0 8916
sw $t0 108($0)
addi $t0 $0 26116
sw $t0 112($0)
addi $t0 $0 30352
sw $t0 116($0)
addi $t0 $0 3204
sw $t0 120($0)
addi $t0 $0 12811
sw $t0 124($0)
addi $t0 $0 4286
sw $t0 128($0)
addi $t0 $0 13948
sw $t0 132($0)
addi $t0 $0 12460
sw $t0 136($0)
addi $t0 $0 11535
sw $t0 140($0)
addi $t0 $0 12156
sw $t0 144($0)
addi $t0 $0 22565
sw $t0 148($0)
addi $t0 $0 19022
sw $t0 152($0)
addi $t0 $0 31635
sw $t0 156($0)
addi $t0 $0 11254
sw $t0 160($0)
addi $t0 $0 31725
sw $t0 164($0)
addi $t0 $0 8086
sw $t0 168($0)
addi $t0 $0 5410
sw $t0 172($0)
addi $t0 $0 338
sw $t0 176($0)
addi $t0 $0 19186
sw $t0 180($0)
addi $t0 $0 9587
sw $t0 184($0)
addi $t0 $0 2558
sw $t0 188($0)
addi $t0 $0 29094
sw $t0 192($0)
addi $t0 $0 26249
sw $t0 196($0)
addi $t0 $0 320
sw $t0 200($0)
addi $t0 $0 3623
sw $t0 204($0)
addi $t0 $0 13496
sw $t0 208($0)
addi $t0 $0 27624
sw $t0 212($0)
addi $t0 $0 19876
sw $t0 216($0)
addi $t0 $0 15034
sw $t0 220($0)
addi $t0 $0 1032
sw $t0 224($0)
addi $t0 $0 24610
sw $t0 228($0)
addi $t0 $0 9911
sw $t0 232($0)
addi $t0 $0 31100
sw $t0 236($0)
addi $t0 $0 10256
sw $t0 240($0)
addi $t0 $0 6233
sw $t0 244($0)
addi $t0 $0 16742
sw $t0 248($0)
addi $t0 $0 20151
sw $t0 252($0)
addi $t0 $0 27338
sw $t0 256($0)
addi $t0 $0 29230
sw $t0 260($0)
addi $t0 $0 4632
sw $t0 264($0)
addi $t0 $0 30021
sw $t0 268($0)
addi $t0 $0 4979
sw $t0 272($0)
addi $t0 $0 28797
sw $t0 276($0)
addi $t0 $0 18066
sw $t0 280($0)
addi $t0 $0 234
sw $t0 284($0)
addi $t0 $0 20367
sw $t0 288($0)
addi $t0 $0 4168
sw $t0 292($0)
addi $t0 $0 5911
sw $t0 296($0)
addi $t0 $0 31463
sw $t0 300($0)
addi $t0 $0 11565
sw $t0 304($0)
addi $t0 $0 27120
sw $t0 308($0)
addi $t0 $0 13012
sw $t0 312($0)
addi $t0 $0 11467
sw $t0 316($0)
addi $t0 $0 2668
sw $t0 320($0)
addi $t0 $0 29355
sw $t0 324($0)
addi $t0 $0 19324
sw $t0 328($0)
addi $t0 $0 3469
sw $t0 332($0)
addi $t0 $0 7742
sw $t0 336($0)
addi $t0 $0 29234
sw $t0 340($0)
addi $t0 $0 1072
sw $t0 344($0)
addi $t0 $0 1240
sw $t0 348($0)
addi $t0 $0 32364
sw $t0 352($0)
addi $t0 $0 186
sw $t0 356($0)
addi $t0 $0 18337
sw $t0 360($0)
addi $t0 $0 30886
sw $t0 364($0)
addi $t0 $0 18138
sw $t0 368($0)
addi $t0 $0 8486
sw $t0 372($0)
addi $t0 $0 18808
sw $t0 376($0)
addi $t0 $0 22800
sw $t0 380($0)
addi $t0 $0 17933
sw $t0 384($0)
addi $t0 $0 19323
sw $t0 388($0)
addi $t0 $0 14070
sw $t0 392($0)
addi $t0 $0 7780
sw $t0 396($0)
addi $t0 $0 21226
sw $t0 400($0)
addi $t0 $0 31636
sw $t0 404($0)
addi $t0 $0 23255
sw $t0 408($0)
addi $t0 $0 28025
sw $t0 412($0)
addi $t0 $0 12224
sw $t0 416($0)
addi $t0 $0 6167
sw $t0 420($0)
addi $t0 $0 14461
sw $t0 424($0)
addi $t0 $0 22079
sw $t0 428($0)
addi $t0 $0 7817
sw $t0 432($0)
addi $t0 $0 17831
sw $t0 436($0)
addi $t0 $0 25162
sw $t0 440($0)
addi $t0 $0 24730
sw $t0 444($0)
addi $t0 $0 2669
sw $t0 448($0)
addi $t0 $0 31323
sw $t0 452($0)
addi $t0 $0 3918
sw $t0 456($0)
addi $t0 $0 23409
sw $t0 460($0)
addi $t0 $0 27272
sw $t0 464($0)
addi $t0 $0 25967
sw $t0 468($0)
addi $t0 $0 13346
sw $t0 472($0)
addi $t0 $0 8706
sw $t0 476($0)
addi $t0 $0 16877
sw $t0 480($0)
addi $t0 $0 32570
sw $t0 484($0)
addi $t0 $0 8979
sw $t0 488($0)
addi $t0 $0 19320
sw $t0 492($0)
addi $t0 $0 24811
sw $t0 496($0)
addi $t0 $0 21856
sw $t0 500($0)
addi $t0 $0 30595
sw $t0 504($0)
addi $t0 $0 30911
sw $t0 508($0)

#记录CLKCount的输出于$v1
lui $t1 16384
addi $t1 $t1 20
lw $v1 0($t1)

#选择排序，需要手动改$s0, $s1
addi $s0 $0 128 #$s0存待排序数据的个数
#数据从DataMemory的0地址开始存储
addi $s1 $0 508 #$s1存待排序数据的截止地址（含最后一个），截止地址等于4*个数-4
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
addi $t0 $t0 -100 #修改过TH
lui $t1 16384
sw $t0 0($t1) #存入TH=
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
addi $t0 $0 1
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
