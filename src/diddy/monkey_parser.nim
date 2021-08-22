import monkey_tokens
import monkey_lexer
import options
import sugar
import strutils

type
    StatementKinds = enum
        LET, RETURN, SIMPLE

    Statement* = ref object of RootObj
        kind: StatementKinds
        token: Token
        value: Expression

    Expression* = ref object of RootObj

type
    Parser* = ref object of RootObj
        lexer*: Lexer
        currentToken*: Token
        peekToken*: Token

    Program* = ref object of RootObj
        statements*: seq[Statement]


proc `%`*(expression: Expression): string =
    return "expression"

proc `%`*(statement: Statement): string =

    return case statement.kind:
        of LET: 
            "let " & statement.token.literal & " = " & %statement.value
        of RETURN:
            "return " & %statement.value
        of SIMPLE:
            statement.token.literal
    


# region Parser related
proc new*(dispatcher: typedesc[Parser], lexer: Lexer): Parser =
    var parser = Parser(lexer: lexer)
    parser.nextToken()
    parser.nextToken()
    return parser

proc currentKind(parser: Parser): TokenKind =
    return parser.currentToken.kind
proc peekKind(parser: Parser): TokenKind =
    return parser.peekToken.kind

proc nextToken*(parser: var Parser) =
    parser.currentToken = parser.peekToken
    parser.peekToken = parser.lexer.readToken()

proc currentIs(parser: Parser, kind: TokenKind): bool =
    return parser.currentKind == kind

proc peekIs(parser: Parser, kind: TokenKind): bool =
    return parser.peekKind == kind

proc expectPeek(parser: var Parser, kind: TokenKind): bool =
    if parser.peekIs(kind):
        parser.nextToken()
        return true
    return false

# endregion

# region Statement related
proc new*(dispatcher: typedesc[Statement], kind: StatementKinds,
        token: Token): Statement =
    return Statement(kind: kind, token: token)

proc parseLetStatement(parser: var Parser): Option[Statement] =

    if not parser.expectPeek(IDENT):
        return Statement.none()

    let letToken = parser.currentToken

    if not parser.expectPeek(ASSIGN):
        return Statement.none()

    while not parser.currentIs(SEMICOLON):
        parser.nextToken()

    let statement: Statement = Statement.new(LET, letToken)
    return statement.some()

proc parseReturnStatement(parser: var Parser): Option[Statement] =

    if not parser.currentIs(TokenKind.RETURN):
        return Statement.none()

    let returnToken = parser.currentToken

    while not parser.currentIs(SEMICOLON):
        parser.nextToken()

    let statement = Statement.new(RETURN, returnToken)
    return statement.some()

proc parseSimpleStatement(parser: var Parser): Option[Statement] =
    let token = parser.currentToken

    if parser.peekIs(SEMICOLON):
        parser.nextToken()

    let statement: Statement = Statement.new(SIMPLE, token)
    return statement.some()

proc parseStatement(parser: var Parser): Option[Statement] =

    return case parser.currentKind:
        of TokenKind.LET:
            parser.parseLetStatement()
        of TokenKind.RETURN:
            parser.parseReturnStatement()
        else:
            parser.parseSimpleStatement()
# endregion

# region Program related
proc new(dispatcher: typedesc[Program]): Program =
    let program = Program(statements: @[])
    return program

proc parseProgram*(parser: var Parser): Program =
    var program = Program.new()
    let append = (element: Statement) => program.statements.add(element)

    while not parser.currentIs(EOF):
        let statement = parser.parseStatement()
        statement.map(append)
        parser.nextToken()

    return program
# endregion
