with type_expression;
use type_expression;

package plot_save is
   
   type T_ptr_fct is access function(n : float) return float;
   type T_tab_var is array(1..100) of T_litteraux;
   type T_tab_fct is array(1..100, 10) of T_ptr_fct;
   
   type T_modif_var is record
      var : T_tab_var;
      fct : T_tab_fct;
      nb_var : interger := 0;
   end record;
   
   type T_tab_res if array <> of float;
   
   procedure pre_eval(modif_var : in out T_modif_var; t : in float);
   function plot(e : in T_expr_int; t : in float; n : in integer) return T_tab_res;
   procedure save_plot(t: in T_tab_res; fichier : string);

end plot_save;
