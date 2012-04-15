(module code-gen racket
  (provide (all-defined-out))
  (require "symbol_table.rkt"
           "semantic.rkt"
           "parser.rkt")

  (define (code-gen ir) (string-append 
                          "\t.data\n"
                          (string-join (flatten (make-data cur_sym_tab)) "\n")
                          "\n"
                          "\t.text\n"
                          (make-code ir cur_sym_tab)))


  (define (make-data sym_tab)
    (hash-map (symbol_table-table sym_tab) (lambda (id entry) (match (hash-ref entry __whatisit)
                                                                     ['var_ (match (hash-ref entry __type)
                                                                                   ['inttype (string-append (hash-ref entry __mem) ": .word 0")]
                                                                                   [_ ""])]
                                                                     ['func (make-data (hash-ref entry __symtab))]))))

  (define (make-code ir sym_tab)
    (begin ;(display ir) (newline)
           (if (not (null? ir)) (string-append
                                  (match (car ir)
                                         [(list 'defi (list func_name inner))
                                          (let [(func_entry (lookup sym_tab func_name))]
                                            (string-append 
                                              (hash-ref func_entry __label)
                                              ":\n" 
                                              (make-code inner (hash-ref func_entry __symtab))))]
                                         [(list 'constn val) (string-append 
                                                               "li $t0, " val "\n"
                                                               "sw $t0, ($sp)" "\n"
                                                               "addi $sp, -4" "\n")]
                                         [(list 'identf id) (string-append 
                                                              "lw $t0, " (get_memory_loc id sym_tab) "\n"
                                                              "sw $t0, ($sp)" "\n"
                                                              "addi $sp, -4" "\n")]
                                         [(list 'assgn (list (list 'identf id) op)) (string-append 
                                                                                      (make-code (list op) sym_tab)
                                                                                      "lw $t0, 4($sp)\n"
                                                                                      "sw $t0, " (get_memory_loc id sym_tab) "\n"
                                                                                      "addi $sp, 4" "\n")]
                                         [(list op (list op1 op2)) (string-append
                                                                     (make-code (list op1) sym_tab)
                                                                     (make-code (list op2) sym_tab)
                                                                     "lw $t0, 4($sp)" "\n"
                                                                     "lw $t1, 8($sp)" "\n"
                                                                     (hash-ref mips-op-hash op) "$t0, $t1, $t0" "\n"
                                                                     "addi $sp, -4" "\n"
                                                                     "sw $t0, 4($sp)" "\n")])
                                  (make-code (cdr ir) sym_tab)) "")))

  (define mips-op-hash
    (make-hash '((addop . "add")
                 (subop . "sub")
                 (andop . "and")
                 (or_op . "or")
                 (xorop . "xor")
                 (lefop . "sll")
                 (rigop . "srl"))))

  (define-syntax-rule (get_memory_loc id sym_tab) (hash-ref (lookup sym_tab id) __mem)))



;  (define (code-gen ir sym_tab)
;    (display sym_tab)
;    (newline)
;    (display ir)
;    (newline))
;
;  ;(define (code-gen ir sym_tab)
;  ; (data-gen sym_tab)
;  ; (text-gen ir))
;
;  (define (data-gen sym_tab)
;    (begin (display "\t.data\n")
;           (hash-for-each (symbol_table-table sym_tab) (lambda (id specs)
;                                                         (display (string-append (hash-ref specs __mem) ":\t.word\t# " id "\n"))))))
;
;  (define (text-gen ir)
;    (begin (display "\t.text\n")
;           (for-each (lambda (ext_dec)
;                       (display (string-append (hash-ref (car (cdaadr ext_dec)) __label) ":\n"))
;                       (for-each (lambda (stmt) (display (expr-code stmt))) (cadadr ext_dec)))
;                     ir)))
;
;  (define (expr-code expr)
;    (match expr
;           ['skip "\n"]
;           [#f (error "Unhandled rule")]
;           [(list 'assgn (list var1 expr)) (string-append (expr-code expr) "\n" "sw $t0, " var1 "\n") ]
;           [(list 'addop (list expr1 expr2)) (string-append (expr-code expr1) "\nmove $t1, $t0\n" (expr-code expr2) "move $t2, $t0\nadd $t0, $t1, $t2\n")]
;           [(regexp "^var.*" var) (string-append "lw $t0, " (car var) "\n")]
;           )))
