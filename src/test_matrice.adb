with type_vecteur;
use type_vecteur;

with type_expression;
use type_expression;

with operation;
use operation;

with ada.Text_IO;
use ada.Text_IO;


procedure test_matrice is
   m : T_matrice;
   theta : T_litteraux;
   alpha :T_litteraux := (false, 0, (1=> 'a', others => ' '), 1, angle, (0=>1.0, 1=>2.0, others => 0.0));
   beta :T_litteraux := (false, 0, (1=> 'b', others => ' '), 1, angle, (0=>1.0, 1=>2.0, others => 0.0));
   gamma :T_litteraux := (false, 0, (1=> 'c', others => ' '), 1, angle, (0=>1.0, 1=>2.0, others => 0.0));
   e1 : T_expr_int :=new T_expression'(cos, new T_expression'(litteral, alpha));
   e2 : T_expr_int :=new T_expression'(cos, new T_expression'(litteral, alpha));

begin
   theta.symbole(1..5) := "theta";
   theta.symbole_lg := 5;
   m := identity;
   for i in 1..3 loop
      for j in 1..3 loop
         m(i)(j) := nb_expr(Float(i+j));
      end loop;
   end loop;
   m(1)(1) := nb_expr(3.14);

   put_line(m);
   put_line(det(m));
   put_line(inverser(m));
   put_line(mat_rotation(theta, 2));
   put_line(rotation_3D(alpha, beta, gamma));

   put_line(Boolean'image(e1=e2));
end test_matrice;
