import monkey_tokens 

proc isLetter*(ch: char): bool =

    return ('a' <= ch and ch <= 'z') or
           ('A' <= ch and ch <= 'Z') or
            ch == '_'

proc isDigit*(ch: char): bool =
    return '0' <= ch and ch <= '9'

proc readSingle*( ch : char ): Token =

    return case ch:
        of '=':
            Token.new(ASSIGN)
        of ';':
            Token.new(SEMICOLON)
        of ',':
            Token.new(COMMA)
        of '+':
            Token.new(PLUS)
        of '-':
            Token.new(MINUS)
        of '*':
            Token.new(ASTERIST)
        of '/':
            Token.new(SLASH)
        of '!':
            Token.new(BANG)
        of '{':
            Token.new(LBRACE)
        of '}':
            Token.new(RBRACE)
        of '(':
            Token.new(LPAREN)
        of ')':
            Token.new(RPAREN)
        of '>':
            Token.new(GT)
        of '<':
            Token.new(LT)
        else:
            Token.new(ILLEGAL)


