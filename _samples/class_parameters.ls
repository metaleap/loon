// This is a script to demonstrate new parameter access to lua c classes in Wicked Engine
// Now you can access class parameters like you access table values just like usual, which now retrieves
// and change class data without using separate getter-setter functions

Wi.backlog_post("---> START SCRIPT: class_parameters.lua")

Wi.ClearWorld()

scene := Wi.GetScene()

sun_entity := Wi.CreateEntity()
sun_name := scene.Component_CreateName(sun_entity)
sun_name.SetName("THE SUN")
scene.Component_CreateLayer(sun_entity)
scene.Component_CreateTransform(sun_entity)
sun := scene.Component_CreateLight(sun_entity)
// sun.SetType() can now be done like this
sun.Type = 0
sun.Intensity = 10.0

weather_entity := Wi.CreateEntity()
weather_name := scene.Component_CreateName(weather_entity)
weather_name.SetName("My Animated Weather")
weather := scene.Component_CreateWeather(weather_entity)
weather.SetRealisticSky(true)
weather.SetVolumetricClouds(true)
weather.skyExposure = 1.2

weather.VolumetricCloudParameters.CloudStartHeight = -100.0
weather.VolumetricCloudParameters.WeatherScale = 0.04
weather.VolumetricCloudParameters.WeatherDensityAmount = 0.5
weather.VolumetricCloudParameters.SkewAlongWindDirection = 5.0

Wi.runProcess(->
  true ->
    Wi.update()
    ?| Wi.input.Press('R')
      Wi.killProcessPID(Wi.script_pid(), true)
      Wi.backlog_post("RESTART")
      Wi.dofile(Wi.script_file(), Wi.script_pid())
      <-
)

Wi.backlog_post("---> END SCRIPT: class_parameters.lua")
