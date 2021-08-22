import monkey_tokens
import parse_utils

type
    Lexer* = ref object of RootObj
        input*: string
        position*: int
        readPosition*: int
        ch*: char



proc readChar*(lexer: var Lexer) =

    if lexer.readPosition >= len(lexer.input):
        lexer.ch = '\x00'
    else:
        lexer.ch = lexer.input[lexer.readPosition]

    lexer.position = lexer.readPosition
    lexer.readPosition += 1


proc skipWhitespace*(lexer: var Lexer) =
    while lexer.ch in [' ', '\t', '\n', '\r']:
        lexer.readChar()

proc back(lexer: var Lexer) =
    lexer.readPosition -= 1
    lexer.position -= 1

proc peekChar*(lexer: Lexer): char =
    if lexer.readPosition >= len(lexer.input):
        return '\x00'
    return lexer.input[lexer.readPosition]

proc readIdentifier(lexer: var Lexer): Token =
    let position = lexer.position

    while isLetter(lexer.ch):
        lexer.readChar()

    let range = position..<lexer.position
    let literal = lexer.input[range]
    let kind = inferKind(literal)

    lexer.back()
    return Token.new(kind, literal)

proc readNumber(lexer: var Lexer): Token =
    let position = lexer.position

    while isDigit(lexer.ch):
        lexer.readChar()
    let range = position..<lexer.position
    let literal = lexer.input[range]
    lexer.back()
    return Token.new(INT, literal)

proc readSingle*(lexer: var Lexer): Token =

    let currentCharacter = lexer.ch


    return case currentCharacter:
        of '\x00':
            Token.new(EOF, "\x00")
        of '=':
            if lexer.peekChar() == '=':
                lexer.readChar()
                Token.new(EQ)
            else:
                Token.new(ASSIGN, )
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
            if lexer.peekChar == '=':
                lexer.readChar()
                Token.new(NOT_EQ)
            else:
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
            if currentCharacter.isLetter():
                lexer.readIdentifier():
            elif currentCharacter.isDigit():
                lexer.readNumber()
            else:
                Token.new(ILLEGAL, $currentCharacter)

proc readToken*(lexer: var Lexer): Token =
    readChar lexer
    skipWhitespace lexer
    let currentToken = readSingle(lexer)
    return currentToken

proc new*(dispatcher: typedesc[Lexer], input: string): Lexer =

    var lexer = Lexer(input: input,
                    position: 0,
                    readPosition: 0,
                    ch: '\x00')
    return lexer


