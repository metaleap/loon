// This script will add a point light fixed to camera

Wi.backlog_post("---> START SCRIPT: camera_pointlight")

scene := Wi.GetScene()

runProcess(->
  light_entity := Wi.CreateEntity()
  scene.Component_CreateLight(light_entity)

  light := scene.Component_GetLight(light_entity)
  light.SetType(Wi.POINT)
  light.SetRange(20)
  light.SetEnergy(4)
  light.SetColor(Wi.Vector(1, 0.9, 0.8))

  scene.Component_CreateTransform(light_entity)

  true ->
    light_pos := scene.Component_GetTransform(light_entity)
    ?| light_pos == nil
      <- Wi.backlog_post("light no longer exists, exiting script")
    light_pos.ClearTransform()
    light_pos.Translate(Wi.GetCamera().GetPosition())

    Wi.update()
)

Wi.backlog_post("---> END SCRIPT: camera_pointlight")
