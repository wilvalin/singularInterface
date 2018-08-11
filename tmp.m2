runSingularCommand = (data) -> (
	tmpName := temporaryFileName();
	data = replace("<<FILENAME>>", tmpName | ".out", data);
	tmpFile := openOut tmpName;
	tmpFile << data << close;
	-- return tmpName;
	
	-- in the future we want to make this check at the beginning when we install SingularInterface package
	if run ("Singular -q -c 'quit;'") =!= 0 then 
		error("You need to install Singular") 
	else (
	ex := "Singular -q  < " | tmpName | " 2> " | tmpName | ".err";

	returnvalue := run ex;
	
     	if(returnvalue != 0) then	
	     error("Singular returned an error message.\n",
	     "COMMAND RUN:\n    ", ex,
	     "\nINPUT:\n", get(tmpName),
	     "\nERROR:\n", get(tmpName |".err")  );
	
	out := get(tmpName | ".out");
	--out = replace("[_app|_ver|_type].*", "", out);
	return out;
	--return out;
	--out = replace(""
	--	print out;
	-- TODO: check the following is done automatically when M2 is closed
	--gfanRemoveTemporaryFile tmpFile;
	--gfanRemoveTemporaryFile(tmpFile | ".out");
	--gfanRemoveTemporaryFile(tmpFile | ".err");
	--outputFileName := null;
	
	--if gfanKeepFiles then outputFileName = tmpFile|".out";
	--(out, "GfanFileName" => outputFileName)
	);	
)
