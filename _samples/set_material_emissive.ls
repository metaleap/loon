// This script will load a teapot model and animate its emissive color and intensity
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
		t += 0.05
		startcolor := Wi.Vector(1,0,1,0) // pink, but zero intesity emissive
		endcolor := Wi.Vector(1,0,1,2) // 2x intensity pink emissive
		color := Wi.vector.Lerp(startcolor, endcolor, Wi.math.sin(t) * 0.5 + 0.5)
		material_component.SetEmissiveColor(color)
		Wi.update()
)

Wi.backlog_post("---> END SCRIPT: set_material_color.lua")
