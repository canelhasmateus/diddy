import diddy

import unittest
import strutils

test "let statements":

    let expecteds = ["let x = 5;", "let y = 10;", "let foobar = 838383;"]
    let input = join(expecteds, "")

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


    let expecteds = ["return 5;", "return 10;", "return 993322;"]
    let input = join(expecteds, "")

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
        echo statement.asString()

test "prefix expressions":
    let input = """
    !5;
    -15;
    """
    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 2
    for statement in program.statements:
        echo statement.asString()

test "infix expressions":

    let input = """
    5 + 5;
    5 - 5;
    5 * 5;
    5 / 5;
    5 > 5
    5 < 5
    5 == 5
    5 != 5
    """
    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 8
    for statement in program.statements:
        echo statement.asString()

