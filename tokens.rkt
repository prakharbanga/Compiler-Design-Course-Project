(module tokens racket
  (provide (all-defined-out))

  (require parser-tools/lex)


  (define-tokens value-tokens (CONSTANT STRING_LITERAL
                                        IDENTIFIER NSString))

  (define-empty-tokens op (AUTO BREAK CASE CHAR CONST
                                CONTINUE DEFAULT DO DOUBLE
                                ELSE ENUM EXTERN FLOAT FOR
                                GOTO IF INT LONG REGISTER
                                RETURN SHORT SIGNED SIZEOF
                                STATIC STRUCT SWITCH
                                TYPEDEF UNION UNSIGNED
                                VOID VOLATILE WHILE CLASS
                                INTERFACE IMPLEMENTATION
                                END PRIVATE PUBLIC
                                PROTECTED TRY THROW CATCH
                                FINALLY SELECTOR PROTOCOL
                                ENCODE SYNCHRONIZED
                                AUTORELEASEPOOL
                                COMPATIBILITY_ALIAS
                                REQUIRED OPTIONAL 
                                SYNTHESIZE DYNAMIC
                                PROPERTY PACKAGE DEFS ID
                                IN OUT INOUT BYCOPY BYREF
                                ONEWAY ASSIGN RIGHT_ASSIGN
                                LEFT_ASSIGN ADD_ASSIGN
                                SUB_ASSIGN MUL_ASSIGN
                                DIV_ASSIGN MOD_ASSIGN
                                AND_ASSIGN XOR_ASSIGN
                                OR_ASSIGN RIGHT_OP LEFT_OP
                                INC_OP DEC_OP PTR_OP
                                AND_OP OR_OP LE_OP GE_OP
                                EQ_OP NE_OP ELLIPSIS
                                SEMICOLON LB RB LSB RSB
                                LCB RCB COMMA COLON DOT
                                AMPERSAND EXCLAMATION
                                TILDE MINUS PLUS ASTERISK
                                DIV MODULO LESS GREATER
                                CARET PIPE QUESTIONMARK EOF)))
