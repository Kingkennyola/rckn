# rckn

Initialize Terraform:

Make sure you have Terraform installed on your machine. If not, you can download it from the official website.
Navigate to the directory where your Terraform script is located.
Run the following command to initialize Terraform:

terraform init

Plan the Terraform deployment:

Run the following command to plan the Terraform deployment:

terraform plan


this will show you the resources that Terraform is going to create, so you can verify that everything is correct before applying the changes.
Apply the Terraform deployment:

Run the following command to apply the Terraform deployment:
terraform apply
You will be prompted to enter "yes" to confirm the deployment.

Connect to the EKS cluster:

Run the following command to download the AWS CLI:

aws eks update-kubeconfig --name <cluster-name>
Replace <cluster-name> with the name of your EKS cluster.
This command updates the kubeconfig file with the information needed to connect to the EKS cluster.



Deploy the nginx service:

Navigate to the directory where the deploy.sh script and the nginx Helm chart are located.
Run the following command to deploy the nginx service



./deploy.sh --image-tag <image-tag>


Replace <image-tag> with the desired image tag of the nginx image.
The script will create the nginx deployment and service in the EKS cluster.



Verify the deployment:

Run the following command to verify that the nginx pods are running:


kubectl get pods


You should see one or more nginx pods running.
Run the following command to get the external IP address of the nginx service:


kubectl get svc nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
You can use this IP address to access the nginx service from a web browser.


