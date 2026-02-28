// This script will load a teapot model and animate its base color between red and green
Wi.killProcesses()  // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: set_material_color.lua")

scene := Wi.GetScene()
scene.Clear()
Wi.LoadModel(Wi.script_dir() + "../models/teapot.wiscene")
material_entity := scene.Entity_FindByName("teapot_material") // query the teapot's material by name
material_component := scene.Component_GetMaterial(material_entity)

Wi.runProcess(->
	t := 0
	true ->
		t += 0.1
		red := Wi.Vector(1,0,0,1)
		green := Wi.Vector(0,1,0,1)
		color := Wi.vector.Lerp(red, green, Wi.math.sin(t) * 0.5 + 0.5)
		material_component.SetBaseColor(color)
		Wi.update()
)

Wi.backlog_post("---> END SCRIPT: set_material_color.lua")
