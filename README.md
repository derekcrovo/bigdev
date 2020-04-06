## bigdev

bigdev is for when you need a secure dev machine with more power than your laptop has.  It takes an infrastructure-as-code approach using Terraform and Ansible to provision an EC2 instance.  This way you can easily bring it up and shut it down when you're not using it. My main use is for Go development with KinD clusters, so those packages are deployed.

bigdev uses [Tailscale](https://tailscale.com/) for VPN access to the instance.  This requires an account but it's free for personal use.  Once the new instance joins your Tailscale VPN mesh, you can ssh into it even without public access to the ssh port.  This makes the instance even more secure.

### Prerequisites
You need an AWS account and you must have the following packages installed.  They can all be installed with Homebrew.  I've only tested this on OSX.
* [Terraform](https://www.terraform.io/)
* [Ansible](https://www.ansible.com/)
* [terraform-inventory](https://github.com/adammck/terraform-inventory)

### Usage

Set up your environment with some required variables
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_DEFAULT_REGION
* TF_VAR_aws_default_az
* TF_VAR_ssh_key
* TF_STATE

Bring up the instance with
```bash
./bigdev up
```

When you're done, you can destroy the instance and all the infrastructure with
```bash
./bigdev down
```

### Future enhancements
* Parameterize the hostname among other things
* Add support for other cloud providers
* Use Packer to create the instance image so we effectively cache the Ansible work to make `bigdev up` quicker
