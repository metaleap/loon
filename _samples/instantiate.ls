// This script demonstrates spawning multiple objects from one source scene
Wi.killProcesses() // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: instantiate.lua")

scene := Wi.GetScene()
scene.Clear()

prefab := Wi.Scene()
Wi.LoadModel(prefab, Wi.script_dir() + "../models/hologram_test.wiscene")

// Instantiate first object
scene.Instantiate(prefab)

Wi.runProcess(->
  true ->
    // Instantiate more objects whenever the user presses space
    ?| Wi.input.Press(Wi.KEYBOARD_BUTTON_SPACE)
      // passing true as second parameter attaches all entities to a common root
      root_entity := scene.Instantiate(prefab, true)
      transform_component := scene.Component_GetTransform(root_entity)
      transform_component.Translate(Vector(Wi.math.random() * 10 - 5, 0, Wi.math.random() * 10 - 5))

    Wi.update()
)

Wi.backlog_post("---> END SCRIPT: instantiate.lua")
