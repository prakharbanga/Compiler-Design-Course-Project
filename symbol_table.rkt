(module symbol_table racket
  (provide (all-defined-out))

  (struct symbol_table (parent table ret_type) #:transparent)

  (define (new_symbol_table parent [ret_type #f])
    (symbol_table parent (make-hash) ret_type))

  (define (insert! sym_tab lexeme attrs)
    (let ([tab (symbol_table-table sym_tab)])
      (if (hash-has-key? tab lexeme) 
        (error (string-append "Symbol " lexeme " already exists."))
        (begin (hash-set! tab lexeme attrs) #t))))

  (define (lookup sym_tab lexeme)
    (let ([tab (symbol_table-table sym_tab)] [par (symbol_table-parent sym_tab)])
      (if (hash-has-key? tab lexeme) 
        (hash-ref tab lexeme)
        (if par
          (lookup par lexeme)
          (error (string-append "Symbol " lexeme " doesn't exist."))))))

  (define (parent sym_tab)
    (symbol_table-parent sym_tab))

  (define (get_ret_type sym_tab)
    (symbol_table-ret_type sym_tab))
  )
