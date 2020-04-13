

with type_expression;
use type_expression;
with ada.Text_IO;
use ada.Text_IO;
with affichage_expr;
use affichage_expr;
WITH Ada.Numerics.Elementary_Functions;
USE Ada.Numerics.Elementary_Functions;


package body operation is

   function nb_expr(n : in float ) return T_expr_int is
   begin
      if n >= 0.0 then
         return new T_expression'(nombre, False,n);
      else
         return new T_expression'(nombre, True,n);
      end if;

   end nb_expr;



   function deriver(expr : in T_expr_int; param : T_litteraux) return T_expr_int is
      temp1 : T_expr_int;
      temp2 : T_expr_int;
      temp3 : T_expr_int;

   begin
      case expr.type_expr is
         when produit =>
            temp1 := new T_expression'(produit, expr.p1.is_negative, deriver(expr.p1, param), expr.p2);
            temp2 := new T_expression'(produit, expr.p2.is_negative, deriver(expr.p2, param), expr.p1);

            return new T_expression'(somme,False, temp1, temp2);
         when somme =>
            return new T_expression'(somme, False,deriver(expr.s1, param), deriver(expr.s2, param));
         when litteral =>
            if expr.litt = param then
               return nb_expr(1.0);
            else
               if param.cat_lit = temps and not expr.litt.is_constant then
                  return new T_expression'(litteral, False, (expr.litt.is_constant, expr.litt.deg_deriv_temps + 1, expr.litt.symbole, expr.litt.symbole_lg, expr.litt.cat_lit, expr.litt.valeur));
               else
                  return nb_expr(0.0);
               end if;
            end if;

         when nombre =>
            return nb_expr(0.0);
         when puissance =>
            if expr.exposant = 1 then
               return deriver(expr.expr, param);
            else
               temp1 := new T_expression'(puissance,False, expr.expr, expr.exposant-1);
               temp2 := nb_expr(float(expr.exposant-1));
               return new T_expression'(produit, False, temp1, new T_expression'(produit, False, temp2, deriver(expr.expr, param)));
            end if;
         when division =>
            temp1 := new T_expression'(produit, False, deriver(expr.d1, param), expr.d2);
            temp2 := new T_expression'(produit, True,deriver(expr.d2, param), expr.d1);--forme négative
            --temp2 := new T_expression'(produit, nb_expr(-1.0), temp2); implémentation de la forme négative
            temp2 := new T_expression'(somme, False, temp1, temp2);
            temp3 := new T_expression'(puissance, False, expr.d2, 2);
            return new T_expression'(division, False, temp2, temp3);
         when cos =>
            --temp1 := nb_expr(-1.0);
            --temp2 := new T_expression'(produit, True, temp1, deriver(expr.Carg, param));
            temp3 := new T_expression'(sin, False, expr.Carg);
            return new T_expression'(produit, True, deriver(expr.Carg, param), temp3);
         when sin =>
            temp3 := new T_expression'(cos,False, expr.Sarg);
            return new T_expression'(produit,False, deriver(expr.Sarg, param) , temp3);
         when others =>
            return nb_expr(0.0); -- ATTENTION CE CODE N EST PAS CENSE ETRE EXECUTE

      end case;

   end deriver;

   procedure normaliser(e : in out T_expr_int) is
      old_e : T_expr_int := e;
   begin

      case e.type_expr is
         when produit =>

            normaliser(e.p1);
            normaliser(e.p2);
            if e.p1.type_expr = nombre and e.p2.type_expr = nombre then
               e := nb_expr(e.p1.valeur * e.p2.valeur);
            else

            if e.p1 = nb_expr(0.0) or e.p2 = nb_expr(0.0) then
               e:= nb_expr(0.0);
            else

               if e.p1 = nb_expr(1.0) then
                  e := e.p2;
               else

                  if e.p2 = nb_expr(1.0) then
                     e := e.p1;
                  end if;
               end if;
               end if ;
            end if;


         when somme =>
            normaliser(e.s1);
            normaliser(e.s2);
            if e.s1.type_expr = nombre and e.s2.type_expr = nombre then
               e := nb_expr(e.s1.valeur + e.s2.valeur);
            else
               if e.s1 = nb_expr(0.0) then
                  e := e.s2;
               else

                  if e.s2 = nb_expr(0.0) then
                     e := e.s1;
                  end if;
               end if;
            end if;


         when puissance =>
               normaliser(e.expr);
               if e.exposant = 0 then
                  e := nb_expr(1.0);
               end if;
               if e.exposant = 1 then
                  e := e.expr;
               end if;
            when division =>
               normaliser(e.d1);
            normaliser(e.d2);
            if e.d1.type_expr = nombre and e.d2.type_expr = nombre then
               e := nb_expr(e.d1.valeur / e.d2.valeur);
            else
               if e.d1 = nb_expr(0.0) then
                  e := nb_expr(0.0);
               end if;
               if e.d2 = nb_expr(1.0) then
                  e := e.d1;
               end if;
            end if;

            when cos =>
               normaliser(e.Carg);
               if e.Carg = nb_expr(0.0) then
                  e := nb_expr(1.0);
               end if;
            when sin =>
               normaliser(e.Sarg);
               if e.Sarg = nb_expr(0.0) then
                  e := nb_expr(0.0);
               end if;
            when others => null;
      end case;

   end normaliser;



   function puissance(a : in float; n : in integer) return float is
      temp : float := 1.0;
   begin
      for i in 1..n loop
         temp := a * temp;
      end loop;
      return temp;
   end puissance;

   function evaluate(e : in T_expr_int) return float is
   begin
      case e.type_expr is
         when produit =>
            return evaluate(e.p1) * evaluate(e.p2);
         when somme =>
            return evaluate(e.s1) + evaluate(e.s2);
         when litteral =>
            return e.litt.valeur(e.litt.deg_deriv_temps);
         when nombre =>
            return e.valeur;
         when puissance =>
            return puissance(evaluate(e.expr), e.exposant);
         when division =>
            return evaluate(e.d1)/evaluate(e.d2);
         when cos =>
            return cos(evaluate(e.Carg));
         when sin =>
            return sin(evaluate(e.Sarg));
         when others => return 0.0;
      end case;
   end evaluate;

   function normaliser(e : in T_expr_int) return T_expr_int is
      n : T_expr_int;
   begin
      n := e;
      normaliser(n);
      return n;
   end;

   function hard_normaliser(e : in T_expr_int) return T_expr_int is
   begin
      if e = normaliser(e) then
         return e;
      else
         return hard_normaliser(normaliser(e));
      end if;
   end;

   procedure hard_normaliser(e : in out T_expr_int) is
   begin
      e := hard_normaliser(e);
   end;

   procedure deriver(expr : in out T_expr_int; param : in T_litteraux) is
   begin
      expr := deriver(expr, param);
   end;








end operation;
