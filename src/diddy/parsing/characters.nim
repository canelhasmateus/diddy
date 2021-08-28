import monkey_expressions

type
    CharRoute = object of ParserRoute

    CharPlan* = object of ParserPlan
        product*: string

proc new(cls: type CharRoute, size: int): auto =
    return CharRoute(size: size)


method `>>`(parser: Parser, route: CharRoute): auto =

    let
        oldPos = parser.pos
        maxLenght = len(parser.source)
        newPos = min(parser.pos + route.size, maxLenght)

        newParser = Parser(source: parser.source, pos: newPos)
        range = oldPos..<newParser.pos
        product = parser.source[range]

    return CharPlan(state: newParser, product: product)

when isMainModule:

    let source = "abcde"
    let route = CharRoute.new(0)
    let parser = Parser.new(source)

    let output = parser >> route

    echo output.product

    echo parser
    echo output.state



















