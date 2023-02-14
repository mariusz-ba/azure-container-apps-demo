using AzureContainerApps.Shared.Observability;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddObservability(builder.Configuration)
    .AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"));

var app = builder.Build();

app.MapReverseProxy();

app.Run();