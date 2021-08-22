import diddy
import json
import unittest



test "let statements":

    let input = """
    let x = 5;
    let y = 10;
    let foobar = 838383;
    """

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 3

    for element in program.statements:
        echo %element

    #let expected = ["x" , "y" , "foobar"]

test "return statements":

    let input = """
    return 5;
    return 10;
    return 993322;
    """

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 3
    for statement in program.statements:

        echo %statement

test "identifier statements":
    let input = """
    5;
    """

    var lexer = Lexer.new(input)
    var parser = Parser.new(lexer)
    let program = parser.parseProgram()
    check len(program.statements) == 1
    for statement in program.statements:
        echo %statement
    
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
        echo %statement

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
        echo %statement

