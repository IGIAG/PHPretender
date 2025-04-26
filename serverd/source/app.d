import std.stdio;
import framework.http_bridge;
import std.conv;
import asdf;
import std.datetime;
import std.random;
import framework.standard_responses.redirect;
import framework.webapp;

class WeatherForecast {
    string city = "Warsaw";
    float temperatureCelsious;
    @property float temperatureFahrenheit() const {
        return temperatureCelsious * 9 / 5 + 32;
    }
    this(){
        temperatureCelsious = uniform(-10.0f, 40.0f);
    }
}

void main() {
    WebApp app = new WebApp();
    app.registerHandler("/", (HttpRequest req) {
        return HttpResponse(new WeatherForecast());
    });

    app.run();
}