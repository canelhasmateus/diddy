import ".."/diddy_lexer
import sugar

type


    Route* = object of RootObj
    Plan* = object of RootObj

    Plannable = concept x
        x >> Route is Plan
        x >> Plan is Plannable

type

    Parser* = object of RootObj
        pos*: int
        source*: string

    ParserRoute* = object of Route
        size*: int

    ParserPlan* = object of Plan
        state*: Parser




method `>>`*(state: Parser, route: ParserRoute): ParserPlan {.base.} =
    return ParserPlan(state: state)

method `>>`*(state: Parser, plan: ParserPlan): Parser {.base.} =
    return plan.state

method `>>`*(before : ParserPlan, after : ParserRoute ) : auto =
    return before.state >> after

proc new*( parser : type Parser  , source  : string ) : Parser =
    return Parser(pos: 0, source: source)
##



