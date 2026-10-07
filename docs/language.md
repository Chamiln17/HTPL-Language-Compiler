# HTPL language reference

HTPL is a small imperative language written with HTML-like tags. This reference describes what the current compiler (`htplc`, built from [src/syntaxique.y](../src/syntaxique.y) and [src/htpl_lexer.l](../src/htpl_lexer.l)) actually accepts. Where the original language annex ([reports/Annexe langage.pdf](reports/Annexe%20langage.pdf), in French) says something else, the grammar wins; the differences are listed at the end.

Every `htpl` code block below is either a complete program that `htplc` accepts or an excerpt of the reference program [examples/test.htpl](../examples/test.htpl). Blocks marked `text` show programs that `htplc` rejects.

## Program structure

A program is a `<program>` element holding an optional `<variables>` section followed by a required `<instructions>` section:

```htpl
<program>
<variables>
    <int name="n">(3)</int>
</variables>
<instructions>
    <while condition=(n >> 0)>
        <assign n=(n - 1)/>
    </while>
</instructions>
</program>
```

The smallest valid program has an empty instruction list and no variables:

```htpl
<program>
<instructions>
</instructions>
</program>
```

Rules, from the `program` and `variables_list` rules of the grammar:

- The order is fixed: `<variables>` (if present) comes before `<instructions>`.
- `<instructions>` is mandatory, but may be empty.
- `<variables>` is optional, but if it is present it must contain at least one declaration. `<variables></variables>` is a syntax error.

## Lexical elements

Defined in [src/htpl_lexer.l](../src/htpl_lexer.l):

| Element | Form | Examples |
|---|---|---|
| Identifier | a letter or `_`, then letters, digits or `_` | `counter`, `_tmp1` |
| Integer | one or more digits | `0`, `42` |
| Float | digits `.` digits (both sides required) | `2.5`, `0.75` |
| Boolean | `true` or `false` | `true` |
| String | double quotes, backslash escapes allowed | `"Hello"`, `"a \"b\""` |
| Comment | `#` to the end of the line | `# note` |

Spaces, tabs and newlines separate tokens and are otherwise ignored. There is no negative literal and no unary minus: `(-1)` is a syntax error; write `(0 - 1)`. A float needs digits before the dot: `.5` is rejected. Any character the lexer does not recognise (for example `!` or `&`) stops compilation with `Unexpected token`.

Comments can appear anywhere a token can:

```htpl
# a comment line
<program>
<instructions>
    # another comment
    <print value="hi"/>
</instructions>
</program>
```

## Attributes

Tags carry attributes of the form `name=value`. A value is either a string literal or an expression in parentheses:

- `name="counter"`, `type="int"`, `value="text"`
- `size=(5)`, `condition=(counter >> 0)`, `counter=(counter + 1)`

The parser keeps attributes in order, with two consequences you have to respect:

- The first attribute is the one that counts. A declaration's `name` attribute and an assignment's target must come first.
- Everything after a parenthesised attribute is dropped. In an `<array>` declaration, `size=(n)` must therefore come last; `<array name="v" size=(2) type="int">` fails with `Invalid array declaration: missing name, type, or size`.

## Variables

Each declaration names a variable and gives it a type. There are four scalar types and arrays.

### Declarations with an initial value

```htpl
<program>
<variables>
    <int name="count">(10)</int>
    <int name="n">7</int>
    <float name="rate">(2.5)</float>
    <string name="greeting">"Hello"</string>
    <boolean name="ready">true</boolean>
    <array name="scores" type="int" size=(3)>
        <element value=(10)/>
        <element value=(20)/>
        <element value=(30)/>
    </array>
</variables>
<instructions>
</instructions>
</program>
```

What each body accepts:

| Type | Body | Notes |
|---|---|---|
| `int` | an arithmetic expression, with or without parentheses | `(10)`, `7`, `(a * 3 + 1)` |
| `float` | an arithmetic expression | an integer such as `(3)` is accepted too |
| `string` | a string literal only | another variable or an expression is a syntax error |
| `boolean` | `true`, `false`, a comparison, or either in parentheses | `true`, `(1 << 2)` |

Booleans are stored as `1` (true) and `0` (false). Floats appear in the compiler output in C `%f` form, so `2.5` becomes `2.500000`.

### Declarations without a value

Any declaration can be self-closing. The variable then gets a default: `0` for `int` and `boolean`, `0.0` for `float`, an empty string for `string`.

```htpl
<program>
<variables>
    <float name="f"/>
    <string name="s"/>
    <boolean name="b"/>
    <int name="i"/>
</variables>
<instructions>
</instructions>
</program>
```

A self-closing `<int .../>` is only registered in the symbol table when it is the **last** declaration of the section (see [Limitations](#limitations)). Put self-closing `int` declarations last, or give them a value.

### Arrays

An array has a `name`, an element `type` and a `size`, in that order, and contains zero or more `<element value=.../>` tags. This excerpt comes from the reference program:

```htpl
<array name="numbers" type="int" size=(5)>
    <element value=(1)/>
    <element value=(2)/>
</array>
```

Indexing is 1-based (the compiler emits bounds `1..size`). An array element is written `name[index]`, where the index is an arithmetic expression. Elements can be read in expressions and assigned:

```htpl
<program>
<variables>
    <int name="i">(1)</int>
    <array name="v" type="int" size=(3)/>
</variables>
<instructions>
    <assign v[1]=(v[i + 1] * 2)/>
</instructions>
</program>
```

The compiler stores the initial elements in reverse order: in the excerpt above, `numbers[1]` receives `2` and `numbers[2]` receives `1` (see [examples/test.expected](../examples/test.expected), quads 4 and 5).

## Instructions

Four instructions can appear in `<instructions>`, inside `<if>`, `<else>` and `<while>` bodies, in any order and nesting.

### Assignment

`<assign target=value/>` assigns to a declared variable or an array element. The tag is always self-closing; `<assign ...></assign>` is a syntax error. The value is a parenthesised expression or a string literal:

```htpl
<program>
<variables>
    <float name="rate">(1.5)</float>
    <string name="msg">"a"</string>
    <boolean name="ok">false</boolean>
</variables>
<instructions>
    <assign rate=(3)/>
    <assign msg="b"/>
    <assign ok=(true)/>
    <assign ok=(rate >> 2)/>
</instructions>
</program>
```

A boolean literal must be parenthesised: `<assign ok=true/>` is a syntax error.

### if and if/else

The `<if>` tag takes a `condition` attribute and is closed by `</if>`. An optional `<else>` tag splits the body into the two branches; `<else>` has no closing tag of its own.

```htpl
<program>
<variables>
    <int name="x">(5)</int>
    <int name="sign">(0)</int>
</variables>
<instructions>
    <if condition=(x >>= 0)>
        <assign sign=(1)/>
    <else>
        <assign sign=(0)/>
    </if>
</instructions>
</program>
```

The condition can also be a plain arithmetic expression such as `condition=(a)`; the branch is skipped when its value is zero. Any attribute name other than `condition` fails with `Invalid attribute for if statement`.

### while

`<while condition=(...)>` repeats its body and is closed by `</while>`. Loops and conditionals nest:

```htpl
<program>
<variables>
    <int name="i">(0)</int>
    <int name="total">(0)</int>
</variables>
<instructions>
    <while condition=(i << 10)>
        <if condition=(i == 5)>
            <assign total=(total + 100)/>
        <else>
            <assign total=(total + i)/>
        </if>
        <assign i=(i + 1)/>
    </while>
    <print value="done"/>
</instructions>
</program>
```

A wrong attribute name on `<while>` also reports `Invalid attribute for if statement`.

### print

`<print .../>` is self-closing and accepts any attributes, usually `value`. From the reference program:

```htpl
<print value="Counter initialized to 10"/>
```

The compiler checks the syntax of `print` but generates no code for it (see [Limitations](#limitations)).

## Expressions

### Arithmetic

Arithmetic expressions combine integers, floats, identifiers, array elements and parenthesised sub-expressions with `+`, `-`, `*` and `/`. The `expr_arithmetique`, `terme` and `facteur` rules give the usual precedence: `*` and `/` bind tighter than `+` and `-`, and all four are left-associative.

```htpl
<program>
<variables>
    <int name="x">(0)</int>
    <int name="y">(4)</int>
</variables>
<instructions>
    <assign x=(1 + 2 * 3)/>
    <assign x=((1 + 2) * 3)/>
    <assign x=(y - 2 - 1)/>
    <assign x=(y / 2 * 3)/>
</instructions>
</program>
```

For `1 + 2 * 3` the compiler emits the multiplication first; `y - 2 - 1` is computed as `(y - 2) - 1`.

### Comparisons

HTPL uses doubled angle brackets for comparisons, because a single `>` closes a tag:

| Operator | Meaning | Quad opcode |
|---|---|---|
| `>>` | greater than | `>` |
| `<<` | less than | `<` |
| `>>=` | greater than or equal | `>=` |
| `<<=` | less than or equal | `<=` |
| `==` | equal | `==` |

```htpl
<program>
<variables>
    <int name="a">(1)</int>
    <int name="b">(2)</int>
</variables>
<instructions>
    <if condition=(a >> b)>
    </if>
    <if condition=(a << b)>
    </if>
    <if condition=(a >>= b)>
    </if>
    <if condition=(a <<= b)>
    </if>
    <if condition=(a == b)>
    </if>
</instructions>
</program>
```

A comparison (the `expr_logique` rule) has exactly one operator between two arithmetic expressions. Comparisons cannot be chained (`0 << a << 5`) or used as operands of arithmetic (`(a >> 0) + 1`). There is no "not equal" operator and no logical connective (`&&`, `||`, `and`, `or`, `not`): combine conditions by nesting `<if>` blocks.

## Type checking

The checks live in the declaration and `assignment` actions of [src/syntaxique.y](../src/syntaxique.y) and the helpers `isInteger`, `isFloat`, `isBoolean`, `isString` and `isVariable` in [src/tableSymboles.c](../src/tableSymboles.c). They look at the text of the value, not at the type of what it names:

- Assigning to a variable that was never declared fails with `Variable undefined`.
- An `int` target accepts an integer literal or any identifier-shaped value (a variable or a temporary). `(2.5)` and `"text"` are rejected with `Invalid value for integer variable`.
- A `float` target accepts float literals, integer literals and identifiers.
- A `string` target accepts only a string literal.
- A `boolean` target accepts `1`, `0`, `true`, `false` and identifiers.

Because any identifier passes, an `int` can be assigned a `string` variable, and identifiers used on the right-hand side are not checked for declaration. Array elements are not type-checked at all.

## Limitations

These follow from the current code and are not fixed. Each rejected example below was run through `htplc`.

- **Self-closing `int` not last.** The grammar rule for `<int .../>` followed by more declarations never calls `addSymbol`, so the variable is unknown later:

  ```text
  <program>
  <variables>
      <int name="i"/>
      <int name="j">(1)</int>
  </variables>
  <instructions>
      <assign i=(2)/>
  </instructions>
  </program>
  ```

  This fails with `Variable undefined`.

- **Declaration order in the output.** Self-closing declarations, and arrays followed by more declarations, emit their code after the declarations that follow them. The meaning is unchanged but the quad listing is out of source order.
- **Array elements are stored in reverse** (see [Arrays](#arrays)).
- **Loop conditions are evaluated once.** A `while` loop jumps back to its test, not to the code that computes the condition, so the condition value is never recomputed. See [the architecture note](architecture.md#while-loops).
- **`print` generates no code.** Expressions inside its attributes still produce arithmetic quads, but nothing consumes them.
- **Duplicate declarations** of scalars print `Erreur : Le symbole 'a' existe dejà.` and compilation continues. A duplicate array name is a fatal error.
- **Error positions.** Errors always report `line 1`; the character position counts from the start of the current line. The first error stops compilation.
- **Fixed sizes.** Quad fields hold 14 characters, so long identifiers, strings or array references are truncated or overflow. An `<array>` keeps at most 10 initial elements and a tag at most 10 attributes.
- **Not available:** negative literals, unary minus, `!=`, logical connectives, chained comparisons, string expressions.

Rejected programs that people write by mistake:

```text
<program>
<variables>
</variables>
<instructions>
</instructions>
</program>
```

An empty `<variables>` section is a syntax error; leave the section out instead.

```text
<program>
<variables>
    <int name="a">(1)</int>
</variables>
<instructions>
    <if condition=(a > 0)>
    </if>
</instructions>
</program>
```

A single `>` ends the tag, so the condition is cut short. Use `>>`.

```text
<program>
<variables>
    <int name="a">(1)</int>
</variables>
<instructions>
    <assign a=(2.5)/>
</instructions>
</program>
```

This fails with `Invalid value for integer variable`.

## Differences from the original spec

The language annex ([reports/Annexe langage.pdf](reports/Annexe%20langage.pdf)) describes the changes made to the language in French. Where it disagrees with the grammar, the grammar is what `htplc` implements and what this reference documents.

### Closing tags of `if` and `while`

- **Annex, §1.1.1 and §1.1.2:** blocks end with a self-closing-looking tag:

  ```text
  <if condition=(condition)>
         # Code à exécuter
  <if/>
  ```

  and likewise `<while/>` for loops.
- **Grammar:** the lexer rules `"</if>"` and `"</while>"` produce `TOKEN_IF_CLOSE` and `TOKEN_WHILE_CLOSE`, which close the `if_statement` and `while_statement` rules. `<if/>` is lexed as `<if` followed by `/>` and is a syntax error:

  ```text
  <program>
  <variables>
      <int name="a">(1)</int>
  </variables>
  <instructions>
      <if condition=(a >> 0)>
          <assign a=(0)/>
      <if/>
  </instructions>
  </program>
  ```

  The same program with `<while ...>` and `<while/>` is rejected the same way.

### Logical operators

- **Annex, §1.2.2:** "Les autres opérateurs logiques et les règles d'associativité restent inchangés par rapport à la version précédente du langage" (the other logical operators and associativity rules are unchanged from the previous version of the language).
- **Grammar:** `expr_logique` only has the five comparisons, `true`/`false` and parentheses. There are no logical connectives, and the lexer rejects `&&` and `!=` outright:

  ```text
  <program>
  <variables>
      <int name="a">(1)</int>
  </variables>
  <instructions>
      <if condition=(a >> 0 && a << 5)>
      </if>
  </instructions>
  </program>
  ```

  `and` and `or` are read as identifiers and cause a syntax error.

### Types

- **Annex, §1.3.2:** "Les variables sont définies sous deux types principaux : int pour les entiers et string pour les chaînes de caractères" (variables come in two main types: int for integers and string for character strings).
- **Grammar:** `declaration_list` also has `float`, `boolean` and `array` declarations (tokens `TOKEN_VAR_FLOAT_OPEN`, `TOKEN_VAR_BOOLEAN_OPEN`, `TOKEN_ARRAY_OPEN`), and the symbol table has the matching `TYPE_FLOAT`, `TYPE_BOOLEAN` and `TYPE_ARRAY`.

### Not in the annex

The annex does not mention these grammar features, so they are additions rather than disagreements:

- `<else>` inside `<if>` (the second alternative of `if_statement`).
- The `==` operator (`TOKEN_EQUAL`); §1.2.1 lists only `>>`, `<<`, `>>=` and `<<=`.
- `<assign>`, `<print>`, arrays with `<element>` and self-closing declarations.

The annex's two declaration examples, `<int name="x">(10)</int>` and `<string name="message">"Bonjour"</string>`, match the grammar.
