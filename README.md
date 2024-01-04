# SnapLogic Lab Environment
The repository contains various Terraform scripts and Packer build instructions that can be used to run a Lab Environment for the [SnapLogic](https://www.snaplogic.com/) integration platform on Google Cloud Platform. The repository contains:

- [Packer instructions](gcp-images/gcp-groundplex-ubuntu/) to build an image for the [SnapLogic Groundplex](https://docs-snaplogic.atlassian.net/wiki/spaces/SD/pages/1438278/Deploying+a+Groundplex+Self-managed+Snaplex).
- Terraform to create a [VPC network](gcp-network/) and a basion host. 
- Terraform to create a [Snaplogic GroundPlex](https://docs-snaplogic.atlassian.net/wiki/spaces/SD/pages/1438278/Deploying+a+Groundplex+Self-managed+Snaplex) with one node in each of the zones of the region you specify.
- Terraform to create an [SAP ABAP Trial instance](gcp-s4hana-dev/) using the [SAP ABAP Trial Docker Container](https://hub.docker.com/r/sapse/abap-platform-trial).
