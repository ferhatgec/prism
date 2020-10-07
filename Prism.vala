/* MIT License
#
# Copyright (c) 2020 Ferhat Geçdoğan All Rights Reserved.
# Distributed under the terms of the MIT License.
#
# */

/* Use Gtk and Webkit namespaces */
using Gtk;
using WebKit;

public class Prism : Window {
	/* Set Window title */
    private const string TITLE = "Fegeya Prism";
    
    /* Default URL */
    private const string DEFAULT_URL = "file:///usr/share/pixmaps/prism/homepage/index.html";
    
    /* Default protocol */
    private const string DEFAULT_PROTOCOL = "http";

    private Regex protocol_regex;

	/* GUIs */
    private Entry url_bar;
    private WebView web_view;
    //private Label status_bar;
    private ToolButton back_button;
    private ToolButton forward_button;
    private ToolButton reload_button;
    private ToolButton _prism_button; /* As a home button */

    private Gtk.Label label = new Gtk.Label("🔓");
	private HeaderBar headerBar;
	
	private WebContext webContext;
	private CookieManager cookieManager;

	private PrismEntryCompletion _completion;
	
	public Prism() {
    	headerBar = new HeaderBar();
    	url_bar = new Entry();
    	webContext = new WebContext();
        _completion = new PrismEntryCompletion();
    	
    	cookieManager = webContext.get_cookie_manager();
    	cookieManager.set_persistent_storage(GLib.Environment.get_home_dir() + "/.config/prism/cookies.prism", CookiePersistentStorage.TEXT);
    	web_view = new WebView.with_context(webContext);
    	
        headerBar.set_title (Prism.TITLE);
		headerBar.set_subtitle ("Browsing for everyone, everytime.");
        headerBar.set_show_close_button (true);
		
        url_bar.set_width_chars(65);
        url_bar.set_icon_from_icon_name(PRIMARY, "system-search-symbolic");
        set_default_size(800, 600);
        
    	_completion.EntryCompletion(url_bar);
        
        try {
            this.protocol_regex = new Regex(".*://.*");
        } catch (RegexError e) {
            critical("%s", e.message);
        }
		
        create_widgets();
        connect_signals();
        
		
        this.url_bar.grab_focus();
    }

    private void create_widgets() {
        Gtk.Image img = new Gtk.Image.from_file("/usr/share/pixmaps/prism/prism_32.png");
		this._prism_button = new Gtk.ToolButton(img, null);
        
        img = new Gtk.Image.from_file("/usr/share/pixmaps/prism/white_arrow_left.png");
		this.back_button = new Gtk.ToolButton(img, null);
                  
        img = new Gtk.Image.from_file("/usr/share/pixmaps/prism/white_arrow_right.png");
		this.forward_button = new Gtk.ToolButton(img, null);
                  
        img = new Gtk.Image.from_file("/usr/share/pixmaps/prism/white_refresh.png");
		this.reload_button = new Gtk.ToolButton(img, null);
                
                  
		headerBar.pack_start(this._prism_button);
        headerBar.pack_start(this.back_button);
        headerBar.pack_start(this.forward_button);
        headerBar.pack_start(this.reload_button);
        headerBar.pack_start(label);
        
        
        headerBar.pack_end(url_bar);
        
        this.set_titlebar(headerBar);
        //this.url_bar = new Entry();
        
        var scrolled_window = new ScrolledWindow(null, null);
        
        scrolled_window.set_policy(PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scrolled_window.add(this.web_view);
        
        //this.status_bar = new Label("Prism.");
        //this.status_bar.xalign = 0;
		
        var box = new Box(Gtk.Orientation.VERTICAL, 0);
        //box.pack_start(toolbar, false, true, 0);
        box.pack_start(scrolled_window, true, true, 0);
        //box.pack_start(this.status_bar, false, true, 0);
        add(box);
    }

    private void connect_signals() {
        this.destroy.connect(Gtk.main_quit);
        this.url_bar.activate.connect(on_activate);
        this.web_view.load_changed.connect((source, evt) => {
            this.url_bar.text = source.get_uri();
            /* TODO: Add title for subtitle */
            //this.title = "%s - %s".printf(this.url_bar.text, Prism.TITLE);
            update_buttons();
        });
        
  
        this.back_button.clicked.connect(this.web_view.go_back);
        this.forward_button.clicked.connect(this.web_view.go_forward);
        this.reload_button.clicked.connect(this.web_view.reload);
        
        this._prism_button.clicked.connect(prism_button);
    }

	private void prism_button() {
		this.web_view.load_uri(DEFAULT_URL);
	}

    private void update_buttons() {
        this.back_button.sensitive = this.web_view.can_go_back();
        this.forward_button.sensitive = this.web_view.can_go_forward();
    }

    private void on_activate() {
        web_view.insecure_content_detected(DISPLAYED); 
        var url = this.url_bar.text;
		
        if (!this.protocol_regex.match(url)) {
			if(DEFAULT_URL.contains("google") == true) {
				url = DEFAULT_URL + "/search?q=" + url; 
			} else if(DEFAULT_URL.contains("duckduckgo") == true) {
				url = DEFAULT_URL + "/" + url;
			} else {
				url = DEFAULT_PROTOCOL + "://" + url;			
			}
		}
		

		if(url.contains("https") == true) {
			this.label.set_label("🔒");
		} else if(url.contains("http") == true) {
		    this.label.set_label("🔓"); 		
		} else {
			this.label.set_label("🔓");
		}
		
        this.web_view.load_uri(url);
    }

    public void start() {
        show_all();
        this.web_view.load_uri(DEFAULT_URL);
    }

    public static int main(string[] args) {
        Gtk.init(ref args);

        var browser = new Prism();
        browser.start();

        Gtk.main();

        return 0;
    }
}
