(module symbol_table racket
  (provide (all-defined-out))

  (struct symbol_table (parent table func_name ret_type) #:transparent)

  (define (new_symbol_table parent [func_name #f] [ret_type #f])
    (symbol_table parent (make-hash) func_name ret_type))

  (define (insert! sym_tab lexeme attrs)
    (let ([tab (symbol_table-table sym_tab)])
      (if (hash-has-key? tab lexeme) 
        (error (string-append "Symbol " lexeme " already exists."))
        (begin (hash-set! tab lexeme attrs) #t))))

  (define (lookup sym_tab lexeme)
    (if (not (string? lexeme))
      (error "Non-string identifier searched for in symbol table.")
      (let ([tab (symbol_table-table sym_tab)] [par (symbol_table-parent sym_tab)])
        (if (hash-has-key? tab lexeme) 
          (hash-ref tab lexeme)
          (if par
            (lookup par lexeme)
            (error (string-append "Symbol " lexeme " doesn't exist.")))))))

  (define (parent sym_tab)
    (symbol_table-parent sym_tab))

  (define (get_ret_type sym_tab)
    (symbol_table-ret_type sym_tab)))
