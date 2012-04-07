(module sem-ana racket
  (provide (all-defined-out))
  (require "symbol_table.rkt"
           "parser.rkt")

  ; The symbol table
  (define cur_sym_tab (new_symbol_table #f))

  (define (sem-ana ast)
    ast))

