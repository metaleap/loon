// This script will check for directional lights and begin rotating them slowly if there are any
Wi.killProcesses() // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: rotate_sun.lua")

scene := Wi.GetScene()

Wi.runProcess(->
  true ->
    lights := scene.Component_GetLightArray()
    lights (i, light) ->
      ?| light.GetType() == Wi.DIRECTIONAL
        entity := scene.Entity_GetLightArray()[i]
        transform_component := scene.Component_GetTransform(entity)
        transform_component.Rotate(Wi.Vector(0.0015 * Wi.getDeltaTime() * Wi.GetGameSpeed(), 0, 0)) // rotate around x axis

    Wi.update()
)

Wi.backlog_post("---> END SCRIPT: rotate_sun.lua")
