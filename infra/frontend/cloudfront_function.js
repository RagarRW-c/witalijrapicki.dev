function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // jeżeli nie ma rozszerzenia i nie kończy się slash
  if (!uri.includes('.') && !uri.endsWith('/')) {
    request.uri = uri + '/index.html';
  }

  return request;
}
