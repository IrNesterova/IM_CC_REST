package portfolio.example.im_cc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@Controller
public class ImCcApplication {

    public static void main(String[] args) {
        SpringApplication.run(ImCcApplication.class, args);
    }
    
    @GetMapping("/")
    public String sayHello() {
        return "index";
    }


}
