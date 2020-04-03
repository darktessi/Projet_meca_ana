with type_vecteur;
use type_vecteur;

with type_expression;
use type_expression;


package type_mecanique is

    type T_point is record
      coordonnees : T_vecteur;
      nom : string(1..10);
      nom_lg : integer := 1;
   end record;

   type T_solide is record
      masse : T_litteraux;
      nom : string(1..10);
      nom_lg : integer;
      mat_intertie : T_matrice; -- dans le repère du solide
      centre_inertie : T_point;
      dynamique : T_torseur;
      cinetique : T_torseur;
      cinematique : T_torseur;
      liste_action : T_liste_action;



   end record;

   type T_cat_torseur is (dynamique, cinetique, cinematique, action);
   type T_cat_referentiel is  (galileen, en_translation, en_rotation);

   type T_referentiel_r;
   type T_referentiel is access T_referentiel_r;
   type T_referentiel_r(cat : T_cat_referentiel) is record
      case cat is
         when galileen =>
            null;
         when others =>
            dependance : T_referentiel;
            rotation : T_vecteur;
            translation : T_vecteur;
            matrice_passage : T_matrice; --pour passer du descendant à l'actuel
      end case;
   end record;

   initial : constant T_referentiel := new T_referentiel_r'(cat =>galileen);



   type T_torseur(genre : T_cat_torseur) is record
      referentiel : T_referentiel;
      resultante : T_vecteur;
      moment : T_vecteur;
      point : T_point;
      solide : T_solide;
      case genre is
         when action =>
         nom_action : string(1..100);
         n_a_lg : integer := 0;
         when others => null;
      end case;
   end record;


   type T_tab_action is array(1..100) of T_torseur(action);
   type T_liste_action is record
      tab_action : T_tab_action;
      nb : integer := 0;
   end record;




   --dans un meme referentiel, un meme solide et un meme point, un meme genre :

   function "+"(t1 : in T_torseur; t2 : in T_torseur) return T_torseur;
   function "*" (t1 : in T_torseur; t2 : in T_torseur) return T_expr_int;

   function chgt_base(ref1 :in T_referentiel; ref2 : in T_referentiel; v : in T_vecteur) return T_vecteur; --v est décrit dans le premier referentie
   function mat_passage(ref :  in T_referentiel) return T_matrice; --renvoie la matrice de passage du referentiel initiale au referentiel ref.

   procedure deplacer(T1 : in out T_torseur; point_cible : in T_point); --le point d'arriver doit etre dans le même solide que le torseur de départ
   function calcul_energie_cinetique(solide : in T_solide) return T_expr_int;



end type_mecanique;
