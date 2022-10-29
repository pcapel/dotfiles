highlight clear
" It looks like JSX breaks this approach, most likely because the queries are
" not designed to handle it that gracefully, it's fairly easy to demonstrate,
" so this issues is likely raised.
" The issue of the ${ opening not being matched by the closing tag _may_ be an
" issues with treesitter itself, but is most likely a query bug.
" I'm pretty sure that you can query for more specific nodes. Which I might
" want to do to make super specialized syntax highlighting.
" It also looks like some of these nodes have a super/subset relationship?
" If I were betting, that relationship is defined in vim itself, and the use
" of these terms as abstractions is for convenience and compatibility with
" existing colorschemes. I personally want to hand-roll colorschemes for each
" of the languages that I work in, so fuck that noise.:q
"

echo 'you are loading your color scheme...'
if exists("syntax_on")
  syntax reset
endif

set background=dark

let g:colors_name="philip-treesitter"

highlight Normal ctermbg=237

" status line is above the message area, and generally shows the current file
" and the like
hi StatusLine ctermfg=232 ctermbg=10

" the message area is where you type commands and the like
hi MsgArea ctermfg=40 ctermbg=237

" the mode message indicates the current mode.
hi ModeMsg ctermfg=10

hi Comment ctermfg=246

" this hits the jsx tag names, but only the lowercase ones
highlight TSTag ctermfg=51

" This gets your tags open closing brackets
" But there's something hinky going on,
" When I set the bg, then it appears on the brackets,
" but the fg only appears on the / for a closing tag...
" Which is fine, I actually don't hate that.
highlight TSTagDelimiter ctermfg=51

" anything .,;: related
highlight TSPunctDelimiter ctermfg=183

"  Anything ({[ related
highlight TSPunctBracket ctermfg=99

" This captures the first part of an interpolation set, but irritatingly not the closing bracket...
" But it's also what colors the spread operator in JS, so this is
" irritating...
highlight TSPunctSpecial ctermfg=99

"  TSConstant is for things that are all CAPS_CONSTANT
highlight TSConstant ctermfg=27 cterm=bold

" js (const, export, var, let, return, function etc..)
highlight TSKeyword ctermfg=219 cterm=bold

" User defined types and the like
" This captures jsdoc stuff, which is cool
" Also is what defines the colors for classes in Ruby and Python
highlight TSType ctermfg=87 guifg=87

" this is if/else, naturally, but also default for some reason?
" Need to look into the grammars, as this probably has an effect
highlight TSConditional ctermfg=227 cterm=italic

" Plain old numbers
highlight TSNumber ctermfg=111 

" Floats probably, but not observed in js
" Likely related to the fact that JS doesn't actually have a float type....
highlight TSFloat ctermfg=9

" gets the booleans true and false!
highlight TSBoolean ctermfg=231

" string literals
highlight TSString ctermfg=189
highlight String ctermfg=189

" function parameters
highlight TSParameter ctermfg=105 cterm=italic

" properties, which includes JSX props
highlight TSProperty ctermfg=105

" User defined function names at their declaration
highlight TSFunction ctermfg=45

" regular expression literal
highlight TSStringRegex ctermfg=160 ctermbg=236

" both the declaration and use of methods on an object
highlight TSMethod ctermfg=40

" Constructors like JS classes, and react components that you defined with caps
" Also affects Constants, but only as an ifexists type situation apparently
" This doesn't affect eg python classes which are affected by the TSType
highlight TSConstructor ctermfg=123

" Standard operators, (+, -, / * || && etc)
highlight TSOperator ctermfg=blue " 214

" Things like import/from
highlight TSInclude ctermfg=199 cterm=bold

" Handles builtins like console and super
highlight TSVariableBuiltin ctermfg=171

" This hits the re.compile method, so apparently has something interesting to
" do with python syntax vs js
" It appears to be overriddne by the method fg when it's called, but simple
" access to the field can be configured to look different!
highlight TSField ctermfg=190

" This hits the Python None value, so is also probably big for ruby
highlight TSConstBuiltin ctermfg=196

" Built in functions like python's print()
highlight TSFuncBuiltin ctermfg=171

" This hits python's for keyword
highlight TSRepeat ctermfg=154

" this hits python's in keyword
highlight TSKeywordOperator ctermfg=155

" This finally hits for things like BaseException in python
highlight TSTypeBuiltin ctermfg=129

" This hits ruby's syntax for @var
highlight TSLabel ctermfg=63

" this hits for regex excape sequences at least in ruby
highlight TSStringEscape ctermfg=132

" This hits for the ruby "rescue" keyword
highlight TSException ctermfg=160

" This hits for the python docstrings
highlight TSLiteral ctermfg=157

" this is for function macros like Rust's print! or format!
highlight TSFuncMacro ctermfg=1

" This hits things like `std::io` in rust `use` statements
" So something to do with namespaces
highlight TSNamespace ctermfg=3

" This hits for the Rust fn keyword
highlight TSKeywordFunction ctermfg=219 cterm=bold

" Things that I don't know what they are just yet...
" So they get red background yellow text

highlight TSConstMacro ctermfg=190 ctermbg=160
highlight TSCharacter ctermfg=190 ctermbg=160
highlight TSAnnotation ctermfg=190 ctermbg=160
highlight TSAttribute ctermfg=190 ctermbg=160
highlight TSText ctermfg=190 ctermbg=160
highlight TSTitle ctermfg=190 ctermbg=160
highlight TSURI ctermfg=190 ctermbg=160
highlight TSParameterReference ctermfg=190 ctermbg=160
