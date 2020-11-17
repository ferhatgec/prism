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
    private ToolButton incognito_button;
    private ToolButton secure_button;
    private ToolButton _prism_button; /* As a home button */

    private Gtk.Label label = new Gtk.Label("🔓");
	private HeaderBar headerBar;
	
	private WebContext webContext;
	private CookieManager cookieManager;

	private PrismEntryCompletion _completion;
	private PrismLog _log;
	
	private Gtk.Image incognito_img;
	
	private bool check_public = true;
	
	private string cookie_data = GLib.Environment.get_home_dir();
	
	public static string argument = null;
 
	public Prism() {
    	headerBar = new HeaderBar();
    	url_bar = new Entry();
    	webContext = new WebContext();
        _completion = new PrismEntryCompletion();
		_log = new PrismLog();
		
        headerBar.set_title(Prism.TITLE);
		headerBar.set_subtitle("Browsing for everyone, everytime.");
        headerBar.set_show_close_button(true);
		
        url_bar.set_width_chars(65);
        url_bar.set_icon_from_icon_name(PRIMARY, "system-search-symbolic");
        url_bar.set_icon_from_icon_name(SECONDARY, "edit-clear");
        
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
                
		incognito_img = new Gtk.Image.from_file("/usr/share/pixmaps/prism/private_32.png");
		this.incognito_button = new Gtk.ToolButton(incognito_img, null);
		
		this.secure_button = new Gtk.ToolButton(label, null);
		
		headerBar.pack_start(this._prism_button);
        headerBar.pack_start(this.back_button);
        headerBar.pack_start(this.forward_button);
        headerBar.pack_start(this.reload_button);
        headerBar.pack_start(secure_button);
        
        
        headerBar.pack_end(incognito_button);
        headerBar.pack_end(url_bar);
        
        this.set_titlebar(headerBar);
        //this.url_bar = new Entry();
		
		if(this.check_public == true) {
			_log.Log("Cookies enabled.");
			this.cookie_data = GLib.Environment.get_home_dir() + "/.config/prism/cookies.prism";
    	} else {
    		_log.Log("Cookies closed.");
    		this.cookie_data = null;
    	} 
    	
    	cookieManager = webContext.get_cookie_manager();
    	cookieManager.set_persistent_storage(this.cookie_data, CookiePersistentStorage.TEXT);
    	web_view = new WebView.with_context(webContext);
    	
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
        
        this.url_bar.icon_press.connect((pos, event) => {
      		if (pos == SECONDARY) {
        		url_bar.set_text("");
      		} else if(pos == PRIMARY) {
      			on_activate();
      		}
    	});
    
        this.web_view.load_changed.connect((source, evt) => { 
			if(source.get_uri() == DEFAULT_URL) {
				this.url_bar.text = "home:prism";	
			} else {
				this.url_bar.text = source.get_uri(); 
			}
			
			if(this.url_bar.text == "home:prism") {
				this.label.set_label("🏠");
			} else if(this.url_bar.text.contains("https") == true) {
				this.label.set_label("🔒");
			} else if(this.url_bar.text.contains("http") == true) {
		    	this.label.set_label("🔓"); 		
			} else {
				this.label.set_label("🔓");
			}
			
		    /* TODO: Add title for subtitle */
            //this.title = "%s - %s".printf(this.url_bar.text, Prism.TITLE);
            update_buttons();
        });
        
  		this.incognito_button.clicked.connect(check_incognito);
        this.back_button.clicked.connect(this.web_view.go_back);
        this.forward_button.clicked.connect(this.web_view.go_forward);
        this.reload_button.clicked.connect(this.web_view.reload);
        
        this._prism_button.clicked.connect(prism_button);
    }

	

	private void prism_button() {
		this.web_view.load_uri(DEFAULT_URL);
	}

	private void check_incognito() {
		if(this.check_public == true) {
			incognito_on();
		} else if(this.check_public == false) {
			public_on();
		}
	}

	private void incognito_on() {
		_log.Log("Private mode enabled.");
		this.cookie_data = null;
		this.web_view.load_uri(DEFAULT_URL);
		this.incognito_img.set_from_file("/usr/share/pixmaps/prism/public_32.png");
		this.incognito_button.set_icon_widget(incognito_img);
		this.check_public = false;
		
		this.cookieManager.set_persistent_storage("", CookiePersistentStorage.TEXT);
	}

	private void public_on() {
		_log.Log("Public mode enabled.");
		this.cookie_data = GLib.Environment.get_home_dir() + "/.config/prism/cookies.prism";
		this.web_view.load_uri(DEFAULT_URL);
		this.incognito_img.set_from_file("/usr/share/pixmaps/prism/private_32.png");
		this.incognito_button.set_icon_widget(incognito_img);
		this.check_public = true;
		
		this.cookieManager.set_persistent_storage(cookie_data, CookiePersistentStorage.TEXT);
	}

    private void update_buttons() {
        this.back_button.sensitive = this.web_view.can_go_back();
        this.forward_button.sensitive = this.web_view.can_go_forward();
    }

	private string parse_url(owned string _url) {
		if(check_public == true) {
			_completion.AddHistoryItem(_url); 
		}
		
		if(_url == DEFAULT_URL) {
			this.url_bar.text = "home:prism";
			_url = this.url_bar.text;
		}
		
		if(_url.contains("home:prism") == true) {
			_url = DEFAULT_URL;
		} else {
        	if (!this.protocol_regex.match(_url)) {
				if(DEFAULT_URL.contains("google") == true) {
					_url = DEFAULT_URL + "/search?q=" + _url; 
				} else if(DEFAULT_URL.contains("duckduckgo") == true) {
					_url = DEFAULT_URL + "/" + _url;
				} else {
					_url = DEFAULT_PROTOCOL + "://" + _url;			
				}
			}
    	}

		return _url;
	}

    private void on_activate() {
        web_view.insecure_content_detected(DISPLAYED); 
        var url = this.url_bar.text;

		this.web_view.load_uri(parse_url(url));
    }

    public void start() {
        show_all();
		
		if(argument != null) {
			this.web_view.load_uri(parse_url(argument));
			this.url_bar.text = argument;
		} else {
        	this.web_view.load_uri(DEFAULT_URL);
        	this.url_bar.text = "home:prism";
		}    
	}

    public static int main(string[] args) {
        Gtk.init(ref args);

		if(args[1] != null) { argument = args[1]; }

        var browser = new Prism();
        browser.start();

        Gtk.main();

        return 0;
    }
}
