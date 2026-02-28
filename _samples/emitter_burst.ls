// This script will load a particle emitter model and burst-spawn particles from it periodically
Wi.killProcesses()  // stops all running lua coroutine processes

Wi.backlog_post("---> START SCRIPT: emitter_burst.lua")

scene := Wi.GetScene()
scene.Clear()
Wi.LoadModel(Wi.script_dir() + "../models/emitter_smoke.wiscene")
emitter_entity := scene.Entity_FindByName("smoke")  // query the emitter entity by name
emitter_component := scene.Component_GetEmitter(emitter_entity)
emitter_component.SetEmitCount(0)  // don't emit continuously
emitter_component.SetNormalFactor(20)  // set starting speed to particles
emitter_component.SetLife(0.3)  // particles will be short lived (around 0.3 sec if we don't account for life randomness)
emitter_component.SetSize(0.1)  // adjust starting particle size
emitter_component.SetMotionBlurAmount(0.008)  // set a little motion blur (particles will be longer along movement direction)

Wi.runProcess(->
  true ->
    emitter_component.Burst(50)  // Burst 50 particles at once
    Wi.waitSeconds(2)  // then wait for 2 seconds before bursting again
)

Wi.backlog_post("---> END SCRIPT: emitter_burst.lua")
