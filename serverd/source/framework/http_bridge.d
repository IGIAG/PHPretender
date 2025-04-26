module framework.http_bridge;

import std.stdio;
import asdf;
import std.exception;
import std.string;
import core.stdc.stdlib : exit;

import framework.static_config;

struct HttpRequest
{
    string path;
    string method;
    string[string] query;
    string[string] post;
    string body;
    string[string] headers;
}

struct HttpResponse {
    int status = 200;
    string[string] headers = null;
    string body = "";
    this(int status){
        this.status = status;
    }
    this(int status,string[string] headers,string body){
        this.status = status;
        this.headers = headers;
        this.body = body;
    }
    this(T)(T value){
        this.body = value.serializeToJson();
        this.headers["Content-Type"] = "application/json";
    }
}

class HttpBridge
{
    public static this()
    {
        // Constructor
    }

    public HttpRequest readRequest()
    {
        try
        {
            string input;
            
            foreach (line; stdin.byLineCopy)
                input ~= line;


            enforce(input.length > 0, "No input received from PHP.");

            HttpRequest req = input.deserialize!HttpRequest;

            return req;
        }
        catch (Exception e)
        {
            HttpResponse errorResponse = HttpResponse(500);
            errorResponse.body = "Internal server error.";
            respond(errorResponse);
            return HttpRequest.init; // Unreachable
        }
    }

    static void respond(HttpResponse response)
    {
        if(X_POWERED_BY != ""){
            response.headers["X-Powered-By"] = X_POWERED_BY;
        }

        import std.file;
        write("./response.log",(response.serializeToJson()));

        stdout.write(response.serializeToJson());
        stdout.flush();

        exit(0); // ✅ Now works thanks to core.stdc.stdlib
    }

    static void respond(T)(T value)
    {
        HttpResponse response = HttpResponse(200);
        response.body = value.serializeToJson();
        response.headers["Content-Type"] = "application/json";
        if(X_POWERED_BY != ""){
            response.headers["X-Powered-By"] = X_POWERED_BY;
        }

        stdout.write(response.serializeToJson());
        stdout.flush();

        exit(0); // ✅ Now works thanks to core.stdc.stdlib
    }
}
