(module tokens racket
  (provide (all-defined-out))

  (require parser-tools/lex)


  (define-tokens value-tokens (CONSTANT STRING_LITERAL
                                        IDENTIFIER))

  (define-empty-tokens op (NEWLINE AUTO BREAK CASE CHAR
                                   CONST CONTINUE DEFAULT DO
                                   DOUBLE ELSE ENUM EXTERN
                                   FLOAT FOR GOTO IF INT
                                   LONG REGISTER RETURN
                                   SHORT SIGNED SIZEOF
                                   STATIC STRUCT SWITCH
                                   TYPEDEF UNION UNSIGNED
                                   VOID VOLATILE WHILE
                                   INTERFACE DEFS ID IN OUT
                                   INOUT BYCOPY BYREF ONEWAY
                                   CLASS END PRIVATE PUBLIC
                                   PROTECTED ELLIPSIS
                                   RIGHT_ASSIGN LEFT_ASSIGN
                                   ADD_ASSIGN SUB_ASSIGN
                                   MUL_ASSIGN DIV_ASSIGN
                                   MOD_ASSIGN AND_ASSIGN
                                   OR_ASSIGN XOR_ASSIGN
                                   RIGHT_OP LEFT_OP INC_OP
                                   DEC_OP PTR_OP AND_OP
                                   OR_OP LE_OP GE_OP EQ_OP
                                   NE_OP COMMA COLON LB RB
                                   LSB RSB LCB RCB DOT AND
                                   EXCLAMATION TILDE LESS
                                   GREATER QUESTIONMARK
                                   ASSIGN SEMICOLON DIV
                                   MODULO AMPERSAND PIPE
                                   CARET PLUS ASTERISK
                                   MINUS)))


