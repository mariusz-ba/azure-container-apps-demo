using AzureContainerApps.Shared.Observability.TelemetryInitializers;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace AzureContainerApps.Shared.Observability;

public static class Extensions
{
    public static IServiceCollection AddObservability(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<ObservabilityOptions>(configuration.GetSection(ObservabilityOptions.SectionName));
        
        services.AddApplicationInsightsTelemetry();
        services.AddSingleton<ITelemetryInitializer, CloudRoleNameTelemetryInitializer>();

        return services;
    }
}