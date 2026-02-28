// This script will load a teapot model with lights, and move the teapot's lid up and down
Wi.killProcesses() // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: move_object.lua")

scene := Wi.GetScene()
scene.Clear()
Wi.LoadModel(Wi.script_dir() + "../models/teapot.wiscene")
top_entity := scene.Entity_FindByName("Top") // query the teapot lid object by name
transform_component := scene.Component_GetTransform(top_entity)
rest_matrix := transform_component.GetMatrix()

Wi.runProcess(->
  t := 0
  true ->
    t += 0.1
    transform_component.ClearTransform()
    transform_component.MatrixTransform(rest_matrix)
    transform_component.Translate(Wi.Vector(0, Wi.math.sin(t) * 0.5 + 0.5, 0)) // up and down
    Wi.update()
)

Wi.backlog_post("---> END SCRIPT: move_object.lua")
