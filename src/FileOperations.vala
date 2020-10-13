
/* MIT License
#
# Copyright (c) 2020 Ferhat Geçdoğan All Rights Reserved.
# Distributed under the terms of the MIT License.
#
# */

public class FileOperations {
	public string line;
	
    public string GetStringFromFile(string _file, string _str) { 	
		File file = File.new_for_path (_file);

		try {
			FileInputStream @is = file.read ();
			DataInputStream dis = new DataInputStream (@is);
			
			while ((line = dis.read_line ()) != null) {
				if(line.contains(_str) == true) {
					return line;
				}
			}
		} catch (Error e) {
			print ("Error: %s\n", e.message);
		}

		return line;
    }
    
    public void CreateDirectory(string _directory) {
    	File file = File.new_for_path(_directory);
		file.make_directory();
    }
    
    public void CreateFile(string _directory, string _data) {
		File file = File.new_for_path(_directory);
		FileOutputStream os = file.create (FileCreateFlags.PRIVATE);
		os.write (_data.data);	
    } 
    
    public bool IsExist(string _directory) {
    	if (GLib.FileUtils.test(_directory, GLib.FileTest.EXISTS)) {
			return true;
		}
		
		return false;
    }

	public void AddText(string _directory, string data) {
		try {
			FileUtils.set_contents(_directory, data);
		} catch(Error e) {
    	  	stderr.printf ("Error: %s\n", e.message);
		}
	}
}	
