%{

#include "avs_lexer.h"

#define YYDEBUG 1
#define YYVERBOSE 1
#define YYERROR_VERBOSE 1

#define YYSTYPE AvsLexerTokenValue

%}

%token IDENTIFIER
%token CONSTANT
%token FUNCTION

%right '='
%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%right UNARY 

%%

translation_unit
	: statement_list{ fprintf(stderr, "STATEMENT: %p\n", $$); }
	| /* empty */	{ fprintf(stderr, "EMPTY!\n"); }
	;

statement_list
	: statement
	| statement_list statement
	;
	
statement 
	: ';'		{ fprintf(stderr, "PP: ;\n"); }
	| expr ';'	{ fprintf(stderr, "PP: expr ;\n"); }

expr
	: primary		
	| '-' expr %prec UNARY	{ fprintf(stderr, "PP: uminus\n");	}
	| '+' expr %prec UNARY	{ fprintf(stderr, "PP: uplus\n");    	}
	| expr '+' expr		{ fprintf(stderr, "PP: %c\n", $1, $2.v.punctuator, $3);  $$ = $3;  }
	| expr '-' expr		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	| expr '*' expr		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	| expr '/' expr		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	| expr '%' expr		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	| expr '&' expr		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	| expr '|' expr		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	| expr '=' expr		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	| '(' expr ')'		{ fprintf(stderr, "PP: %c\n", $2.v.punctuator);    }
	;

fn_expr
	: /* empty */
	| expr
	| fn_expr ',' expr
	;
	
primary
	: CONSTANT		{ fprintf(stderr, "PP: constant\n"); }
	| IDENTIFIER		{ fprintf(stderr, "PP: identifier\n"); }
	| IDENTIFIER '(' fn_expr ')' { fprintf(stderr, "PP: function '(' ')'\n"); } 
	;

%%


AvsLexerContext ac;

int yyerror (char *s)  
{
	fprintf(stderr, "yyerror: %s\n", s);
	return 1;
}

int yylex ()
{
	AvsLexerTokenValue v, *p;

	fprintf(stderr, "\n");
	for (;;) {
		if (!avs_lexer_token(&ac, &v)) {
			fprintf(stderr, "AVS: EOF\n");
			return 0;
		}

		if (v.type != AvsLexerTokenInvalid)
			break;
			
		fprintf(stderr, "Lexer error: \n");
		fprintf(stderr, "\tLine: %d Column: %d\n", ac.line, ac.column);
		fprintf(stderr, "\tError: %s\n", avs_lexer_error(&ac));
	}
	
	yylval = v;

	fprintf(stderr, "Line: %d Column: %d\n", ac.line, ac.column);
	if (v.type == AvsLexerTokenConstant) {
		fprintf(stderr, "AVS: Constant: %f\n", v.v.constant);
		return CONSTANT;
	}
	if (v.type == AvsLexerTokenIdentifier) {
		fprintf(stderr, "AVS: Identifier: %s\n", v.v.identifier);
		return IDENTIFIER;
	}
	if (v.type == AvsLexerTokenPunctuator) {
		fprintf(stderr, "AVS: Punctuator: '%c'\n", v.v.punctuator);
		return v.v.punctuator;
	}
	
	return 0;
}
	

int main(int argc, char **argv)
{	
	char buf[32768];
	int len = 0;

	len = read(0, buf, sizeof(buf));
	buf[len] = 0;
	
	avs_lexer_init(&ac, buf, len);

	yydebug=  1;
	yyparse();
	return 0;
}