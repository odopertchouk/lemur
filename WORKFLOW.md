# Workflow for the Team

  ## Daily Development:

  ## Each developer creates feature branches from integration
  git checkout integration
  git pull origin integration
  git checkout -b feature/my-feature

  ## Work, commit, push feature branch
  git push origin feature/my-feature

  ## Create PR: feature/my-feature → integration (on your fork)

  ## Integration Branch Maintenance:

  ### Periodically sync with Netflix
  git checkout integration
  git fetch upstream
  git merge upstream/main
  git push origin integration

  ## Workflow for Netflix PRs

  When you want to contribute to Netflix:
  ### Create clean branch from latest Netflix main
  git fetch upstream
  git checkout -b feature/for-netflix upstream/main

  ### Cherry-pick or implement clean version of your feature
  ### Push and create PR: your-fork/feature/for-netflix → Netflix/main