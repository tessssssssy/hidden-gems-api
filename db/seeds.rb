Location.destroy_all
User.destroy_all

Location.create(
  name: "Hosier Lane Graffiti",
  tagline: "Best street art in Melbourne CBD",
  address: "Hosier Lane, Melbourne, Victoria, 3000",
  latitude: -37.8165717,
  longitude: 144.9669809,
  description: "Opposite Federation Square and joining Flinders Lane with Flinders Street, the cobblestoned Hosier Lane is arguably the central point of the city's street art scene. Spend a long while checking out every little bit of this overflowing art cluster – a creative mark has been left on almost anything with a surface and sometimes it's the smaller, easily-overlooked pieces that really astound."
)

Location.create(
  name: "Docklands",
  tagline: "Best place learn photography",
  address: "912 Collins St, Docklands VIC 3008",
  latitude: -37.81992,
  longitude: 144.9392745,
  description: "This is a secret point to visit at night.
  Fantastic view from the back of the library to the Observation Wheel with the Docklands pier in the foreground"
)

Location.create(
  name: "Surprising Presgrave Place",
  tagline: "Small framed painting",
  address: "Presgrave Pl, Melbourne VIC 3000",
  latitude: -37.815133,
  longitude: 144.9654093,
  description: "This location is well worth a visit and is very different to the other lanes with street art. It has lots of different types of art including many small framed paintings and installations. Access is via Howey Place which runs off Little Collins Street (west of Swanston Street)"
)

User.create(
  username: "test1",
  email: "test1@hg.com",
  password: "123456",
  admin: true
)

User.create(
  username: "test2",
  email: "test2@hg.com",
  password: "123456",
  admin: true
)