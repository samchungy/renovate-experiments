const datadog = new Datadog(this, 'datadog', {
  apiKeySecret: datadogSecret,
  addLayers: false,
  enableDatadogLogs: false,
  flushMetricsToLogs: false,
  extensionLayerVersion: 57,
  nodeLayerVersion: 113,
});
