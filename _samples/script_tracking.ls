// This is a script which showcases the new path system for scripts, and new handling for processes

// There are new APIs exist too for managing scripts
// killProcess(coroutine)  >>> To kill exactly one process if you know the coroutine,
//    runProcess exposes this by returning two variables: success, and coroutine
//    coroutine holds the index to kill this exact runProcess you're running
// killProcessPID(script_pid())  >>> To kill all processes within one instance of the script
//    script_pid() are a local variable exposed to each script for the user to track and kill one full script
// killProcessFile(script_file())  >> To kill all instances of scripts which originates from one file
//    script_pid() are a local variable exposed to each script for the user to track and kill all
//    instances of scripts that uses the same file

Wi.backlog_post("---> START SCRIPT: script_tracking.lua")

// By using a global table you can keep code data across reloads
dict := {}

// Now you can track even the coroutine that the script has
// You can exactly kill this one coroutine by killing them like this: killProcess(proc_coroutine)
(proc_success, proc_coroutine) := Wi.runProcess(->
  // If you want to do stuff once but never again on the next sequence of reloads, you can do it like this
  // (apply to any scripts you have their PID tracked on script too)
  ?| !Script_Initialized(script_pid())
    Wi.backlog_post("\n")
    Wi.backlog_post("== Script INFO ==")
    Wi.backlog_post("script_dir(): " + Wi.script_dir())
    Wi.backlog_post("script_file(): " + Wi.script_file())
    Wi.backlog_post("script_pid(): " + Wi.script_pid())
    Wi.backlog_post("\n")

    dict.counter = 0

    Wi.ClearWorld()
    dict.prevPath = Wi.application.GetActivePath()
    dict.path = Wi.RenderPath3D()
    dict.path.SetLightShaftsEnabled(true)
    Wi.application.SetActivePath(dict.path)

    dict.font = Wi.SpriteFont("");
    dict.font.SetSize(30)
    dict.font.SetPos(Wi.Vector(10, 10))
    dict.font.SetAlign(Wi.WIFALIGN_LEFT, Wi.WIFALIGN_TOP)
    dict.font.SetColor(0xFFADA3FF)
    dict.font.SetShadowColor(Wi.Vector(0,0,0,1))
    dict.path.AddFont(dict.font)

    // With the new scripting system, use script_dir() string variable to load files relative to the script directory.
    // Also running a script can now return its PID, which you can use to kill the script you just launched in this script
    // Down below is a small demo to open a file on another script and open it relative to that script's path
    dict.subscript_PID = Wi.dofile(Wi.script_dir() + "subscript_demo/load_model.lua", true)
    Wi.backlog_post("subscript PID: " + dict.subscript_PID)

  true ->
    dict.counter += 0.00001
    // Here's a fun thing: edit the text below and reload the script (press R)!
    // e.g "Hello There!"" to "Yeehaw"
    dict.font.SetText("Script directory: " + script_dir() + "\nScript file: " + script_file() + "\nScript PID: " + script_pid() + "\nPersistent counter value: " + dict.counter + "\nSubscript PID: " + dict.subscript_PID)
    Wi.update()
    // Here's an example on how to reload exactly this script
    ?| input.Press('R')
      // This is an example to restart a script using killProcessPID, to keep script PID add true to the argument
      Wi.killProcessPID(Wi.script_pid(), true)
      Wi.backlog_post("RESTART")
      Wi.dofile(Wi.script_file(), Wi.script_pid())
      <-
    ?| input.Press(Wi.KEYBOARD_BUTTON_ESCAPE)
      // restore previous component
      // so if you loaded this script from the editor, you can go back to the editor with ESC
      // This is an example to exit a script using killProcessPID
      Wi.killProcesses()
      Wi.backlog_post("EXIT")
      Wi.application.SetActivePath(dict.prevPath)
      <-
)

Wi.backlog_post("---> END SCRIPT: script_tracking.lua")
