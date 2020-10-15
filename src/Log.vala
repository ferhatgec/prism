/* MIT License
#
# Copyright (c) 2020 Ferhat Geçdoğan All Rights Reserved.
# Distributed under the terms of the MIT License.
#
# */

public class PrismLog {
	public string GetTime() {
		int64 timestamp = 1234151912;
    	var time = new DateTime.from_unix_utc (timestamp);
    
    	assert (time.to_unix () == timestamp);

    	time = new DateTime.utc (2010, 10, 22, 9, 22, 0);

    	var now = new DateTime.now_local();
    	
    	return now.to_string();
	}
	
	public void Log(string item) {
		print("Prism-Log: " + GetTime() + " : ");
		print(item + "\n");
	}

	public void ErrorLog(string item, string code) {
		print("Prism-Log: @Error: " + GetTime() + " : ");
		print(item + " : Code: " + code + "\n");
	}
}
