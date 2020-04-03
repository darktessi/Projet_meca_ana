

package type_expression is

   type T_chaine is record
      ch : String(1..10000);
      lg : integer := 0;
   end record;


   type T_cat_expr is (produit, somme, litteral, nombre, puissance, division, cos, sin);
   type T_cat_litt is  (masse, longueur, temps, angle, inertie);
   type T_valeur_lit is array(0..10) of float;
   type T_litteraux is record
      is_constant : boolean;
      deg_deriv_temps : integer := 0;
      symbole : string(1..10);
      symbole_lg : integer;
      cat_lit : T_cat_litt;
      valeur : T_valeur_lit := (0=>1.0,1=>1.0,2=>0.0,others => 0.0); --valeur de la deriver/ temps degre 0 1 2 3 ... EN UNITE S.I

   end record;



   type T_expression;
   type T_expr_int is access T_expression;

   type T_expression(type_expr : T_cat_expr := nombre) is record
      case type_expr is
         when produit =>
            p1 : T_expr_int;
            p2 : T_expr_int;
         when somme =>
            s1 : T_expr_int;
            s2 : T_expr_int;
         when litteral =>
            litt : T_litteraux := (false, 0, (1 => 't',others => ' '), 1, temps, (0=> 1.0,others => 0.0));
         when nombre =>
            valeur : float := 0.0;
         when puissance =>
            expr : T_expr_int;
            exposant : integer := 0;
         when division =>
            d1 : T_expr_int;
            d2 : T_expr_int;
         when cos =>
            Carg : T_expr_int;
         when sin =>
            Sarg : T_expr_int;
         when others => null;

      end case;
   end record;

   function expr_text(expr : in T_expr_int) return T_chaine;
   function text_ch(s : in string) return T_chaine;
   function "="(n1 : in T_expr_int; n2 : in T_expr_int) return boolean;
   function "*"(n1 : in T_expr_int; n2 : in T_expr_int) return T_expr_int;
   function "+"(n1 : in T_expr_int; n2 : in T_expr_int) return T_expr_int;
   function "-"(n1 : in T_expr_int; n2 : in T_expr_int) return T_expr_int;
   function "/"(d1 : in T_expr_int; d2 : in T_expr_int) return T_expr_int;
   procedure put(expr : in T_expr_int);
   procedure put_line(expr: in T_expr_int);
   function "+"(ch1 : in T_chaine; ch2 : in T_chaine) return T_chaine;
   function "="(ch1 : in T_chaine; ch2 : in T_chaine) return Boolean;
end type_expression;
