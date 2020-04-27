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
         return expr_text(n1) = expr_text(n2);
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

         return new T_expression'(soustraction, n1, n2);
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
      c : T_chaine := expr_text(expr);
   begin
      put(c.ch(1..c.lg));
   end;

   function text_ch(s : in string) return T_chaine is
   c : T_chaine;
   begin
      c.ch(1..s'Length) := s;
      c.lg := s'Length;
      c.nb_carac_ligne := s'Length;
      return c;
   end;


   function expr_text(expr : in T_expr_int) return T_chaine is
      c : T_chaine := text_ch("");
   begin
      case expr.type_expr is
         when produit =>
            if expr.p1.type_expr /= somme then
               c := c+ expr_text(expr.p1);
               c := c+ text_ch(" * ");
            else
               c := c+ text_ch("(");
               c := c+ expr_text(expr.p1);
               c := c+ text_ch(") * ");
            end if;
            if expr.p2.type_expr /= somme then
               c := c+ expr_text(expr.p2);
            else
               c := c+ text_ch("(");
               c := c+ expr_text(expr.p2);
               c := c+ text_ch(")");
            end if;
         when somme =>

            c := c+ expr_text(expr.s1);
            c := c+ text_ch(" + ");
            c := c+ expr_text(expr.s2);
         when soustraction =>
            if expr.sm1 /= nb_expr(0.0) then
               put(expr.sm1);
            end if;
            put(" - (");
            put(expr.sm2);
            put(")");
         when litteral =>
            c := c+ text_ch(expr.litt.symbole(1..expr.litt.symbole_lg));
            for i in 1..expr.litt.deg_deriv_temps loop
               c := c+ text_ch("#"); --nombre de fois derivé ... ° ne fonctionne pas
            end loop;

         when nombre =>
            c := c+ text_ch(Float'image(expr.valeur));
         when puissance =>
            if expr.expr.type_expr = litteral or expr.expr.type_expr = nombre or expr.expr.type_expr = sin or expr.expr.type_expr = cos then
               c := c+ expr_text(expr.expr);
               c := c+ text_ch(" ** ");
               c := c+ text_ch(integer'image(expr.exposant));
            else

               c := c+ text_ch("(");
               c := c+ expr_text(expr.expr);
               c := c+ text_ch(") ** ");
               c := c+ text_ch(integer'image(expr.exposant));
            end if;


         when division =>
            if expr.d1.type_expr /= somme then
               c := c+ expr_text(expr.d1);
               c := c+ text_ch(" / ");
            else
               c := c+ text_ch("(");
               c := c+ expr_text(expr.d1);
               c := c+ text_ch(") / ");
            end if;
            if expr.d2.type_expr = litteral or expr.d2.type_expr = nombre then
               c := c+ expr_text(expr.d2);
            else
               c := c+ text_ch("(");
               c := c+ expr_text(expr.d2);
               c := c+ text_ch(")");
            end if;

         when cos =>
            c := c+ text_ch("cos(");
            c := c+ expr_text(expr.Carg);
            c := c+ text_ch(")");
         when sin =>
            c := c+ text_ch("sin(");
            c := c+ expr_text(expr.Sarg);
            c := c+ text_ch(")");
         when others =>
            null;
      end case;
      return c;

   end expr_text;


   procedure put_line(expr: in T_expr_int) is
   begin
      put(expr);
      New_Line;
   end;

   function "+"(ch1 : in T_chaine; ch2 : in T_chaine) return T_chaine is
   ch : T_chaine;
   begin
      ch.ch(1..ch1.lg) := ch1.ch(1..ch1.lg);
      ch.ch(ch1.lg+1..ch1.lg+ch2.lg) := ch2.ch(1..ch2.lg);
      ch.lg := ch1.lg+ch2.lg;
      ch.nb_carac_ligne:= ch1.nb_carac_ligne+ch2.nb_carac_ligne;
      return ch;
   end;

   function "="(ch1 : in T_chaine; ch2 : in T_chaine) return Boolean is
   begin
      return (ch1.lg = ch2.lg) and ch1.ch(1..ch1.lg) = ch2.ch(1..ch2.lg);
   end "=";


   procedure put(c : in T_chaine) is
   begin
      put(c.ch(1..c.lg));
   end;






end type_expression;
