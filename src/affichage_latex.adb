with type_vecteur;
use type_vecteur;

with ada.Float_Text_IO;
use ada.Float_Text_IO;
with ada.Text_IO;
use ada.Text_IO;
with ada.Integer_Text_IO;
use ada.Integer_Text_IO;


package body affichage_latex is

   procedure latex_vecteur (v : in T_vecteur) is
   begin
      put_line("$$");
      put_line("\begin{pmatrix}");
      --X
      put(latex_expr(v.X));
      
      Put_Line("\\[3mm]");
      --Y
      put(latex_expr(v.Y));
      
      Put_Line("\\[3mm]");
      --Z
      put(latex_expr(v.Z));
      
      put_line("\\");
      put_line("\end{pmatrix}");
      put_line("$$");
      
   end;
   
   function latex_expr(expr : in T_expr_int) return T_chaine is
       c : T_chaine := text_ch("");
   begin
            case expr.type_expr is
         when produit =>
            if expr.p1.type_expr /= somme then
               c := c+ latex_expr(expr.p1);
               c := c+ text_ch("\cdot ");
            else
               c := c+ text_ch("(");
               c := c+ latex_expr(expr.p1);
               c := c+ text_ch(")\cdot ");
            end if;
            if expr.p2.type_expr /= somme then
               c := c+ latex_expr(expr.p2);
            else
               c := c+ text_ch("(");
               c := c+ latex_expr(expr.p2);
               c := c+ text_ch(")");
            end if;
         when somme =>

            c := c+ latex_expr(expr.s1);
            c := c+ text_ch(" + ");
            c := c+ latex_expr(expr.s2);

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
               c := c+ text_ch("(-1)");
               else 
               c := c+ text_ch(Float'image(expr.valeur));
            end if;
            
         when puissance =>
            if expr.expr.type_expr = litteral or expr.expr.type_expr = nombre or expr.expr.type_expr = sin or expr.expr.type_expr = cos then
               c := c+ latex_expr(expr.expr);
               c := c+ text_ch("^");
               c := c+ text_ch(integer'image(expr.exposant));
            else

               c := c+ text_ch("(");
               c := c+ latex_expr(expr.expr);
               c := c+ text_ch(")^{");
               c := c+ text_ch(integer'image(expr.exposant));
               c := c+ text_ch("}");
            end if;


         when division =>
            c := c+ text_ch("\frac{");
            c := c+ latex_expr(expr.d1);
            c := c+ text_ch("}{");
            c := c+ latex_expr(expr.d2);
            c := c+ text_ch("}");

         when cos =>
            c := c+ text_ch("\cos(");
            c := c+ latex_expr(expr.Carg);
            c := c+ text_ch(")");
         when sin =>
            c := c+ text_ch("\sin(");
            c := c+ latex_expr(expr.Sarg);
            c := c+ text_ch(")");
         when others =>
            null;
      end case;
      return c;

   end latex_expr;
   
   function latex_symbole(s : in string) return T_chaine is
      c : T_chaine;
   begin
      c := text_ch("\");
      for i in T_symbole_litt'range loop
         --put_line(s);
         --put_line(T_symbole_litt'image(i));
         if s'Length = T_symbole_litt'image(i)'Length and T_symbole_litt'image(i) = s then
            return c + text_ch(s);
         end if;
      end loop;
      return text_ch(s);
   end latex_symbole;
   
   
      
   
end affichage_latex;
