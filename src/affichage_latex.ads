with type_vecteur;
use type_vecteur;
with type_expression;
use type_expression;


package affichage_latex is


   type T_symbole_litt is (alpha, beta, gamma);
   procedure latex_vecteur (v : in T_vecteur);
   procedure latex_expr(expr : in T_expr_int; c : in out T_chaine);
   function latex_symbole(s : in string) return T_chaine;

end affichage_latex;
