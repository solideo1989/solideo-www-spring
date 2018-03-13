package pl.solideo.www;

import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.web.bind.annotation.*;

@RestController
@EnableAutoConfiguration
public class App {

    @RequestMapping("/")
    String home() {
        return "<h1>Strona w trakcie budowy</h1> <p>unixtime="+(System.currentTimeMillis()/1000)+"</p> <p>Merge test 3</p> <hr />";
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(App.class, args);
    }
}

