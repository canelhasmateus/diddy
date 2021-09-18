import monkey_expressions
import sugar

type
    CharPlanner = object
        start: int
        size: int

    CharPlan* = object of Plan[string]


proc new(cls: type CharPlan, step: int, produce: string): CharPlan =
    return CharPlan(step: step, produce: produce)

proc new(cls: type CharPlanner, start: int, size: int): CharPlanner =
    return CharPlanner(start: start, size: size)

proc plan(planner: CharPlanner, source: Source): CharPlan =

    let
        length = len(source)
        finish = min(length, planner.start + planner.size)
        size = finish - planner.start
        range = planner.start ..< finish
        produce = source[range]

    return CharPlan.new(size, produce)

proc step(planner: CharPlanner): ( Source ) -> Plan[string] =
    return (s: Source) => planner.plan(s)

when isMainModule:

    let source = Source.new("abcde")
    let planner = CharPlanner.new(0, 1)
    let parser = Parser.new(source)

    let charPlan = planner.step()(parser.source)

    echo charPlan
    echo parser



















