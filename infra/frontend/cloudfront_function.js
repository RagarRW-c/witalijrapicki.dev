function handler(event) {
  var request = event.request;
  var uri = request.uri;

  // wszystko co nie jest plikiem → index.html
  if (!uri.includes(".")) {
    request.uri = "/index.html";
  }

  return request;
}
