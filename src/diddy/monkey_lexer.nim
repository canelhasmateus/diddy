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

proc readToken*(lexer: var Lexer): Token =

    let currentCharacter = lexer.ch

    let currentToken = readSingle(currentCharacter)

    lexer.readChar()

    return currentToken

proc new*(dispatcher: typedesc[Lexer], input: string): Lexer =

    var lexer = Lexer(input: input,
                    position: 0,
                    readPosition: 0,
                    ch: '\x00')
    lexer.readChar()
    return lexer
