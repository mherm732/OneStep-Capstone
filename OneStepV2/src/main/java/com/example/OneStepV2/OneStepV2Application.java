package com.example.OneStepV2;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;


@SpringBootApplication
@ComponentScan(basePackages = {
	    "com.example.OneStepV2", "controllers", "dto", "security", "service"
	})
@EntityScan(basePackages = {"model"})
@EnableJpaRepositories(basePackages = {"repository"})
public class OneStepV2Application {

	public static void main(String[] args) {
		SpringApplication.run(OneStepV2Application.class, args);
	}
}
