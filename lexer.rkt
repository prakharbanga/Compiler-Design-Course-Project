(module lexer racket
  (require "tokens.rkt"
           (prefix-in : parser-tools/lex-sre)
           parser-tools/lex)
  
  (provide (all-defined-out)
           (all-from-out "tokens.rkt"))
  
  (define-lex-abbrevs
    [digit (:/ "0" "9")]
    [letter (:or (:/ "a" "z") (:/ "A" "Z") "_")]
    [hexa (:or (:/ "a" "f") (:/ "A" "F") digit)]
    [expo (:: (:or "e" "E") (:? (:or "+" "-")) (:+ digit))]
    [fract (:or "f" "F" "l" "L")]
    [unsign (:* (:or "u" "U" "l" "L"))])

  (define objc-lexer 
    (lexer
      ; To skip comments. By default regexes are greedy.
      ; So I had to ensure that no "*/" occurs in the comment block.
      [(:: "/*" (complement (:: any-string "*/" any-string))
           "*/") (objc-lexer input-port)]

      ["auto" (token-AUTO)]
      ["break" (token-BREAK)]
      ["case" (token-CASE)]
      ["char" (token-CHAR)]
      ["const" (token-CONST)]
      ["continue" (token-CONTINUE)]
      ["default" (token-DEFAULT)]
      ["do" (token-DO)]
      ["double" (token-DOUBLE)]
      ["else" (token-ELSE)]
      ["enum" (token-ENUM)]
      ["extern" (token-EXTERN)]
      ["float" (token-FLOAT)]
      ["for" (token-FOR)]
      ["goto" (token-GOTO)]
      ["if" (token-IF)]
      ["int" (token-INT)]
      ["long" (token-LONG)]
      ["register" (token-REGISTER)]
      ["return" (token-RETURN)]
      ["short" (token-SHORT)]
      ["signed" (token-SIGNED)]
      ["sizof" (token-SIZEOF)]
      ["static" (token-STATIC)]
      ["struct" (token-STRUCT)]
      ["switch" (token-SWITCH)]
      ["typedef" (token-TYPEDEF)]
      ["union" (token-UNION)]
      ["unsigned" (token-UNSIGNED)]
      ["void" (token-VOID)]
      ["volatile" (token-VOLATILE)]
      ["while" (token-WHILE)]

      ["@interface" (token-INTERFACE)]
      ["@defs" (token-DEFS)]
      ["id" (token-ID)]
      ["in" (token-IN)]
      ["out" (token-OUT)]
      ["inout" (token-INOUT)]
      ["bycopy" (token-BYCOPY)]
      ["byref" (token-BYREF)]
      ["oneway" (token-ONEWAY)]
      ["@class" (token-CLASS)]
      ["@end" (token-END)]
      ["@private" (token-PRIVATE)]
      ["@public" (token-PUBLIC)]
      ["@protected" (token-PROTECTED)]
      ["@protocol" (token-PROTOCOL)]

      ; Likely bug region starts
      [(:: letter (:* (:or letter digit))) (token-IDENTIFIER lexeme)]

      [(:: "0" (:or "x" "X") (:+ hexa) (:? unsign)) (token-CONSTANT lexeme)]
      [(:: "0" (:+ digit) (:? unsign)) (token-CONSTANT lexeme)]
      [(:: (:+ digit) (:? unsign)) (token-CONSTANT lexeme)]
      [(:: (:? letter) (:: "'" 
                           (:+ (:or (:: "\\" any-char) (char-complement (char-set "\\'"))))
                           "'")) (token-CONSTANT lexeme)]

      [(:: (:+ digit) expo (:? fract)) (token-CONSTANT lexeme)]
      [(:: (:* digit) "." (:+ digit) (:? expo) (:? fract)) (token-CONSTANT lexeme)]
      [(:: (:+ digit) "." (:* digit) (:? expo) (:? fract)) (token-CONSTANT lexeme)]

      [(:: (:? letter) (:: "\"" 
                           (:+ (:or (:: "\\" any-char) (char-complement (char-set "\\\""))))
                           "\"")) (token-STRING_LITERAL lexeme)]
      ; Likely bug region ends

      ["..." (token-ELLIPSIS)]
      [">>=" (token-RIGHT_ASSIGN)]
      ["<<=" (token-LEFT_ASSIGN)]
      ["+=" (token-ADD_ASSIGN)]
      ["-=" (token-SUB_ASSIGN)]
      ["*=" (token-MUL_ASSIGN)]
      ["/=" (token-DIV_ASSIGN)]
      ["%=" (token-MOD_ASSIGN)]
      ["&=" (token-AND_ASSIGN)]
      ["^=" (token-XOR_ASSIGN)]
      ["|=" (token-OR_ASSIGN)]
      [">>" (token-RIGHT_OP)]
      ["<<" (token-LEFT_OP)]
      ["++" (token-INC_OP)]
      ["--" (token-DEC_OP)]
      ["->" (token-PTR_OP)]
      ["&&" (token-AND_OP)]
      ["||" (token-OR_OP)]
      ["<=" (token-LE_OP)]
      [">=" (token-GE_OP)]
      ["==" (token-EQ_OP)]
      ["!=" (token-NE_OP)]
      [";" (token-SEMICOLON)]
      [(:or "{" "<%") (token-LCB)]
      [(:or "}" "%>") (token-LSB)]
      ["," (token-COMMA)]
      [":" (token-COLON)]
      ["=" (token-ASSIGN)]
      ["(" (token-LB)]
      [")" (token-RB)]
      [(:or "[" "<:") (token-LSB)]
      [(:or "]" ":>") (token-RSB)]
      ["." (token-DOT)]
      ["&" (token-AMPERSAND)]
      ["!" (token-EXCLAMATION)]
      ["~" (token-TILDE)]
      ["-" (token-MINUS)]
      ["+" (token-PLUS)]
      ["*" (token-ASTERISK)]
      ["/" (token-DIV)]
      ["%" (token-MODULO)]
      ["<" (token-LESS)]
      [">" (token-GREATER)]
      ["^" (token-CARET)]
      ["|" (token-PIPE)]
      ["?" (token-QUESTIONMARK)]

      [(eof) (token-EOF)]
      [(char-set "\t\v\n\f") (objc-lexer input-port)])))
