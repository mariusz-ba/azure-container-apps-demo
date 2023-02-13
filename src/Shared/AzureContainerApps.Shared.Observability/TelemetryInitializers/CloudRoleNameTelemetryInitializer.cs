using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.Options;

namespace AzureContainerApps.Shared.Observability.TelemetryInitializers;

internal sealed class CloudRoleNameTelemetryInitializer : ITelemetryInitializer
{
    private readonly IOptions<ObservabilityOptions> _observabilityOptions;

    public CloudRoleNameTelemetryInitializer(IOptions<ObservabilityOptions> observabilityOptions)
    {
        _observabilityOptions = observabilityOptions;
    }

    public void Initialize(ITelemetry telemetry)
    {
        telemetry.Context.Cloud.RoleName = _observabilityOptions.Value.CloudRoleName;
    }
}