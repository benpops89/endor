{
  image = "jmalloc/echo-server";
  autoStart = true;
  extraOptions = [
    "--network=containers"
    "--ip=10.0.1.232"
  ];
  environment = {
    PORT = "80";
  };
}
