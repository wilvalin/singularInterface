tropicalVarietyWithVal = method(TypicalValue => TropicalCycle,  Options => {
	Valuation => null 
	})

-- TODO: make TropicalCycle from Polyhedral complex
	
tropicalVarietyWithVal (Ideal) := o -> (I) ->(
local T;
local F;

-- Adic valuation 
	if (instance(o.Valuation, number)) then (
		
		if (!isPrime(o.Valuation)) then (
			error("The "p" in the p-adic valuation has to be prime");
			)
		else if 
			if(!isHomogeneous(I)) then ( 
				--homogenize
				--call sing with J
			)
			else ( 
			
			
			R = ring I;
			inputToSingular = "LIB \"gfanlib.so\"; \n" | 
									"ring R = 0, (" | replace("[{}]", "", toString gens R) | "), dp; \n" |
									"ideal I = " | replace("ideal", "", toString I ) | ";  \n" |
									"fan TI = tropicalVariety (I, number( " | -*o.Adic*- 2 | ")); \n" |
									"write(\":w <<FILENAME>> \",TI);";
									
			--inputToSingular = "LIB \"gfanlib.so\"; \n" | 
			--						"ring R = 0, (" | replace("[{}]", "", toString gens R) | "), dp; \n" |
			--						"ideal I = " | replace("ideal", "", toString I); | "\n" |
			--						"fan TI = tropicalVariety (I, number( " | o.Adic | ")); \n" | 
			--						"write(\":w filename.out\",TI);" | "\n";
			
			-- runSingular ... 
			-- ok, call Singular
			--Singular FileName; 
			--LIB "gfanlib.so";
			--ring R = 0, (x, y, z), dp;
			--ideal I = x^2+ x*y;
			-- !!! has to be homogeneous
			--fan TI = tropicalVariety (I, number(o.Adic));	
			--write(":w filename.out",TI);			
			
			output := runSingularCommand(inputToSingular);
			--output := runSingularCommand(tropicalVariety, data);
			if(length(output#0)==0) then return "error: this variety is empty";
			-- since Singular returns a file in the same format as gfan we use this method to read it;
			-- this is a fan with miltiplicities for the max cones 
			F = gfanParsePolyhedralFan output;  
			
			if (instance(F,String)) then return F; 
			----T=tropicalCycle(F_0,F_1); -- TODO replace with the correct constructor to get 
			T = TropicalCycleFromPolyhedralComplex (PolyhedralComplexFromFan F);	
			);
	)	
	
--- Puiseux valuation  
	else if (instance(o.Valuation, RingElement)) then ( 
	--print "we haven't implemented this this yet"
	-- we need the correct method name from fan 
	--- make sure the "t" is the first variable!!
	T = TropicalCycleFromPolyhedralComplex (PolyhedralComplexFromSliceOfFan (tropicalVariety (I)));  
	)
	
-- run constant coefficients 
	else ( 
	-- run tropical variety
	T = TropicalCycleFromPolyhedralComplex (PolyhedralComplexFromFan (tropicalVariety (I)));
	);

	
);

singularMakeTemporaryFile = (data) -> (
	

	tmpFile << data << close;
	tmpName
)

runSingularCommand = (data) -> (
	tmpName := temporaryFileName();
	data = replace("<<FILENAME>>", tmpName | ".out", data);
	tmpFile := openOut tmpName;
	tmpFile := singularMakeTemporaryFile(data);
	
	-- in the future we want to make this check at the beginning when we install SingularInterface package
	if run ("Singular -c 'quit;'") =!= 0 then 
		error("You need to install Singular") 
	else (
	ex := "Singular" | " < " | tmpFile | " 2> " | tmpFile | ".err";

	returnvalue := run ex;
     	if(not returnvalue == 0) then
		(	
	     << "Singular returned an error message.\n";
	     << "COMMAND:" << ex << endl;
	     << "INPUT:\n";
	     << get(tmpFile);
	     << "ERROR:\n";
	     << get(tmpFile |".err");
	     );
		 
		out := get(tmpFile | ".out");
	-- TODO: check the following is done automatically when M2 is closed
	--gfanRemoveTemporaryFile tmpFile;
	--gfanRemoveTemporaryFile(tmpFile | ".out");
	--gfanRemoveTemporaryFile(tmpFile | ".err");
	--outputFileName := null;
	
	--if gfanKeepFiles then outputFileName = tmpFile|".out";
	--(out, "GfanFileName" => outputFileName)
	);	
)
