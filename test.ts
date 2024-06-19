const datadog = new Datadog(this, 'datadog', {
  apiKeySecret: datadogSecret,
  addLayers: false,
  enableDatadogLogs: false,
  flushMetricsToLogs: false,
  extensionLayerVersion: 58,
  nodeLayerVersion: 112,
});
