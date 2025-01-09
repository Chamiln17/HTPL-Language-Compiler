/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 2 "syntaxique.y"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "tableSymbole.h"
extern int yylineno;
extern int yyleng;
extern int current_column;
int yylex();
void yyerror(const char *s);
void yysuccess(char *s);
int currentColumn = 1; 

SymbolTable symbolTable;

char* trimQuotes(char* str) {
    size_t len = strlen(str);
    if (len >= 2 && str[0] == '"' && str[len - 1] == '"') {
        str[len - 1] = '\0';
        return str + 1;
    }
    return str;
}

typedef struct {
    char* name;
    union {
        int intVal;
        float floatVal;
        char* strVal;
        bool boolVal;
    } value;
    DataType type;
} AttributeValue;

typedef struct quadruplet{
char op[15];
char opr1[15];
char opr2[15];
char res[15];
}Quad;

Quad quad[1000];

int sauv_fin_if[100];
int sauv_fin_else[100];
int sauv_begin_While[100];
int sauv_while_condition[100];
int top_fin_if = -1;
int top_fin_else = -1;
int top_begin_While = -1;
int top_while_condition = -1;
void push(int stack[], int *top, int value) {
    stack[++(*top)] = value;
}

int pop(int stack[], int *top) {
    if (*top == -1) {
        fprintf(stderr, "Stack underflow\n");
        exit(EXIT_FAILURE);
    }
    return stack[(*top)--];
}


#line 138 "syntaxique.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "syntaxique.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_TOKEN_UNRECOGNIZED = 3,         /* TOKEN_UNRECOGNIZED  */
  YYSYMBOL_TOKEN_PROGRAM_OPEN = 4,         /* TOKEN_PROGRAM_OPEN  */
  YYSYMBOL_TOKEN_PROGRAM_CLOSE = 5,        /* TOKEN_PROGRAM_CLOSE  */
  YYSYMBOL_TOKEN_VARIABLES_OPEN = 6,       /* TOKEN_VARIABLES_OPEN  */
  YYSYMBOL_TOKEN_VARIABLES_CLOSE = 7,      /* TOKEN_VARIABLES_CLOSE  */
  YYSYMBOL_TOKEN_INSTRUCTIONS_OPEN = 8,    /* TOKEN_INSTRUCTIONS_OPEN  */
  YYSYMBOL_TOKEN_INSTRUCTIONS_CLOSE = 9,   /* TOKEN_INSTRUCTIONS_CLOSE  */
  YYSYMBOL_TOKEN_ASSIGN_OPEN = 10,         /* TOKEN_ASSIGN_OPEN  */
  YYSYMBOL_TOKEN_ASSIGN_CLOSE = 11,        /* TOKEN_ASSIGN_CLOSE  */
  YYSYMBOL_TOKEN_PRINT_OPEN = 12,          /* TOKEN_PRINT_OPEN  */
  YYSYMBOL_TOKEN_PRINT_CLOSE = 13,         /* TOKEN_PRINT_CLOSE  */
  YYSYMBOL_TOKEN_IF_OPEN = 14,             /* TOKEN_IF_OPEN  */
  YYSYMBOL_TOKEN_IF_CLOSE = 15,            /* TOKEN_IF_CLOSE  */
  YYSYMBOL_TOKEN_ELSE = 16,                /* TOKEN_ELSE  */
  YYSYMBOL_TOKEN_WHILE_OPEN = 17,          /* TOKEN_WHILE_OPEN  */
  YYSYMBOL_TOKEN_WHILE_CLOSE = 18,         /* TOKEN_WHILE_CLOSE  */
  YYSYMBOL_TOKEN_ARRAY_OPEN = 19,          /* TOKEN_ARRAY_OPEN  */
  YYSYMBOL_TOKEN_ARRAY_CLOSE = 20,         /* TOKEN_ARRAY_CLOSE  */
  YYSYMBOL_TOKEN_ELEMENT_OPEN = 21,        /* TOKEN_ELEMENT_OPEN  */
  YYSYMBOL_TOKEN_END_TAG = 22,             /* TOKEN_END_TAG  */
  YYSYMBOL_TOKEN_SELF_CLOSING_TAG = 23,    /* TOKEN_SELF_CLOSING_TAG  */
  YYSYMBOL_TOKEN_VAR_INT_OPEN = 24,        /* TOKEN_VAR_INT_OPEN  */
  YYSYMBOL_TOKEN_VAR_INT_CLOSE = 25,       /* TOKEN_VAR_INT_CLOSE  */
  YYSYMBOL_TOKEN_VAR_FLOAT_OPEN = 26,      /* TOKEN_VAR_FLOAT_OPEN  */
  YYSYMBOL_TOKEN_VAR_FLOAT_CLOSE = 27,     /* TOKEN_VAR_FLOAT_CLOSE  */
  YYSYMBOL_TOKEN_VAR_BOOLEAN_OPEN = 28,    /* TOKEN_VAR_BOOLEAN_OPEN  */
  YYSYMBOL_TOKEN_VAR_BOOLEAN_CLOSE = 29,   /* TOKEN_VAR_BOOLEAN_CLOSE  */
  YYSYMBOL_TOKEN_VAR_STRING_OPEN = 30,     /* TOKEN_VAR_STRING_OPEN  */
  YYSYMBOL_TOKEN_VAR_STRING_CLOSE = 31,    /* TOKEN_VAR_STRING_CLOSE  */
  YYSYMBOL_TOKEN_EXPRESSION = 32,          /* TOKEN_EXPRESSION  */
  YYSYMBOL_TOKEN_STRING = 33,              /* TOKEN_STRING  */
  YYSYMBOL_TOKEN_PLUS = 34,                /* TOKEN_PLUS  */
  YYSYMBOL_TOKEN_MINUS = 35,               /* TOKEN_MINUS  */
  YYSYMBOL_TOKEN_MULTIPLY = 36,            /* TOKEN_MULTIPLY  */
  YYSYMBOL_TOKEN_DIVIDE = 37,              /* TOKEN_DIVIDE  */
  YYSYMBOL_TOKEN_GREATER_THAN = 38,        /* TOKEN_GREATER_THAN  */
  YYSYMBOL_TOKEN_LOWER_THAN = 39,          /* TOKEN_LOWER_THAN  */
  YYSYMBOL_TOKEN_GREATER_OR_EQUAL = 40,    /* TOKEN_GREATER_OR_EQUAL  */
  YYSYMBOL_TOKEN_LOWER_OR_EQUAL = 41,      /* TOKEN_LOWER_OR_EQUAL  */
  YYSYMBOL_TOKEN_EQUAL = 42,               /* TOKEN_EQUAL  */
  YYSYMBOL_TOKEN_OPEN_PARENTHESIS = 43,    /* TOKEN_OPEN_PARENTHESIS  */
  YYSYMBOL_TOKEN_CLOSE_PARENTHESIS = 44,   /* TOKEN_CLOSE_PARENTHESIS  */
  YYSYMBOL_TOKEN_ASSIGN = 45,              /* TOKEN_ASSIGN  */
  YYSYMBOL_TOKEN_QUOTE = 46,               /* TOKEN_QUOTE  */
  YYSYMBOL_IDENTIFICATEUR = 47,            /* IDENTIFICATEUR  */
  YYSYMBOL_TOKEN_INT = 48,                 /* TOKEN_INT  */
  YYSYMBOL_TOKEN_FLOAT = 49,               /* TOKEN_FLOAT  */
  YYSYMBOL_TOKEN_BOOLEAN = 50,             /* TOKEN_BOOLEAN  */
  YYSYMBOL_YYACCEPT = 51,                  /* $accept  */
  YYSYMBOL_program = 52,                   /* program  */
  YYSYMBOL_variables_list = 53,            /* variables_list  */
  YYSYMBOL_declaration_list = 54,          /* declaration_list  */
  YYSYMBOL_55_1 = 55,                      /* $@1  */
  YYSYMBOL_56_2 = 56,                      /* $@2  */
  YYSYMBOL_57_3 = 57,                      /* $@3  */
  YYSYMBOL_58_4 = 58,                      /* $@4  */
  YYSYMBOL_attributes = 59,                /* attributes  */
  YYSYMBOL_elements = 60,                  /* elements  */
  YYSYMBOL_element = 61,                   /* element  */
  YYSYMBOL_instruction_list = 62,          /* instruction_list  */
  YYSYMBOL_instruction = 63,               /* instruction  */
  YYSYMBOL_assignment = 64,                /* assignment  */
  YYSYMBOL_if_statement = 65,              /* if_statement  */
  YYSYMBOL_while_statement = 66,           /* while_statement  */
  YYSYMBOL_print_statement = 67,           /* print_statement  */
  YYSYMBOL_expr_arithmetique = 68,         /* expr_arithmetique  */
  YYSYMBOL_terme = 69,                     /* terme  */
  YYSYMBOL_facteur = 70,                   /* facteur  */
  YYSYMBOL_expr_logique = 71               /* expr_logique  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  5
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   149

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  51
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  21
/* YYNRULES -- Number of rules.  */
#define YYNRULES  65
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  128

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   305


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   117,   117,   124,   125,   129,   129,   134,   134,   139,
     139,   143,   143,   147,   148,   153,   158,   162,   166,   167,
     170,   173,   176,   179,   180,   183,   186,   189,   192,   197,
     207,   213,   218,   228,   233,   241,   241,   245,   249,   250,
     254,   255,   256,   257,   261,   271,   274,   282,   288,   292,
     293,   294,   298,   299,   300,   304,   305,   306,   309,   313,
     316,   319,   322,   325,   328,   331
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "TOKEN_UNRECOGNIZED",
  "TOKEN_PROGRAM_OPEN", "TOKEN_PROGRAM_CLOSE", "TOKEN_VARIABLES_OPEN",
  "TOKEN_VARIABLES_CLOSE", "TOKEN_INSTRUCTIONS_OPEN",
  "TOKEN_INSTRUCTIONS_CLOSE", "TOKEN_ASSIGN_OPEN", "TOKEN_ASSIGN_CLOSE",
  "TOKEN_PRINT_OPEN", "TOKEN_PRINT_CLOSE", "TOKEN_IF_OPEN",
  "TOKEN_IF_CLOSE", "TOKEN_ELSE", "TOKEN_WHILE_OPEN", "TOKEN_WHILE_CLOSE",
  "TOKEN_ARRAY_OPEN", "TOKEN_ARRAY_CLOSE", "TOKEN_ELEMENT_OPEN",
  "TOKEN_END_TAG", "TOKEN_SELF_CLOSING_TAG", "TOKEN_VAR_INT_OPEN",
  "TOKEN_VAR_INT_CLOSE", "TOKEN_VAR_FLOAT_OPEN", "TOKEN_VAR_FLOAT_CLOSE",
  "TOKEN_VAR_BOOLEAN_OPEN", "TOKEN_VAR_BOOLEAN_CLOSE",
  "TOKEN_VAR_STRING_OPEN", "TOKEN_VAR_STRING_CLOSE", "TOKEN_EXPRESSION",
  "TOKEN_STRING", "TOKEN_PLUS", "TOKEN_MINUS", "TOKEN_MULTIPLY",
  "TOKEN_DIVIDE", "TOKEN_GREATER_THAN", "TOKEN_LOWER_THAN",
  "TOKEN_GREATER_OR_EQUAL", "TOKEN_LOWER_OR_EQUAL", "TOKEN_EQUAL",
  "TOKEN_OPEN_PARENTHESIS", "TOKEN_CLOSE_PARENTHESIS", "TOKEN_ASSIGN",
  "TOKEN_QUOTE", "IDENTIFICATEUR", "TOKEN_INT", "TOKEN_FLOAT",
  "TOKEN_BOOLEAN", "$accept", "program", "variables_list",
  "declaration_list", "$@1", "$@2", "$@3", "$@4", "attributes", "elements",
  "element", "instruction_list", "instruction", "assignment",
  "if_statement", "while_statement", "print_statement",
  "expr_arithmetique", "terme", "facteur", "expr_logique", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-82)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-18)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
       3,    21,    34,    -2,    37,   -82,     0,     0,     0,     0,
       0,    43,   -82,    12,    19,    45,    54,    84,    97,   -82,
      83,   -14,    38,    -2,    89,    -2,    89,    -2,    75,    -2,
      41,    -2,    74,     0,     0,     0,     0,   -82,   -82,   -82,
     -82,   -82,     0,    75,     0,    62,    38,   -82,    89,   -82,
     -82,   -82,    -4,    98,   -82,   -82,     5,   -82,    75,   -82,
      46,    60,   -82,    65,   -82,   -82,    71,    79,    82,    99,
     -82,    14,    67,    90,    -2,   -82,   -19,   120,    89,    89,
      89,    89,   122,    31,   102,    89,    89,    89,    89,    89,
     136,   140,   -82,   -82,   -82,   -82,     0,     0,   -82,   -82,
     -82,    -2,    98,    98,   -82,   -82,    -2,   -82,   105,   105,
     105,   105,   105,    -2,    -2,   100,    91,   -82,   -82,   -82,
     -82,   -82,   -82,   -82,   -82,   -82,   116,   -82
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     4,     0,     0,     0,     1,     0,     0,     0,     0,
       0,     0,    39,     0,     0,     0,     0,     0,     0,     3,
       0,     0,    36,    28,     0,    24,     0,    25,     0,    27,
       0,    26,     0,     0,     0,     0,     0,    38,    40,    41,
      42,    43,    32,     0,     0,     0,    36,    23,     0,    57,
      55,    56,     0,    49,    52,    19,     0,    20,     0,    65,
       0,     0,    22,     0,    21,     2,     0,     0,     0,     0,
      29,     0,     0,     0,    18,    35,     0,     5,     0,     0,
       0,     0,     7,     0,     0,     0,     0,     0,     0,     0,
      11,     9,    44,    48,    39,    39,    33,    34,    37,    13,
      58,     0,    50,    51,    53,    54,     0,    64,    60,    61,
      62,    63,    59,     0,     0,     0,     0,    30,    31,     6,
       8,    12,    10,    45,    39,    47,     0,    46
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -82,   -82,   -82,   -23,   -82,   -82,   -82,   -82,     2,   103,
     -82,   -81,   -82,   -82,   -82,   -82,   -82,   -25,    63,    64,
     -38
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
       0,     2,     4,    11,   101,   106,   114,   113,    14,    45,
      46,    20,    37,    38,    39,    40,    41,    52,    53,    54,
      61
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      47,    56,    55,    60,    57,    72,    62,     1,    64,    15,
      16,    17,    18,   115,   116,    78,    79,     6,    71,    42,
      84,    77,     7,    76,     8,   100,     9,     3,    10,    43,
      78,    79,    82,    83,     5,    66,    67,    68,    69,    78,
      79,    22,    23,   126,    70,    12,    73,    13,    78,    79,
      19,    99,    85,    86,    87,    88,    89,    21,    96,    44,
     108,   109,   110,   111,   112,    78,    79,    24,    25,    85,
      86,    87,    88,    89,    63,   100,    26,    27,   119,    65,
      78,    79,    74,   120,    85,    86,    87,    88,    89,    90,
     121,   122,    32,    33,    92,    34,    91,    35,   117,   118,
      36,    33,    93,    34,    94,    35,    28,    29,    36,   125,
      33,    97,    34,    98,    35,   123,   124,    36,    58,    30,
      31,    95,    49,    50,    51,    59,    33,   -14,    34,   -15,
      35,   127,    48,    36,    80,    81,    49,    50,    51,    78,
      79,   102,   103,   -17,   104,   105,   107,   -16,     0,    75
};

static const yytype_int8 yycheck[] =
{
      23,    26,    25,    28,    27,    43,    29,     4,    31,     7,
       8,     9,    10,    94,    95,    34,    35,    19,    43,    33,
      58,    25,    24,    48,    26,    44,    28,     6,    30,    43,
      34,    35,    27,    58,     0,    33,    34,    35,    36,    34,
      35,    22,    23,   124,    42,     8,    44,    47,    34,    35,
       7,    74,    38,    39,    40,    41,    42,    45,    44,    21,
      85,    86,    87,    88,    89,    34,    35,    22,    23,    38,
      39,    40,    41,    42,    33,    44,    22,    23,   101,     5,
      34,    35,    20,   106,    38,    39,    40,    41,    42,    29,
     113,   114,     9,    10,    23,    12,    31,    14,    96,    97,
      17,    10,    23,    12,    22,    14,    22,    23,    17,    18,
      10,    44,    12,    23,    14,    15,    16,    17,    43,    22,
      23,    22,    47,    48,    49,    50,    10,     7,    12,     7,
      14,    15,    43,    17,    36,    37,    47,    48,    49,    34,
      35,    78,    79,     7,    80,    81,    44,     7,    -1,    46
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     4,    52,     6,    53,     0,    19,    24,    26,    28,
      30,    54,     8,    47,    59,    59,    59,    59,    59,     7,
      62,    45,    22,    23,    22,    23,    22,    23,    22,    23,
      22,    23,     9,    10,    12,    14,    17,    63,    64,    65,
      66,    67,    33,    43,    21,    60,    61,    54,    43,    47,
      48,    49,    68,    69,    70,    54,    68,    54,    43,    50,
      68,    71,    54,    33,    54,     5,    59,    59,    59,    59,
      59,    68,    71,    59,    20,    60,    68,    25,    34,    35,
      36,    37,    27,    68,    71,    38,    39,    40,    41,    42,
      29,    31,    23,    23,    22,    22,    44,    44,    23,    54,
      44,    55,    69,    69,    70,    70,    56,    44,    68,    68,
      68,    68,    68,    58,    57,    62,    62,    59,    59,    54,
      54,    54,    54,    15,    16,    18,    62,    15
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    51,    52,    53,    53,    55,    54,    56,    54,    57,
      54,    58,    54,    54,    54,    54,    54,    54,    54,    54,
      54,    54,    54,    54,    54,    54,    54,    54,    54,    59,
      59,    59,    59,    59,    59,    60,    60,    61,    62,    62,
      63,    63,    63,    63,    64,    65,    65,    66,    67,    68,
      68,    68,    69,    69,    69,    70,    70,    70,    70,    71,
      71,    71,    71,    71,    71,    71
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     6,     3,     0,     0,     7,     0,     7,     0,
       7,     0,     7,     6,     5,     5,     5,     5,     5,     4,
       4,     4,     4,     4,     3,     3,     3,     3,     3,     4,
       6,     6,     3,     5,     5,     2,     0,     3,     2,     0,
       1,     1,     1,     1,     3,     5,     7,     5,     3,     1,
       3,     3,     1,     3,     3,     1,     1,     1,     3,     3,
       3,     3,     3,     3,     3,     1
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 5: /* $@1: %empty  */
#line 129 "syntaxique.y"
                                                                                     {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_INTEGER);
        int value = (yyvsp[-1].intVal);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &value);
    }
#line 1296 "syntaxique.tab.c"
    break;

  case 7: /* $@2: %empty  */
#line 134 "syntaxique.y"
                                                                                           {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_FLOAT);
        float value = (float)(yyvsp[-1].intVal);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &value);
    }
#line 1306 "syntaxique.tab.c"
    break;

  case 9: /* $@3: %empty  */
#line 139 "syntaxique.y"
                                                                                        {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_STRING);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &(yyvsp[-1].strVal));
    }
#line 1315 "syntaxique.tab.c"
    break;

  case 11: /* $@4: %empty  */
#line 143 "syntaxique.y"
                                                                                          {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_BOOLEAN);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &(yyvsp[-1].boolVal));
    }
#line 1324 "syntaxique.tab.c"
    break;

  case 14: /* declaration_list: TOKEN_VAR_INT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_INT_CLOSE  */
#line 148 "syntaxique.y"
                                                                                       {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_INTEGER);
        int value = (yyvsp[-1].intVal);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &value);
    }
#line 1334 "syntaxique.tab.c"
    break;

  case 15: /* declaration_list: TOKEN_VAR_FLOAT_OPEN attributes TOKEN_END_TAG expr_arithmetique TOKEN_VAR_FLOAT_CLOSE  */
#line 153 "syntaxique.y"
                                                                                           {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_FLOAT);
        float value = (float)(yyvsp[-1].intVal);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &value);
    }
#line 1344 "syntaxique.tab.c"
    break;

  case 16: /* declaration_list: TOKEN_VAR_STRING_OPEN attributes TOKEN_END_TAG TOKEN_STRING TOKEN_VAR_STRING_CLOSE  */
#line 158 "syntaxique.y"
                                                                                        {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_STRING);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &(yyvsp[-1].strVal));
    }
#line 1353 "syntaxique.tab.c"
    break;

  case 17: /* declaration_list: TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_END_TAG expr_logique TOKEN_VAR_BOOLEAN_CLOSE  */
#line 162 "syntaxique.y"
                                                                                          {
        addSymbol(&symbolTable, (yyvsp[-3].attr).name, TYPE_BOOLEAN);
        updateSymbolValue(&symbolTable, (yyvsp[-3].attr).name, &(yyvsp[-1].boolVal));
    }
#line 1362 "syntaxique.tab.c"
    break;

  case 19: /* declaration_list: TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list  */
#line 167 "syntaxique.y"
                                                                           {
        addSymbol(&symbolTable, (yyvsp[-2].attr).name, TYPE_INTEGER);
    }
#line 1370 "syntaxique.tab.c"
    break;

  case 20: /* declaration_list: TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list  */
#line 170 "syntaxique.y"
                                                                             {
        addSymbol(&symbolTable, (yyvsp[-2].attr).name, TYPE_FLOAT);
    }
#line 1378 "syntaxique.tab.c"
    break;

  case 21: /* declaration_list: TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list  */
#line 173 "syntaxique.y"
                                                                              {
        addSymbol(&symbolTable, (yyvsp[-2].attr).name, TYPE_STRING);
    }
#line 1386 "syntaxique.tab.c"
    break;

  case 22: /* declaration_list: TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG declaration_list  */
#line 176 "syntaxique.y"
                                                                               {
        addSymbol(&symbolTable, (yyvsp[-2].attr).name, TYPE_BOOLEAN);
    }
#line 1394 "syntaxique.tab.c"
    break;

  case 24: /* declaration_list: TOKEN_VAR_INT_OPEN attributes TOKEN_SELF_CLOSING_TAG  */
#line 180 "syntaxique.y"
                                                          {
        addSymbol(&symbolTable, (yyvsp[-1].attr).name, TYPE_INTEGER);
    }
#line 1402 "syntaxique.tab.c"
    break;

  case 25: /* declaration_list: TOKEN_VAR_FLOAT_OPEN attributes TOKEN_SELF_CLOSING_TAG  */
#line 183 "syntaxique.y"
                                                            {
        addSymbol(&symbolTable, (yyvsp[-1].attr).name, TYPE_FLOAT);
    }
#line 1410 "syntaxique.tab.c"
    break;

  case 26: /* declaration_list: TOKEN_VAR_STRING_OPEN attributes TOKEN_SELF_CLOSING_TAG  */
#line 186 "syntaxique.y"
                                                             {
        addSymbol(&symbolTable, (yyvsp[-1].attr).name, TYPE_STRING);
    }
#line 1418 "syntaxique.tab.c"
    break;

  case 27: /* declaration_list: TOKEN_VAR_BOOLEAN_OPEN attributes TOKEN_SELF_CLOSING_TAG  */
#line 189 "syntaxique.y"
                                                              {
        addSymbol(&symbolTable, (yyvsp[-1].attr).name, TYPE_BOOLEAN);
    }
#line 1426 "syntaxique.tab.c"
    break;

  case 29: /* attributes: IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING attributes  */
#line 197 "syntaxique.y"
                                                       {
        if (strcmp((yyvsp[-3].strVal),"name")==0){
        (yyval.attr).name = strdup(trimQuotes((yyvsp[-1].strVal)));  // this is the variable name
        (yyval.attr).type = TYPE_STRING;
        }else{// else so the attribute isn't for naming a var , we just return the name of attribute and its value (will be used in case of assign)
        (yyval.attr).name = strdup((yyvsp[-3].strVal));
        (yyval.attr).value.strVal = strdup((yyvsp[-1].strVal));  
        (yyval.attr).type = TYPE_STRING;
        }
    }
#line 1441 "syntaxique.tab.c"
    break;

  case 30: /* attributes: IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS attributes  */
#line 207 "syntaxique.y"
                                                                                                             {
        //this is to get just the value of the attribute and its name
        (yyval.attr).name = strdup((yyvsp[-5].strVal));
        (yyval.attr).value.intVal = (yyvsp[-2].intVal);  
        (yyval.attr).type = TYPE_INTEGER;
    }
#line 1452 "syntaxique.tab.c"
    break;

  case 31: /* attributes: IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS attributes  */
#line 213 "syntaxique.y"
                                                                                                        {
        (yyval.attr).name = strdup((yyvsp[-5].strVal));
        (yyval.attr).value.boolVal = (yyvsp[-2].boolVal);  
        (yyval.attr).type = TYPE_BOOLEAN;
    }
#line 1462 "syntaxique.tab.c"
    break;

  case 32: /* attributes: IDENTIFICATEUR TOKEN_ASSIGN TOKEN_STRING  */
#line 218 "syntaxique.y"
                                              {
        if (strcmp((yyvsp[-2].strVal),"name")==0){
        (yyval.attr).name = strdup(trimQuotes((yyvsp[0].strVal)));  // this is the variable name
        (yyval.attr).type = TYPE_STRING;
        }else{// else so the attribute isn't for naming a var , we just return the name of attribute and its value (will be used in case of assign)
        (yyval.attr).name = strdup((yyvsp[-2].strVal));
        (yyval.attr).value.strVal = strdup((yyvsp[0].strVal));  
        (yyval.attr).type = TYPE_STRING;
        }
    }
#line 1477 "syntaxique.tab.c"
    break;

  case 33: /* attributes: IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS  */
#line 228 "syntaxique.y"
                                                                                                  {
        (yyval.attr).name = strdup((yyvsp[-4].strVal));
        (yyval.attr).value.intVal = (yyvsp[-1].intVal);  
        (yyval.attr).type = TYPE_INTEGER;
    }
#line 1487 "syntaxique.tab.c"
    break;

  case 34: /* attributes: IDENTIFICATEUR TOKEN_ASSIGN TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS  */
#line 233 "syntaxique.y"
                                                                                             {
        (yyval.attr).name = strdup((yyvsp[-4].strVal));
        (yyval.attr).value.boolVal = (yyvsp[-1].boolVal);  
        (yyval.attr).type = TYPE_BOOLEAN;
    }
#line 1497 "syntaxique.tab.c"
    break;

  case 44: /* assignment: TOKEN_ASSIGN_OPEN attributes TOKEN_SELF_CLOSING_TAG  */
#line 261 "syntaxique.y"
                                                        {
        //update the value of a variable
        SymbolEntry* entry = findSymbol(&symbolTable, (yyvsp[-1].attr).name);
        if (!entry) {
            yyerror("Variable undefined");
        } 
}
#line 1509 "syntaxique.tab.c"
    break;

  case 50: /* expr_arithmetique: expr_arithmetique TOKEN_PLUS terme  */
#line 293 "syntaxique.y"
                                        { (yyval.intVal) = (yyvsp[-2].intVal) + (yyvsp[0].intVal); }
#line 1515 "syntaxique.tab.c"
    break;

  case 51: /* expr_arithmetique: expr_arithmetique TOKEN_MINUS terme  */
#line 294 "syntaxique.y"
                                         { (yyval.intVal) = (yyvsp[-2].intVal) - (yyvsp[0].intVal); }
#line 1521 "syntaxique.tab.c"
    break;

  case 53: /* terme: terme TOKEN_MULTIPLY facteur  */
#line 299 "syntaxique.y"
                                  { (yyval.intVal) = (yyvsp[-2].intVal) * (yyvsp[0].intVal); }
#line 1527 "syntaxique.tab.c"
    break;

  case 54: /* terme: terme TOKEN_DIVIDE facteur  */
#line 300 "syntaxique.y"
                                { (yyval.intVal) = (yyvsp[-2].intVal) / (yyvsp[0].intVal); }
#line 1533 "syntaxique.tab.c"
    break;

  case 55: /* facteur: TOKEN_INT  */
#line 304 "syntaxique.y"
             { (yyval.intVal) = (yyvsp[0].intVal); }
#line 1539 "syntaxique.tab.c"
    break;

  case 56: /* facteur: TOKEN_FLOAT  */
#line 305 "syntaxique.y"
                 { (yyval.intVal) = (int)(yyvsp[0].floatVal); }
#line 1545 "syntaxique.tab.c"
    break;

  case 57: /* facteur: IDENTIFICATEUR  */
#line 306 "syntaxique.y"
                    {
        (yyval.intVal)=1;
    }
#line 1553 "syntaxique.tab.c"
    break;

  case 58: /* facteur: TOKEN_OPEN_PARENTHESIS expr_arithmetique TOKEN_CLOSE_PARENTHESIS  */
#line 309 "syntaxique.y"
                                                                      { (yyval.intVal) = (yyvsp[-1].intVal); }
#line 1559 "syntaxique.tab.c"
    break;

  case 59: /* expr_logique: expr_arithmetique TOKEN_EQUAL expr_arithmetique  */
#line 313 "syntaxique.y"
                                                   {
    (yyval.boolVal) = ((yyvsp[-2].intVal) == (yyvsp[0].intVal)); 
  }
#line 1567 "syntaxique.tab.c"
    break;

  case 60: /* expr_logique: expr_arithmetique TOKEN_GREATER_THAN expr_arithmetique  */
#line 316 "syntaxique.y"
                                                            {
    (yyval.boolVal) = ((yyvsp[-2].intVal) > (yyvsp[0].intVal));
  }
#line 1575 "syntaxique.tab.c"
    break;

  case 61: /* expr_logique: expr_arithmetique TOKEN_LOWER_THAN expr_arithmetique  */
#line 319 "syntaxique.y"
                                                          {
    (yyval.boolVal) = ((yyvsp[-2].intVal) < (yyvsp[0].intVal)); 
  }
#line 1583 "syntaxique.tab.c"
    break;

  case 62: /* expr_logique: expr_arithmetique TOKEN_GREATER_OR_EQUAL expr_arithmetique  */
#line 322 "syntaxique.y"
                                                                 {
    (yyval.boolVal) = ((yyvsp[-2].intVal) >= (yyvsp[0].intVal)); 
  }
#line 1591 "syntaxique.tab.c"
    break;

  case 63: /* expr_logique: expr_arithmetique TOKEN_LOWER_OR_EQUAL expr_arithmetique  */
#line 325 "syntaxique.y"
                                                              {
    (yyval.boolVal) = ((yyvsp[-2].intVal) <= (yyvsp[0].intVal)); 
  }
#line 1599 "syntaxique.tab.c"
    break;

  case 64: /* expr_logique: TOKEN_OPEN_PARENTHESIS expr_logique TOKEN_CLOSE_PARENTHESIS  */
#line 328 "syntaxique.y"
                                                                 {
    (yyval.boolVal) = (yyvsp[-1].boolVal) ; 
  }
#line 1607 "syntaxique.tab.c"
    break;


#line 1611 "syntaxique.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 334 "syntaxique.y"


void yysuccess(char *s){
    currentColumn+=yyleng;
}

void yyerror(const char *s) {
    fprintf(stdout, "File output, line %d, character %d :  %s \n", yylineno, currentColumn, s);
}

int main(void) {
    initSymbolTable(&symbolTable);
    if (yyparse() == 0) {
        printf("Parsing successful\n");
    } else {
        fprintf(stderr, "Parsing failed\n");
        return 1;
    }

    printSymbolTable(&symbolTable);
    freeSymbolTable(&symbolTable);
    return 0;
}


