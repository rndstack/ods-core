# Jenkins Webhook Proxy

Provides one endpoint accepting webhooks from BitBucket and forwards them to the
corresponding Jenkins pipeline (which is determined based on the branch name).
If there is no corresponding pipeline yet, it will be created on the fly. Once a
branch is deleted or a pull request declined/merged, the corresponding Jenkins
pipeline is deleted as well.

Jenkinsfiles, within a project are created when provisioning quickstarters,
thru the [provision app](https://github.com/opendevstack/ods-provisioning-app).
The [quickstarter boilerplates](https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates) 
contain the appropriate skeletons.

One instance of the webhook proxy runs in every `project`-cd namespace next to 
the jenkins instance for this `project`.

## Adding a webhook in BitBucket

Go to "Repository Settings > Webhooks" and click on "Create webhook". Enter
`Jenkins` as Title and the route URL (see following [Setup](#setup) section) as
URL. Under "Repository events", select `Push`. Under "Pull request events",
select `Merged` and `Declined`. Save your changes and you're done! Any other
webhooks already setup to trigger Jenkins are not needed anymore and should be
deactivated or deleted.

## Setup the webhook proxy in a `*-cd` namespace

Run `tailor update` in `ocp-config`. This will create `BuildConfig` and
`ImageStream` in the central `cd` namespace. Next, you will have to create a
`DeploymentConfig`, `Service` and `Route` in the namespace your Jenkins instance
runs.

## Customizing the behaviour of the webhook proxy

The following environment variables are read by the proxy:

| Variable | Description |
| --- | --- |
| PROTECTED_BRANCHES | Comma-separated list of branches which pipelines should not be cleaned up. Use either exact branch names, branch prefixes (e.g. `feature/`) or `*` for all branches. Defaults to: `master,develop,production,staging,release/` |
| OPENSHIFT_API_HOST | Defaults to `openshift.default.svc.cluster.local`. Usually does not need to be modified. |
| REPO_BASE | The base URL of the repository (e.g. your BitBucket host). This variable is set by the template and usually does not need to be modified. |
| TRIGGER_SECRET | The secret which protects the pipeline to be executed from outside. This variable is set by the template and usually does not need to be modified.  |


## Development

See the `Makefile` targets.
