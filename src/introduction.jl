
using Gtk
using GtkBuilderAid

export start_intro

@GtkBuilderAid function_name(build_intro) begin

@guarded function language_toggled(cell, path_ptr, built)
  store = GAccessor.object(built, "programming_languages")
  path_str = pointer_to_string(path_ptr)
  iter = Gtk.iter_from_string_index(store, path_str)
  store[iter, 2] = Cint(!store[iter, 2])
  nothing
end

@guarded function submit(widget, built)
  store = GAccessor.object(built, "programming_languages")
  known_languages = []
  println("Chosen color:")
  color_iter = Ref(GtkTreeIter())
  if ccall(
      (:gtk_combo_box_get_active_iter, Gtk.libgtk), 
      Cint, 
      (Ptr{GObject}, Ptr{GtkTreeIter}), 
      GAccessor.object(built, "color_selection"),
      color_iter) != 0
    color_store = GAccessor.object(built, "colors")
    println(GtkTreeModel(color_store)[color_iter[], 1])
  else
    println("No color chosen")
  end
  
  model = GtkTreeModel(store)
  iter = Gtk.mutable(GtkTreeIter)
  println("I know:")
  if Gtk.get_iter_first(model, iter)
    last = true
    while last
      if store[iter, 2]
        push!(known_languages, store[iter, 1])
      end
      last = next(model, iter)
    end
  end
  println(known_languages)
  destroy(GAccessor.object(built, "main_window"))
  nothing
end

end

@guarded function activate_cb(app_ptr, udata)
  
  app = GObject(app_ptr)
  built = @GtkBuilder(filename=joinpath(Pkg.dir("HackRvaJulia"), "resources", "introduction.glade"))
  
  build_intro(built, built)
  
  win = GAccessor.object(built, "main_window")
  push!(app, win)
  showall(win)
  
  nothing
end

"""
Starts a GTK+ GUI for introducing people to the power of julia. This 
demonstrates that even complicated GUI applications are possible rather
easily. It doesn't even take that many lines of code either.
"""
function start_intro()
  println("Preventing a GTK related Heisenbug by Printing!")
  app = @GtkApplication("com.matt5sean3.juliademo.introduction", 0)
  signal_connect(activate_cb, app, "activate", Void, (), false, ())
  run(app)
end

