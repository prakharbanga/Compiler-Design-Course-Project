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
    (hash-map (symbol_table-table sym_tab) 
              (lambda (id entry) 
                (match (hash-ref entry __whatisit)
                       ['var_ (data-for-var-entry (list (hash-ref entry __type) (hash-ref entry __mem)))]
                       ['func (if (hash-has-key? entry __def)
                                (map data-for-var-entry (hash-ref entry __localmemlist))
                                (error "Function declared but never defined."))]))))

  (define (data-for-var-entry var-entry)
    (match var-entry
           [(list 'inttype location) (string-append location ": .word 0")]
           [_ ""]))

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
                                       (let [(locals_mem_list (hash-ref
                                                                (lookup (get-glob-symtab sym_tab) (symbol_table-func_name (get-func-symtab sym_tab)))
                                                                __localmemlist))]
                                         (string-append
                                           (store-locals-on-stack locals_mem_list)
                                           "\t" "la $t0, " return_label "\n"
                                           "\t" "addi $sp, -4" "\n"
                                           "\t" "sw $t0, ($sp)" "\n"
                                           (let [(func_entry (lookup sym_tab func_name))]
                                             (store-arguments sym_tab (hash-ref func_entry __symtab) arg_list (hash-ref func_entry __parlist)))
                                           "\t" "j " (hash-ref func_entry __label) "\n"
                                           return_label ":\n"
                                           "\t" "addi $sp, 4" "\n"
                                           (retrieve-locals-from-stack locals_mem_list))))]
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
                                         ))]
                                    [(list 'if_stmt if_label else_label (list if_cond if_stmts else_stmts))
                                     (let [(end_label (new_codegen_label))]
                                       (string-append
                                         (trans-cond if_cond else_label sym_tab)
                                         if_label ":\n"
                                         (make-code if_stmts (hash-ref (lookup sym_tab if_label) __symtab))
                                         "\t" "j " end_label "\n"
                                         else_label ":\n"
                                         (make-code else_stmts (hash-ref (lookup sym_tab else_label) __symtab))
                                         end_label ":\n"))]
                                    [(list 'while_stmt while_label (list while_cond while_stmts))
                                     (let [(loop_label (new_codegen_label))
                                           (end_label (new_codegen_label))]
                                       (string-append
                                         loop_label ":\n"
                                         (trans-cond while_cond end_label sym_tab)
                                         while_label ":\n"
                                         (make-code while_stmts (hash-ref (lookup sym_tab while_label) __symtab))
                                         "\t" "j " loop_label "\n"
                                         end_label ":\n"))]
                                    [(list 'for_stmt for_label (list for_init for_cond for_loop for_stmts))
                                     (let [(loop_label (new_codegen_label))
                                           (end_label (new_codegen_label))]
                                       (let [(for_symtab (hash-ref (lookup sym_tab for_label) __symtab))]
                                         (string-append
                                           (make-code for_init for_symtab)
                                           loop_label ":\n"
                                           (trans-cond for_cond end_label for_symtab)
                                           for_label ":\n"
                                           (make-code for_stmts for_symtab)
                                           (make-code for_loop for_symtab)
                                           "\t" "j " loop_label "\n"
                                           end_label ":\n")))])
                             (make-code (cdr ir) sym_tab)) "")))

  (define (trans-cond condit false_label sym_tab)
    (string-append
      (expr-code (list condit) sym_tab)
      "\t" "lw $t0, ($sp)" "\n"
      "\t" "add $sp, 4"    "\n"
      "\t" "beq $t0, $zero, " false_label "\n"))

  (define (store-locals-on-stack local_list)
    (if (not (null? local_list))
      (string-append
        "\t" "lw $t0, " (cadar local_list) "\n"
        "\t" "addi $sp, -4" "\n"
        "\t" "sw $t0, ($sp)" "\n"
        (store-locals-on-stack (cdr local_list)))
      ""))

  (define (retrieve-locals-from-stack local_list)
    (if (not (null? local_list))
      (string-append
        (retrieve-locals-from-stack (cdr local_list))
        "\t" "lw $t0, ($sp)" "\n"
        "\t" "addi $sp, 4" "\n"
        "\t" "sw $t0, " (cadar local_list) "\n")
      ""))


  (define (store-arguments sym_tab func_symtab arg_list par_list)
    (begin
      ;(display arg_list)
      ;(newline)
      ;(display par_list)
      ;(newline)
      (if (not (null? arg_list))
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
                                                                (expr-code (list op1) sym_tab)
                                                                (expr-code (list op2) sym_tab)
                                                                "\t" "lw $t0, ($sp)" "\n"
                                                                "\t" "lw $t1, 4($sp)" "\n"
                                                                "\t" (hash-ref mips-op-hash1 op) "$t0, $t1, $t0" "\n"
                                                                "\t" "addi $sp, 4" "\n"
                                                                "\t" "sw $t0, ($sp)" "\n")])
                             (expr-code (cdr ir) sym_tab)) "")))

  (define mips-op-hash1
    (make-hash '((addop . "add")
                 (subop . "sub")
                 (ampop . "and")
                 (pipop . "or")
                 (lesop . "slt")
                 (greop . "sgt")
                 (leqop . "sle")
                 (geqop . "sge")
                 (equop . "seq")
                 (neqop . "sne"))))

  (define mips-op-hash2
    (make-hash '()))

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
