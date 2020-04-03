with operation; use operation;
with ada.Text_IO;
use ada.Text_IO;
with ada.Float_Text_IO;
use ada.Float_Text_IO;
with ada.Integer_Text_IO;
use ada.Integer_Text_IO;


package body type_expression is

   function "="(n1 : in T_expr_int; n2 : in T_expr_int) return boolean is
   begin
      if n1.type_expr = nombre and n2.type_expr = nombre then
         return  n1.valeur = n2.valeur;
      else
         return false;
      end if;

   end "=";

   function "*"(n1 : in T_expr_int; n2 : in T_expr_int) return T_expr_int is
   begin
      if n1.type_expr = nombre and n2.type_expr = nombre then
         return nb_expr(n1.valeur*n2.valeur);
      else

         return new T_expression'(produit, n1, n2);
      end if;

   end "*";

   function "+"(n1 : in T_expr_int; n2 : in T_expr_int) return T_expr_int is
   begin
      if n1.type_expr = nombre and n2.type_expr = nombre then
         return nb_expr(n1.valeur+n2.valeur);
      else

         return new T_expression'(somme, n1, n2);
      end if;

   end "+";

   function "-"(n1 : in T_expr_int; n2 : in T_expr_int) return T_expr_int is
   begin
     if n1.type_expr = nombre and n2.type_expr = nombre then
         return nb_expr(n1.valeur-n2.valeur);
      else

         return new T_expression'(somme, n1, new T_expression'(produit, nb_expr(-1.0), n2));
      end if;

   end "-";


   function "/"(d1 : in T_expr_int; d2 : in T_expr_int) return T_expr_int is
   begin
      if d1.type_expr = nombre and d2.type_expr = nombre then
         return nb_expr(d1.valeur/d2.valeur);
      else

         return new T_expression'(division, d1, d2);
      end if;

   end "/";



   procedure put(expr : in T_expr_int) is
   begin
      case expr.type_expr is
         when produit =>
            if expr.p1.type_expr /= somme then
               put(expr.p1);
               put(" * ");
            else
               put("(");
               put(expr.p1);
               put(") * ");
            end if;
            if expr.p2.type_expr /= somme then
               put(expr.p2);
            else
               put("(");
               put(expr.p2);
               put(")");
            end if;
         when somme =>

            put(expr.s1);
            put(" + ");
            put(expr.s2);

         when litteral =>
            put(expr.litt.symbole(1..expr.litt.symbole_lg));
            for i in 1..expr.litt.deg_deriv_temps loop
               put("#"); --nombre de fois derivé ... ° ne fonctionne pas
            end loop;

         when nombre =>
            put(expr.valeur);
         when puissance =>
            if expr.expr.type_expr = litteral or expr.expr.type_expr = nombre or expr.expr.type_expr = sin or expr.expr.type_expr = cos then
               put(expr.expr);
               put(" ** ");
               put(expr.exposant);
            else

               put("(");
               put(expr.expr);
               put(") ** ");
               put(expr.exposant);
            end if;


         when division =>
            if expr.d1.type_expr /= somme then
               put(expr.d1);
               put(" / ");
            else
               put("(");
               put(expr.d1);
               put(") / ");
            end if;
            if expr.d2.type_expr = litteral or expr.d2.type_expr = nombre then
               put(expr.d2);
            else
               put("(");
               put(expr.d2);
               put(")");
            end if;

         when cos =>
            put("cos(");
            put(expr.Carg);
            put(")");
         when sin =>
            put("sin(");
            put(expr.Sarg);
            put(")");
         when others =>
            null;
      end case;

   end put;


   procedure put_line(expr: in T_expr_int) is
   begin
      put(expr);
      New_Line;
   end;






end type_expression;
