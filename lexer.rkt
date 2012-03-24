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
      ["__declspec" (token-DECLSPEC)]
      ["dllimport" (token-DLLIMPORT)]
      ["dllexport" (token-DLLEXPORT)]

      ["@class" (token-CLASS)]
      ["@interface" (token-INTERFACE)]
      ["@implementation" (token-IMPLEMENTATION)]
      ["@end" (token-END)]
      
      ["@private" (token-PRIVATE)]
      ["@public" (token-PUBLIC)]
      ["@protected" (token-PROTECTED)]

      ["@try" (token-TRY)]
      ["@throw" (token-THROW)]
      ["@catch" (token-CATCH)]
      ["@finally" (token-FINALLY)]

      ["@selector" (token-SELECTOR)]
      ["@protocol" (token-PROTOCOL)]
      ["@encode" (token-ENCODE)]
      ["@synchronized" (token-SYNCHRONIZED)]
      ["@autoreleasepool" (token-AUTORELEASEPOOL)]
      ["@compatibility_alias" (token-COMPATIBILITY_ALIAS)]
      ["@required" (token-REQUIRED)]
      ["@optional" (token-OPTIONAL)]
      ["@synthesize" (token-SYNTHESIZE)]
      ["@dynamic" (token-DYNAMIC)] 
      ["@property" (token-PROPERTY)] 
      ["@package" (token-PACKAGE)] 
      ["@defs" (token-DEFS)]

      ["id" (token-ID)]
      ["in" (token-IN)]
      ["out" (token-OUT)]
      ["inout" (token-INOUT)]
      ["bycopy" (token-BYCOPY)]
      ["byref" (token-BYREF)]
      ["oneway" (token-ONEWAY)]

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

      [(:: "@" (:? letter) (:: "\"" 
                               (:+ (:or (:: "\\" any-char) (char-complement (char-set "\\\""))))
                               "\"")) (token-NSString lexeme)]
      ; Likely bug region ends

      ["=" (token-ASSIGN)]
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

      ["..." (token-ELLIPSIS)]
      [";" (token-SEMICOLON)]
      ["(" (token-LB)]
      [")" (token-RB)]
      [(:or "[" "<:") (token-LSB)]
      [(:or "]" ":>") (token-RSB)]
      [(:or "{" "<%") (token-LCB)]
      [(:or "}" "%>") (token-RCB)]
      ["," (token-COMMA)]
      [":" (token-COLON)]
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
      [(:or (char-set "\t\v\n\f") #\space) (objc-lexer input-port)]))
  
  (define (get-lexgen-file file)
    (let ((f (open-input-file file)))
      (get-lexgen f)))

  (define (get-lexgen-str str)
    (let ((p (open-input-string str)))
      (get-lexgen p)))

  (define (get-lexgen port)
    (lambda () (objc-lexer port)))

  (define (test-objc-lexer-file file)
    (let ((f (open-input-file file)))
      (test-objc-lexer f)))

  (define (test-objc-lexer-str str)
    (let ((p (open-input-string str)))
      (test-objc-lexer p)))

  (define (test-objc-lexer port)
      (let loop ()
        (let ((tok (objc-lexer port)))
          (printf "~a\n" tok)
          (unless (equal? tok 'EOF)
            (loop))))))

