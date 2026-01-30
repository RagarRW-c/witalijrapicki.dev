function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // ===== NIE DOTYKAJ API =====
  if (uri.startsWith("/api/")) {
    return request;
  }

  // ===== JEŚLI KATALOG → index.html =====
  if (uri.endsWith("/")) {
    request.uri = uri + "index.html";
    return request;
  }

  // ===== JEŚLI BRAK ROZSZERZENIA → /index.html =====
  if (!uri.includes(".")) {
    request.uri = uri + "/index.html";
    return request;
  }

  return request;
}
