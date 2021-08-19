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
                !-/*5;
                5 < 10 > 5;
                if (5 < 10) {
                return true;
                } else {
                return false;
                }
                10 == 10;
                10 != 9;
             """

    let expected = [
        ("let", LET), ("five", IDENT), ("=", ASSIGN), ("5", INT), (";",
                SEMICOLON),

         ("let", LET), ("ten", IDENT), ("=", ASSIGN), ("10", INT), (";",
                 SEMICOLON),

      ("let", LET), ("add", IDENT), ("=", ASSIGN), ("fn", FUNCTION), ("(",
              LPAREN), ("x", IDENT), (",", COMMA), ("y", IDENT), (")", RPAREN),
              ("{", LBRACE), ("x", IDENT), ("+", PLUS), ("y", IDENT), (";",
              SEMICOLON), ("}", RBRACE), (";", SEMICOLON),

      ("let", LET), ("result", IDENT), ("=", ASSIGN),
    ("add", IDENT), ("(", LPAREN), ("five", IDENT), (",", COMMA), ("ten", IDENT),
    (")", RPAREN), (";", SEMICOLON),

      ("!", BANG), ("-", MINUS), ("/", SLASH), ("*", ASTERIST), ("5", INT), (
              ";", SEMICOLON),

      ("5", INT), ("<", LT), ("10", INT), (">", GT), ("5", INT), (";",
              SEMICOLON),

      ("if", IF), ("(", LPAREN), ("5", INT), ("<", LT), ("10", INT), (")",
              RPAREN), ("{", LBRACE), ("return", RETURN), ("true", TRUE), (";",
              SEMICOLON), ("}", RBRACE), ("else", ELSE), ("{", LBRACE), (
              "return", RETURN), ("false", FALSE), (";", SEMICOLON), ("}",
              RBRACE),

      ("10", INT), ("==", EQ), ("10", INT), (";", SEMICOLON),

      ("10", INT), ("!=", NOT_EQ), ("9", INT), (";", SEMICOLON),

      ("\x00", EOF)
    ]

    var lexer = Lexer.new(input)

    for expectedLiteral, expectedKind in expected.items():

        let currentToken = lexer.readToken()

        check currentToken of Token
        check currentToken.kind == expectedKind
        check currentToken.literal == expectedLiteral


