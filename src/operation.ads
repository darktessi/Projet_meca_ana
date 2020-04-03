

with type_expression;
use type_expression;


package operation is

   function deriver(expr : in T_expr_int; param : T_litteraux) return T_expr_int;
   procedure normaliser(e : in out T_expr_int);
   function nb_expr(n : in float ) return T_expr_int;
   function evaluate(e : in T_expr_int) return float;
   function puissance(a : in float; n : in integer) return float;

end operation;
