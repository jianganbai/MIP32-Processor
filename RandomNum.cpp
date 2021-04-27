#include <iostream>
#include <stdlib.h>
#include <time.h>
using namespace std;
int main()
{
	srand((unsigned)time(NULL));
	int const NumofRan = 10; //生成的随机数数量
	int i,num,shamt;
	char* a="addi $t0 $0 ";
	char* b="sw $t0 ";
	char* c="($0)";
	for (i=0;i<NumofRan;i++)
	{
		num = rand();
		num = num%(65535);
		//addi $t0 $0 num
		//sw $t0 shamt($0)
		shamt = 4*i;
		cout<<a<<num<<endl;
		cout<<b<<shamt<<c<<endl;
	}
	return 0;
}