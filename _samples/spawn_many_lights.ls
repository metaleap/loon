// This script will create 200 lights and move them in one direction.
//	Use this when you already loaded a scene, because the lights will be placed inside the scene bounds
Wi.backlog_post("---> START SCRIPT: spawn_many_lights.lua")

scene := Wi.GetScene()

entities := []
velocities := []
bounds_min := scene.GetBounds().GetMin()
bounds_max := scene.GetBounds().GetMax()

(1...200) (i) ->
  entity := Wi.CreateEntity()
  entities += [entity]
  velocities += [Wi.math.lerp(0.1, 0.2, Wi.math.random())]
  light_transform := scene.Component_CreateTransform(entity)
  light_transform.Translate(Wi.Vector(
    Wi.math.lerp(bounds_min.GetX(), bounds_max.GetX(), Wi.math.random()),
    Wi.math.lerp(bounds_min.GetY(), bounds_max.GetY(), Wi.math.random()),
    Wi.math.lerp(bounds_min.GetZ(), bounds_max.GetZ(), Wi.math.random()),
  ))
  light_component := scene.Component_CreateLight(entity)
  light_component.SetType(Wi.POINT)
  light_component.SetRange(12)
  light_component.SetIntensity(40)
  light_component.SetColor(Vector(1,0.5,0)) // orange color
  //light_component.SetColor(Wi.Vector(Wi.math.random(),Wi.math.random(),Wi.math.random())) // random color
  //light_component.SetVolumetricsEnabled(true)
  light_component.SetCastShadow(true)

runProcess(->
  time := 0.0
  true ->
    time += Wi.getDeltaTime()
    (bounds_min, bounds_max) = scene.GetBounds() |> (_.GetMin(), _.GetMax())

    entities (i, entity) ->
      ?| (transform := scene.Component_GetTransform(entity)) != nil
        transform.Translate(Wi.Vector(velocities[i]))
        ?| transform.GetPosition().GetX() > bounds_max.GetX()
          transform.ClearTransform()
          transform.Translate(Wi.Vector(
            bounds_min.GetX(),
            Wi.math.lerp(bounds_min.GetY(), bounds_max.GetY(), math.random()),
            Wi.math.lerp(bounds_min.GetZ(), bounds_max.GetZ(), math.random()),
          ))

    Wi.update()
)

Wi.backlog_post("---> END SCRIPT: spawn_many_lights.lua")
