(module code-gen racket
  (provide (all-defined-out))
  (require "symbol_table.rkt"
           "semantic.rkt"
           "parser.rkt")

  (define codegen_label_count 0)

  (define (new_codegen_label) (begin (inc1! codegen_label_count) (string-append "codegen_label" (number->string codegen_label_count))))

  (define (code-gen ir) (string-append 
                          "\t.data\n"
                          "newline: .asciiz \"\\n\"" "\n"
                          (string-join (flatten (make-data cur_sym_tab)) "\n")
                          "\n"
                          "\t.text\n"
                          (make-code ir cur_sym_tab)))


  (define (make-data sym_tab)
    (hash-map (symbol_table-table sym_tab) (lambda (id entry) (match (hash-ref entry __whatisit)
                                                                     ['var_ (match (hash-ref entry __type)
                                                                                   ['inttype (string-append (hash-ref entry __mem) ": .word 0")]
                                                                                   [_ ""])]
                                                                     ['func (if (hash-has-key? entry __def)
                                                                              (make-data (hash-ref entry __symtab))
                                                                              (error "Function declared but never defined."))]))))

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
                                    [(list 'assgn (list (list 'identf id) op)) 
                                     (string-append 
                                       (expr-code (list op) sym_tab)
                                       "\t" "lw $t0, ($sp)" "\n"
                                       "\t" "sw $t0, " (get_memory_loc id sym_tab) "\n"
                                       "\t" "addi $sp, 4" "\n")]
                                    [(list 'func_call (list 'identf "print") (list (list 'identf id)))
                                     (string-append
                                       "\t" "li $v0, 1" "\n"
                                       "\t" "lw $a0, " (get_memory_loc id sym_tab) "\n"
                                       "\t" "syscall" "\n"
                                       "\t" "li $v0, 4" "\n"
                                       "\t" "la $a0, newline" "\n"
                                       "\t" "syscall" "\n")]
                                    [(list 'func_call (list 'identf func_name) arg_list)
                                     (let [(func_entry (lookup sym_tab func_name))
                                           (return_label (new_codegen_label))]
                                       (string-append
                                         "\t" "la $t0, " return_label "\n"
                                         "\t" "addi $sp, -4" "\n"
                                         "\t" "sw $t0, ($sp)" "\n"
                                         (let [(func_entry (lookup sym_tab func_name))]
                                           (store-arguments sym_tab (hash-ref func_entry __symtab) arg_list (hash-ref func_entry __parlist)))
                                         "\t" "j " (hash-ref func_entry __label) "\n"
                                         return_label ":\n"
                                         "\taddi $sp, 4" "\n"))]
                                    [(list 'return expr)
                                     (if (equal? (symbol_table-func_name sym_tab) "main")
                                       (string-append
                                         "\t" "li $v0, 10" "\n"
                                         "\t" "syscall" "\n")
                                       (string-append
                                         (expr-code (list expr) sym_tab)
                                         "\t" "lw $t1, ($sp)" "\n"
                                         "\t" "addi $sp, 4" "\n"
                                         "\t" "lw $t0, ($sp)" "\n"
                                         "\t" "sw $t1, ($sp)" "\n"
                                         "\t" "jr $t0" "\n"
                                         ))])
                             (make-code (cdr ir) sym_tab)) "")))

  (define (store-arguments sym_tab func_symtab arg_list par_list)
    (begin
     ;(display arg_list)
     ;(newline)
     ;(display par_list)
     ;(newline)
      (if (not (equal? arg_list null))
        (string-append
          (expr-code (list (car arg_list)) sym_tab)
          "\t" "lw $t0, ($sp)"                                                   "\n"
          "\t" "addi $sp, 4"                                                     "\n"
          "\t" "sw $t0, " (hash-ref (lookup func_symtab (car (cdadar par_list))) __mem) "\n"
          (store-arguments sym_tab func_symtab (cdr arg_list) (cdr par_list))) 
        "")))

  (define (expr-code ir sym_tab)
    (begin
      (if (not (null? ir)) (string-append
                             (match (car ir)
                                    [(list 'constn val) (string-append 
                                                          "\t" "addi $sp, -4" "\n"
                                                          "\t" "li $t0, " val "\n"
                                                          "\t" "sw $t0, ($sp)" "\n")]
                                    [(list 'identf id) (string-append 
                                                         "\t" "addi $sp, -4" "\n"
                                                         "\t" "lw $t0, " (get_memory_loc id sym_tab) "\n"
                                                         "\t" "sw $t0, ($sp)" "\n")]
                                    [(list op (list op1 op2)) (string-append
                                                                "\t" (expr-code (list op1) sym_tab)
                                                                "\t" (expr-code (list op2) sym_tab)
                                                                "\t" "lw $t0, ($sp)" "\n"
                                                                "\t" "lw $t1, 4($sp)" "\n"
                                                                "\t" (hash-ref mips-op-hash op) "$t0, $t1, $t0" "\n"
                                                                "\t" "addi $sp, 4" "\n"
                                                                "\t" "sw $t0, ($sp)" "\n")])
                             (expr-code (cdr ir) sym_tab)) "")))

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
