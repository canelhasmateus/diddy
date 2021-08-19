import monkey_lexer
import monkey_tokens

const PROMPT = "🐒 >> "

proc start*() =

    while not endOfFile(stdin):

        stdout.write(PROMPT)
        stdout.write("\n")
        let input = stdin.readLine()
        var lexer = Lexer.new(input)

        while true:

            let token = lexer.readToken()
            if token.kind == EOF:
                break

            stdout.write( $token.kind)


when isMainModule:
    start()
