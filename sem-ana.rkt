(module sem-ana racket
  (provide (all-defined-out))
  (require "parser.rkt")

  ; The symbol table
  (define cur_sym_tab (new_symbol_table #f))

  (define (sem-ana ast)
    ast))

