## Whitespace

Loon is a whitespace sensitive language. This means that
instead of using `do` and `end` (or `{` and `}`) to delimit sections of code we
use line-breaks and indentation.

This means that how you indent your code is important. Luckily Loon
doesn't care how you do it but only requires that you be consistent.

An indent must be at least 1 space or 1 tab, but you can use as many as you
like. All the code snippets on this page will use two spaces.

Mixing tabs and spaces in a single file is illegal. The `loon fmt` formatter
rewrites subsequent illegal indents into legal ones consistent with the very
first indent it encountered in the file.

## Variable declaration and assignment

Via tuples enclosed by `{` and `}`, you can assign or declare-and-assign
multiple names and values at once just like Lua:

```go
hello := "world"
{a,b,c} := {1, 2, 3}
hello = 123 // uses the existing variable
```

Yields Lua:

```lua
local hello = "world"
local a, b, c = 1, 2, 3
hello = 123
```

## Update assignment

`+=`, `-=`, `/=`, `*=`, `%=`, `&=`, `|=`, `>>=`, and
`<<=` operators have been added for updating and assigning at the same time.
They are aliases for their expanded equivalents.

```go
x := 0
x += 10

s := "hello "
s += "world"

b := false
b &= true || false

p := 50
p &= 5
p |= 3
p >>= 3
p <<= 3
```

Yields Lua:

```lua
local x = 0
x = x + 10
local s = "hello "
s = s .. "world"
local b = false
b = b and (true or false)
local p = 50
p = p & 5
p = p | 3
p = p >> 3
p = p << 3
```

## Comments

Unlike Lua, comments start with `//` and continue to the end of the line.
Comments are not written to the output.

```go
// I am a comment
```

## Literals & operators

All of the primitive literals in Lua can be used. This applies to numbers,
strings, booleans, and `nil`.

All of Lua's binary and unary operators are available, except for `~=`,
which is expressed with `!=`.

Unlike Lua, Line breaks are allowed inside of single and double and backtick
quote strings without an escape sequence:

```go
some_string := "Here is a string
  that has a line break in it."
```

Yields Lua:

```lua
local some_string = "Here is a string\n  that has a line break in it."
```

Other than that, double-quoted and single-quoted string literals support
the usual `\` backslashed escape sequences, backtick-quoted ones do not.

All three string-quoting delimiters support `${}` string interpolation syntax.

## Function literals

All functions are created using a function expression. A simple function is
denoted using the arrow `->` prefixed by an arguments list inside parens:

```go
my_function := () ->
my_function() // call the empty function
```

Yields Lua:

```lua
local my_function
my_function = function() end
my_function()
```

The body of the function can either be one statement placed directly after the
arrow, or it can be any number of statements indented on the following lines:

```go
func_a := -> print("hello world")

func_b := ->
  value := 100
  print("The value:", value)
```

Yields Lua:

```lua
local func_a
func_a = function()
  return print("hello world")
end
local func_b
func_b = function()
  local value = 100
  return print("The value:", value)
end
```

Functions with arguments can be created by preceding the arrow with a list of
argument names in parentheses:

```go
sum := (x, y) -> print("sum", x + y)
```

Yields Lua:

```lua
local sum
sum = function(x, y)
  return print("sum", x + y)
end
```

Functions can be called by comma-separating the arguments inside parens, which
follow an expression that evaluates to a function.

```go
sum(10, 20)
print(sum(10, 20))
```

Yields Lua:

```lua
sum(10, 20)
print(sum(10, 20))
```

Functions will coerce the last statement in their body into a return statement,
this is called implicit return:

```go
sum := (x, y) -> x + y
print("The sum is ", sum(10, 20))
```

Yields Lua:

```lua
local sum
sum = function(x, y)
  return x + y
end
print("The sum is ", sum(10, 20))
```

And if you need to explicitly return, you can use the `<-` unary operator:

```go
sum := (x, y) -> <- (x + y)
```

Yields Lua:

```lua
local sum
sum = function(x, y)
  return x + y
end
```

Via tuples enclosed by `{` and `}`, functions can return multiple values:

```go
mystery := (x, y) -> {x + y, x - y}
{a, b} := mystery(10, 20)
```

Yields Lua:

```lua
local mystery
mystery = function(x, y)
  return x + y, x - y
end
local a, b = mystery(10, 20)
```

### Argument Defaults

It is possible to provide default values for the arguments of a function.

```go
my_function := (name="something", height=100) ->
  print("Hello I am", name)
  print("My height is", height)
```

Yields Lua:

```lua
local my_function
my_function := function(name, height)
  if name == __loon_omitted_fn_arg__ then
    name = "something"
  end
  if height == __loon_omitted_fn_arg__ then
    height = 100
  end
  print("Hello I am", name)
  return print("My height is", height)
end
```

An argument default value expression is evaluated in the body of the function
in the order of the argument declarations. For this reason default values have
access to previously declared arguments.

```go
some_args := (x=100, y=x+1000) ->
  print(x + y)
```

Yields Lua:

```lua
local some_args
some_args = function(x, y)
  if x == __loon_omitted_fn_arg__ then
    x = 100
  end
  if y == __loon_omitted_fn_arg__ then
    y = x + 1000
  end
  return print(x + y)
end
```

### Multi-line expressions

When calling functions that take a large number of arguments (or writing
extensive array, tuple, dict literals), it can be desirable to split the
listing over multiple lines. Despite the white-space-sensitive nature of
the language, tokens inside delimiters `()` and `{}` and `[]` carry their
opening token's (`(` or `{` or `[`) line indent until the closing token
(`)` or `}` or `]`).

```go
my_func(5,4,3,
  8,9,10)

cool_func(1,2,
  3,4,
  5,6,
  7,8)
```

Yields Lua:

```lua
my_func(5, 4, 3, 8, 9, 10)
cool_func(1, 2, 3, 4, 5, 6, 7, 8)
```

## Table equivalents

Unlike Lua's tables, in Loon there's well-typed distinctive array types,
tuple types, dictionary / hashmap / hashtable types, structs / records, etc.

```go
some_array := [ 1, 2.0, 3.4, 5 ]
// [ Int | Float ]

some_tuple_of_4 := { 123, 4.56, 'seven', [8, 9.0, `10`] }
// { Int, Float, Str, [Int | Float] }

some_dict_aka_map := { one: 1, "two": 2.0, `the third`: '3' }
// { Str : Int | Float | Str }
```

Yields Lua:

```lua
local some_array = { 1, 2.0, 3.4, 5 }
local some_tuple_of_4 = { 123, 4.56, "seven", {8, 9.0, "10"} }
local some_dict_aka_map = { one = 1, two = 2.0, ["the third"] = "3" }
```

If you are constructing a table out of variables and wish the keys to be the
same as the variable names, then the `:` prefix operator can be used:

```go
hair := "golden"
height := 200
person := { :hair, :height, shoe_size: 40 }
print_table({ :hair, :height })
```

Yields Lua:

```lua
local hair = "golden"
local height = 200
local person = {
  hair = hair,
  height = height,
  shoe_size = 40
}
print_table({
  hair = hair,
  height = height
})
```

If you want the key of a field in the table to to be result of an expression,
then you can write it without `[` and `]`, unlike in Lua. You can also use a
string literal directly as a key, leaving out the square brackets. This is
useful if your key has any special characters.

```go
t := {
  1 + 2: "three"
  "hello world": true
}

```

Yields Lua:

```lua
local t = {
  [1 + 2] = "three",
  ["hello world"] = true
}
```

## String interpolation

You can mix expressions into string literals using `${}` syntax.

```go
print("I am ${math.random() * 100}% sure."
```

Yields Lua:

```lua
print("I am " .. tostring(math.random() * 100) .. "% sure.")
```

## Control flow via value-as-unary-operator-style-callee and function expressions

### For-style loops

showcased below, also demonstrating the `...`-with-optional-`\` range
operator, whose below examples would ordinarily (when not being a
callee for iteration, like here below) construct respectively
`[10,11,12,13,14,15,16,17,18,19,20]` and `[1,3,5,7,9,11,13,15]`:

```go
10...20 (i) -> // will call print 11 times with the values 10 through 20
  print(i)

1...15\2 (k) -> // an optional step provided
  print(k)

some_dict (key, value) ->
  print(key, value)
```

Yields Lua:

```lua
for i = 10, 20 do
  print(i)
end
for k = 1, 15, 2 do
  print(k)
end
for key, value in pairs(some_dict) do
  print(key, value)
end
```

Array-slicing example:

```go
items[1..3] (item) -> print(item)
```

Yields Lua:

```lua
local _list_0 = items
for _index_0 = 1 + 1, 3 do
  local item = _list_0[_index_0]
  print(item)
end
```

Because the unary-callee syntax expects a function expression, just passing
an identifier resolving to a function suffices for brevity and reusability:

```go
items print
1...10\3 print
```

Yields Lua:

```lua
local _list_0 = items
for _index_0 = 1, #_list_0 do
  local __loon_tmp0__ = _list_0[_index_0]
  print(__loon_tmp0__)
end
for __loon_tmp1__ = 1, 10, 3 do
  print(__loon_tmp1__)
end
```

Admittledly, in the case of function names like `print`, readability might
occasionally actually be better with full function syntax, as in:

```go
items (each) -> print(each) // same as `items print`
```

A for-style loop can also be used as an expression. The last statement in the body of
the for loop is coerced into an expression and appended to an accumulating
array.

Doubling every even number:

```go
doubled_evens := [1...20] (i) ->
  (i % 2) == 0 ? (i * 2) : i
```

Yields Lua:

```lua
local doubled_evens
do
  local _accum_0 = { }
  local _len_0 = 1
  for i = 1, 20 do
    if i % 2 == 0 then
      _accum_0[_len_0] = i * 2
    else
      _accum_0[_len_0] = i
    end
    _len_0 = _len_0 + 1
  end
  doubled_evens = _accum_0
end
```

For-style loops at the end of a function body are not accumulated into a table
for a return value (instead the function will return `nil`), unless prefixed
with a `<-` return statement.

This is done to avoid the needless creation of tables for functions that don't
need to return the results of the loop.

### While-style loops

are written quite similarly, with the boolean being the unary callee and the
function receiving zero args:

```go
i := 10
i > 0 () ->
  print(i)
  i -= 1
```
