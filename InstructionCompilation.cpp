#include <iostream>
using namespace std;
int main()
{
	FILE* fp;
	fp=fopen("mips_pip_machinecode.txt","r");
	int i,temp;
	char num[9];
	memset(num,'\0',sizeof(num));
	for(i=0;;i++)
	{
		temp=fread(num,8,1,fp); //注意最后还有\n
		if(temp == 0)
		{
			break;
		}
		cout<<"10'd"<<i<<": Instruction <= 32'h"<<num<<';'<<endl;
		fseek(fp,2,SEEK_CUR);
	}
	fclose(fp);
}