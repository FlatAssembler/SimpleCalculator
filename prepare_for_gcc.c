/*
	This program prepares the files produced by "prepare.c" for
	compilation using GCC. It's intended to be a possible part of
	a workflow which includes SimpleCalculator or
	ArithmeticExpressionCompiler for producing Assembly, if that
	Assembly is intended to be included in a C or a C++ program.
	ArithmeticExpressionCompiler and SimpleCalculator are available
	at these URLs:
	https://github.com/FlatAssembler
	https://flatassembler.000webhostapp.com/calculator.html
	https://flatassembler.000webhostapp.com/compiler.html
	All of those programs are made by Teo Samaržija, and they are 
	open source.
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	if (argc-2 || (strcmp(argv[1]+strlen(argv[1])-2,".c")
			&& strcmp(argv[1]+strlen(argv[1])-2,".C")))
			{
				printf("Usage: prepare filename.c\n");
				return 1;
			}
	FILE *file=fopen(argv[1],"r");
	if (!file) {
		printf("Can't open \"%s\" for reading.\n",argv[1]);
		return 1;
	}
	fseek(file,0,SEEK_END);
	int file_size=ftell(file),i;
	char *old=calloc(file_size,sizeof(char));
	char *new=calloc(file_size*2,sizeof(char));
	if (!old || !new) {
		printf("System out of memory!?\n");
		if (old) free(old);
		if (new) free(new);
		fclose(file);
		return 1;
	}
	fseek(file,0,SEEK_SET);
	fread(old,sizeof(char),file_size,file);
	for (i=0; i<file_size; i++) {
		if (old[i]=='[') {
#ifdef linux
			strcat(new,"ptr [");
#else
			strcat(new,"ptr [_");
#endif
			continue;
		}
		if (!strncmp(old+i,"st1,st0",strlen("st1,st0"))) {
			strcat(new,"#st1,st0");
			i+=strlen("st1,st0")-1;
			continue;
		}
		strncat(new,old+i,1);
	}
	fclose(file);
	file=fopen(argv[1],"w");
	if (!file) {
		printf("Cannot open \"%s\" for writing!\n",argv[1]);
		free(old);
		free(new);
		return 1;
	}
	fwrite(new,sizeof(char),strlen(new),file);
	fclose(file);
	free(old);
	free(new);
	return 0;
}

