(module semantic racket
  (provide (all-defined-out))

  (require "parser.rkt"
           "symbol_table.rkt")

  (define-syntax-rule (errors a ...) (error (string-append a ...)))

  ; The global symbol table
  (define cur_sym_tab (new_symbol_table #f 'global))

  (define (get-func-symtab sym_tab)
    (if (equal? (symbol_table-func_name sym_tab) 'inner) (get-func-symtab (parent sym_tab)) sym_tab))

  (define (get-glob-symtab sym_tab)
    (if (equal? (symbol_table-func_name sym_tab) 'global) sym_tab (get-func-symtab (parent sym_tab))))

  (define label_count 0)
  (define var___count 0)

  (define-syntax-rule (ret (proc x ...)) (begin (proc x ...) (car (list x ...))))

  (define-syntax-rule (setr! x y) (ret (set! x y)))

  (define-syntax-rule (inc1! x) (set! x (+ 1 x)))
  (define (new_label) (begin (inc1! label_count) (string-append "label_" (number->string label_count))))
  (define (new___var) (begin (inc1! var___count) (string-append "var___" (number->string var___count))))

  (define-syntax-rule (make-var-entry)
                      (make-hash (list (cons __mem (new___var)))))

  (define-syntax-rule (make-func-entry parlist)
                      (make-hash (list (cons __label (new_label)) (cons __parlist parlist))))

  (define-syntax-rule (get_mem_loc sym)
                      (hash-ref (lookup cur_sym_tab sym) __mem))

  (define-syntax-rule (get_type sym)
                      (hash-ref (lookup cur_sym_tab sym) __type))

  (define-syntax-rule (get_label sym)
                      (hash-ref (lookup cur_sym_tab sym) __label))

  ; Symbol table entry keys
  (define __mem "__mem")
  (define __whatisit "__whatisit")

  (define __type "__type")

  (define __parlist "__parlist")
  (define __label "__label")
  (define __symtab "__symtab")
  (define __def "__def")
  (define __localmemlist "__localmemlist")

  (define __looplabels "__looplabels")

  (define (sym_tab_ins! decl_name decl_fields) (insert! cur_sym_tab decl_name decl_fields))

  (define (insert-all! decls type) 
    (for-each (lambda (decl) (let [(func_name (cadr decl))] 
                               (sym_tab_ins! func_name
                                             (match (car decl) 
                                                    ['var_ (make-hash [list (cons __mem (new___var)) (cons __type type) (cons __whatisit 'var_)])]
                                                    ['func (make-hash [list (cons __label (if (equal? func_name "main") "main" (new_label))) (cons __type type) (cons __parlist (caddr decl)) (cons __whatisit 'func)])])))) decls))

  (define (semantic ast)
    (begin ;(display ast) (newline) (display cur_sym_tab) (newline)
      (if (not (null? ast)) (append 
                              (match (car ast)
                                     [(and binding (list 'identf id)) (begin (expr-type binding) (list binding))]
                                     [(list 'decl (list type (list decls stmts ))) (begin (insert-all! decls type) (semantic stmts))]
                                     [(list 'defi (list type declarator stmts))
                                      (begin (let* [(func_name (cadr declarator))
                                                    (inner_sym_tab (new_symbol_table cur_sym_tab func_name type))
                                                    (this_entry (lookup cur_sym_tab func_name))]
                                               (if (hash-has-key? this_entry __def) (errors "Redefinition of function " func_name) (hash-set! this_entry __def #t))
                                               (if (not (equal? type (hash-ref this_entry __type))) (errors "Wrong return type in definition of function " func_name ) #f)
                                               ;(display (hash-ref this_entry __parlist))
                                               ;(newline)
                                               ;(display (caddr declarator))
                                               ;(newline)
                                               (let [(par1 (hash-ref this_entry __parlist))
                                                     (par2 (caddr declarator))]
                                                 (if (not (equal? (length par1) (length par2))) (errors "Wrong number of arguments in definition of function " func_name) #f)
                                                 (for-each (lambda (d1 d2) (if (not (equal? (car d1) (car d2))) (errors "Wrong parameter types in definition of function " func_name) #f)) par1 par2)
                                                 (hash-set! this_entry __parlist par2))
                                               (if (not (equal? (car (last stmts)) 'return)) (errors "The last statement in function " func_name " should be a return statement.") #f)
                                               (hash-set! this_entry __symtab inner_sym_tab)
                                               (set! cur_sym_tab inner_sym_tab)
                                               (for-each (lambda (parameter) (insert-all! (cdr parameter) (car parameter))) (caddr declarator))
                                               (let [(inner (semantic stmts))]
                                                 (hash-set! (lookup cur_sym_tab func_name) __localmemlist (let [(x (comp_localmemlist cur_sym_tab))] (pairup (flatten x))))
                                                 (set! cur_sym_tab (parent cur_sym_tab))
                                                 (list (list 'defi (list func_name inner))))))]
                                     [(list 'skip) null]
                                     [(list 'break) (list (list 'break))]
                                     [(list 'continue) (list (list 'continue))]
                                     [(and binding (list 'assgn (list op1 op2))) (get-gen-type! (expr-type op1) (expr-type op2) "Types don't match in assignment operation") (list binding)]
                                     [(and binding (list 'return expr)) (get-gen-type! 
                                                                          (expr-type expr)
                                                                          (get_ret_type (get-func-symtab cur_sym_tab))
                                                                          (string-append "Return type in return statement doesn't match defined return type for function " (symbol_table-func_name (get-func-symtab cur_sym_tab)))) (list binding)]
                                     [(and binding (list 'return)) (get-gen-type! 
                                                                     voitype
                                                                     (get_ret_type (get-func-symtab cur_sym_tab))
                                                                     (string-append "Return type in return statement doesn't match defined return type for function " (symbol_table-func_name (get-func-symtab cur_sym_tab)))) (list binding)]
                                     [(and binding (list 'func_call (list 'identf "print"  ) par_list)) (list binding)]
                                     [(and binding (list 'func_call (list 'identf func_name) par_list))
                                      (let* [(func_entry (lookup cur_sym_tab func_name))
                                             (def_par_list (if (hash-has-key? func_entry __parlist)
                                                             (hash-ref func_entry __parlist)
                                                             (errors func_name "not a function")))]
                                        (if (not (equal? (length par_list) (length def_par_list))) (errors  "Wrong number of arguments in call to function " func_name) null)
                                        (for-each (lambda (par1 par2) (get-gen-type! (expr-type par1) (car par2) (string-append "Wrong argument types in call to function " func_name))) par_list def_par_list)
                                        (list binding))]
                                     [(list 'if_stmt (list if_cond if_stmts else_stmts))
                                      (if (equal? (expr-type if_cond) 'boolean)
                                        (let [(if_label (new_label))
                                              (else_label (new_label))]
                                          (list (list 'if_stmt if_label else_label 
                                                      (list if_cond 
                                                            (begin 
                                                              (set! cur_sym_tab (new_symbol_table cur_sym_tab 'inner))
                                                              (let [(return (semantic if_stmts))]
                                                                (insert! (parent cur_sym_tab) if_label (make-hash (list (cons __symtab cur_sym_tab)
                                                                                                                        (cons __whatisit 'inner))))
                                                                (set! cur_sym_tab (parent cur_sym_tab))
                                                                return))
                                                            (begin 
                                                              (set! cur_sym_tab (new_symbol_table cur_sym_tab 'inner))
                                                              (let [(return (semantic else_stmts))]
                                                                (insert! (parent cur_sym_tab) else_label (make-hash (list (cons __symtab cur_sym_tab)
                                                                                                                          (cons __whatisit 'inner))))
                                                                (set! cur_sym_tab (parent cur_sym_tab))
                                                                return))))))
                                        (error "IF condition must be a relational expression(boolean)."))]
                                     [(list 'while_stmt (list while_cond while_stmts))
                                      (if (equal? (expr-type while_cond) 'boolean)
                                        (let [(while_label (new_label))
                                              (loop_label (new_label)) 
                                              (end_label (new_label)) 
                                              (next_label (new_label)) ]
                                          (list (list 'while_stmt while_label loop_label end_label next_label 
                                                      (list while_cond
                                                            (begin
                                                              (set! cur_sym_tab (new_symbol_table cur_sym_tab 'inner))
                                                              (let [(return (semantic while_stmts))]
                                                                (insert! (parent cur_sym_tab) while_label (make-hash (list (cons __symtab cur_sym_tab)
                                                                                                                           (cons __whatisit 'inner)
                                                                                                                           )))
                                                                (insert! cur_sym_tab __looplabels (make-hash (list (cons "__labels" (list while_label loop_label end_label next_label))
                                                                                                                   (cons "__whatisit" "something"))))
                                                                (set! cur_sym_tab (parent cur_sym_tab))
                                                                return))))))
                                        (error "WHILE condition must be a relational expression(boolean)."))]
                                     [(list 'for_stmt (list for_init for_cond for_loop for_stmts))
                                      (let [(for_label (new_label))
                                            (loop_label (new_label)) 
                                            (end_label (new_label)) 
                                            (next_label (new_label))]
                                        (begin
                                          (set! cur_sym_tab (new_symbol_table cur_sym_tab 'inner))
                                          (if (equal? (expr-type (car for_cond)) 'boolean)
                                            (begin
                                              (let [(return_init (semantic for_init))
                                                    (return_loop (semantic (list for_loop)))
                                                    (return_stmts (semantic for_stmts))]
                                                (insert! (parent cur_sym_tab) for_label (make-hash (list (cons __symtab cur_sym_tab)
                                                                                                         (cons __whatisit 'inner))))
                                                (insert! cur_sym_tab __looplabels (make-hash (list (cons "__labels" (list for_label loop_label end_label next_label))
                                                                                                                   (cons "__whatisit" "something"))))
                                                (set! cur_sym_tab (parent cur_sym_tab))
                                                (list (list 'for_stmt for_label loop_label end_label next_label (list return_init (car for_cond) return_loop return_stmts)))))
                                            (error "FOR condition must be a relational expression(boolean)."))))])
                              (semantic (cdr ast)))
        null)))


  (define (comp_localmemlist sym_tab)
    (remove "" (hash-map (symbol_table-table sym_tab)
              (lambda (id entry) 
                (match (hash-ref entry __whatisit)
                       ['var_ (list (hash-ref entry __type) (hash-ref entry __mem))]
                       ['func (error "Function inside function")]
                       ['inner (comp_localmemlist (hash-ref entry __symtab))]
                       ["something" ""])))))

  (define (pairup x) (if (not (equal? x null)) (append (list (list (car x) (cadr x))) (pairup (cddr x))) null))


  (define (get-gen-type! t1 t2 err)
    (if (equal? t1 t2) t1 (error err)))

  (define (expr-type expr)
    (match expr
           [(list op (list op1 op2)) (let* [(op1-type (expr-type op1)) 
                                            (op2-type (expr-type op2)) 
                                            (this_type (get-gen-type! op1-type op2-type "Type mismatch in operation"))]
                                       (if (member this_type ari-operables)
                                         (if (member op ari-ari-operators)
                                           this_type
                                           (if (member op ari-boo-operators)
                                             'boolean
                                             (error "Unhandled arithmetic operator")))
                                         (if (equal? this_type 'boolean)
                                           (if (member op boo-operators)
                                             'boolean
                                             (error "Unhandled boolean operator"))
                                           (error "Can't do operations on this type"))))]
           [(list 'identf id) (hash-ref (lookup cur_sym_tab id) __type)]
           [(list 'constn val) (if (regexp-match (regexp "\\.") val) flotype inttype)]
           [(list 'func_call (list 'identf func_name) par_list)
            (let* [(func_entry (lookup cur_sym_tab func_name))
                   (def_par_list (hash-ref func_entry __parlist))
                   (type (hash-ref func_entry __type))]
              (if (not (equal? (length par_list) (length def_par_list))) (errors "Wrong number of arguments in call to function " func_name) null)
              (for-each (lambda (par1 par2) (get-gen-type! (expr-type par1) (car par2) (string-append "Wrong argument types in call to function " func_name))) par_list def_par_list)
              type)]))


  (define ari-ari-operators '(modop mulop divop addop subop))

  (define ari-boo-operators '(lesop greop leqop geqop equop neqop))

  (define boo-operators  '(ampop pipop))

  (define ari-operables '(shotype inttype lontype flotype doutype sigtype unstype)))
