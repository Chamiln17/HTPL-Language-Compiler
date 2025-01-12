/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_SYNTAXIQUE_TAB_H_INCLUDED
# define YY_YY_SYNTAXIQUE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TOKEN_UNRECOGNIZED = 258,      /* TOKEN_UNRECOGNIZED  */
    TOKEN_PROGRAM_OPEN = 259,      /* TOKEN_PROGRAM_OPEN  */
    TOKEN_PROGRAM_CLOSE = 260,     /* TOKEN_PROGRAM_CLOSE  */
    TOKEN_VARIABLES_OPEN = 261,    /* TOKEN_VARIABLES_OPEN  */
    TOKEN_VARIABLES_CLOSE = 262,   /* TOKEN_VARIABLES_CLOSE  */
    TOKEN_INSTRUCTIONS_OPEN = 263, /* TOKEN_INSTRUCTIONS_OPEN  */
    TOKEN_INSTRUCTIONS_CLOSE = 264, /* TOKEN_INSTRUCTIONS_CLOSE  */
    TOKEN_ASSIGN_OPEN = 265,       /* TOKEN_ASSIGN_OPEN  */
    TOKEN_ASSIGN_CLOSE = 266,      /* TOKEN_ASSIGN_CLOSE  */
    TOKEN_PRINT_OPEN = 267,        /* TOKEN_PRINT_OPEN  */
    TOKEN_PRINT_CLOSE = 268,       /* TOKEN_PRINT_CLOSE  */
    TOKEN_IF_OPEN = 269,           /* TOKEN_IF_OPEN  */
    TOKEN_IF_CLOSE = 270,          /* TOKEN_IF_CLOSE  */
    TOKEN_ELSE = 271,              /* TOKEN_ELSE  */
    TOKEN_WHILE_OPEN = 272,        /* TOKEN_WHILE_OPEN  */
    TOKEN_WHILE_CLOSE = 273,       /* TOKEN_WHILE_CLOSE  */
    TOKEN_ARRAY_OPEN = 274,        /* TOKEN_ARRAY_OPEN  */
    TOKEN_ARRAY_CLOSE = 275,       /* TOKEN_ARRAY_CLOSE  */
    TOKEN_ELEMENT_OPEN = 276,      /* TOKEN_ELEMENT_OPEN  */
    TOKEN_END_TAG = 277,           /* TOKEN_END_TAG  */
    TOKEN_SELF_CLOSING_TAG = 278,  /* TOKEN_SELF_CLOSING_TAG  */
    TOKEN_VAR_INT_OPEN = 279,      /* TOKEN_VAR_INT_OPEN  */
    TOKEN_VAR_INT_CLOSE = 280,     /* TOKEN_VAR_INT_CLOSE  */
    TOKEN_VAR_FLOAT_OPEN = 281,    /* TOKEN_VAR_FLOAT_OPEN  */
    TOKEN_VAR_FLOAT_CLOSE = 282,   /* TOKEN_VAR_FLOAT_CLOSE  */
    TOKEN_VAR_BOOLEAN_OPEN = 283,  /* TOKEN_VAR_BOOLEAN_OPEN  */
    TOKEN_VAR_BOOLEAN_CLOSE = 284, /* TOKEN_VAR_BOOLEAN_CLOSE  */
    TOKEN_VAR_STRING_OPEN = 285,   /* TOKEN_VAR_STRING_OPEN  */
    TOKEN_VAR_STRING_CLOSE = 286,  /* TOKEN_VAR_STRING_CLOSE  */
    TOKEN_EXPRESSION = 287,        /* TOKEN_EXPRESSION  */
    TOKEN_STRING = 288,            /* TOKEN_STRING  */
    TOKEN_PLUS = 289,              /* TOKEN_PLUS  */
    TOKEN_MINUS = 290,             /* TOKEN_MINUS  */
    TOKEN_MULTIPLY = 291,          /* TOKEN_MULTIPLY  */
    TOKEN_DIVIDE = 292,            /* TOKEN_DIVIDE  */
    TOKEN_GREATER_THAN = 293,      /* TOKEN_GREATER_THAN  */
    TOKEN_LOWER_THAN = 294,        /* TOKEN_LOWER_THAN  */
    TOKEN_GREATER_OR_EQUAL = 295,  /* TOKEN_GREATER_OR_EQUAL  */
    TOKEN_LOWER_OR_EQUAL = 296,    /* TOKEN_LOWER_OR_EQUAL  */
    TOKEN_EQUAL = 297,             /* TOKEN_EQUAL  */
    TOKEN_OPEN_PARENTHESIS = 298,  /* TOKEN_OPEN_PARENTHESIS  */
    TOKEN_CLOSE_PARENTHESIS = 299, /* TOKEN_CLOSE_PARENTHESIS  */
    TOKEN_ASSIGN = 300,            /* TOKEN_ASSIGN  */
    TOKEN_QUOTE = 301,             /* TOKEN_QUOTE  */
    TOKEN_OPEN_BRACKET = 302,      /* TOKEN_OPEN_BRACKET  */
    TOKEN_CLOSE_BRACKET = 303,     /* TOKEN_CLOSE_BRACKET  */
    IDENTIFICATEUR = 304,          /* IDENTIFICATEUR  */
    TOKEN_INT = 305,               /* TOKEN_INT  */
    TOKEN_FLOAT = 306,             /* TOKEN_FLOAT  */
    TOKEN_BOOLEAN = 307            /* TOKEN_BOOLEAN  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 146 "syntaxique.y"

    int intVal;
    float floatVal;
    char* strVal;
    bool boolVal;
    AttributeValue attr;
    elementsArray elementsValues;

#line 125 "syntaxique.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_SYNTAXIQUE_TAB_H_INCLUDED  */
