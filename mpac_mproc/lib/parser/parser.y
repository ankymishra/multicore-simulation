%{
	#include "pac-list.h"
	#include "tic-parser.h"
	#include "stdlib.h"
	#include "stdio.h"
	extern struct tic_head *list_set;
	extern struct tic_head *list_compare;
%}

%union {
	char *str;
	int num;
}

%token <num> ADDRESS COMPARE_VALUE SET_VALUE
%token <str> COMMENT

%%

input
    : input line
	| line
	;

line
: COMMENT
| ADDRESS COMPARE_VALUE {
	struct tic_head *p; 

	p = (struct tic_head*)malloc(sizeof(struct tic_head));

	INIT_LIST_HEAD(&(p->list));

	p->address = $1;
	p->value = $2; 
	
	list_add_tail(&(p->list), &(list_compare->list));
 }
| ADDRESS SET_VALUE {
	struct tic_head *p; 

	p = (struct tic_head*)malloc(sizeof(struct tic_head));

	INIT_LIST_HEAD(&(p->list));
		
	p->address = $1;
	p->value = $2; 

	list_add_tail(&(p->list), &(list_set->list));
 }
;

%%

yyerror(char *s)
{
	fprintf(stderr, "%s", s);
}
