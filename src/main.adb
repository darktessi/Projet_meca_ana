with type_expression;
use type_expression;

with affichage_expr;
use affichage_expr;

with operation;
use operation;

with type_mecanique;
use type_mecanique;

with ada.Text_IO;
use ada.Text_IO;

with ada.Float_Text_IO;
use ada.Float_Text_IO;

procedure main is
   expr : T_expr_int;
   temp : T_expr_int;
   t : T_litteraux := (false, 0, (1=> 't', others => ' '), 1, temps, (0=> 1.0, others => 0.0));
   alpha :T_litteraux := (false, 0, (1=> 'a', others => ' '), 1, angle, (0=>1.0, 1=>2.0, others => 0.0));
   beta :T_litteraux := (false, 0, (1=> 'b', others => ' '), 1, angle, (0=>1.0, 1=>2.0, others => 0.0));
   gamma :T_litteraux := (false, 0, (1=> 'c', others => ' '), 1, angle, (0=>1.0, 1=>2.0, others => 0.0));

begin

   temp := new T_expression'(type_expr => nombre, valeur => 1.2256);
   expr := new T_expression'(produit, temp, new T_expression'(litteral, alpha));
   temp := new T_expression'(cos, expr);
   temp := new T_expression'(puissance, temp, 4);


   temp := deriver(temp, t);
   temp := deriver(temp, t);
   temp := deriver(temp, t);
   temp := deriver(temp, t);
   normaliser(temp);
   New_Line;
   put("Valeur finale :");
   put(evaluate(temp));


end main;
