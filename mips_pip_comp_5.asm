#��5��������+ȫ���ж�
j Main
j Interrupt
j Exception

Main:
addi $ra $0 20
jr $ra #�˳��ں�̬
add $ra $0 $0
#Timer��ֹ�жϣ�TCON=000
addi $t0 $0 0
lui $t1 16384
addi $t1 $t1 8 
sw $t0 0($t1)
#�˴�д����������ݣ�����������ݴ�DataMemory��0λ�ÿ�ʼд
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
#��¼CLKCount�������$v1
lui $t1 16384
addi $t1 $t1 20
lw $v1 0($t1)

#ѡ��������Ҫ�ֶ���$s0, $s1
addi $s0 $0 5 #$s0����������ݵĸ���
#���ݴ�DataMemory��0��ַ��ʼ�洢
addi $s1 $0 16 #$s1����������ݵĽ�ֹ��ַ�������һ��������ֹ��ַ����4*����-4
addi $s2 $s1 4 #$s2����������ݵ����޵�ַ���������һ���������޵�ַ����4*����
add $t0 $0 $0 #$t0���������ָ��
i_loop:
slt $t4 $t0 $s1 #$t4������
beq $t4 $0 i_end
addi $t1 $t0 4 #$t1���Ҳ�����ָ��
j_loop:
slt $t4 $t1 $s2
beq $t4 $0 j_end
lw $t2 0($t0) #$t2���������
lw $t3 0($t1) #$t3���Ҳ�����
slt $t4 $t2 $t3
bne $t4 $0 swap_end
sw $t2 0($t1) #����
sw $t3 0($t0)
swap_end:
addi $t1 $t1 4
j j_loop
j_end:
addi $t0 $t0 4
j i_loop
i_end:

#��ʱ��������
#��¼CLKCount�������$v0
lui $t1 16384
addi $t1 $t1 20
lw $v0 0($t1)
#������ָ����������$v0��
sub $v0 $v0 $v1
#������ܲ��ұ���ؽ�DataMemory������0x00000710��֮��
addi $t0 $0 192 #$t0������
addi $t1 $0 1808 #$t1���ַ
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

#���źõ�������ʾ��$a0��
addi $t0 $0 0 #$t0�����ʾ�����ı��
show:
beq $t0 $s2 Timer_start
lw $a0 0($t0)
addi $t0 $t0 4
j show

Timer_start:
#Timer����TH, TL
lui $t0 65535
sra $t0 $t0 16
addi $t0 $t0 -100
lui $t1 16384
sw $t0 0($t1) #����TH��ֻ�ж�100������
lui $t0 65535
sra $t0 $t0 16
sw $t0 4($t1) #����TL=0xffffffff
#Timer��ʼ������TCON=011
addi $t0 $0 3
lui $t1 16384
addi $t1 $t1 8
sw $t0 0($t1) #TCON=011
#$k1д��0
addi $k1 $0 0
#����Main��ѭ��
Main_loop:
beq $0 $0 Main_loop

Interrupt: #�˴�д���жϴ���
#Timer��ֹ�жϣ����������TCON=001
addi $t0 $0 1 #$t0��������أ�$t1��ָ�����
lui $t1 16384
addi $t1 $t1 8
sw $t0 0($t1) #TCON=001
#���������
addi $t2 $0 0 #$t2������
beq $k1 $t2 AN0 #������0�������
addi $t2 $t2 1
beq $k1 $t2 AN1 #������1�������
addi $t2 $t2 1
beq $k1 $t2 AN2 #������2�������
addi $t2 $t2 1
beq $k1 $t2 AN3 #������3�������
AN0:
addi $t0 $0 14
sll $t0 $t0 8
addi $t3 $0 15 #$t3��ȡ����ʱ�õ���������
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
and $t4 $v0 $t3 #$t4�����ʾ������
num_loop:
beq $t2 $0 num_end
srl $t4 $t4 4
subi $t2 $t2 1
j num_loop
num_end:
sll $t1 $t4 2 #$t1���ַ���
addi $t1 $t1 1808 #�����ֱ�����DataMemory�еĴ洢��ַ
lw $t2 0($t1)
add $t0 $t0 $t2 #�������������ܵ�12bit��Ч����
lui $t1 16384
addi $t1 $t1 16
sw $t0 0($t1) #д�������
addi $k1 $k1 1 #$k1+1
#Timer�����жϣ�TCON=011
addi $t0 $0 3
lui $t1 16384
addi $t1 $t1 8
sw $t0 0($t1) #TCON=011
#$k1=4�����»ص�0
addi $t2 $0 4
bne $k1 $t2 Interrupt_end
addi $k1 $0 0
Interrupt_end:
jr $26

Exception: #�˴�д���쳣����
#�쳣���������ѭ��
beq $0 $0 Exception
jr $26
