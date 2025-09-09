# Create Pull Request Command

Submit a new pull request draft and summarize all changes of
all existing commits ahead of `main`

## Behavior

- Analyzes changes and automatically splits into logical commits when appropriate
- Each commit focuses on a single logical change or feature
- Creates descriptive commit messages for each logical unit
- Pushes branch to remote
- Creates pull request draft with proper summary and test plan

## Guidelines for Automatic Commit Splitting

- Split commits by feature, component, or concern
- Keep related file changes together in the same commit
- Separate refactoring from feature additions
- Ensure each commit can be understood independently
- Multiple unrelated changes should be split into separate commits
