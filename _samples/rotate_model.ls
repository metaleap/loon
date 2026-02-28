// This script will load a teapot model with lights and rotate the whole model
Wi.killProcesses()  // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: rotate_model.lua")

scene := Wi.GetScene()
scene.Clear()
model_entity := Wi.LoadModel(Wi.script_dir() + "../models/teapot.wiscene")
transform_component := scene.Component_GetTransform(model_entity)

Wi.runProcess(->
  true ->
    transform_component.Rotate(Wi.Vector(0, 0.1, 0)) // rotate around y axis
    Wi.update()
)

Wi.backlog_post("---> END SCRIPT: rotate_model.lua")
