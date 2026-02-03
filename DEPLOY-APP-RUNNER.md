# Deploy LegalLens to AWS App Runner

Your repo is ready for App Runner. Code is on GitHub and `apprunner.yaml` configures **build** (`npm install` + `npm run build`) and **run** (`npx serve -s dist -l 8080`).

---

## One-time: Enable App Runner and connect GitHub

Your AWS account reported that App Runner needs a subscription. Do this once:

### 1. Open App Runner and create a GitHub connection

1. Go to **AWS Console** → **App Runner** → [https://us-east-1.console.aws.amazon.com/apprunner/home?region=us-east-1](https://us-east-1.console.aws.amazon.com/apprunner/home?region=us-east-1)
2. Click **Create service**.
3. Under **Source and deployment**, choose **Source code repository** → **Add new** (or use an existing connection).
4. For the GitHub connection:
   - **Connection name**: e.g. `legal-lens-github`
   - **Provider**: GitHub  
   Click **Connect to GitHub** and authorize in the browser. Then **Continue**.
5. You don’t have to finish creating the service in the console; you can stop after the connection is created.  
   Or continue with the wizard: choose repo `SurdeshKumar/Project`, branch `master`, and let it use the **apprunner.yaml** from the repo (build/start are already set there).

### 2. Get the connection ARN (if you use the script)

- In App Runner: **Settings** (left) → **Connections** → open your connection → copy the **ARN**.

---

## Option A: Deploy from AWS Console (easiest)

1. App Runner → **Create service**.
2. **Source**: Source code repository → your GitHub connection → **Repository** `SurdeshKumar/Project`, **Branch** `master`.
3. **Deployment settings**: Automatic (so each push deploys).
4. **Configure build**: leave **Use a configuration file** so it uses `apprunner.yaml` (build: `npm install` + `npm run build`, run: `npx serve -s dist -l 8080`).
5. **Configure service**:  
   - **Service name**: `legal-lens-app`  
   - **Instance**: 1 vCPU, 2 GB (free tier friendly).  
   - **Public**: Yes (so you get a public URL).
6. **Create & deploy**. After the first deployment (about 5–10 minutes), the **Default domain** is your **live public URL** (e.g. `https://xxxxx.us-east-1.awsapprunner.com`).

---

## Option B: Deploy with AWS CLI (after connection exists)

After you have a GitHub connection ARN:

```powershell
.\deploy-apprunner.ps1 -ConnectionArn "arn:aws:apprunner:us-east-1:643025069371:connection/YOUR_CONNECTION_NAME/YOUR_ID"
```

Or inline (replace `YOUR_CONNECTION_ARN`):

```powershell
aws apprunner create-service --service-name legal-lens-app `
  --source-configuration '{
    "AuthenticationConfiguration": {"ConnectionArn": "YOUR_CONNECTION_ARN"},
    "AutoDeploymentsEnabled": true,
    "CodeRepository": {
      "RepositoryUrl": "https://github.com/SurdeshKumar/Project",
      "SourceCodeVersion": {"Type": "BRANCH", "Value": "master"},
      "CodeConfiguration": {"ConfigurationSource": "REPOSITORY"}
    }
  }' `
  --instance-configuration '{"Cpu": "1 vCPU", "Memory": "2 GB"}' `
  --region us-east-1
```

Then get the URL:

```powershell
aws apprunner describe-service --service-arn <ServiceArn> --region us-east-1 --query "Service.ServiceUrl" --output text
```

**Live public URL**: `https://<ServiceUrl>` (e.g. `https://xxxxx.us-east-1.awsapprunner.com`).

---

## Summary

| Step | Status |
|------|--------|
| GitHub repo | Done – https://github.com/SurdeshKumar/Project |
| Code pushed | Done – `apprunner.yaml` + `serve` in package.json |
| Build / run | `npm run build` then `npx serve -s dist -l 8080` (in apprunner.yaml) |
| Auto deploy | Enable in App Runner (default when creating from GitHub) |
| Free tier | Use 1 vCPU, 2 GB instance |
| Live URL | After first deployment: App Runner → your service → Default domain |

Once App Runner is enabled and the GitHub connection exists, use either the console (Option A) or the CLI/script (Option B) to create the service; the **Default domain** (or `https://<ServiceUrl>`) is your live public URL.
