#lang racket

(require racket/cmdline
         "lexer.rkt"
         "parser.rkt"
         "semantic.rkt"
         "code-gen.rkt")


(begin (let* [(ast (objc-parser (get-lexgen-file (vector-ref (current-command-line-arguments) 0))))
              (ir (semantic ast))
              (code (code-gen ir))]
         (if is_main #f (error "There is no main function in the program."))
;        (display cur_sym_tab)
;        (newline)
;        (display ast)
;        (newline)
;        (display ir)
;        (newline)
         (display code)
         (newline)))
