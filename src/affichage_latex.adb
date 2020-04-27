with type_vecteur;
use type_vecteur;

with ada.Float_Text_IO;
use ada.Float_Text_IO;
with ada.Text_IO;
use ada.Text_IO;
with ada.Integer_Text_IO;
use ada.Integer_Text_IO;

with operation;
use operation;

with Ada.Strings.Maps.Constants; use Ada.Strings.Maps.Constants;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body affichage_latex is

   procedure latex_vecteur (v : in T_vecteur) is
      c : T_chaine;
   begin
      put_line("$$");
      Put_Line("\begin{pmatrix}");
      --X
      latex_expr(v.X, c);
      put(c);
      c := text_ch("");
      New_Line;
      put_line("\\[3mm]");
      --Y
      latex_expr(v.Y, c);
      put(c);
      c:=text_ch("");      
      put_line("\\[3mm]");
      --Z
      latex_expr(v.Z, c);
      put(c);
      c := text_ch("");
      put_line("\end{pmatrix}");
      put_line("$$");
      
   end;
   
   procedure latex_expr(expr : in T_expr_int; c : in out T_chaine)  is
   begin
      if c.nb_carac_ligne >= c.nb_limite then
         c := c+text_ch("\\");
         c.nb_carac_ligne :=0;
      end if;
      
            case expr.type_expr is
         when produit =>
            if expr.p1.type_expr /= somme and expr.p1.type_expr /= soustraction then
               latex_expr(expr.p1, c);
               c := c+ text_ch("\cdot ");
            else
               c := c+ text_ch("(");
               latex_expr(expr.p1, c);
               c := c+ text_ch(")\cdot ");
            end if;
            if expr.p2.type_expr /= somme and expr.p2.type_expr /= soustraction then
               latex_expr(expr.p2, c);
            else
               c := c+ text_ch("(");
               latex_expr(expr.p2, c);
               c := c+ text_ch(")");
            end if;
         when somme =>
            latex_expr(expr.s1, c);
            c := c+ text_ch(" + ");
            latex_expr(expr.s2, c);

         when litteral =>
            if expr.litt.deg_deriv_temps = 1 then
               c := c+ text_ch("\dot ");
            end if;
            if expr.litt.deg_deriv_temps = 2 then
               c := c+ text_ch("\ddot ");
            end if;            
            c := c+ latex_symbole(expr.litt.symbole(1..expr.litt.symbole_lg));

         when nombre =>
            if expr.valeur = -1.0 then
               c := c+ text_ch("-1");
               else 
               c := c+ text_ch(Float'image(expr.valeur));
            end if;
         when soustraction =>
            if expr.sm1 /= nb_expr(0.0) then
               latex_expr(expr.sm1, c);
            end if;
            if expr.sm2.type_expr = litteral or expr.sm2.type_expr = sin or expr.sm2.type_expr = cos or expr.sm2.type_expr = produit or expr.sm2.type_expr = puissance or expr.sm2.type_expr = nombre then
               c := c+ text_ch(" - ");
               latex_expr(expr.sm2, c);
               else 
               c := c+ text_ch(" - (");
               latex_expr(expr.sm2, c);
               c := c+text_ch(")");
            end if;
            
            
         when puissance =>
            if expr.expr.type_expr = litteral or expr.expr.type_expr = nombre or expr.expr.type_expr = sin or expr.expr.type_expr = cos then
               latex_expr(expr.expr, c);
               c := c+ text_ch("^");
               c := c+ text_ch(integer'image(expr.exposant));
            else

               c := c+ text_ch("(");
               latex_expr(expr.expr, c);
               c := c+ text_ch(")^{");
               c := c+ text_ch(integer'image(expr.exposant));
               c := c+ text_ch("}");
            end if;


         when division =>
            c := c+ text_ch("\frac{");
            latex_expr(expr.d1, c);
            c := c+ text_ch("}{");
            latex_expr(expr.d2, c);
            c := c+ text_ch("}");

         when cos =>
            c := c+ text_ch("\cos(");
            latex_expr(expr.Carg, c);
            c := c+ text_ch(")");
         when sin =>
            c := c+ text_ch("\sin(");
            latex_expr(expr.Sarg, c);
            c := c+ text_ch(")");
         when others =>
            null;
      end case;

   end latex_expr;
   
   function latex_symbole(s : in string) return T_chaine is
      c : T_chaine;
   begin
      c := text_ch("\");
      for i in T_symbole_litt'range loop
         --put_line(s);
         --put_line(T_symbole_litt'image(i));
         if s'Length = T_symbole_litt'image(i)'Length and T_symbole_litt'image(i) = s then
            return c + text_ch(Translate (s (s'First .. s'Last), Lower_Case_Map));
         end if;
      end loop;
      return text_ch(s);
   end latex_symbole;
   
   
      
   
end affichage_latex;
