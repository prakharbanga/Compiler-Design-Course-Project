(module parser racket
  (provide objc-parser)

  (require parser-tools/yacc
           "lexer.rkt")

  (define objc-parser
    (parser
      (start exp)
      (end EOF)
      (error void)
      (tokens value-tokens op)
      (grammar
        (exp
          ((translation_unit) $1))
        (translation_unit
          (() '())
          ((external_declaration translation_unit) (cons $1 $2)))
        (external_declaration
          ((IDENTIFIER) $1)
          ((CONSTANT) $1))

        
        ))))
