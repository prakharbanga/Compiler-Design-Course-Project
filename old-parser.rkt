(module parser racket
  (provide objc-parser)

  (require parser-tools/yacc
           "lexer.rkt")

  (define objc-parser
    (parser
      (start exp)
      (end EOF)
      (error void)
      (tokens value-tokens op)
      (grammar
        (exp ((translation_unit) #f))
        (primary_expression
          ((identifier) #f)
          ((CONSTANT) #f)
          ((STRING_LITERAL) #f)
          ((LB expression RB) #f))
        (postfix_expression
          ((primary_expression) #f)
          ((postfix_expression LSB expression RSB) #f)
          ((postfix_expression LB RB) #f)
          ((postfix_expression LB argument_expression_list RB)
           #f)
          ((postfix_expression DOT IDENTIFIER) #f)
          ((postfix_expression PTR_OP IDENTIFIER) #f)
          ((postfix_expression INC_OP) #f)
          ((postfix_expression DEC_OP) #f))
        (argument_expression_list
          ((assignment_expression) #f)
          ((argument_expression_list COMMA assignment_expression)
           #f))
        (unary_expression
          ((postfix_expression) #f)
          ((INC_OP unary_expression) #f)
          ((DEC_OP unary_expression) #f)
          ((unary_operator cast_expression) #f)
          ((SIZEOF unary_expression) #f)
          ((SIZEOF LB type_name RB) #f))
        (unary_operator
          ((AMPERSAND) #f)
          ((ASTERISK) #f)
          ((PLUS) #f)
          ((MINUS) #f)
          ((TILDE) #f)
          ((EXCLAMATION) #f))
        (cast_expression
          ((unary_expression) #f)
          ((LB type_name RB cast_expression) #f))
        (multiplicative_expression
          ((cast_expression) #f)
          ((multiplicative_expression ASTERISK cast_expression) #f)
          ((multiplicative_expression DIV cast_expression) #f)
          ((multiplicative_expression MODULO cast_expression) #f))
        (additive_expression
          ((multiplicative_expression) #f)
          ((additive_expression PLUS multiplicative_expression) #f)
          ((additive_expression MINUS multiplicative_expression) #f))
        (shift_expression
          ((additive_expression) #f)
          ((shift_expression LEFT_OP additive_expression) #f)
          ((shift_expression RIGHT_OP additive_expression) #f))
        (relational_expression
          ((shift_expression) #f)
          ((relational_expression LESS shift_expression) #f)
          ((relational_expression GREATER shift_expression) #f)
          ((relational_expression LE_OP shift_expression) #f)
          ((relational_expression GE_OP shift_expression) #f))
        (equality_expression
          ((relational_expression) #f)
          ((equality_expression EQ_OP relational_expression) #f)
          ((equality_expression NE_OP relational_expression) #f))
        (and_expression
          ((equality_expression) #f)
          ((and_expression AMPERSAND equality_expression) #f))
        (exclusive_or_expression
          ((and_expression) #f)
          ((exclusive_or_expression CARET and_expression) #f))
        (inclusive_or_expression
          ((exclusive_or_expression) #f)
          ((inclusive_or_expression PIPE exclusive_or_expression)
           #f))
        (logical_and_expression
          ((inclusive_or_expression) #f)
          ((logical_and_expression AND_OP inclusive_or_expression)
           #f))
        (logical_or_expression
          ((logical_and_expression) #f)
          ((logical_or_expression OR_OP logical_and_expression)
           #f))
        (conditional_expression
          ((logical_or_expression) #f)
          ((logical_or_expression
             QUESTIONMARK
             expression
             COLON
             conditional_expression)
           #f))
        (assignment_expression
          ((conditional_expression) #f)
          ((unary_expression
             assignment_operator
             assignment_expression)
           #f))
        (assignment_operator
          ((ASSIGN) #f)
          ((MUL_ASSIGN) #f)
          ((DIV_ASSIGN) #f)
          ((MOD_ASSIGN) #f)
          ((ADD_ASSIGN) #f)
          ((SUB_ASSIGN) #f)
          ((LEFT_ASSIGN) #f)
          ((RIGHT_ASSIGN) #f)
          ((AND_ASSIGN) #f)
          ((XOR_ASSIGN) #f)
          ((OR_ASSIGN) #f))
        (expression
          ((assignment_expression) #f)
          ((expression COMMA assignment_expression) #f))
        (constant_expression ((conditional_expression) #f))
        (external_declaration
          ((class_interface) #f)
          ((category_interface) #f)
          ((declaration) #f)
          ((protocol_declaration) #f)
          ((protocol_declaration_list) #f)
          ((class_declaration_list) #f)
          ((function_definition) #f))
        (class_interface
          ((INTERFACE
             identifier
             superclass_name
             protocol_reference_list
             instance_variables
             interface_declaration_list
             END)
           #f))
        (category_interface
          ((INTERFACE
             identifier
             LB
             category_name
             RB
             protocol_reference_list
             interface_declaration_list
             END)
           #f)
          ((INTERFACE
             identifier
             LB
             category_name
             RB
             protocol_reference_list
             END)
           #f))
        (protocol_declaration
          ((PROTOCOL
             protocol_name
             protocol_reference_list
             interface_declaration_list
             END)
           #f))
        (protocol_declaration_list
          ((PROTOCOL LESS identifier_list GREATER) #f))
        (class_declaration_list
          ((CLASS identifier_list) #f))
        (identifier_list
          ((identifier) #f)
          ((identifier_list COMMA identifier) #f))
        (identifier ((IDENTIFIER) #f))
        (protocol_reference_list
          ((LESS identifier_list GREATER) #f)
          (() #f))
        (superclass_name ((COLON identifier) #f) (() #f))
        (category_name ((identifier) #f))
        (protocol_name ((identifier) #f))
        (instance_variables
          (() #f)
          ((LCB instance_variable_declaration RCB) #f))
        (instance_variable_declaration
          ((visibility_specification
             struct_declaration_list
             instance_variables)
           #f)
          ((instance_variable_declaration visibility_specification)
           #f)
          ((instance_variable_declaration
             struct_declaration_list
             instance_variables)
           #f))
        (visibility_specification
          ((PRIVATE) #f)
          ((PROTECTED) #f)
          ((PUBLIC) #f))
        (interface_declaration_list
          ((declaration) #f)
          ((method_declaration) #f)
          ((interface_declaration_list declaration) #f)
          ((interface_declaration_list method_declaration) #f)
          (() #f))
        (method_declaration
          ((classMethod_declaration) #f)
          ((instanceMethod_declaration) #f))
        (classMethod_declaration
          ((PLUS method_type method_selector) #f))
        (instanceMethod_declaration
          ((MINUS method_type method_selector) #f))
        (method_selector
          ((unary_selector) #f)
          ((keyword_selector) #f)
          ((keyword_selector COMMA ELLIPSIS) #f)
          ((keyword_selector COMMA parameter_type_list) #f))
        (unary_selector ((selector) #f))
        (keyword_selector
          ((keyword_declarator) #f)
          ((keyword_selector keyword_declarator) #f))
        (keyword_declarator
          ((COLON method_type identifier) #f)
          ((selector COLON method_type identifier) #f))
        (selector ((identifier) #f))
        (method_type ((LB type_name RB) #f) (() #f))
        (declaration_list
          ((declaration) #f)
          ((declaration_list declaration) #f))
        (declaration
          ((declaration_specifiers SEMICOLON) #f)
          ((declaration_specifiers init_declarator_list SEMICOLON) #f))
        (init_declarator_list
          ((init_declarator) #f)
          ((init_declarator_list COMMA init_declarator) #f))
        (init_declarator
          ((declarator) #f)
          ((declarator ASSIGN initializer) #f))
        (storage_class_specifier
          ((TYPEDEF) #f)
          ((EXTERN) #f)
          ((STATIC) #f)
          ((AUTO) #f)
          ((REGISTER) #f))
        (type_specifier
          ((VOID) #f)
          ((CHAR) #f)
          ((SHORT) #f)
          ((INT) #f)
          ((LONG) #f)
          ((FLOAT) #f)
          ((DOUBLE) #f)
          ((SIGNED) #f)
          ((UNSIGNED) #f)
          ((struct_or_union_specifier) #f)
          ((enum_specifier) #f)
          ((ID protocol_reference_list) #f)
          ((identifier protocol_reference_list) #f))
        (struct_or_union_specifier
          ((struct_or_union
             identifier
             LCB
             struct_declaration_list
             RCB)
           #f)
          ((struct_or_union LCB struct_declaration_list RCB) #f)
          ((struct_or_union identifier) #f)
          ((struct_or_union
             identifier
             LCB
             DEFS
             LB
             identifier
             RB
             RCB)
           #f))
        (struct_or_union ((STRUCT) #f) ((UNION) #f))
        (struct_declaration_list
          ((struct_declaration) #f)
          ((struct_declaration_list struct_declaration) #f))
        (struct_declaration
          ((specifier_qualifier_list struct_declarator_list SEMICOLON)
           #f))
        (specifier_qualifier_list
          ((type_specifier specifier_qualifier_list) #f)
          ((type_specifier) #f)
          ((type_qualifier specifier_qualifier_list) #f)
          ((type_qualifier) #f))
        (struct_declarator_list
          ((struct_declarator) #f)
          ((struct_declarator_list COMMA struct_declarator) #f))
        (struct_declarator
          ((declarator) #f)
          ((COLON constant_expression) #f)
          ((declarator COLON constant_expression) #f))
        (enum_specifier
          ((ENUM LCB enumerator_list RCB) #f)
          ((ENUM identifier LCB enumerator_list RCB) #f)
          ((ENUM identifier) #f))
        (enumerator_list
          ((enumerator) #f)
          ((enumerator_list COMMA enumerator) #f))
        (enumerator
          ((identifier) #f)
          ((identifier ASSIGN constant_expression) #f))
        (type_qualifier
          ((CONST) #f)
          ((VOLATILE) #f)
          ((protocol_qualifier) #f))
        (protocol_qualifier
          ((IN) #f)
          ((OUT) #f)
          ((INOUT) #f)
          ((BYCOPY) #f)
          ((BYREF) #f)
          ((ONEWAY) #f))
        (declarator
          ((pointer direct_declarator) #f)
          ((direct_declarator) #f))
        (direct_declarator
          ((identifier) #f)
          ((LB declarator RB) #f)
          ((direct_declarator LSB constant_expression RSB) #f)
          ((direct_declarator LSB RSB) #f)
          ((direct_declarator LB parameter_type_list RB) #f)
          ((direct_declarator LB identifier_list RB) #f)
          ((direct_declarator LB RB) #f))
        (pointer
          ((ASTERISK type_qualifier_list pointer) #f)
          ((ASTERISK pointer) #f)
          ((ASTERISK type_qualifier_list) #f)
          ((ASTERISK) #f))
        (type_qualifier_list
          ((type_qualifier) #f)
          ((type_qualifier_list type_qualifier) #f))
        (parameter_type_list
          ((parameter_list) #f)
          ((parameter_list COMMA ELLIPSIS) #f))
        (parameter_list
          ((parameter_declaration) #f)
          ((parameter_list COMMA parameter_declaration) #f))
        (declaration_specifiers
          ((storage_class_specifier) #f)
          ((type_specifier) #f)
          ((type_qualifier) #f)
          ((declaration_specifiers storage_class_specifier) #f)
          ((declaration_specifiers type_specifier) #f)
          ((declaration_specifiers type_qualifier) #f))
        (parameter_declaration
          ((declaration_specifiers declarator) #f)
          ((declaration_specifiers abstract_declarator) #f)
          ((declaration_specifiers) #f))
        (type_name
          ((specifier_qualifier_list) #f)
          ((specifier_qualifier_list abstract_declarator) #f))
        (abstract_declarator
          ((pointer) #f)
          ((direct_abstract_declarator) #f)
          ((pointer direct_abstract_declarator) #f))
        (direct_abstract_declarator
          ((LB abstract_declarator RB) #f)
          ((LSB RSB) #f)
          ((LSB constant_expression RSB) #f)
          ((direct_abstract_declarator LSB RSB) #f)
          ((direct_abstract_declarator LSB constant_expression RSB)
           #f)
          ((LB RB) #f)
          ((LB parameter_type_list RB) #f)
          ((direct_abstract_declarator LB RB) #f)
          ((direct_abstract_declarator LB parameter_type_list RB)
           #f))
        (initializer
          ((assignment_expression) #f)
          ((LCB initializer_list RCB) #f))
        (initializer_list
          ((initializer) #f)
          ((initializer_list COMMA initializer) #f))
        (statement
          ((labeled_statement) #f)
          ((compound_statement) #f)
          ((expression_statement) #f)
          ((selection_statement) #f)
          ((iteration_statement) #f)
          ((jump_statement) #f))
        (labeled_statement
          ((identifier COLON statement) #f)
          ((CASE constant_expression COLON statement) #f)
          ((DEFAULT COLON statement) #f))
        (compound_statement
          ((LCB RCB) #f)
          ((LCB statement_list RCB) #f)
          ((LCB declaration_list RCB) #f)
          ((LCB declaration_list statement_list RCB) #f))
        (statement_list
          ((statement) #f)
          ((statement_list statement) #f))
        (expression_statement ((SEMICOLON) #f) ((expression SEMICOLON) #f))
        (selection_statement
          ((IF LB expression RB statement) #f)
          ((IF LB expression RB statement ELSE statement) #f)
          ((SWITCH LB expression RB statement) #f))
        (iteration_statement
          ((WHILE LB expression RB statement) #f)
          ((DO statement WHILE LB expression RB SEMICOLON) #f)
          ((FOR
             LB
             expression_statement
             expression_statement
             RB
             statement)
           #f)
          ((FOR
             LB
             expression_statement
             expression_statement
             expression
             RB
             statement)
           #f))
        (jump_statement
          ((GOTO IDENTIFIER SEMICOLON) #f)
          ((CONTINUE SEMICOLON) #f)
          ((BREAK SEMICOLON) #f)
          ((RETURN SEMICOLON) #f)
          ((RETURN expression SEMICOLON) #f))
        (translation_unit
          ((external_declaration) #f)
          ((translation_unit external_declaration) #f))
        (function_definition
          ((declaration_specifiers
             declarator
             declaration_list
             compound_statement)
           #f)
          ((declaration_specifiers declarator compound_statement)
           #f)
          ((declarator declaration_list compound_statement) #f)
          ((declarator compound_statement) #f))))))
