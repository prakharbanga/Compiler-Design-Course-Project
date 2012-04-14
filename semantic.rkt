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
  (define __type "__type")
  (define __parlist "__parlist")
  (define __label "__label")

  (define (sym_tab_ins! decl_name decl_fields) (insert! cur_sym_tab decl_name decl_fields))

  (define (semantic ast)
    ast))
