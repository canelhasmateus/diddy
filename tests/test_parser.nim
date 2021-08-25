import diddy

import unittest
import strutils
import sequtils
import json

test "let statements":

    let expecteds = ["let x = 5", "let y = 10", "let foobar = 838383"]
    let input = join(expecteds, ";")

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 3

    for i in 0..<expecteds.len():
        let actual = program.statements[i]
        let expected = expecteds[i]

        check actual.kind == StatementKind.LET
        check actual.asString() == expected

test "return statements":


    let expecteds = ["return 5", "return 10", "return 993322"]
    let input = join(expecteds, ";")

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 3

    for i in 0..<expecteds.len():
        let actual = program.statements[i]
        let expected = expecteds[i]

        check actual.kind == StatementKind.RETURN
        check actual.asString() == expected

test "simple statements":
    let input = """
    5;
    """

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 1
    for statement in program.statements:

        check statement.kind == SIMPLE
        check statement.expression.kind == INTEGER_LITERAL
        check statement.asString() == "5"

test "prefix expressions":

    let expects = ["!5", "-15"]
    let input = expects.join(";")

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == len(expects)
    for index in 0..<expects.len:
        let expected = expects[index]
        let actual = program.statements[index]

        check actual.kind == SIMPLE
        check actual.expression.kind == PREFIX
        check actual.asString() == expected

test "infix expressions":

    let expecteds = ["5 + 5", "5 - 5", "5 * 5", "5 / 5", "5 > 5", "5 < 5",
            "5 == 5", "5 != 5"]
    let input = join(expecteds, ";")


    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == len(expecteds)

    for index in 0..<expecteds.len:
        let expected = expecteds[index]
        let actual = program.statements[index]

        check actual.kind == SIMPLE
        check actual.expression.kind == INFIX
        check actual.asString() == "(" & expected & ")"

proc first[K, V](tupl: tuple[a: K, b: V]): K =
    return tupl[0]

test "precedence expressions":

    let equivalences = [
        ("a + b / c", "(a + (b / c))"),
        ("a * b - c", "((a * b) - c)"),
        ("(a + b) / c", "((a + b) / c)"),
        ]


    let input = equivalences.map(first).join(";")

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()

    check len(program.statements) == equivalences.len()

    for index in 0..<equivalences.len():
        let expected = equivalences[index][1]
        let actual = program.statements[index]
        check actual.kind == SIMPLE
        check actual.asString() == expected


test "booleanExpressions":

    let expecteds = ["true", "false"]
    let input = join(expecteds, ";")
    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()

    check len(program.statements) == len(expecteds)

    for index in 0..<expecteds.len():
        let actual = program.statements[index]
        let expected = expecteds[index]

        check actual.kind == SIMPLE
        check actual.expression.kind == BOOLEAN_LITERAL
        check actual.asString() == expected

test "if expressions":

    let expecteds = ["if (x < y) { x }", "if (x < y) { x } else { y }"]
    let input = join(expecteds, ";")
    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == len(expecteds)

    for index in 0..<expecteds.len():
        let actual = program.statements[index]
        let expected = expecteds[index]

        check actual.kind == SIMPLE
        check actual.expression.kind == CONDITIONAL
        check actual.asString() == expected

test "function literals":

    let expecteds = ["fn( x ) { x }",
    "fn( x, y ) { (x + y) }",
            "fn( x, y, z ) { ((x + y) + z) }"]

    let input = join(expecteds, ";")
    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == len(expecteds)

    for index in 0..<expecteds.len():
        let actual = program.statements[index]
        let expected = expecteds[index]

        check actual.kind == SIMPLE
        check actual.expression.kind == FUNCTION_LITERAL
        check actual.asString() == expected




