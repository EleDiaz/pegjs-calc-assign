/*
 * Classic example grammar, which recognizes simple arithmetic expressions like
 * "2*(3+4)". The parser generated from this grammar then computes their value.
 */

/*

  Como controlar la identacion?
  Los identificadores no pueden ser palabras reservadas del lenguaje // esto es importante

*/
{
    var util = require('util');
    var symbolTable = {
        PI: Math.PI
    };

    // :: Int -> [(String, Int)] -> Int
    function foldExpresion(left, rest) {
        return rest.reduce((prod, [op, num]) => { return eval(prod+op+num); },left);
    };

}

start =
    expresion

expresion
    = value:assign {
        console.log("assign:" + value);
        console.log(util.inspect(symbolTable,{ depth: null}));
        return value;
    }

    / value:ifthenelse {
        console.log("IfthenElse");
        return value;
    }

    / value:additive {
        console.log("Additive :" + value);
        return value;
    }

assign
    = id:ID ASSIGN a:expresion {
        symbolTable[id] = a;
        return a;
    }

func
    = name:ID param:ID* ASSIGN expresion {
        symbolTable[id] =  {}
    }

ifthenelse
    = IF check:expresion THEN trueExp:expresion ELSE falseExp:expresion {
        console.log("CHECK:" + check);
        console.log("TRUE:" + trueExp);
        console.log("FALSE:" + falseExp);
        if (check) {
            return trueExp;
        }
        else {
            return falseExp;
        }
    }

additive
    = left:multiplicative rest:(ADDOP multiplicative)* { return foldExpresion(left, rest); }
    / multiplicative

multiplicative
    = left:primary rest:(MULOP primary)* { return foldExpresion(left, rest); }
    / primary

primary
    = integer
    / id:ID { return symbolTable[id]; }
    /* / id:ID (expresion _)* {  }*/
    / LEFTPAR additive:additive RIGHTPAR { return additive; }

/* A rule can also contain human-readable name that is used in error messages (in our example, only the integer rule has a human-readable name). */
integer "integer"
    = NUMBER

_ = $[ \t\n\r]*

ADDOP = PLUS / MINUS
MULOP = MULT / DIV
PLUS = _"+"_  { return '+'; }
MINUS = _"-"_ { return '-'; }
MULT = _"*"_  { return '*'; }
DIV = _"/"_   { return '/'; }
LEFTPAR = _"("_
RIGHTPAR = _")"_
NUMBER = _ digits:$[0-9]+ _ { return parseInt(digits, 10); }
ID = _ id:$([a-z_]i$([a-z0-9_]i*)) _ { return id; }
ASSIGN = _ '=' _
IF = _ 'if' _
THEN = _ 'then' _
ELSE = _ 'else' _
