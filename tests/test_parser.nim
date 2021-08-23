import diddy

import unittest
import strutils

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
        check statement.asString() == "5"

test "prefix expressions":

    let expects = ["!5", "-15"]
    let input = expects.join(";")

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 2
    for index in 0..<expects.len:
        let expected = expects[index]
        let actual = program.statements[index]
        check actual.asString() == expected

test "infix expressions":

    let expecteds = ["5 + 5", "5 - 5", "5 * 5", "5 / 5", "5 > 5", "5 < 5",
            "5 == 5", "5 != 5"]
    let input = join(expecteds, ";")


    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
#    check len(program.statements) == 8

    for index in 0..<expecteds.len:
        let expected = expecteds[index]
        let actual = program.statements[index]
        check actual.asString() == expected
