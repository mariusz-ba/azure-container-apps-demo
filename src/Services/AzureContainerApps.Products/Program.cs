using AzureContainerApps.Shared.Observability;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddObservability(builder.Configuration);

var app = builder.Build();

app.MapGet("/", () => "Products");

app.Run();