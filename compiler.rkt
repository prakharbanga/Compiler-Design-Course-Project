#lang racket

(require racket/cmdline
         "lexer.rkt"
         "parser.rkt"
         "semantic.rkt"
         "code-gen.rkt")


(begin (let* [(ast (objc-parser (get-lexgen-file (vector-ref (current-command-line-arguments) 0))))
              (ir (semantic ast))
              (code (code-gen ir))]
         (display cur_sym_tab)
         (newline)
         (display ast)
         (newline)
         (display ir)
         (newline)
         (display code)
         (newline)))
