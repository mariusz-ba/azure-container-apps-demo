namespace AzureContainerApps.Shared.Observability;

public class ObservabilityOptions
{
    public const string SectionName = "Observability";
    public string CloudRoleName { get; set; } = string.Empty;
}