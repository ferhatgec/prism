/* MIT License
#
# Copyright (c) 2020 Ferhat Geçdoğan All Rights Reserved.
# Distributed under the terms of the MIT License.
#
# */

public class PrismEntryCompletion : Gtk.Window {
	private FileOperations operations = new FileOperations();
	private Gtk.ListStore liststore;
	private Gtk.EntryCompletion entrycompletion;
	private string line;
	
	private string default_items = "github.com\nfacebook.com\ndiscord.com\nduckduckgo.com\nyoutube.com\nnetflix.com\ngoogle.com\nreddit.com\n";
	
    public void EntryCompletion(Gtk.Entry entry) {
        liststore = new Gtk.ListStore(1, typeof(string));
	
		/* Default items */
        Gtk.TreeIter iter;
        if(operations.IsExist(GLib.Environment.get_home_dir() + "/.config/prism/history.prism") != true) {
        	operations.CreateFile(GLib.Environment.get_home_dir() + "/.config/prism/history.prism", default_items);
        }
        
        File file = File.new_for_path (GLib.Environment.get_home_dir() + "/.config/prism/history.prism");

		try {
			FileInputStream @is = file.read ();
			DataInputStream dis = new DataInputStream (@is);
			
			while ((line = dis.read_line ()) != null) {
				liststore.append(out iter);
				liststore.set(iter, 0, line); 
			}
		} catch (Error e) {
			print ("Error: %s\n", e.message);
		}
        
        entrycompletion = new Gtk.EntryCompletion();
        entrycompletion.set_model(liststore);
        entrycompletion.set_text_column(0);
        entrycompletion.set_popup_completion(true);
        entry.set_completion(entrycompletion);
    }
    
    public void AddHistoryItem(string history) {
    	print(history + "\n");
    	if(operations.IsExist(GLib.Environment.get_home_dir() + "/.config/prism/history.prism") == true) {
        	operations.AppendText(GLib.Environment.get_home_dir() + "/.config/prism/history.prism", history + "\n");
        	print("Nicely done!");
        } else {
        	operations.CreateFile(GLib.Environment.get_home_dir() + "/.config/prism/history.prism", default_items);
        }
    }
}
