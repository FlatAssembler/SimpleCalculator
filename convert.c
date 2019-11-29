/*
	This is a program that converts from Assembly output made by
	ArithmeticExpressionCompiler or SimpleCalculator into a format
	that can be easily included into C.
	ArithmeticExpressionCompiler and SimpleCalculator are available
	there:
	https://github.com/FlatAssembler
	https://flatassembler.000webhostapp.com/compiler.html
	https://flatassembler.000webhostapp.com/calculator.html
	This program, along with ArithmeticExpressionCompiler and
	SimpleCalculator, are made by Teo Samar�ija.
*/

#include <stdio.h>
#include <iso646.h>
#include <string.h>

int main(int argc, char **argv) {
	if (argc-2 or
		(strcmp(argv[1]+strlen(argv[1])-4,".asm") and
		strcmp(argv[1]+strlen(argv[1])-4,".ASM"))) {
			fprintf(stderr,"Usage: convert filename.asm\n");
			return 1;
	}
	FILE *input=fopen(argv[1],"r");
	if (!input) {
		fprintf(stderr,"Can't open \"%s\" for reading!\n",argv[1]);
		return 1;
	}
	char outPutName[256];
	strncpy(outPutName,argv[1],strlen(argv[1])-3);
	outPutName[strlen(argv[1])-3]='\0';
	strcat(outPutName,"c");
	FILE *output=fopen(outPutName,"w");
	if (!output) {
		fprintf(stderr,"Can't open \"%s\" for writing!\n",outPutName);
		fclose(input);
		return 1;
	}
	fprintf(output,"asm(\n");
	while (!feof(input)) {
		char tmp[1024];
		fscanf(input,"%[^\n]\n",tmp);
		if (tmp[strlen(tmp)-1]=='\n' || tmp[strlen(tmp)-1]=='\r')
			tmp[strlen(tmp)-1]='\0';
		if (!strlen(tmp)) {
			fprintf(stderr,"Error: The input file contains an empty line.\n"
					"That's not a file made by ArithmeticExpressionCompiler \"calc\",\n"
					"nor an output of SimpleCalculator.\n"
					"Aborting!\n");
			fclose(output);
			fclose(input);
			remove(outPutName);
			return 1;
		}
		for (int i=0; i<strlen(tmp); i++)
			if (tmp[i]==';') tmp[i]='#';
		fprintf(output,"\t\"%s\\n\"\n",tmp);
	}
	fprintf(output,");\n");
	fclose(output);
	fclose(input);
	return 0;
}

