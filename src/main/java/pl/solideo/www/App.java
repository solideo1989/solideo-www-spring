package pl.solideo.www;

import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.web.bind.annotation.*;

@RestController
@EnableAutoConfiguration
public class App {

    @RequestMapping("/")
    String home() {
        return "Strona w trakcie budowy. (unixtime="+(System.currentTimeMillis()/1000)+")";
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(App.class, args);
    }
}

