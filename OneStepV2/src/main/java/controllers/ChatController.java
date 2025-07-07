/*
package controllers;

import java.util.Map;

import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Flux;

@RestController
@RequestMapping("/ai")
public class ChatController {
	  private final OpenAiChatModel chatModel;

	    @Autowired
	    public ChatController(OpenAiChatModel chatModel) {
	        this.chatModel = chatModel;
	    }

	    @GetMapping("/generate")
	    public Map<String,String> generate(@RequestParam(value = "message", defaultValue = "Generate the next, logical step to complete my goal") String message) {
	        return Map.of("generation", this.chatModel.call(message));
	    }

	    @GetMapping("/generateStream")
		public Flux<ChatResponse> generateStream(@RequestParam(value = "Generate the next, logical step to complete my goal\"", defaultValue = "Tell me a joke") String message) {
	        Prompt prompt = new Prompt(new UserMessage(message));
	        return this.chatModel.stream(prompt);
	    }
}
*/