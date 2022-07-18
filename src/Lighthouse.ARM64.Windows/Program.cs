// See https://aka.ms/new-console-template for more information
using Akka.Hosting;
using Lighthouse;
using Microsoft.Extensions.Hosting;
using Petabridge.Cmd.Cluster;
using Petabridge.Cmd.Host;
using Petabridge.Cmd.Remote;

var (config, actorSystemName) = LighthouseConfigurator.LaunchLighthouse();
var hostBuilder = new HostBuilder();
hostBuilder.ConfigureServices(services =>
{
    services.AddAkka(actorSystemName, builder =>
    {
        builder.AddHocon(config) // clustering / remoting automatically configured here
            .StartActors((system, registry) =>
            {
                var pbm = PetabridgeCmd.Get(system);
                pbm.RegisterCommandPalette(ClusterCommands.Instance); // enable Akka.Cluster management commands
                pbm.RegisterCommandPalette(RemoteCommands.Instance); // enable Akka.Remote management commands
                pbm.Start();
            });
    });
});

var host = hostBuilder.Build();
await host.RunAsync();
//Console.WriteLine("Hello, World!");
