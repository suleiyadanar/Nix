## Git Workflow Guide

### Clone a Repo

1. Clone the repository.

```bash
git clone git@github.com:suleiyadanar/Nix.git
```
2. Create a branch for the Jira Ticket you are working on. 
Branch Name format [Jira Ticket Number]-[Ticket Title]
e.g. NIX-1-AppleCalendarIntegration
```bash
git branch [Branch Name]	
```
3. After you have tested and finish code for the ticket, 
Get a list of files you have made changes to:
```bash
git status
```

4. Add files to staging area
For all Files

```bash
git add .
```

Select Files using filename
```bash
git add [filename]
```

5. Make a commit
```bash
git commit -m ‘Commit Message’
```

6. Check that you are in the correct branch (most likely not master)
```bash
git branch
```

7. Push the commit to the branch
```bash
git push
```
8. Create a PR using the Pull Requests tab.
