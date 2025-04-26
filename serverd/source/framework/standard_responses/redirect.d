module framework.standard_responses.redirect;

import framework.http_bridge;

public HttpResponse redirectTemporary(string url){
    return HttpResponse(307,["Location" : url],"");
}
public HttpResponse redirectPermamant(string url){
    return HttpResponse(301,["Location" : url],"");
}