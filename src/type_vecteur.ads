
with type_expression;
use type_expression;
with operation; use operation;


package type_vecteur is
   type T_vecteur is record
      X : T_expr_int:= nb_expr(0.0);
      Y : T_expr_int:= nb_expr(0.0);
      Z : T_expr_int:= nb_expr(0.0);
   end record;

   type T_matrice_ligne is array(1..3) of T_expr_int;
   type T_matrice is array(1..3) of T_matrice_ligne;
   identity : Constant T_matrice := ((nb_expr(1.0),nb_expr(0.0),nb_expr(0.0)),(nb_expr(0.0),nb_expr(1.0),nb_expr(0.0)),(nb_expr(0.0),nb_expr(0.0),nb_expr(1.0)));

   function "*"(v1 : in T_vecteur; v2 : in T_vecteur) return T_expr_int;-- produit scalaire
   function "*"(v1 : in T_vecteur; v2 : in T_vecteur) return T_vecteur; -- produit vectoriel
   function "+"(v1 : in T_vecteur; v2 : in T_vecteur) return T_vecteur;
   function "*"(e : in T_expr_int; v2 : in T_vecteur) return T_vecteur; -- produit externe
   function "-"(v1 : in T_vecteur; v2 : in T_vecteur) return T_vecteur;
   procedure put(v : in T_vecteur);
   procedure put_line(v : in T_vecteur);


   function "+"(m1 : in T_matrice; m2 :in T_matrice) return T_matrice;  -- somme matrice matrice
   function "*"(m1 : in T_matrice; m2 : in T_matrice) return T_matrice; -- produit matriciel
   function "*"(e : in T_expr_int; m1 : in T_matrice) return T_matrice; -- produit externe
   function "-"(m1 : in T_matrice; m2 : in T_matrice) return T_matrice; -- soustraction matrice
   function "*"(m1 : in T_matrice; v1 : in T_vecteur) return T_vecteur; -- produit matrice vecteur
   procedure put(m : in T_matrice);
   function inverser(m : in T_matrice) return T_matrice; -- on suppose que la matrice est inversible !!!!
   function det(m : in T_matrice) return T_expr_int;
   procedure put_line(m : in T_matrice);

   function mat_rotation(angle : in T_litteraux; axe : integer) return T_matrice;
   function rotation_3D(roulis : in T_litteraux; lacet : in T_litteraux; tanguage : in T_litteraux) return T_matrice;
   procedure normaliser(m : in out T_matrice);
   procedure normaliser(v : in out T_vecteur);

end type_vecteur;
