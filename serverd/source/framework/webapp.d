module framework.webapp;

import framework.http_bridge;

class WebApp {
    alias RequestHandler = HttpResponse function(HttpRequest);

    private RequestHandler[string] handlers;
    
    private HttpBridge httpBridge = new HttpBridge();

    public this() {
        handlers = new RequestHandler[string];
    }
    public void registerHandler(string path, RequestHandler handler) {
        handlers[path] = handler;
    }
    private HttpResponse handleRequest(HttpRequest request) {
        if (request.path in handlers) {
            auto handler = handlers[request.path];
            return handler(request);
        } else {
            return HttpResponse(404, ["Content-Type": "text/plain"], "Not Found");
        }
    }
    public void run() {
        auto req = httpBridge.readRequest();
        auto res = handleRequest(req);
        httpBridge.respond(res);
    }
}