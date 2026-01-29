function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // jeśli katalog (np. /contact/)
  if (uri.endsWith('/')) {
    request.uri = uri + 'index.html';
    return request;
  }

  // jeśli brak rozszerzenia (np. /contact)
  if (!uri.includes('.')) {
    request.uri = uri + '/index.html';
    return request;
  }

  return request;
}
