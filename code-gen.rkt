(module code-gen racket
  (provide (all-defined-out))
  (require "symbol_table.rkt"
           "parser.rkt")

  (define (code-gen ir sym_tab)
    (data-gen sym_tab)
    (text-gen ir))

  (define (data-gen sym_tab)
    (begin (display "\t.data\n")
           (hash-for-each (symbol_table-table sym_tab) (lambda (id specs)
                                                         (display (string-append (hash-ref specs __mem) ":\t.word\t# " id "\n"))))))

  (define (text-gen ir)
    (begin (display "\t.text\n")
           (for-each (lambda (ext_dec)
                       (display (string-append (hash-ref (car (cdaadr ext_dec)) __label) ":\n"))
                       (for-each (lambda (stmt) (display (expr-code stmt))) (cadadr ext_dec)))
                     ir)))

  (define (expr-code expr)
    (match expr
           ['skip "\n"]
           [#f "\n"]
           [(list 'assgn (list var1 expr)) (string-append (expr-code expr) "\n" "sw $t0, " var1 "\n") ]
           [(list 'addop (list expr1 expr2)) (string-append (expr-code expr1) "\nmove $t1, $t0\n" (expr-code expr2) "move $t2, $t0\nadd $t0, $t1, $t2\n")]
           [(regexp "^var.*" var) (string-append "lw $t0, " (car var) "\n")]
           )))
