import diddy

import unittest

test "Basic-Tokens":

    let input = "=+(){},;"

    let expected = [(ASSIGN, "="),
    (PLUS, "+"),
    (LPAREN, "("),
    (RPAREN, ")"),
    (LBRACE, "{"),
    (RBRACE, "}"),
    (COMMA, ","),
    (SEMICOLON, ";")]

    var lexer = Lexer.new(input)

    check lexer of Lexer

    for expectedKind, expectedLiteral in expected.items():

        let currentToken = lexer.readToken()

        discard repr lexer

        check currentToken of Token
        check currentToken.kind == expectedKind
        check currentToken.literal == expectedLiteral

test "Basic Source":

    let input = """let five = 5;
                let ten = 10;
                let add = fn(x, y) { x + y; };
                let result = add(five, ten);
             """

    let expected = [("let", LET),
     ("five", IDENT),
     ("=", ASSIGN),
      ("5", INT),
      (";", SEMICOLON),
      ("let", LET),
      ("ten", IDENT),
      ("=", ASSIGN),
      ("10", INT),
      (";", SEMICOLON),
      ("let", LET),
      ("add", IDENT),
      ("=", ASSIGN),
      ("fn", FUNCTION),
      ("(", LPAREN),
      ("x", IDENT),
      (",", COMMA),
      ("y", IDENT),
      (")", RPAREN),
      ("{", LBRACE),
      ("x", IDENT),
      ("+", PLUS),
      ("y", IDENT),
      (";", SEMICOLON),
      ("}", RBRACE),
      (";", SEMICOLON),
      ("let", LET),
      ("result", IDENT),
      ("=", ASSIGN),
      ("add", IDENT),
      ("(", LPAREN),
      ("five", IDENT),
      (",", COMMA),
      ("ten", IDENT),
      (")", RPAREN),
      (";", SEMICOLON),
        ]


    var lexer = Lexer.new(input)

    for expectedLiteral, expectedKind in expected.items():

        let currentToken = lexer.readToken()

        check currentToken of Token
        check currentToken.kind == expectedKind
        check currentToken.literal == expectedLiteral


