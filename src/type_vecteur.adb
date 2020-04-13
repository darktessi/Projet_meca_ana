with type_expression;
use type_expression;
with ada.Text_IO;
use ada.Text_IO;
with operation;
use operation;

package body type_vecteur is

   function "*"(v1 : in T_vecteur; v2 : in T_vecteur) return T_expr_int is
   begin
      --il faut s'assurer que les deux vecteurs soient ecris dans la meme base
      return normaliser((v1.X * v2.X) + (v1.Y * v2.Y) + (v1.Z * v2.Z));
   end "*";
   function "*"(v1 : in T_vecteur; v2 : in T_vecteur) return T_vecteur is
      temp : T_vecteur;
   begin
      --il faut s'assurer que les deux vecteurs soient ecris dans la meme base
      temp.X := normaliser((v1.Y * v2.Z) - (v1.Z * v2.Y));
      temp.Y := normaliser((v1.Z * v2.X) - (v1.X * v2.Z));
      temp.Z := normaliser((v1.X * v2.Y) - (v1.Y * v2.X));
      return temp;
   end "*";

   function "+"(v1 : in T_vecteur; v2 : in T_vecteur) return T_vecteur is
      temp : T_vecteur;

   begin
      temp.X := normaliser(v1.X + v2.X);
      temp.Y := normaliser(v1.Y + v2.Y);
      temp.Z := normaliser(v1.Z + v2.Z);
      return temp;

   end "+";

   function "*"(e : in T_expr_int; v2 : in T_vecteur) return T_vecteur is
      temp : T_vecteur;
   begin
      temp.X := normaliser(e * v2.X);
      temp.Y := normaliser(e * v2.Y);
      temp.Z := normaliser(e * v2.Z);

      return temp;
   end "*";

   function "-"(v1 : in T_vecteur; v2 : in T_vecteur) return T_vecteur is

   begin
      return v1 + (nb_expr(-1.0) * v2);
   end "-";

   function "+"(m1 : in T_matrice; m2 :in T_matrice) return T_matrice is  -- somme matrice matrice
      m : T_matrice;
   begin
      for i in 1..3 loop
         for j in 1..3 loop
            m(i)(j) :=  m1(i)(j) + m2(i)(j);
         end loop;
      end loop;
   return m;
   end "+";


   function "*"(m1 : in T_matrice; m2 : in T_matrice) return T_matrice is -- produit matriciel
      m : T_matrice;
      s : T_expr_int;
   begin
      for i in 1..3 loop
         for j in 1..3 loop
            s := nb_expr(0.0);
            for k in 1..3 loop
               s := s + m1(i)(k)*m2(k)(j);
            end loop;
            m(i)(j) := s;
         end loop;
      end loop;
      return m;
   end "*";

   function "*"(e : in T_expr_int; m1 : in T_matrice) return T_matrice is -- produit externe
      m : T_matrice;
   begin
      for i in 1..3 loop
         for j in 1..3 loop
            m(i)(j) := e * m1(i)(j);
         end loop;
      end loop;
      return m;
   end "*";

   function "-"(m1 : in T_matrice; m2 : in T_matrice) return T_matrice is -- soustraction matrice
   begin
      return m1+nb_expr(-1.0)*m2;
   end "-";

   function "*"(m1 : in T_matrice; v1 : in T_vecteur) return T_vecteur is -- produit matrice vecteur
      v : T_vecteur;
      s : T_expr_int := nb_expr(0.0);
   begin
      v.X := m1(1)(1)*v1.X + m1(1)(2)*v1.Y + m1(1)(3)*v1.Z;
      v.Y := m1(2)(1)*v1.X + m1(2)(2)*v1.Y + m1(2)(3)*v1.Z;
      v.Z := m1(3)(1)*v1.X + m1(3)(2)*v1.Y + m1(3)(3)*v1.Z;
      return v;

   end "*";
  function inverser(m : in T_matrice) return T_matrice is
      mr : T_matrice;
      mt : T_matrice; --transposée
      d : T_expr_int := det(m);

   begin
      mt(1)(1) := m(2)(2)*m(3)(3)-m(3)(2)*m(2)(3);
      mt(1)(2) := m(3)(1)*m(2)(3)-m(2)(1)*m(3)(3);
      mt(1)(3) := m(2)(1)*m(3)(2)-m(3)(1)*m(2)(2);
      mt(2)(1) := m(3)(2)*m(1)(3)-m(1)(2)*m(3)(3);
      mt(2)(2) := m(1)(1)*m(3)(3)-m(3)(1)*m(1)(3);
      mt(2)(3) := m(3)(1)*m(1)(2)-m(1)(1)*m(3)(2);
      mt(3)(1) := m(1)(2)*m(2)(3)-m(2)(2)*m(1)(3);
      mt(3)(2) := m(2)(1)*m(1)(3)-m(1)(1)*m(2)(3);
      mt(3)(3) := m(1)(1)*m(2)(2)-m(2)(1)*m(1)(2);

      mr(1)(1) := mt(1)(1)/d;
      mr(2)(2) := mt(2)(2)/d;
      mr(3)(3) := mt(3)(3)/d;
      mr(1)(2) := mt(2)(1)/d;
      mr(1)(3) := mt(3)(1)/d;
      mr(2)(1) := mt(1)(2)/d;
      mr(2)(3) := mt(3)(2)/d;
      mr(3)(1) := mt(1)(3)/d;
      mr(3)(2) := mt(2)(3)/d;


      return mr;

   end inverser;

   function det(m : in T_matrice) return T_expr_int is
      determinant : T_expr_int := nb_expr(0.0);
   begin
      determinant := m(1)(1)*(m(2)(2)*m(3)(3)-m(3)(2)*m(2)(3))-m(1)(2)*(m(2)(1)*m(3)(3)-m(3)(1)*m(2)(3))+m(1)(3)*(m(2)(1)*m(3)(2)-m(3)(1)*m(2)(2));
      return determinant;
   end det;


   procedure put(v : in T_vecteur) is
   begin
      put("X:");
      put(v.X);
      New_Line;
      put("Y:");
      put(v.Y);
      New_Line;
      put("Z:");
      put(v.Z);
   end put;

   procedure put_line(v : in T_vecteur) is
   begin
      put(v);
      New_Line;
   end;

   procedure put_line(m : in T_matrice) is
   begin
      put(m);
      New_Line;
   end;

   procedure put(m : in T_matrice) is
   begin
      put("(");
      for i in 1..3 loop
         put("(");
         for j in 1..3 loop
            put(m(i)(j));
            if j < 3 then
               put("   ,    ");
            end if;

         end loop;
         put_line(")");
      end loop;
      put(")");
   end put;

   function mat_rotation(angle : in T_litteraux; axe : integer) return T_matrice is
      m : T_matrice;
   begin
      if (axe =1) then
         m(1)(1) := nb_expr(1.0);
         m(1)(2) := nb_expr(0.0);
         m(1)(3) := nb_expr(0.0);
         m(2)(1) := nb_expr(0.0);
         m(3)(1) := nb_expr(0.0);
         m(2)(2) := new T_expression'(cos, False,new T_expression'(litteral, False,angle));
         m(2)(3) := new T_expression'(sin, True,new T_expression'(litteral, False,angle));
         m(3)(2) := new T_expression'(sin, False,new T_expression'(litteral, False,angle));
         m(3)(3) := new T_expression'(cos, False,new T_expression'(litteral, False,angle));
      end if;
      if (axe=2) then
         m(2)(2) := nb_expr(1.0);
         m(1)(2) := nb_expr(0.0);
         m(2)(3) := nb_expr(0.0);
         m(2)(1) := nb_expr(0.0);
         m(3)(2) := nb_expr(0.0);
         m(1)(1) := new T_expression'(cos, False,new T_expression'(litteral, False,angle));
         m(1)(3) := new T_expression'(sin, True ,new T_expression'(litteral, False,angle));
         m(3)(1) := new T_expression'(sin, False,new T_expression'(litteral, False,angle));
         m(3)(3) := new T_expression'(cos, False,new T_expression'(litteral, False,angle));
      end if;
      if (axe=3) then
         m(3)(3) := nb_expr(1.0);
         m(1)(3) := nb_expr(0.0);
         m(2)(3) := nb_expr(0.0);
         m(3)(1) := nb_expr(0.0);
         m(3)(2) := nb_expr(0.0);
         m(1)(1) := new T_expression'(cos, False,new T_expression'(litteral, False,angle));
         m(1)(2) := new T_expression'(sin, True,new T_expression'(litteral, False,angle));
         m(2)(1) := new T_expression'(sin, False,new T_expression'(litteral, False,angle));
         m(2)(2) := new T_expression'(cos, False,new T_expression'(litteral, False,angle));
      end if;
      return m;
   end mat_rotation;

   function rotation_3D(roulis : in T_litteraux; lacet: in T_litteraux; tanguage :in T_litteraux) return T_matrice is
      m1 : T_matrice := mat_rotation(roulis, 1);
      m2 : T_matrice := mat_rotation(lacet, 2);
      m3 : T_matrice := mat_rotation(tanguage, 3);
   begin
      return m3*m2*m1;
   end rotation_3D;

   procedure normaliser(m : in out T_matrice) is
   begin
      for i in 1..3 loop
         for j in 1..3 loop
            hard_normaliser(m(i)(j));
         end loop;
      end loop;
   end;

   procedure normaliser(v : in out T_vecteur) is
   begin
      hard_normaliser(v.X);
      hard_normaliser(v.Y);
      hard_normaliser(v.Z);
   end;


   procedure deriver(v : in out T_vecteur; param : in T_litteraux) is
   begin
      deriver(v.X, param);
      deriver(v.Y, param);
      deriver(v.Z, param);
      normaliser(v);
   end;

   procedure deriver(m : in out T_matrice; param : in T_litteraux) is
   begin
      for i in 1..3 loop
         for j in 1..3 loop
            deriver(m(i)(j), param);
         end loop;
      end loop;
      normaliser(m);
   end;








end type_vecteur;
