package controllers;

import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import model.Goal;
import model.Step;
import model.StepStatus;
import repository.GoalRepository;
import repository.StepRepository;
import service.StepService;

@RestController
@RequestMapping("/ai")
public class ChatController {

    private final OpenAiChatModel chatModel;

    @Autowired
    public ChatController(OpenAiChatModel chatModel) {
        this.chatModel = chatModel;
    }

    @Autowired private StepService stepService;
    @Autowired private StepRepository stepRepository;
    @Autowired private GoalRepository goalRepository;

    @PostMapping("/generateStep")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Step> generateAndSaveStep(
            @RequestParam("goalId") UUID goalId,
            Authentication authentication) {

        String email = authentication.getName();

        Goal goal = goalRepository.findById(goalId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Goal not found"));

        if (!goal.getUser().getEmail().equals(email)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Unauthorized");
        }

        var steps = stepRepository.findByGoal_GoalId(goalId);
        steps.sort((a, b) -> Integer.compare(a.getStepOrder(), b.getStepOrder()));

        StringBuilder history = new StringBuilder();
        for (int i = 0; i < steps.size(); i++) {
            history.append("%d. %s\n".formatted(i + 1, steps.get(i).getStepDescription()));
        }

        String promptText = """
            You are an assistant helping users achieve goals through a step-by-step plan.

            Goal: "%s - %s"

            Existing Steps:
            %s

            Based on these, generate the next logical, concise, and actionable step.
            Return only the new step description as a single sentence. Do not repeat any previous steps.
            """.formatted(goal.getTitle(), goal.getGoalDescription(), history.toString());

        Prompt prompt = new Prompt(promptText);
        ChatResponse response = chatModel.call(prompt);
        Generation generation = response.getResults().get(0); 
        String stepDescription = generation.getOutput().getText().trim();

        if (stepDescription.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid AI-generated step.");
        }

        Step aiStep = new Step();
        aiStep.setStepDescription(stepDescription);
        aiStep.setGoal(goal);
        aiStep.setStepOrder(stepService.getNextStepOrder(goal));
        aiStep.setStatus(StepStatus.PENDING);
        aiStep.setIsAiGenerated(true);
        aiStep.setDateCreated(LocalDateTime.now());

        stepRepository.save(aiStep);
        return ResponseEntity.ok(aiStep);
    }

}
