{
  image = "nginx";
  autoStart = true;
  extraOptions = [
    "--network=containers"
    "--ip=10.0.1.231"
  ];
}
