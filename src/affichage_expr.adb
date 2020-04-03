with ada.Text_IO;
use ada.Text_IO;
with ada.Float_Text_IO;
use ada.Float_Text_IO;
with type_expression;
with ada.Integer_Text_IO;
use ada.Integer_Text_IO;

package body affichage_expr is

   procedure display_expr(expr : in T_expr_int) is
   begin
      case expr.type_expr is
         when produit =>
            if expr.p1.type_expr /= somme then
               display_expr(expr.p1);
               put(" * ");
            else
               put("(");
               display_expr(expr.p1);
               put(") * ");
            end if;
            if expr.p2.type_expr /= somme then
               display_expr(expr.p2);
            else
               put("(");
               display_expr(expr.p2);
               put(")");
            end if;
         when somme =>

            display_expr(expr.s1);
            put(" + ");
            display_expr(expr.s2);

         when litteral =>
            put(expr.litt.symbole(1..expr.litt.symbole_lg));
            for i in 1..expr.litt.deg_deriv_temps loop
               put("#"); --nombre de fois derivé ... ° ne fonctionne pas
            end loop;

         when nombre =>
            put(expr.valeur);
         when puissance =>
            if expr.expr.type_expr = litteral or expr.expr.type_expr = nombre or expr.expr.type_expr = sin or expr.expr.type_expr = cos then
               display_expr(expr.expr);
               put(" ** ");
               put(expr.exposant);
            else

               put("(");
               display_expr(expr.expr);
               put(") ** ");
               put(expr.exposant);
            end if;


         when division =>
            if expr.d1.type_expr /= somme then
               display_expr(expr.d1);
               put(" / ");
            else
               put("(");
               display_expr(expr.d1);
               put(") / ");
            end if;
            if expr.d2.type_expr = litteral or expr.d2.type_expr = nombre then
               display_expr(expr.d2);
            else
               put("(");
               display_expr(expr.d2);
               put(")");
            end if;

         when cos =>
            put("cos(");
            display_expr(expr.Carg);
            put(")");
         when sin =>
            put("sin(");
            display_expr(expr.Sarg);
            put(")");
         when others =>
            null;
      end case;

   end display_expr;





end affichage_expr;
