/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     TOKEN_UNRECOGNIZED = 258,
     TOKEN_PROGRAM_OPEN = 259,
     TOKEN_PROGRAM_CLOSE = 260,
     TOKEN_VARIABLES_OPEN = 261,
     TOKEN_VARIABLES_CLOSE = 262,
     TOKEN_INSTRUCTIONS_OPEN = 263,
     TOKEN_INSTRUCTIONS_CLOSE = 264,
     TOKEN_ASSIGN_OPEN = 265,
     TOKEN_ASSIGN_CLOSE = 266,
     TOKEN_PRINT_OPEN = 267,
     TOKEN_PRINT_CLOSE = 268,
     TOKEN_IF_OPEN = 269,
     TOKEN_IF_CLOSE = 270,
     TOKEN_ELSE = 271,
     TOKEN_WHILE_OPEN = 272,
     TOKEN_WHILE_CLOSE = 273,
     TOKEN_ARRAY_OPEN = 274,
     TOKEN_ARRAY_CLOSE = 275,
     TOKEN_ELEMENT_OPEN = 276,
     TOKEN_END_TAG = 277,
     TOKEN_SELF_CLOSING_TAG = 278,
     TOKEN_VAR_INT_OPEN = 279,
     TOKEN_VAR_INT_CLOSE = 280,
     TOKEN_VAR_FLOAT_OPEN = 281,
     TOKEN_VAR_FLOAT_CLOSE = 282,
     TOKEN_VAR_BOOLEAN_OPEN = 283,
     TOKEN_VAR_BOOLEAN_CLOSE = 284,
     TOKEN_VAR_STRING_OPEN = 285,
     TOKEN_VAR_STRING_CLOSE = 286,
     TOKEN_EXPRESSION = 287,
     TOKEN_STRING = 288,
     TOKEN_PLUS = 289,
     TOKEN_MINUS = 290,
     TOKEN_MULTIPLY = 291,
     TOKEN_DIVIDE = 292,
     TOKEN_GREATER_THAN = 293,
     TOKEN_LOWER_THAN = 294,
     TOKEN_GREATER_OR_EQUAL = 295,
     TOKEN_LOWER_OR_EQUAL = 296,
     TOKEN_EQUAL = 297,
     TOKEN_OPEN_PARENTHESIS = 298,
     TOKEN_CLOSE_PARENTHESIS = 299,
     TOKEN_ASSIGN = 300,
     TOKEN_QUOTE = 301,
     IDENTIFICATEUR = 302,
     TOKEN_INT = 303,
     TOKEN_FLOAT = 304,
     TOKEN_BOOLEAN = 305
   };
#endif
/* Tokens.  */
#define TOKEN_UNRECOGNIZED 258
#define TOKEN_PROGRAM_OPEN 259
#define TOKEN_PROGRAM_CLOSE 260
#define TOKEN_VARIABLES_OPEN 261
#define TOKEN_VARIABLES_CLOSE 262
#define TOKEN_INSTRUCTIONS_OPEN 263
#define TOKEN_INSTRUCTIONS_CLOSE 264
#define TOKEN_ASSIGN_OPEN 265
#define TOKEN_ASSIGN_CLOSE 266
#define TOKEN_PRINT_OPEN 267
#define TOKEN_PRINT_CLOSE 268
#define TOKEN_IF_OPEN 269
#define TOKEN_IF_CLOSE 270
#define TOKEN_ELSE 271
#define TOKEN_WHILE_OPEN 272
#define TOKEN_WHILE_CLOSE 273
#define TOKEN_ARRAY_OPEN 274
#define TOKEN_ARRAY_CLOSE 275
#define TOKEN_ELEMENT_OPEN 276
#define TOKEN_END_TAG 277
#define TOKEN_SELF_CLOSING_TAG 278
#define TOKEN_VAR_INT_OPEN 279
#define TOKEN_VAR_INT_CLOSE 280
#define TOKEN_VAR_FLOAT_OPEN 281
#define TOKEN_VAR_FLOAT_CLOSE 282
#define TOKEN_VAR_BOOLEAN_OPEN 283
#define TOKEN_VAR_BOOLEAN_CLOSE 284
#define TOKEN_VAR_STRING_OPEN 285
#define TOKEN_VAR_STRING_CLOSE 286
#define TOKEN_EXPRESSION 287
#define TOKEN_STRING 288
#define TOKEN_PLUS 289
#define TOKEN_MINUS 290
#define TOKEN_MULTIPLY 291
#define TOKEN_DIVIDE 292
#define TOKEN_GREATER_THAN 293
#define TOKEN_LOWER_THAN 294
#define TOKEN_GREATER_OR_EQUAL 295
#define TOKEN_LOWER_OR_EQUAL 296
#define TOKEN_EQUAL 297
#define TOKEN_OPEN_PARENTHESIS 298
#define TOKEN_CLOSE_PARENTHESIS 299
#define TOKEN_ASSIGN 300
#define TOKEN_QUOTE 301
#define IDENTIFICATEUR 302
#define TOKEN_INT 303
#define TOKEN_FLOAT 304
#define TOKEN_BOOLEAN 305




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 86 "syntaxique.y"
{
    int intVal;
    float floatVal;
    char* strVal;
    bool boolVal;
    AttributeValue attr;
}
/* Line 1529 of yacc.c.  */
#line 157 "syntaxique.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

