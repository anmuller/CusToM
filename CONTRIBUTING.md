# Contribution Guidelines

## Before Contributing
- Please read the [README](README.md) and [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md).

## Reporting issues

- **Search for existing issues.** Please check to see if someone else has reported the same issue.
- **Share as much information as possible.** Include operating system and version, browser and version. Also, include steps to reproduce the bug.

## Project Setup
Refer to the [README](README.md).

## Code Style

### Variable Naming
Not all current code follows the conventions below but these will be followed for future developments. 
- Maximize the use of semantic and descriptive variables names (e.g. `faceIndices` not `fcInd` or `fi`). 
- Avoid abbreviations except in cases of industry wide usage.

## Testing
For the moment the tutorial files provided may serves as a test suite.

## Creating pull requests.
- Try not to pollute your pull request with unintended changes – keep them simple and small. If possible, squash your commits.
- Try to share how your code has been tested before submitting a pull request.
- If your pull resquest resolves an issue, include **closes #ISSUE_NUMBER** in your commit message (or a [synonym](https://help.github.com/articles/closing-issues-via-commit-messages)).
- Review
    - If your pull resquest is ready for review, another contributor will be assigned to review your pull resquest
    - The reviewer will accept or comment on the pull resquest. 
    - If needed address the comments left by the reviewer. Once you're ready to continue the review, ping the reviewer in a comment.
    - Once accepted your code will be merged to `master`