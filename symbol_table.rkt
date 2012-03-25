(module symbol_table racket
  (provide new_symbol_table insert! lookup)

  (struct symbol_table (parent table))

  (define (new_symbol_table parent)
    (symbol_table parent (make-hash)))

  (define (insert! sym_tab lexeme attrs)
    (let ([tab (symbol_table-table sym_tab)])
      (if (hash-has-key? tab lexeme) 
        #f
        (begin (hash-set! tab lexeme attrs) #t))))

  (define (lookup sym_tab lexeme)
    (hash-ref (symbol_table-table sym_tab) lexeme
              [(lambda ()
                 (let ([par (symbol_table-parent sym_tab)])
                   (if par (lookup par lexeme) #f)))]))

  (define (parent sym_tab)
    (symbol_table-parent sym_tab)))