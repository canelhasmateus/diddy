import tables

type

    TokenKind* = enum

        ASSIGN = "="
        ASTERIST = "*"
        BANG = "!"
        COMMA = ","
        EQ = "=="
        GT = ">"
        LBRACE = "{"
        LPAREN = "("
        LT = "<"
        MINUS = "-"
        NOT_EQ = "!="
        PLUS = "+"
        RBRACE = "}"
        RPAREN = ")"
        SEMICOLON = ";"
        SLASH = "/"


        EOF = "EOF"
        IDENT = "IDENT"
        ILLEGAL = "ILLEGAL"
        INT = "INT"

        ELSE = "ELSE"
        FALSE = "false"
        FUNCTION = "function"
        IF = "if"
        LET = "let"
        RETURN = "return"
        TRUE = "true"

    Token* = ref object
        kind*: TokenKind
        literal*: string


const

    keywords = {"fn": FUNCTION, "let": LET, "true": TRUE, "false": FALSE,
            "if": IF, "else": ELSE, "return": RETURN}.toTable()

    constructs = {'=': ASSIGN,
 '*': ASTERIST,
 '!': BANG,
 ',': COMMA,
 '>': GT,
 '{': LBRACE,
 '(': LPAREN,
 '<': LT,
 '-': MINUS,
 '+': PLUS,
 '}': RBRACE,
 ')': RPAREN,
 ';': SEMICOLON,
 '/': SLASH}.toTable()

    SINGLES* = {'(', ')', ',', ';', '+', '-', '*', '<', '>', '{', '}', '\x00'}


proc new*( dispatcher : typedesc[Token] , kind : TokenKind) : Token =
    return Token( kind : kind , literal : $kind)
    

proc lookupKeyword*(identifier: string): TokenKind =

    if keywords.hasKey(identifier):
        return keywords[identifier]

    return IDENT

proc lookupConstruct*(construct: char): TokenKind =

    if constructs.hasKey(construct):
        return constructs[construct]


