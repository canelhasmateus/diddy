import monkey_expressions
import characters
import options

type

    Token = object of RootObj
        literal: string

    TokenRoute = object of ParserRoute
    TokenPlan* = object of ParserPlan[ Token ]

        
method `>>`( parser : Parser , route : TokenRoute) : TokenPlan = 
    
    
    let 
        startingRoute = CharRoute.new( 1 )
        plan: ParserPlan[string] = parser >>  startingRoute
        
        plan.produce 

    

