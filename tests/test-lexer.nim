import diddy

import unittest

test "Basics":

    let lexer = Lexer.new()
    check lexer of Lexer



test "Lexer":

    let input = "=+(){},;"
    let literals = ["=", "+", "(", ")", "{", "}", ",", ";"]
    let tokens = [ASSIGN, PLUS, LPAREN, RPAREN, LBRACE, RBRACE, COMMA, SEMICOLON]

    var lexer = Lexer.new(input)
    for index in 0..<len(literals):

        let expectedLiteral = literals[index]
        let expectedToken = tokens[index]
        let currentToken = lexer.readToken()

        check currentToken of Token
        check currentToken.kind == expectedToken
        check currentToken.literal == expectedLiteral
