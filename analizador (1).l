%{
#include <stdio.h>
#include <string.h>

int errorCount = 0;

#define MAX_IDS 100
char *identificadores[MAX_IDS];
int idIndex = 0;
FILE *out;  // archivo de salida

int getIdentificadorNum(char *lexema) {
    for (int i = 0; i < idIndex; i++) {
        if (strcmp(identificadores[i], lexema) == 0) {
            return i + 1;
        }
    }
    if (idIndex < MAX_IDS) {
        identificadores[idIndex] = strdup(lexema);
        idIndex++;
        return idIndex;
    }
    return -1;
}

int col = 1;
int token_start_col = 1;

#define YY_USER_ACTION \
    token_start_col = col; \
    col += yyleng; \
    for (int i = 0; i < yyleng; i++) { \
        if (yytext[i] == '\n') { yylineno++; col = 1; fprintf(out,"\n"); } \
    }
%}

%option noyywrap
%option yylineno

DIG     [0-9]
id      [a-zA-Z_][a-zA-Z0-9_]*
INT     {DIG}+
LONG    {INT}[lL]
FLOAT   {DIG}+(\.{DIG}+)?([eE][-+]?{DIG}+)? 
IMAG    ({INT}|{FLOAT})[jJ]
STRING  \"([^"\n])*\"|\'([^'\n])*\' 

%%

"and"       { fprintf(out,"AND"); }
"else"      { fprintf(out,"ELSE"); }
"is"        { fprintf(out,"IS"); }
"return"    { fprintf(out,"RETURN"); }
"break"     { fprintf(out,"BREAK"); }
"for"       { fprintf(out,"FOR"); }
"not"       { fprintf(out,"NOT"); }
"while"     { fprintf(out,"WHILE"); }
"continue"  { fprintf(out,"CONTINUE"); }
"if"        { fprintf(out,"IF"); }
"or"        { fprintf(out,"OR"); }
"def"       { fprintf(out,"DEF"); }
"import"    { fprintf(out,"IMPORT"); }
"pass"      { fprintf(out,"PASS"); }
"elif"      { fprintf(out,"ELIF"); }
"in"        { fprintf(out,"IN"); }
"print"     { fprintf(out,"PRINT"); }
"range"     { fprintf(out,"RANGE"); }

"True"      { fprintf(out,"TRUE"); }
"False"     { fprintf(out,"FALSE"); }

"**"    { fprintf(out,"exp=%s ", yytext); }
"//"    { fprintf(out,"divint=%s ", yytext); }
"<<"    { fprintf(out,"shift_left=%s ", yytext); }
">>"    { fprintf(out,"shift_right=%s ", yytext); }
"<="    { fprintf(out,"menor_ig=%s ", yytext); }
">="    { fprintf(out,"mayor_ig=%s ", yytext); }
"=="    { fprintf(out,"comp=%s ", yytext); }
"!="    { fprintf(out,"neg=%s ", yytext); }
"<>"    { fprintf(out,"ne_alt=%s ", yytext); }
"+"     { fprintf(out,"suma=%s ", yytext); }
"-"     { fprintf(out,"menos=%s ", yytext); }
"*"     { fprintf(out,"mult=%s ", yytext); }
"/"     { fprintf(out,"div=%s ", yytext); }
"%"     { fprintf(out,"mod=%s ", yytext); }
"<"     { fprintf(out,"menor=%s ", yytext); }
">"     { fprintf(out,"mayor=%s ", yytext); }
"&"     { fprintf(out,"and=%s ", yytext); }
"|"     { fprintf(out,"or=%s ", yytext); }
"^"     { fprintf(out,"xor=%s ", yytext); }
"~"     { fprintf(out,"not=%s ", yytext); }
"="     { fprintf(out,"assign=%s ", yytext); }

"("     { fprintf(out,"parabre=%s ", yytext); }
")"     { fprintf(out,"parcierr=%s ", yytext); }
"["     { fprintf(out,"corabre=%s ", yytext); }
"]"     { fprintf(out,"corcier=%s ", yytext); }
";"     { fprintf(out,"puntocoma=%s ", yytext); }
","     { fprintf(out,"coma=%s ", yytext); }
":"     { fprintf(out,"dospunt=%s ", yytext); }
"."     { fprintf(out,"punto=%s ", yytext); }

">>="   { fprintf(out,"ASSIGN_SHR=%s ", yytext); }
"<<="   { fprintf(out,"ASSIGN_SHL=%s ", yytext); }
"+="    { fprintf(out,"ASSIGN_PLUS=%s ", yytext); }
"-="    { fprintf(out,"ASSIGN_MINUS=%s ", yytext); }
"*="    { fprintf(out,"ASSIGN_MUL=%s ", yytext); }
"/="    { fprintf(out,"ASSIGN_DIV=%s ", yytext); }
"//="   { fprintf(out,"ASSIGN_DIVINT=%s ", yytext); }
"&="    { fprintf(out,"ASSIGN_AND=%s ", yytext); }
"|="    { fprintf(out,"ASSIGN_OR=%s ", yytext); }
"^="    { fprintf(out,"ASSIGN_XOR=%s ", yytext); }
"**="   { fprintf(out,"ASSIGN_EXP=%s ", yytext); }
"%="    { fprintf(out,"ASSIGN_MOD=%s ", yytext); }

{id}    {
            int num = getIdentificadorNum(yytext);
            fprintf(out,"id%d=%s ", num, yytext);
        }

{LONG}  { fprintf(out,"long=%s ", yytext); }
{IMAG}  { fprintf(out,"imaginario=%s ", yytext); }
{INT}   { fprintf(out,"entero=%s ", yytext); }
{FLOAT} { fprintf(out,"real=%s ", yytext); }


{STRING} { fprintf(out,"cadena=%s ", yytext); }

"#".*   { /* ignorar comentarios */ }

[ ]+        { fprintf(out, "%s", yytext); }   /* espacios */
\t+         { fprintf(out, "%s", yytext); }   /* tabs */
\r          { /* ignorar retorno de carro (Windows) */ }
\n          { fprintf(out, "\n"); }           /* salto de línea real */

 
{DIG}+{id}+   {
    fprintf(out,"ERROR = %s", yytext);
    errorCount++;
}

{DIG}+(\.{DIG}+){2,}   {
    fprintf(out,"ERROR = %s", yytext);
    errorCount++;
}

{DIG}+[eE][-+]?   {
    fprintf(out,"ERROR = %s", yytext);
    errorCount++;
}

{INT}[lL]{2,}   {
    fprintf(out,"ERROR = %s", yytext);
    errorCount++;
}

({INT}|{FLOAT})[jJ]{2,}   {
    fprintf(out,"ERROR = %s", yytext);
    errorCount++;
}

\"([^"\n]*)$   {
    fprintf(out,"ERROR = string no cerrado");
    errorCount++;
}

\'([^'\n]*)$   {
    fprintf(out,"ERROR = string no cerrado");
    errorCount++;
}

\?\?   {
    fprintf(out,"ERROR = operador desconocido %s", yytext);
    errorCount++;
}

.   {
    fprintf(out,"ERROR = %s", yytext);
    errorCount++;
}
%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("No se pudo abrir el archivo de entrada %s\n", argv[1]);
            return 1;
        }
        out = fopen("salida.txt", "w");   // siempre crea salida.txt
        if (!out) {
            printf("No se pudo crear salida.txt\n");
            return 1;
        }
    } else {
        printf("Uso: %s <archivo_entrada.py>\n", argv[0]);
        return 1;
    }

    yylex();

    fprintf(out,"\n\n--- Identificadores encontrados ---\n");
    for (int i = 0; i < idIndex; i++) {
        fprintf(out,"Id%d=%s\n", i+1, identificadores[i]);
    }
    fprintf(out,"\nTotal errores léxicos: %d\n", errorCount);

    fclose(out);
    return 0;
}
