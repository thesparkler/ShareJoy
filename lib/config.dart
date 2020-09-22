class Config {
  static const host =
      "http://ec2-13-233-228-241.ap-south-1.compute.amazonaws.com/";

  static const baseUrl = host + "api/";

  static const types = {
    0: "meme",
    1: "shayari",
    2: "greetings",
  };
  static const titles = {
    "meme": "Memes",
    "shayari": "Sher-O-Shayari",
    "greetings": "Greetings / Statuses"
  };
}
