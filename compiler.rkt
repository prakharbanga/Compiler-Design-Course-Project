#lang racket

(require racket/cmdline
         "lexer.rkt"
         "parser.rkt"
         "code-gen.rkt")

(code-gen (objc-parser (get-lexgen-file (vector-ref (current-command-line-arguments) 0))) cur_sym_tab)
