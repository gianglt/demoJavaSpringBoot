package com.example.demo.controller; // Thay thế bằng package controller của bạn

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController // Đánh dấu class này là một REST controller, kết hợp @Controller và @ResponseBody
public class HelloController {

    @GetMapping("/hello") // Ánh xạ các HTTP GET request tới "/hello" vào phương thức sayHello()
    public String sayHello() {
        return "hello";
    }
}
