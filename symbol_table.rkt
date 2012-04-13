(module symbol_table racket
  (provide new_symbol_table insert! lookup parent)

  (struct symbol_table (parent table) #:transparent)

  (define (new_symbol_table parent)
    (symbol_table parent (make-hash)))

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
    (symbol_table-parent sym_tab)))
