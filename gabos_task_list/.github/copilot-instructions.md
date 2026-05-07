# Workspace Agent Instructions

Apply these rules across this workspace.

## Response Workflow
- Before making code changes, confirm briefly what changes will be applied.
- Before making code changes, present a short execution plan with the concrete steps to be performed.
- After finishing edits, confirm what was changed and what was verified.

## Change Confirmation
- Do not jump directly from analysis to edits without first stating the intended change set.
- Keep that confirmation concise and action-oriented.
- If the request is ambiguous, resolve the ambiguity before editing.

## Planning
- Show the execution plan before the first edit whenever the task requires file changes or command execution.
- Prefer short numbered plans focused on the next concrete actions.
- Update the user if the plan changes because of findings during implementation.

## Flutter Architecture
- Preserve the GetX architecture already used by this repository.
- Do not introduce StatefulWidget for screen-level state when the same behavior can be handled with GetX controllers and reactive widgets.
- Prefer StatelessWidget plus Obx/GetX/GetBuilder, with orchestration and form state owned by the corresponding GetX controller.
- If a StatefulWidget is genuinely necessary, state the reason explicitly before using it and keep the scope local.