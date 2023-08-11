# rhtsid18.dev
The base landing page for my online portfolio domain `rhtsid18.dev` where I will showcase all the hobby projects that I am building.

## Following are some of the implementations in this repository : -
- Using shell scripting to create an OS independent automated process of creating local certs.
- Use of React bundled using webpack.
- Use of Typescript for static typing.
- Github actions for CI/CD workflow.
- Material UI for page design.
- Implemented github branch protections to only accept changes to the branch through Pull Requests.
	- Also implemented restrictions to merging the PR through : -
		- Approval Requirements.
		- Dissmisal of stale approvals.
		- Requiring review from code owners.
- Through the Settings -> General -> `Automatically delete head branches` checkbox checked, I have setup so that post the PR is merged, the Head branch gets deleted keeping the list of branches in the repository clean.
- Added a `Makefile` to the repo for easy setup steps.
