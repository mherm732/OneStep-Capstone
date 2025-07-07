package com.example.OneStepV2;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@EnableJpaRepositories(basePackages = "repository")
@EntityScan(basePackages = "model")
@ComponentScan(basePackages = {"com.example.OneStepV2", "controllers", "service", "dto"})
@SpringBootApplication
public class OneStepV2Application {

	public static void main(String[] args) {
		SpringApplication.run(OneStepV2Application.class, args);
	}
}
