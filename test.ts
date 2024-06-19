const datadog = new Datadog(this, 'datadog', {
  apiKeySecret: datadogSecret,
  addLayers: false,
  enableDatadogLogs: false,
  flushMetricsToLogs: false,
  extensionLayerVersion: 58,
  // renovate: depName=DataDog/datadog-lambda-js
  nodeLayerVersion: 111,
});
