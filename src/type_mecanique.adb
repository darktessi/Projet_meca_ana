with type_vecteur;
use type_vecteur;

with type_expression;
use type_expression;



package body type_mecanique is


   function "+"(t1 : in T_torseur; t2 : in T_torseur) return T_torseur is
   temp :T_torseur := t1;
   begin
      temp.resultante := t1.resultante + t2.resultante;
      temp.moment := t1.moment + t2.moment;
      if temp.genre = action then
         temp.nom_action(1..3) := "SOM";
         temp.n_a_lg := 3;
      end if;
      return temp;

   end "+";


   function "*"(t1 : in T_torseur; t2 : in T_torseur) return T_expr_int is
      temp :T_expr_int;
   begin
      temp := (t1.resultante * t2.moment) + (t1.moment * t2.resultante);

      return temp;

   end "*";

   function mat_passage(ref :  in T_referentiel) return T_matrice is
     mtot : T_matrice := identity;
     ref_actual : T_referentiel := ref;

   begin
      while ref_actual.dependance <> initial loop
         mtot = mtot*ref_actual.matrice_passage;
         ref_actual := ref_actual.dependance;
      end loop;
      mat_passage := mat_passage*ref_actual.matrice_passage;
      return mat_passage;
   end;

   function chgt_base(ref1 :in T_referentiel; ref2 : in T_referentiel; v : in T_vecteur) return T_vecteur is
      v_primaire :T_vecteur;
      mtot1 : T_matrice := mat_passage(ref1);
      mtot2 : T_matrice := mat_passage(ref2);
   begin
      v_primaire := inverser(mtot1)*v;
      return mtot2*v_primaire;
   end chgt_base;


   procedure deplacer(T1 : in out T_torseur; point_cible : in T_point) is
   begin
      T1.moment := T1.moment + (point_cible.coordonnees-T1.point.coordonnees)*T1.resultante;
      T1.point := point_cible;
   end;

   function calcul_energie_cinetique(solide : in T_solide) return T_expr_int is
      cinema : T_torseur := solide.cinematique;
   begin
      if cinema.point <> solide.cinetique.point then
         deplacer(cinema, solide.cinetique.point);
      end if;

      return nb_expr(0.5)*(solide.cinetique *cinema);
   end;




end type_mecanique;
