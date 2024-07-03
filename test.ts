const datadog = new Datadog(this, 'datadog', {
  apiKeySecret: datadogSecret,
  addLayers: false,
  enableDatadogLogs: false,
  flushMetricsToLogs: false,
  extensionLayerVersion: 59,
  nodeLayerVersion: 111,
});
