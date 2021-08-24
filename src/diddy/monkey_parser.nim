import monkey_tokens
import monkey_lexer
import options
import sugar
import strutils

type

    Precedence* = enum
        LOWEST,
        EQUALS,
        LESSGREATER,
        SUM,
        PRODUCT,
        OPERATOR,
        CALL

    ExpressionKind* = enum
        IDENTIFIER,
        INTEGER_LITERAL,
        PREFIX,
        INFIX

    Expression* = ref object of RootObj

        token: Token
        case kind: ExpressionKind:
            of INTEGER_LITERAL:
                value: int
            of INFIX:
                left: Expression
                right: Expression
            of PREFIX:
                postfixed: Expression
            of IDENTIFIER:
                nil
 #todo implement syntax for leds and nuds.
 #
type
    StatementKind* = enum
        LET, SIMPLE, RETURN

    Statement* = ref object of RootObj
        token*: Token
        kind*: StatementKind
        expression*: Expression

type
    Parser* = ref object of RootObj
        lexer*: Lexer
        currentToken*: Token
        peekToken*: Token

    Program* = ref object of RootObj
        statements*: seq[Statement]

    Led* = (var Parser) -> Option[Expression]
    Nud* = (var Parser, Expression) -> Option[Expression]

# region debugging, reporting related
proc `asString`*(expression: Expression): string =
    return case expression.kind:
        of {INTEGER_LITERAL, IDENTIFIER}:
            expression.token.literal
        of INFIX:
            "(" & expression.left.asString() & " " & expression.token.literal &
                    " " &
            expression.right.asString() & ")"
        of PREFIX:
            expression.token.literal & expression.postfixed.asString()

proc `asString`*(statement: Statement): string =
    return case statement.kind:
        of StatementKind.LET:
            "let " & statement.token.literal & " = " &
                    statement.expression.asString()
        of StatementKind.RETURN:
            "return " & statement.expression.asString()
        of StatementKind.SIMPLE:
            statement.expression.asString()
# endregion


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

# region Precedence related
proc parseExpression(parser: var Parser, precedence: Precedence): Option[Expression]

proc precedence(token: TokenKind): Precedence =
    return case token:
        of {EQ, NOT_EQ}:
            EQUALS
        of {LT, GT}:
            LESSGREATER
        of {PLUS, MINUS}:
            SUM
        of {SLASH, ASTERIST}:
            PRODUCT
        of {BANG}:
            OPERATOR
        else:
            LOWEST

proc precedence(token: Token): Precedence =
    return precedence(token.kind)

proc peekPrecedence(parser: Parser): Precedence =
    return precedence(parser.peekToken)
# endregion


# region Expression related
proc fallbackExpression(parser: var Parser): Option[Expression] =
    return Expression.none()

# region Expression Instantiation
proc newIdentifier*(dispatcher: typedesc[Expression],
        token: Token): Expression =

    let expression = Expression(token: token, kind: ExpressionKind.IDENTIFIER)
    return expression

proc newIntegerLiteral*(dispatcher: typedesc[Expression],
        token: Token): Expression =

    let value = parseInt(token.literal)
    let expression = Expression(token: token,
        kind: ExpressionKind.INTEGER_LITERAL,
        value: value)
    return expression

proc newPrefix(dispatcher: typedesc[Expression],
token: Token, postfixed: Expression): Expression =

    let expression = Expression(token: token, kind: ExpressionKind.PREFIX,
            postfixed: postfixed)
    return expression

proc newInfix(dispatcher: typedesc[Expression], token: Token, left: Expression,
        right: Expression): Expression =
    let expression = Expression(token: token, kind: ExpressionKind.INFIX,
            left: left, right: right)
    return expression
# endregion




# region leds
proc parseIdentifierExpression(parser: var Parser): Option[Expression] =
    let currentToken = parser.currentToken
    let expression = Expression.newIdentifier(currentToken)
    return expression.some()

proc parsePrefixExpression(parser: var Parser): Option[Expression] =
    let currentToken = parser.currentToken
    parser.nextToken()
    let rightExpression = parser.parseExpression(OPERATOR)
    let create = (e: Expression) => Expression.newPrefix(currentToken, e)
    return rightExpression.map(create)

proc parseIntegerLiteralExpression(parser: var Parser): Option[Expression] =
    let token = parser.currentToken
    let expression = Expression.newIntegerLiteral(token)
    return expression.some()

proc new(dispatcher: typedesc[Led], token: TokenKind): Led =
    return case token:
        of {BANG, MINUS}:
            Led(parsePrefixExpression)
        of IDENT:
            parseIdentifierExpression
        of INT:
            parseIntegerLiteralExpression
        else:
            fallbackExpression
# endregion


# region nuds

proc parseInfixExpression(parser: var Parser, left: Expression): Option[Expression] =
    let currentToken = parser.currentToken
    let precedence = currentToken.precedence()
    parser.nextToken()
    let right = parser.parseExpression(precedence)
    let create = (e: Expression) => Expression.newInfix(currentToken, left, e)
    return right.map(create)

proc parseBooleanLiteralExpression(parser: var Parser): Option[Expression] =
    return Expression.none()

proc parseIfExpression(parser: var Parser): Option[Expression] =
    return Expression.none()

proc new(dispatcher: typedesc[Nud], token: TokenKind): Nud =
    return case token:
        of {GT, LT, EQ, PLUS, EQ, NOT_EQ, ASTERIST, SLASH, MINUS}:
            (parser: var Parser, e: Expression) => parseInfixExpression(parser, e)
        of {TRUE, FALSE}:
            (parser: var Parser, _: Expression) =>
                    parseBooleanLiteralExpression(parser)
        of IF:
            (parser: var Parser, _: Expression) => parseIfExpression(parser)
        else:
            (parser: var Parser, _: Expression) => fallbackExpression(parser)

# endregion

proc parseExpression(parser: var Parser, precedence: Precedence): Option[Expression] =

    let leftKind = parser.currentKind()
    let led = Led.new(leftKind)
    var leftExpression = led(parser)

    if leftExpression.isNone():
        return Expression.none()

    while not parser.peekIs(SEMICOLON) and precedence < parser.peekPrecedence():
        parser.nextToken()

        let rightKind = parser.currentKind()
        let nud = Nud.new(rightKind) # this creates a ( var Parser , Expression ) -> Option[Expression])

        if leftExpression.isSome():
            leftExpression = nud(parser, leftExpression.get())

    return leftExpression
# endregion

# region Statement related
proc new*(dispatcher: typedesc[Statement], kind: StatementKind, token: Token,
        expression: Expression): Statement =
    let statement = Statement(token: token,
    kind: kind,
     expression: expression)
    return statement

proc newLetStatement*(dispatcher: typedesc[Statement], token: Token,
        expression: Expression): Statement =
    return Statement.new(StatementKind.LET, token, expression)

proc newReturnStatement*(dispatcher: typedesc[Statement],
        expression: Expression): Statement =
    let token = Token.new(TokenKind.RETURN, "return")
    return Statement.new(StatementKind.RETURN, token, expression)

proc newSimpleStatement*(dispatcher: typedesc[Statement], token: Token,
        expression: Expression): Statement =
    return Statement.new(StatementKind.SIMPLE, token, expression)

proc parseLetStatement(parser: var Parser): Option[Statement] =
    if not parser.expectPeek(IDENT):
        return Statement.none()

    let identifier = parser.currentToken

    if not parser.expectPeek(ASSIGN):
        return Statement.none()

    parser.nextToken()

    let expression = parser.parseExpression(LOWEST)

    if expression.isNone():
        return Statement.none()

    let statement = Statement.newLetStatement(identifier, expression.get())

    return statement.some()

proc parseReturnStatement(parser: var Parser): Option[Statement] =

    if not parser.currentIs(TokenKind.RETURN):
        return Statement.none()

    parser.nextToken()

    let expression = parser.parseExpression(LOWEST)
    if expression.isNone():
        return Statement.none()

    let statement = Statement.newReturnStatement(expression.get())
    return statement.some()

proc parseSimpleStatement(parser: var Parser): Option[Statement] =
    let token = parser.currentToken
    let expression = parser.parseExpression(LOWEST)

    if parser.peekIs(SEMICOLON):
        parser.nextToken()

    if expression.isNone():
        return Statement.none()

    let statement = Statement.newSimpleStatement(token, expression.get())
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

