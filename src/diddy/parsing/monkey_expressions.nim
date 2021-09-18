import sugar

type

    Source* = object of RootObj
        value: string


proc `[]`*(source: Source, range: HSlice[int, int]): string =
    return source.value[range]

proc len*(source: Source): int =
    return len(source.value)

proc new*(cls: type Source, value: string): Source =
    return Source(value: value)


###

type
    Plan*[T] = object of RootObj
        step*: int
        produce*: T



    Parser* = object of RootObj
        offset*: int
        source*: Source


proc new*(parser: type Parser, offset: int, source: Source): Parser =
    return Parser(offset: offset, source: source)

proc new*(parser: type Parser, source: Source): Parser =
    return Parser.new(0, source)


method route*[T](state: Parser, planner: (Source) -> Plan[T]): Plan[T] {.base.} =
    return planner(state.source)


##
