//
// Vivado(TM)
// rundef.js: a Vivado-generated Runs Script for WSH 5.1/5.6
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//

var WshShell = new ActiveXObject( "WScript.Shell" );
var ProcEnv = WshShell.Environment( "Process" );
var PathVal = ProcEnv("PATH");
if ( PathVal.length == 0 ) {
  PathVal = "C:/Xilinx/Vivado/2022.1/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2022.1/ids_lite/ISE/lib/nt64;C:/Xilinx/Vivado/2022.1/bin;";
} else {
  PathVal = "C:/Xilinx/Vivado/2022.1/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2022.1/ids_lite/ISE/lib/nt64;C:/Xilinx/Vivado/2022.1/bin;" + PathVal;
}

ProcEnv("PATH") = PathVal;

var RDScrFP = WScript.ScriptFullName;
var RDScrN = WScript.ScriptName;
var RDScrDir = RDScrFP.substr( 0, RDScrFP.length - RDScrN.length - 1 );
var ISEJScriptLib = RDScrDir + "/ISEWrap.js";
eval( EAInclude(ISEJScriptLib) );


// pre-commands:
<<<<<<< HEAD
ISETouchFile( "write_bitstream", "begin" );
=======
ISETouchFile( "init_design", "begin" );
>>>>>>> 8d8951fe53392006346f0a5ba26bbcbabd6294a8
ISEStep( "vivado",
         "-log Core_Top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Core_Top.tcl -notrace" );





function EAInclude( EAInclFilename ) {
  var EAFso = new ActiveXObject( "Scripting.FileSystemObject" );
  var EAInclFile = EAFso.OpenTextFile( EAInclFilename );
  var EAIFContents = EAInclFile.ReadAll();
  EAInclFile.Close();
  return EAIFContents;
}
