proc isLetter*(ch: char): bool =

    return ('a' <= ch and ch <= 'z') or
           ('A' <= ch and ch <= 'Z') or
            ch == '_'

proc isDigit*(ch: char): bool =
    return '0' <= ch and ch <= '9'




