(module semantic racket
  (provide (all-defined-out))

  (require "parser.rkt"
           "symbol_table.rkt")

  ; The global symbol table
  (define cur_sym_tab (new_symbol_table #f))

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

  (define (sym_tab_ins! decl_name decl_fields) (insert! cur_sym_tab decl_name decl_fields))

  (define (insert-all! decls type) 
    (for-each (lambda (decl) (let [(func_name (cadr decl))] 
                               (sym_tab_ins! func_name
                                             (match (car decl) 
                                                    ['var_ (make-hash [list (cons __mem (new___var)) (cons __type type) (cons __whatisit 'var_)])]
                                                    ['func (make-hash [list (cons __label (if (equal? func_name "main") "main" (new_label))) (cons __type type) (cons __parlist (caddr decl)) (cons __whatisit 'func)])])))) decls))

  (define (semantic ast)
    (begin ;(display ast) (newline)
      (if (not (null? ast)) (append 
                              (match (car ast)
                                     [(list 'decl (list type (list decls stmts ))) (begin (insert-all! decls type) (semantic stmts))]
                                     [(list 'defi (list type declarator stmts))
                                      (begin (let* [(func_name (cadr declarator))
                                                    (inner_sym_tab (new_symbol_table cur_sym_tab func_name type))
                                                    (this_entry (lookup cur_sym_tab func_name))]
                                               (if (hash-has-key? this_entry __def) (error "Redefinition of function.") (hash-set! this_entry __def #t))
                                               (if (not (equal? type (hash-ref this_entry __type))) (error "Wrong return type.") #f)
                                               ;(display (hash-ref this_entry __parlist))
                                               ;(newline)
                                               ;(display (caddr declarator))
                                               ;(newline)
                                               (let [(par1 (hash-ref this_entry __parlist))
                                                     (par2 (caddr declarator))]
                                                 (if (not (equal? (length par1) (length par2))) (error "Wrong number of arguments.") #f)
                                                 (for-each (lambda (d1 d2) (if (not (equal? (car d1) (car d2))) (error "Wrong parameter types.") #f)) par1 par2)
                                                 (hash-set! this_entry __parlist par2))
                                               (if (not (equal? (car (last stmts)) 'return)) (error "The last statement in a function should be a return statement.") #f)
                                               (hash-set! this_entry __symtab inner_sym_tab)
                                               (set! cur_sym_tab inner_sym_tab)
                                               (for-each (lambda (parameter) (insert-all! (cdr parameter) (car parameter))) (caddr declarator))
                                               (let [(inner (semantic stmts))]
                                                 (hash-set! (lookup cur_sym_tab func_name) __localmemlist (let [(x (comp_localmemlist cur_sym_tab))] (pairup (flatten x))))
                                                 (set! cur_sym_tab (parent cur_sym_tab))
                                                 (list (list 'defi (list func_name inner))))))]
                                     ['skip null]
                                     [(and binding (list 'assgn (list op1 op2))) (get-gen-type! (expr-type op1) (expr-type op2)) (list binding)]
                                     [(and binding (list 'return expr)) (get-gen-type! (expr-type expr) (get_ret_type cur_sym_tab )) (list binding)]
                                     [(and binding (list 'return)) (get-gen-type! voitype (get_ret_type cur_sym_tab )) (list binding)]
                                     [(and binding (list 'func_call (list 'identf "print"  ) par_list)) (list binding)]
                                     [(and binding (list 'func_call (list 'identf func_name) par_list))
                                      (let* [(func_entry (lookup cur_sym_tab func_name))
                                             (def_par_list (if (hash-has-key? func_entry __parlist)
                                                             (hash-ref func_entry __parlist)
                                                             (error "Not a function")))]
                                        (if (not (equal? (length par_list) (length def_par_list))) (error "Wrong number of arguments") null)
                                        (for-each (lambda (par1 par2) (get-gen-type! (expr-type par1) (car par2))) par_list def_par_list)
                                        (list binding))])
                              (semantic (cdr ast)))
        null)))

  (define (comp_localmemlist sym_tab)
    (hash-map (symbol_table-table sym_tab)
              (lambda (id entry) 
                (match (hash-ref entry __whatisit)
                       ['var_ (list (hash-ref entry __type) (hash-ref entry __mem))]
                       ['func (error "Function inside function")]
                       ['inner (comp_localmemlist (hash-ref entry __symtab))]))))

  (define (pairup x) (if (not (equal? x null)) (append (list (list (car x) (cadr x))) (pairup (cddr x))) null))


  (define (get-gen-type! t1 t2)
    (if (equal? t1 t2) t1 (error "Type mismatch")))

  (define (expr-type expr)
    (match expr
           [(list _ (list op1 op2)) (let [(op1-type (expr-type op1)) (op2-type (expr-type op2))] (get-gen-type! op1-type op2-type))]
           [(list 'identf id) (hash-ref (lookup cur_sym_tab id) __type)]
           [(list 'constn val) (if (regexp-match (regexp "\\.") val) flotype inttype)]
           [(list 'func_call (list 'identf func_name) par_list)
            (let* [(func_entry (lookup cur_sym_tab func_name))
                   (def_par_list (hash-ref func_entry __parlist))
                   (type (hash-ref func_entry __type))]
              (if (not (equal? (length par_list) (length def_par_list))) (error "Wrong number of arguments") null)
              (for-each (lambda (par1 par2) (get-gen-type! (expr-type par1) (car par2))) par_list def_par_list)
              type)])))
