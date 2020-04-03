with type_vecteur;
use type_vecteur;

with type_expression;
use type_expression;

with operation;
use operation;

with ada.Text_IO;
use ada.Text_IO;

with affichage_latex;
use affichage_latex;

procedure test_matrice is
   m : T_matrice;
   alpha :T_litteraux := (false, 0, (1=> 'a', others => ' '), 1, temps, (0=>1.0, 1=>2.0, others => 0.0));
   beta :T_litteraux := (false, 0, (1=> 'b', others => ' '), 1, temps, (0=>1.0, 1=>2.0, others => 0.0));
   gamma :T_litteraux := (false, 0, (1=> 'c', others => ' '), 1, temps, (0=>1.0, 1=>2.0, others => 0.0));
   x : T_litteraux := (false, 0, (1=> 'x', others => ' '), 1, temps, (0=>1.0, 1=>2.0, others => 0.0));
   y : T_litteraux := (false, 0, (1=> 'y', others => ' '), 1, temps, (0=>1.0, 1=>2.0, others => 0.0));
   z : T_litteraux := (false, 0, (1=> 'z', others => ' '), 1, temps, (0=>1.0, 1=>2.0, others => 0.0));
   t : T_litteraux := (false, 0, (1=> 't', others => ' '), 1, temps, (0=> 1.0, others => 0.0));
   vect : T_vecteur;
begin
   alpha.symbole(1..5) := "ALPHA";
   alpha.symbole_lg := 5;

   --put_line(m);
   --put_line(det(m));
   --put_line(inverser(m));
   --put_line(mat_rotation(theta, 2));
   m := rotation_3D(alpha, beta, gamma);
   normaliser(m);
   vect.X := new T_expression'(litteral, x);
   vect.Y := new T_expression'(litteral, y);
   vect.Z := new T_expression'(litteral, z);

   put_line(m*vect);
   vect := m*vect;
   for i in 1..2 loop
      deriver(vect, t);
   end loop;
   latex_vecteur(vect);

end test_matrice;
