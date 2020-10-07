/* MIT License
#
# Copyright (c) 2020 Ferhat Geçdoğan All Rights Reserved.
# Distributed under the terms of the MIT License.
#
# */

public class PrismEntryCompletion : Gtk.Window {
	private Gtk.ListStore liststore;
	private Gtk.EntryCompletion entrycompletion;
	
    public void EntryCompletion(Gtk.Entry entry) {
        liststore = new Gtk.ListStore(1, typeof(string));

		/* Default items */
        Gtk.TreeIter iter;
        liststore.append(out iter);
        liststore.set(iter, 0, "github.com");
        liststore.append(out iter);
        liststore.set(iter, 0, "stackoverflow.com");
        liststore.append(out iter);
        liststore.set(iter, 0, "facebook.com");
        liststore.append(out iter);
        liststore.set(iter, 0, "discord.com");
		liststore.append(out iter);
        liststore.set(iter, 0, "gitlab.com");
		liststore.append(out iter);
		liststore.set(iter, 0, "gnu.org");
        liststore.append(out iter);
		liststore.set(iter, 0, "kernel.org");
        liststore.append(out iter);
        liststore.set(iter, 0, "duckduckgo.com");
		liststore.append(out iter);
        liststore.set(iter, 0, "discord.com");
		liststore.append(out iter);
        liststore.set(iter, 0, "youtube.com");
		liststore.append(out iter);
        liststore.set(iter, 0, "bitbucket.com");
		liststore.append(out iter);
        liststore.set(iter, 0, "netflix.com");
		liststore.append(out iter);
        liststore.set(iter, 0, "tidal.com");

        entrycompletion = new Gtk.EntryCompletion();
        entrycompletion.set_model(liststore);
        entrycompletion.set_text_column(0);
        entrycompletion.set_popup_completion(true);
        entry.set_completion(entrycompletion);
    }
}
